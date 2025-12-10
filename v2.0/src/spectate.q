// Spectator functions
// Added Aug11'97 by Zoid <zoid@idsoftware.com>
//
// These functions are called from the server if they exist.
// Note that Spectators only have one think since they movement code doesn't
// track them much.  Impulse commands work as usual, but don't call
// the regular ImpulseCommand handler in weapons.qc since Spectators don't
// have any weapons and things can explode.
//
//   --- Zoid.

//team
//shame about the fecking mess in the spectator code, ill structure the thing later (hopefully)
// /kK

m4_define(`CAMTEXT',`m4_dnl
COLOR(`impulse 1') next spawnpoint (floatcam)
COLOR(`impulse 2') change camera mode
COLOR(`impulse 3') zoom out (trackcam)
COLOR(`impulse 4') zoom in  (trackcam)
COLOR(`impulse 5') toggle statusbar (trackcam)

use [jump] to change target or camera

')

void() ModStatus;
void() ModStatus2;
void() PlayerStatus;
void() PlayerStatusS;
void() ShowVersion;
void() SMakeMOTD;
void() SShowCmds;
void() AdminImpBot;
void() ReqAdmin;
void() AdminForceStart;
void() AdminForceBreak;
void() TogglePreWar;
void() ToggleMapLock;
void() ToggleMaster;
void() SelectMap;
void() ChangeDM;
void() ChangeTP;
void() TogglePowerups;
void() ToggleSpecTalk;
void(float t) TimeDown;
void(float t) TimeUp;
void() ToggleQTimer;
void() ToggleQLag;
void() ToggleQEnemy;
void() ToggleRespawns;

void() TrackNext =
{
	local entity p;

	p = find(self.goalentity, classname, "player");
	while(p != world) {
		if(p != self && p.netname != "") {
			self.goalentity = p;
			return;
		}
		p = find(p, classname, "player");
	}
	p = find(world, classname, "player");
	while(p != world) {
		if(p != self && p.netname != "") {
			self.goalentity = p;
			return;
		}
		p = find(p, classname, "player");
	}
	if (p == world) {
		sprint(self, PRINT_HIGH, "No target found ...\n");
		self.k_track = 2;
	}
};

void() TrackNext2 =
{
	local entity p;

	p = find(self.goalentity, classname, "info_intermission");
	if(p != world) {
		self.goalentity = p;
		return;
	}
	p = find(world, classname, "info_intermission");
	if(p != world) {
		self.goalentity = p;
		return;
	}
	sprint(self, PRINT_HIGH, "No target found ...\n");
	self.k_track = 0;
};

void() ShowCamHelp =
{
	sprint(self, PRINT_HIGH, "multiline(`CAMTEXT')");
};
//team


/*
===========
SpectatorConnect

called when a spectator connects to a server
============
*/
void() SpectatorConnect =
{
	if(match_in_progress != M_MATCH || stof(infokey(world, "k_ann"))) {	//team
		bprint (PRINT_MEDIUM, "Spectator ");
		bprint (PRINT_MEDIUM, self.netname);
		bprint (PRINT_MEDIUM, " entered the game\n");
	}
	self.goalentity = world; // used for impulse 1 below

//team
	SMakeMOTD();
	self.k_track = 0;
	self.ready = 0;			//used to check if admin stuffing has been performed
	self.k_666 = 40;		//zoom value default for trackcam
	self.suicide_time = 1;	//user for statusbar on/off checking
	stuffcmd(self, "alias status \"impulse 22\"\n");
	stuffcmd(self, "alias cam \"impulse 23\"\n");
	stuffcmd(self, "alias join \"spectator 0;wait;wait;wait;reconnect\"\n");
	stuffcmd(self, "alias commands \"impulse 50\"\n");
	stuffcmd(self, "alias admin \"impulse 51\"\n");
	stuffcmd(self, "alias who \"impulse 56\"\n");
	stuffcmd(self, "alias about \"impulse 58\"\n");
	stuffcmd(self, "alias whoskin \"impulse 59\"\n");
	stuffcmd(self, "alias status2 \"impulse 64\"\n");
//team
};

//team
void() SpectatorAdminGain =
{
	stuffcmd(self, "alias forcestart \"impulse 52\"\n");
	stuffcmd(self, "alias forcebreak \"impulse 53\"\n");
	stuffcmd(self, "alias lockmap \"impulse 54\"\n");
	stuffcmd(self, "alias prewar \"impulse 55\"\n");
	stuffcmd(self, "alias master \"impulse 57\"\n");
	stuffcmd(self, "alias dm \"impulse 60\"\n");
	stuffcmd(self, "alias tp \"impulse 61\"\n");
	stuffcmd(self, "alias powerups \"impulse 62\"\n");
	stuffcmd(self, "alias silence \"impulse 63\"\n");
	stuffcmd(self, "alias timeup \"impulse 65\"\n");
	stuffcmd(self, "alias timedown \"impulse 66\"\n");
	stuffcmd(self, "alias qtimer \"impulse 67\"\n");
	stuffcmd(self, "alias qlag \"impulse 68\"\n");
	stuffcmd(self, "alias qenemy \"impulse 69\"\n");
	stuffcmd(self, "alias spawn \"impulse 70\"\n");
	StuffMapAliases();
	StuffCustomMaps();
	self.ready = 1;
};
//team

/*
===========
SpectatorDisconnect

called when a spectator disconnects from a server
============
*/
void() SpectatorDisconnect =
{
	if(match_in_progress != M_MATCH || stof(infokey(world, "k_ann"))) {	//team
		bprint (PRINT_MEDIUM, "Spectator ");
		bprint (PRINT_MEDIUM, self.netname);
		bprint (PRINT_MEDIUM, " left the game\n");
	}
};

/*
================
SpectatorImpulseCommand

Called by SpectatorThink if the spectator entered an impulse
================
*/
void() SpectatorImpulseCommand =
{
//team
	if(self.k_track == 1 && (self.goalentity.classname != "player" || self.goalentity.netname == "")) self.k_track == 0;
	if(self.k_admin == 1 && self.impulse >= 1 && self.impulse <=9) {
		AdminImpBot();
		if(self.k_admin == 2 && !self.ready) SpectatorAdminGain();
		self.impulse = 0;
	} else if(self.impulse == 2) {
		self.goalentity = world;
		self.k_track = self.k_track + 1;
		if(self.k_track == 3) self.k_track = 0;
		if(self.k_track == 1) {
			if(self.goalentity == world) {
				TrackNext();
			}
			if(self.k_track == 1) {
				sprint(self, PRINT_HIGH, "--- Trackcam ---");
				if(!self.suicide_time) sprint3(self, PRINT_HIGH, " : showing ", self.goalentity.netname, "\n");
				else sprint(self, PRINT_HIGH, "\n");
				self.deaths = time; 	//.deaths is used for spectators as a counter for centerprinted stuff
			}
		} else if(self.k_track == 0) sprint(self, PRINT_HIGH, "--- Floatcam ---\n");
		if(self.k_track == 2) {
			if(self.goalentity == world) {
				TrackNext2();
			}
			if(self.k_track) {
				sprint(self, PRINT_HIGH, "--- Intermissioncam ---\n");
				self.deaths = time;
			}
		}
	} else if(self.impulse == 3 && self.k_track == 1) {
		if(self.k_666 < 60) {
			self.k_666 = self.k_666 + 10;
		}
	} else if(self.impulse == 4 && self.k_track == 1) {
		if(self.k_666 > -10) {
			self.k_666 = self.k_666 - 10;
		}
	} else if(self.impulse == 5) {
		self.suicide_time = self.suicide_time + 1;
		if(self.suicide_time == 3) self.suicide_time = 0;
		if(!self.suicide_time) {
			msg_entity = self;
			WriteByte(MSG_ONE, SVC_CENTERPRINT);
			WriteString(MSG_ONE, "\n");
		}
	} else if(self.impulse == 1 && !self.k_track) {
//team
		// teleport the spectator to the next spawn point
		// note that if the spectator is tracking, this doesn't do
		// much
		self.goalentity = find(self.goalentity, classname, "info_player_deathmatch");
		if (self.goalentity == world)
			self.goalentity = find(self.goalentity, classname, "info_player_deathmatch");
		if (self.goalentity != world) {
			setorigin(self, self.goalentity.origin);
			self.angles = self.goalentity.angles;
			self.fixangle = TRUE;           // turn this way immediately
		}
	}
//team
	else if(self.impulse == 22) ModStatus();
	else if(self.impulse == 64) ModStatus2();
	else if(self.impulse == 23) ShowCamHelp();
	else if(self.impulse == 50) SShowCmds();
	else if(self.impulse == 51) ReqAdmin();
	else if(self.impulse == 56) PlayerStatus();
	else if(self.impulse == 58) ShowVersion();
	else if(self.impulse == 59) PlayerStatusS();
	else if(self.k_admin == 2) {
		if(self.impulse == 52) AdminForceStart();
		else if(self.impulse == 53) AdminForceBreak();
		else if(self.impulse == 54) ToggleMapLock();
		else if(self.impulse == 55) TogglePreWar();
		else if(self.impulse == 57) ToggleMaster();
		else if(self.impulse == 60) ChangeDM();
		else if(self.impulse == 61) ChangeTP();
		else if(self.impulse == 62) TogglePowerups();
		else if(self.impulse == 63) ToggleSpecTalk();
		else if(self.impulse == 65) TimeUp(5);
		else if(self.impulse == 66) TimeDown(5);
		else if(self.impulse == 67) ToggleQTimer();
		else if(self.impulse == 68) ToggleQLag();
		else if(self.impulse == 69) ToggleQEnemy();
		else if(self.impulse == 70) ToggleRespawns();
		else if(self.impulse >= 100 && !match_in_progress) SelectMap();
	}
//team
	self.impulse = 0;
};

/*
================
SpectatorThink

Called every frame after physics are run
================
*/
void() SpectatorThink =
{
//team
	local float f1, f2, f3;
	local entity p;
	local vector v1;

	self.effects = self.goalentity.effects;
//team

	// self.origin, etc contains spectator position, so you could
	// do some neat stuff here

	if(self.impulse)
		SpectatorImpulseCommand();
//team
	if(self.button2 && !self.jump_flag && self.k_track) {
		if(self.k_track == 1) {
			TrackNext();
			if(!self.suicide_time && self.k_track == 1) sprint3(self, PRINT_HIGH, "--- Tracking ", self.goalentity.netname, "\n");
		}
		else TrackNext2();
		self.jump_flag = 1;
	}
	if(!self.button2) self.jump_flag = 0;
	if(self.k_track == 1) {
		makevectors(self.goalentity.angles);
		//if someone should want to edit this code; - traceline takes the following parameters:
		//1: trace start position, 2: trace end position, 3: TRUE = don't stop at entities : FALSE = stop on first entity
		//4: take no notice of this entity (usually self)
		// /kemiKal
		if(self.k_666 != -10) {
			traceline(self.goalentity.origin, self.goalentity.origin - (v_forward * (self.k_666 - 4)), TRUE, self);
			if(trace_fraction < 1) trace_endpos = trace_endpos + (v_forward * 4);
			v1 = trace_endpos;
			traceline(v1, v1 + (v_up * 32), TRUE, self);
			if(trace_fraction == 1) {
				traceline(trace_endpos, trace_endpos + (v_up * 0.5 * (self.k_666 + 10)), TRUE, self);
				if(trace_fraction < 1) trace_endpos = trace_endpos - (v_up * 4);
				setorigin(self, trace_endpos);
			} else setorigin(self, v1);
		} else {
			traceline(self.goalentity.origin, self.goalentity.origin + (v_forward * 14), TRUE, self);
			if(trace_fraction < 1) trace_endpos = trace_endpos - (v_forward * 4);
			setorigin(self, trace_endpos);
		}
		self.angles = self.v_angle = self.goalentity.v_angle;
		self.fixangle = TRUE;
		if(time > self.deaths && self.suicide_time)
		{
			msg_entity = self;
			WriteByte(MSG_ONE, SVC_CENTERPRINT);
			WriteShort(MSG_ONE, 2592);
			WriteShort(MSG_ONE, 2570);
			WriteShort(MSG_ONE, 2570);
			WriteShort(MSG_ONE, 2570);
			WriteShort(MSG_ONE, 2570);
			WriteShort(MSG_ONE, 2570);
			if(self.suicide_time == 2) {
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
			}
			//"health xxx "
			WriteShort(MSG_ONE, 58856);
			WriteShort(MSG_ONE, 60641);
			WriteShort(MSG_ONE, 59636);
			WriteByte(MSG_ONE, 32);
			f1 = self.goalentity.health;
			if(f1 > 0 ) {
				f3 = floor(f1 / 100);
				f1 = f1 - (f3 * 100);
				if(f3) WriteByte(MSG_ONE, f3 + 48);
				else WriteByte(MSG_ONE, 32);
				f2 = floor(f1 / 10);
				f1 = f1 - (f2 * 10);
				if(f2 || f3) WriteByte(MSG_ONE, f2 + 48);
				else WriteByte(MSG_ONE, 32);
				WriteByte(MSG_ONE, f1 + 48);
				WriteByte(MSG_ONE, 32);
			} else {
			//"dead"
				WriteShort(MSG_ONE, 25956);
				WriteShort(MSG_ONE, 25697);
			}
			f1 = self.goalentity.armorvalue;
			if(f1 > 0) {
				WriteByte(MSG_ONE, 32);
				if(self.goalentity.items & IT_ARMOR1) {
					//" green armor "
					WriteByte(MSG_ONE, 32);
					WriteShort(MSG_ONE, 62183);
					WriteShort(MSG_ONE, 58853);
					WriteShort(MSG_ONE, 41198);
					WriteShort(MSG_ONE, 62177);
					WriteShort(MSG_ONE, 61421);
					WriteShort(MSG_ONE, 41202);
				} else if(self.goalentity.items & IT_ARMOR2) {
					//"yellow armor "
					WriteShort(MSG_ONE, 58873);
					WriteShort(MSG_ONE, 60652);
					WriteShort(MSG_ONE, 63471);
					WriteShort(MSG_ONE, 57760);
					WriteShort(MSG_ONE, 60914);
					WriteShort(MSG_ONE, 62191);
					WriteByte(MSG_ONE, 32);
				} else {
					//"   red armor "
					WriteByte(MSG_ONE, 32);
					WriteShort(MSG_ONE, 8224);
					WriteShort(MSG_ONE, 58866);
					WriteShort(MSG_ONE, 41188);
					WriteShort(MSG_ONE, 62177);
					WriteShort(MSG_ONE, 61421);
					WriteShort(MSG_ONE, 41202);
				}
				f3 = floor(f1 / 100);
				f1 = f1 - (f3 * 100);
				if(f3) WriteByte(MSG_ONE, f3 + 48);
				else WriteByte(MSG_ONE, 32);
				f2 = floor(f1 / 10);
				f1 = f1 - (f2 * 10);
				if(f2 || f3) WriteByte(MSG_ONE, f2 + 48);
				else WriteByte(MSG_ONE, 32);
				WriteByte(MSG_ONE, f1 + 48);
				WriteByte(MSG_ONE, 32);
			}
			WriteByte(MSG_ONE, 10);
			WriteString(MSG_ONE, self.goalentity.netname);
			self.deaths = time + 0.5;
		}
	} else if(self.k_track == 2) {
		makevectors(self.goalentity.angles);
		setorigin(self, self.goalentity.origin);
		self.angles = self.v_angle = self.goalentity.mangle;
		self.fixangle = TRUE;
		if(time > self.deaths)
		{
			p = find(world, classname, "timer");
			if(p != world) {
				msg_entity = self;
				WriteByte(MSG_ONE, SVC_CENTERPRINT);
				WriteShort(MSG_ONE, 2592);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				WriteShort(MSG_ONE, 2570);
				f1 = p.cnt;
				f2 = p.cnt2;
				if(f2 == 60) f2 = 0;
				else f1 = f1 - 1;
				f3 = floor(f1 / 10);
				f1 = f1 - (f3 * 10);
				WriteByte(MSG_ONE, f3 + 176);
				WriteByte(MSG_ONE, f1 + 176);
				WriteByte(MSG_ONE, 58);
				f3 = floor(f2 / 10);
				f2 = f2 - (f3 * 10);
				WriteByte(MSG_ONE, f3 + 176);
				WriteByte(MSG_ONE, f2 + 176);
				WriteByte(MSG_ONE, 0);
			}
			self.deaths = time + 0.5;
		}
	}
//team
};