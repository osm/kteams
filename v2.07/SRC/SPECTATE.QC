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
//shame about the feKKing mess in the spectator code, ill structure the thing later
//kK
void() ModStatus;
void() PlayerStatus;
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
//team

/*
===========
SpectatorConnect

called when a spectator connects to a server
============
*/
void() SpectatorConnect =
{
	if(match_in_progress != 2 || stof(infokey(world, "k_ann"))) {	//team
		bprint (1, "Spectator ");
		bprint (1, self.netname);
		bprint (1, " entered the game\n");
	}
	self.goalentity = world; // used for impulse 1 below

//team
	SMakeMOTD();
	stuffcmd(self, "alias status \"impulse 22\"\n");
	stuffcmd(self, "alias join \"spectator 0;wait;wait;wait;reconnect\"\n");
	stuffcmd(self, "alias commands \"impulse 100\"\n");
	stuffcmd(self, "alias admin \"impulse 101\"\n");
	stuffcmd(self, "alias forcestart \"impulse 102\"\n");
	stuffcmd(self, "alias forcebreak \"impulse 103\"\n");
	stuffcmd(self, "alias lockmap \"impulse 104\"\n");
	stuffcmd(self, "alias prewar \"impulse 105\"\n");
	stuffcmd(self, "alias who \"impulse 106\"\n");
	stuffcmd(self, "alias master \"impulse 107\"\n");
	stuffcmd(self, "alias about \"impulse 108\"\n");
//team
};

/*
===========
SpectatorDisconnect

called when a spectator disconnects from a server
============
*/
void() SpectatorDisconnect =
{
	if(match_in_progress != 2 || stof(infokey(world, "k_ann"))) {	//team
		bprint (1, "Spectator ");
		bprint (1, self.netname);
		bprint (1, " left the game\n");
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
	if(self.k_admin == 1 && self.impulse >= 1 && self.impulse <=9)
	{
		AdminImpBot();
		self.impulse = 0;
		return;
	}
//team
	if (self.impulse == 1) {
		// teleport the spectator to the next spawn point
		// note that if the spectator is tracking, this doesn't do
		// much
		self.goalentity = find(self.goalentity, classname, "info_player_deathmatch");
		if (self.goalentity == world)
			self.goalentity = find(self.goalentity, classname, "info_player_deathmatch");
		if (self.goalentity != world) {
			setorigin(self, self.goalentity.origin);
			self.angles = self.goalentity.angles;
			self.fixangle = 1;           // turn this way immediately
		}
	}
//team
	else if(self.impulse == 22) ModStatus();
	else if(self.impulse == 100) SShowCmds();
	else if(self.impulse == 101) ReqAdmin();
	else if(self.impulse == 102) AdminForceStart();
	else if(self.impulse == 103) AdminForceBreak();
	else if(self.impulse == 104) ToggleMapLock();
	else if(self.impulse == 105) TogglePreWar();
	else if(self.impulse == 106) PlayerStatus();
	else if(self.impulse == 107) ToggleMaster();
	else if(self.impulse == 108) ShowVersion();
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
	// self.origin, etc contains spectator position, so you could
	// do some neat stuff here

	if (self.impulse)
		SpectatorImpulseCommand();
};