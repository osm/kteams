
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float   modelindex_eyes, modelindex_player;

// TEAM -->
void(float skip_log) EndMatch;
void() StuffAliases;
float() CountALLPlayers;
// <-- TEAM
/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

string nextmap;

float   intermission_running;
float   intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
        self.angles = self.mangle;
};

void() SetChangeParms =
{
// TEAM -->
	if(match_in_progress == 2) {
		parm1 = 1 | 4096;
		parm8 = 1;
		parm2 = 100;
		parm3 = 0;
		parm4 = 25;
		parm5 = 0;
		parm6 = 0;
		parm7 = 0;
	} else {
		parm1 = 4096 | 1 | 2 | 4 | 8 | 32 | 16 | 64;
		parm2 = 100;
		parm3 = 0;
		parm4 = 100;
		parm5 = 200;
		parm6 = 100;
		parm7 = 100;
		parm8 = 32;
	}
	parm9 = 0;
//	parm10 = self.userid;
	parm11 = self.k_admin;
	parm12 = self.k_accepted;
// <-- TEAM
};

void() SetNewParms =
{
//team
	local string t;

	if(match_in_progress == 2) {
		parm1 = 1 | 4096;
		parm8 = 1;
		parm2 = 100;
		parm3 = 0;
		parm4 = 25;
		parm5 = 0;
		parm6 = 0;
		parm7 = 0;
	} else {
		parm1 = 4096 | 1 | 2 | 4 | 8 | 32 | 16 | 64;
		parm2 = 100;
		parm3 = 0;
		parm4 = 100;
		parm5 = 200;
		parm6 = 100;
		parm7 = 100;
		parm8 = 32;
	}
	parm9 = 0;
/*
	k_userid = stof(infokey(world, "k_levelubase"));
	k_userid = k_userid + 1;
	localcmd("localinfo k_levelubase ");
	t = ftos(k_userid);
	localcmd(t);
	localcmd("\n");
	parm10 = k_userid;
*/
	parm11 = 0;
	parm12 = 0;
//team
};

void() DecodeLevelParms =
{
	local entity r;

//team
/*
	if(serverflags) {
		if(world.model == "maps/start.bsp") SetNewParms ();         // take away all stuff on starting new episode
	}
*/
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
//	if(parm10) self.userid = parm10;
	self.k_admin = parm11;
	if(parm12) self.k_accepted = parm12;
//team
};

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local   entity spot;
	local   float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{       // pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;

	objerror ("FindIntermission: no spot");
};


void() GotoNextMap =
{
	local string newmap;

//ZOID: 12-13-96, samelevel is overloaded, only 1 works for same level
	if (cvar("samelevel") == 1)     // if samelevel is set, stay on same level
		changelevel (mapname);
	else {
		// configurable map lists, see if the current map exists as a
		// serverinfo/localinfo var
		newmap = infokey(world, mapname);
		if (newmap != "")
			changelevel (newmap);
        	else
                	changelevel (nextmap);
        }
};



/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;

	GotoNextMap ();
};

/*
============
execute_changelevel

The global "nextmap" has been set previously.
Take the players to the intermission spot
============
*/
void() execute_changelevel =
{
	local entity    pos;

	intermission_running = 1;

// enforce a wait time before allowing changelevel
	intermission_exittime = time + 5;

	pos = FindIntermission ();

// play intermission music
	WriteByte (2, 32);
	WriteByte (2, 3);

	WriteByte (2, 30);
	WriteCoord (2, pos.origin_x);
	WriteCoord (2, pos.origin_y);
	WriteCoord (2, pos.origin_z);
	WriteAngle (2, pos.mangle_x);
	WriteAngle (2, pos.mangle_y);
	WriteAngle (2, pos.mangle_z);

	other = find (world, classname, "player");
	while (other != world)
	{
		other.takedamage = 0;
		other.solid = 0;
		other.movetype = 0;
		other.modelindex = 0;
		other = find (other, classname, "player");
	}

};


void() changelevel_touch =
{
	local entity    pos;

	if (other.classname != "player")
		return;

// if "noexit" is set, blow up the player trying to leave
//ZOID, 12-13-96, noexit isn't supported in QW.  Overload samelevel
//      if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	if ((cvar("samelevel") == 2) || ((cvar("samelevel") == 3) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	bprint (2, other.netname);
	bprint (2," exited the level\n");

	nextmap = self.map;

	SUB_UseTargets ();

	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if(!self.map) objerror ("changelevel trigger doesn't have map");		//team
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	// make a copy of the dead body for appearances sake
	CopyToBodyQue (self);
	// set default spawn parms
	SetChangeParms ();
	// respawn
	PutClientInServer ();
};


/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
// TEAM -->
	if((time < self.suicide_time + 10) && stof(infokey(world, "k_kfp"))) {
		sprint(self, 2, "Only one suicide in 10 seconds\n");
		return;
	}
	self.suicide_time = time;
// <-- TEAM
	bprint (1, self.netname);
	bprint (1, " suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	logfrag (self, self);
	if(match_in_progress == 2)	//team
		self.frags = self.frags - 2;    // extra penalty
	respawn ();
};

float(vector v) CheckSpawnPoint =
{
	return 0;
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity() SelectSpawnPoint =
{
    local   entity  spot, newspot, thing;
	local	entity spots;
	local   float   numspots, totalspots;
	local   float   rnum, pcount;
	local   float   rs;
	local	float	k_nspots;	//team
	local	string	t1;			//team


	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;

// choose a info_player_deathmatch point
// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, "info_player_deathmatch");
	while (spot) {
		totalspots = totalspots + 1;
		thing = findradius(spot.origin, 84);
        pcount = 0;
		while(thing) {
//team
//			if (thing.classname == "player") pcount = pcount + 1;
			if(thing.classname == "player") {
				if(!(stof(infokey(world, "k_spw")) == 2 && match_in_progress == 2 && !thing.k_1spawn) &&
					thing.health > 0) pcount = pcount + 1;
//				if(!((stof(infokey(world, "k_spw")) != 2) && !thing.k_1spawn && match_in_progress == 2)
//					 && thing.health > 0) pcount = pcount + 1;
			}
//team
			thing = thing.chain;
		}
//team
		if(stof(infokey(world, "k_spw")) && match_in_progress == 2 && self.k_lastspawn == spot)
		 pcount = pcount + 1;
//team
        if (pcount == 0) {
        	spot.goalentity = spots;
        	spots = spot;
        	numspots = numspots + 1;
		}
		// Get the next spot in the chain
		spot = find (spot, classname, "info_player_deathmatch");
	}

//team
	if(match_in_progress == 2) self.k_1spawn = 60;
	k_nspots = totalspots;
//team
	totalspots = totalspots - 1;
	if (!numspots) {
// ack, they are all full, just pick one at random
//		bprint (2, "Ackk! All spots are full. Selecting random spawn spot\n");
		totalspots = rint((random() * totalspots));
		spot = find (world, classname, "info_player_deathmatch");
		while (totalspots > 0) {
			totalspots = totalspots - 1;
			spot = find (spot, classname, "info_player_deathmatch");
		}
		if(k_nspots > 2 && match_in_progress == 2) self.k_lastspawn = spot;  //team
		return spot;
    }

// We now have the number of spots available on the map in numspots
// Generate a random number between 1 and numspots

	numspots = numspots - 1;
	numspots = rint((random() * numspots));
	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	if(k_nspots > 2 && match_in_progress == 2) self.k_lastspawn = spot;  //team
 	return spot;
};

void() DecodeLevelParms;
void() PlayerDie;

/*
===========
ValidateUser


============
*/
float(entity e) ValidateUser =
{
/*
	local string    s;
	local string    userclan;
	local float     rank, rankmin, rankmax;

//
// if the server has set "clan1" and "clan2", then it
// is a clan match that will allow only those two clans in
//
	s = serverinfo("clan1");
	if (s)
	{
		userclan = masterinfo(e,"clan");
		if (s == userclan)
			return true;
		s = serverinfo("clan2");
		if (s == userclan)
			return true;
		return false;
	}

//
// if the server has set "rankmin" and/or "rankmax" then
// the users rank must be between those two values
//
	s = masterinfo (e, "rank");
	rank = stof (s);

	s = serverinfo("rankmin");
	if (s)
	{
		rankmin = stof (s);
		if (rank < rankmin)
			return false;
	}
	s = serverinfo("rankmax");
	if (s)
	{
		rankmax = stof (s);
		if (rankmax < rank)
			return false;
	}

	return true;
*/
};

/*
===========
PutClientInServer

called each time a player enters a new level
============
*/
void() PutClientInServer =
{
	local   entity spot;
        local   string s;

	self.classname = "player";
	self.health = 100;
	self.takedamage = 2;
	self.solid = 3;
	self.movetype = 3;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = 8;
	self.air_finished = time + 12;
	self.dmg = 2;                   // initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
//team
	if(stof(infokey(world, "k_sready")) && !match_in_progress && !self.ready)
		self.effects = 64;
	else self.effects = 0;
//team
	self.invincible_time = 0;

	DecodeLevelParms ();

	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;

	self.deadflag = 0;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;

	spot = SelectSpawnPoint ();

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = 1;           // turn this way immediately

// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, '-16 -16 -24', '16 16 32');

	self.view_ofs = '0 0 22';

        self.velocity = '0 0 0';

		makevectors(self.angles);

//team
	self.mdl = self.model;
	if(!self.k_accepted && match_in_progress == 2) {
		self.takedamage = 0;
		self.solid = 0;
		self.movetype = 0;
		self.modelindex = 0;
		self.model = string_null;
	} else {
		self.k_accepted = 2;
		self.takedamage = 2;
		self.solid = 3;
		self.movetype = 3;
		self.modelindex = modelindex_player;
		self.model = self.mdl;
		player_stand1 ();
		spawn_tfog (self.origin + v_forward*20);
		spawn_tdeath (self.origin, self);
//berzerk will not affect players that logs in during berzerk
//spawn666 will not affect the first spawn of players connecting to a game in progress
		if(match_in_progress == 2) {
			if(stof(infokey(world, "k_bzk")) && k_berzerk) {
				self.items = self.items | 4194304;
				self.super_time = 1;
				self.super_damage_finished = time + 30;
			}
			if(stof(infokey(world, "k_666"))) {
				stuffcmd (self, "bf\n");
				self.invincible_time = 1;
				self.invincible_finished = time + 2;
				self.k_666 = 1;
				self.items = self.items | 1048576;
			}
		}
	}
//team

	// Set Rocket Jump Modifiers
	if (stof(infokey(world, "rj")) != 0)
	{
		rj = stof(infokey(world, "rj"));
	}

	if (deathmatch == 4 && match_in_progress == 2)
	{
		self.ammo_shells = 0;
		if (stof(infokey(world, "axe")) == 0)
		{
			self.ammo_nails = 255;
			self.ammo_shells = 255;
			self.ammo_rockets = 255;
			self.ammo_cells = 255;
			self.items = self.items | 4;
			self.items = self.items | 8;
			self.items = self.items | 2;
			self.items = self.items | 32;
//		self.items = self.items | 16;
			self.items = self.items | 64;
		}
		self.items = self.items - (self.items & (8192 | 16384 | 32768)) + 32768;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 250;
		self.items = self.items | 1048576;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}

	if (deathmatch == 5 && match_in_progress == 2)
	{
		self.ammo_nails = 80;
		self.ammo_shells = 30;
		self.ammo_rockets = 10;
		self.ammo_cells = 30;
		self.items = self.items | 4;
		self.items = self.items | 8;
		self.items = self.items | 2;
		self.items = self.items | 32;
		self.items = self.items | 16;
		self.items = self.items | 64;
		self.items = self.items - (self.items & (8192 | 16384 | 32768)) + 32768;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 200;
		self.items = self.items | 1048576;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}
};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
*/
void() NextLevel =
{
	local entity o;
	local string newmap;

	if (nextmap != "")
		return; // already done

	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}

		o = spawn();
		o.map = mapname;
	}
	else
	{
// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");
		if (!o || mapname == "start")
		{       // go back to same map if no trigger_changelevel
			o = spawn();
			o.map = mapname;
		}
	}

	nextmap = o.map;

	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{
// TEAM -->
/*
	if (timelimit && time >= timelimit) NextLevel ();
*/
	if(fraglimit && self.frags >= fraglimit) EndMatch(0);
// <-- TEAM
};

//============================================================================

void() PlayerDeathThink =
{
	local entity    old_self;
	local float             forward;

	if ((self.flags & 512))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else
			self.velocity = forward * normalize(self.velocity);
	}

//team   autospawn
	if(time - self.dead_time > 5) {
		self.deadflag = 3;
		respawn();
		return;
	}
//team

// wait for all buttons released
	if (self.deadflag == 2)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = 3;
		return;
	}

// wait for any button down
	if((!self.button2 && !self.button1 && !self.button0)) return;
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};


void() PlayerJump =
{
	local vector start, end;

	if (self.flags & 2048)
		return;

	if (self.waterlevel >= 2)
	{
// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, 4, "misc/water1.wav", 1, 1);
			else
				sound (self, 4, "misc/water2.wav", 1, 1);
		}

		return;
	}

	if (!(self.flags & 512))
		return;

	if ( !(self.flags & 4096) )
		return;         // don't pogo stick

	self.flags = self.flags - (self.flags & 4096);
	self.button2 = 0;

// player jumping sound
	sound (self, 4, "player/plyrjmp8.wav", 1, 1);
};


/*
===========
WaterMove

============
*/
.float  dmgtime;

void() WaterMove =
{
//dprint (ftos(self.waterlevel));
	if (self.movetype == 8)
		return;
	if (self.health < 0)
		return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			sound (self, 2, "player/gasp2.wav", 1, 1);
		else if (self.air_finished < time + 9)
			sound (self, 2, "player/gasp1.wav", 1, 1);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{       // drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}

	if (!self.waterlevel)
	{
		if (self.flags & 16)
		{
			// play leave water sound
			sound (self, 4, "misc/outwater.wav", 1, 1);
			self.flags = self.flags - 16;
		}
		return;
	}

	if (self.watertype == -5)
	{       // do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == -4)
	{       // do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}

	if ( !(self.flags & 16) )
	{

// player enter water sound

		if (self.watertype == -5)
			sound (self, 4, "player/inlava.wav", 1, 1);
		if (self.watertype == -3)
			sound (self, 4, "player/inh2o.wav", 1, 1);
		if (self.watertype == -4)
			sound (self, 4, "player/slimbrn2.wav", 1, 1);

		self.flags = self.flags + 16;
		self.dmgtime = 0;
	}
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8;
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, 1, self);
	if (trace_fraction < 1)
	{       // solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, 1, self);
		if (trace_fraction == 1)
		{       // open at eye level
			self.flags = self.flags | 2048;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & 4096);
			self.teleport_time = time + 2;  // safety net
			return;
		}
	}
};

/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
	local   float   mspeed, aspeed;
	local   float   r;

	if (intermission_running)
	{
		IntermissionThink ();   // otherwise a button could be missed between
		return;                                 // the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;         // intermission or finale

	if(!self.k_accepted) return;	//team

	makevectors (self.v_angle);             // is this still used

        self.deathtype = "";

	CheckRules ();
	WaterMove ();
/*
	if (self.waterlevel == 2)
		CheckWaterJump ();
*/

	if (self.deadflag >= 2)
	{
		PlayerDeathThink ();
		return;
	}

	if (self.deadflag == 1)
		return; // dying, so do nothing

	if (self.button2)
                PlayerJump ();
	else
		self.flags = self.flags | 4096;

// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	if(time > self.attack_finished && self.currentammo == 0 && self.weapon != 4096)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}

};

/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, 0, "items/inv3.wav", 0.5, 2);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, 2, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, 0, "items/inv2.wav", 1, 1);
				self.invisible_time = time + 1;
			}

			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{       // just stopped
			self.items = self.items - 524288;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}

	// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
		self.modelindex = modelindex_player;    // don't use eyes

// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if(self.invincible_finished < time + 3 && !self.k_666)		//team
		{
			if (self.invincible_time == 1)
			{
				sprint (self, 2, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, 0, "items/protect2.wav", 1, 1);
				self.invincible_time = time + 1;
			}

			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invincible_finished < time)
		{       // just stopped
			self.items = self.items - (self.items & 1048576);
			self.invincible_time = 0;
			self.invincible_finished = 0;
			self.k_666 = 0;		//team
		}
		if(self.invincible_finished > time && !self.k_666) { //team
			self.effects = self.effects | 8;
			self.effects = self.effects | 128;
                }
		else {
			self.effects = self.effects - (self.effects & 8);
			self.effects = self.effects - (self.effects & 128);
                }
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if(self.super_damage_finished < time + 3 && !k_berzerk)	//team
		{
			if (self.super_time == 1)
			{
				if (deathmatch == 4)
					sprint (self, 2, "OctaPower is wearing off\n");
				else
        				sprint (self, 2, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, 0, "items/damage2.wav", 1, 1);
				self.super_time = time + 1;
			}

			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if(self.super_damage_finished < time && !k_berzerk)	//team
		{       // just stopped
			self.items = self.items - 4194304;
			if (deathmatch == 4)
			{
				self.ammo_cells = 255;
				self.armorvalue = 1;
				self.armortype = 0.8;
				self.health = 100;
			}
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time) {
			self.effects = self.effects | 8;
			self.effects = self.effects | 64;
                }
		else {
			self.effects = self.effects - (self.effects & 8);
			self.effects = self.effects - (self.effects & 64);
                }
	}

// suit
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;          // don't drown

// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, 2, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, 0, "items/suit2.wav", 1, 1);
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{       // just stopped
			self.items = self.items - 2097152;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}

};


/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{
	local   float   mspeed, aspeed;
	local   float   r;
	local string s1, s2;	//team
	local float f1, f2;	//team
	local entity ghost;	//team

//dprint ("post think\n");

//team
	if(match_in_progress == 2 && self.k_accepted == 2 && self.k_teamnum && k_checkx) {
		s1 = ftos(self.k_teamnum);
		s2 = infokey(world, s1);
		s1 = infokey(self, "team");
		if(s1 != s2)
		{
			logfrag (self, self);
			self.frags = self.frags - 2;
			stuffcmd(self, "\ndisconnect\n");
			bprint2(2, self.netname, " gets kicked for changing team\n");
			self.k_accepted = 0;
			f1 = 1;
			f2 = 0;
			while(f1 < k_userid && !f2) {
				s1 = ftos(f1);
				s1 = infokey(world, s1);
				if(s1 == "") f2 = 1;
				else f1 = f1 + 1;
			}
			if(!f2) k_userid = k_userid + 1;
			ghost = spawn();
			ghost.owner = world;
			ghost.classname = "ghost";
			ghost.cnt = f1;
			ghost.k_teamnum = self.k_teamnum;
			ghost.frags = self.frags;
			ghost.deaths = self.deaths;
			ghost.ready = 0;
			s1 = ftos(f1);
			localcmd("localinfo ");
			localcmd(s1);
			localcmd(" \"");
			localcmd(self.netname);
			localcmd("\"\n");
		}
	}
	if(self.k_accepted == 1) {
		self.k_accepted = 2;
		self.takedamage = 2;
		self.solid = 3;
		self.movetype = 3;
		self.modelindex = modelindex_player;
		self.model = self.mdl;
		player_stand1 ();
		spawn_tfog (self.origin + v_forward*20);
		spawn_tdeath (self.origin, self);
	}
//team

	if (self.view_ofs == '0 0 0')
		return;         // intermission or finale
	if (self.deadflag)
		return;

//team
	if(!self.k_accepted && match_in_progress == 2) return;
	if(self.k_1spawn) self.k_1spawn = self.k_1spawn - 1;
//team

// check to see if player landed and play landing sound
	if ((self.jump_flag < -300) && (self.flags & 512) )
	{
		if (self.watertype == -3)
			sound (self, 4, "player/h2ojump.wav", 1, 1);
		else if (self.jump_flag < -650)
		{
			self.deathtype = "falling";
			T_Damage (self, world, world, 5);
			sound (self, 2, "player/land2.wav", 1, 1);
		}
		else
			sound (self, 2, "player/land.wav", 1, 1);
	}

	self.jump_flag = self.velocity_z;

	CheckPowerups ();

	W_WeaponFrame ();
};

/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
// TEAM -->
	MakeMOTD();
// <-- TEAM

// a client connecting during an intermission can cause problems
	if(intermission_running)
		GotoNextMap();
};

/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
//kombat teams gained control over this
	local entity ghost;
	local float f1, f2, f3;
	local string s1;

	if(self.k_accepted == 2) {
		bprint(2, self.netname);
		bprint(2, " left the game with ");
		bprint(2, ftos(self.frags));
		bprint(2, " frags\n");
		sound(self, 4, "player/tornoff2.wav", 1, 0);
		set_suicide_frame();
		if(match_in_progress == 2) {
			f1 = 1;
			f2 = 0;
			while(f1 < k_userid && !f2) {
				s1 = ftos(f1);
				s1 = infokey(world, s1);
				if(s1 == "") f2 = 1;
				else f1 = f1 + 1;
			}
			if(!f2) k_userid = k_userid + 1;
			ghost = spawn();
			ghost.owner = world;
			ghost.classname = "ghost";
			ghost.cnt = f1;
			ghost.k_teamnum = self.k_teamnum;
			ghost.frags = self.frags;
			ghost.deaths = self.deaths;
			ghost.ready = 0;
			s1 = ftos(f1);
			localcmd("localinfo ");
			localcmd(s1);
			localcmd(" \"");
			localcmd(self.netname);
			localcmd("\"\n");
		}
	} else if(match_in_progress == 2) {
		self.takedamage = 0;
		self.solid = 0;
		self.movetype = 0;
		self.modelindex = 0;
		self.model = string_null;
	}

	f1 = CountALLPlayers();
	if(f1 < 2) {
		s1 = infokey(world, "k_defmap");
		if(s1 != "" && s1 != mapname) {
			if(match_in_progress) EndMatch(1);
			localcmd("map ");
			localcmd(s1);
			localcmd("\n");
		}
	}
//team
};

/*
===========
ClientObituary

called when a player dies
============
*/
void(entity targ, entity attacker) ClientObituary =
{
	local   float rnum;
	local   string deathstring, deathstring2;
	local   string s;
	local   string attackerteam, targteam;
	local string attackerteam2;	//team

	rnum = random();
	//ZOID 12-13-96: self.team doesn't work in QW.  Use keys
	attackerteam = infokey(attacker, "team");
	targteam = infokey(targ, "team");

	if (targ.classname == "player")
	{

		if (deathmatch > 3)
		{
			if (targ.deathtype == "selfwater")
			{
				bprint (1, targ.netname);
///team
				if(infokey(targ,"gender") == "f") bprint(1," electrocutes herself.\n");
				else bprint(1," electrocutes himself.\n");
///team
				targ.frags = targ.frags - 1;
				return;
			}
		}

		if (attacker.classname == "teledeath")
		{
// team --> no points for telefragging teammate
			if(match_in_progress != 2) {
				bprint2(1,targ.netname, " was telefragged\n");
				return;
			}
			attackerteam2 = infokey(attacker.owner, "team");
			if(teamplay && targteam == attackerteam2 && attackerteam2 != "" && targ != attacker.owner)
			{
				bprint(1,targ.netname);
				if(infokey(targ,"gender") == "f") bprint (1," was telefragged by her teammate\n");
				else bprint(1," was telefragged by his teammate\n");
				targ.deaths = targ.deaths + 1;
				return;
			}
			bprint(1,targ.netname);
			bprint(1," was telefragged by ");
			bprint(1,attacker.owner.netname);
			bprint(1,"\n");
			attacker.owner.frags = attacker.owner.frags + 1;
			targ.deaths = targ.deaths + 1;
			logfrag (attacker.owner, targ);
// <-- team
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint (1,"Satan's power deflects ");
			bprint (1,targ.netname);
			bprint (1,"'s telefrag\n");

	            targ.frags = targ.frags - 1;
			logfrag (targ, targ);
			return;
		}

		// double 666 telefrag (can happen often in deathmatch 4)
		if (attacker.classname == "teledeath3")
		{
			bprint (1,targ.netname);
			bprint (1," was telefragged by ");
			bprint (1,attacker.owner.netname);
			bprint (1, "'s Satan's power\n");
			targ.frags = targ.frags - 1;
			logfrag (targ, targ);
			return;
		}


		if (targ.deathtype == "squish")
		{
			if (teamplay && targteam == attackerteam && attackerteam != "" && targ != attacker)
			{
				logfrag (attacker, attacker);
				attacker.frags = attacker.frags - 1;
				bprint (1,attacker.netname);
				bprint (1," squished a teammate\n");
				return;
			}
			else if (attacker.classname == "player" && attacker != targ)
			{
				bprint (1, attacker.netname);
				bprint (1," squishes ");
				bprint (1,targ.netname);
				bprint (1,"\n");
				logfrag (attacker, targ);
                                        attacker.frags = attacker.frags + 1;
				targ.deaths = targ.deaths + 1;	// team
				return;
			}
			else
			{
				logfrag (targ, targ);
				targ.frags = targ.frags - 1;            // killed self
				bprint (1,targ.netname);
				bprint (1," was squished\n");
				return;
			}
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				logfrag (attacker, attacker);
                                        attacker.frags = attacker.frags - 1;
				bprint (1,targ.netname);

				if (targ.deathtype == "grenade")
					bprint (1," tries to put the pin back in\n");
				else if (targ.deathtype == "rocket")
					bprint (1," becomes bored with life\n");
				else if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					if (targ.watertype == -4)
						bprint (1," discharges into the slime\n");
					else if (targ.watertype == -5)
						bprint (1," discharges into the lava\n");
					else
        					bprint (1," discharges into the water.\n");
					return;
				}
                                else
					bprint (1," becomes bored with life\n");
                        }
			else if ( (teamplay == 2) && (targteam == attackerteam) && (attackerteam != "") )
			{
///team
//0.25 changed to 0.33 and 0.50 changed to 0.66 for kombat teams
				if(rnum < 0.33) deathstring = " mows down a teammate\n";
				else if(rnum < 0.66) if(infokey(attacker.owner,"gender") == "f") deathstring = " checks her glasses\n";
					else deathstring = " checks his glasses\n";
// shite message - removed by kombat teams
//                                else if (rnum < 0.75)
//					deathstring = " gets a frag for the other team\n";
// removed by kombat teams
///team
				else
					deathstring = " loses another friend\n";
				bprint (1, attacker.netname);
				bprint (1, deathstring);
                                        attacker.frags = attacker.frags - 1;
				//ZOID 12-13-96:  killing a teammate logs as suicide
				logfrag (attacker, attacker);
				return;
			}
			else
			{
				logfrag (attacker, targ);
                attacker.frags = attacker.frags + 1;
                targ.deaths = targ.deaths + 1;
   				rnum = attacker.weapon;
				if (targ.deathtype == "nail")
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				if (targ.deathtype == "supernail")
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "grenade")
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				else if (targ.deathtype == "rocket")
				{
					if (attacker.super_damage_finished > 0 && targ.health < -40)
					{
						rnum = random();
						if (rnum < 0.3)
							deathstring = " was brutalized by ";
						else if (rnum < 0.6)
							deathstring = " was smeared by ";
						else
						{
							bprint (1, attacker.netname);
							bprint (1, " rips ");
							bprint (1, targ.netname);
							bprint (1, " a new one\n");
							return;
						}
       						deathstring2 = "'s quad rocket\n";
					}
					else
                                        {
						deathstring = " rides ";
						deathstring2 = "'s rocket\n";
						if (targ.health < -40)
                                                {
							deathstring = " was gibbed by ";
							deathstring2 = "'s rocket\n" ;
						}
					}
				}
				else if (rnum == 4096)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				else if (rnum == 1)
				{
					deathstring = " chewed on ";
				deathstring2 = "'s boomstick\n";
				}
				else if (rnum == 2)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				else if (rnum == 64)
				{
					deathstring = " accepts ";
					if (attacker.waterlevel > 1)
						deathstring2 = "'s discharge\n";
					else
						deathstring2 = "'s shaft\n";
				}
				bprint (1,targ.netname);
				bprint (1,deathstring);
				bprint (1,attacker.netname);
				bprint (1,deathstring2);
			}
			return;
		}
		else
		{
			logfrag (targ, targ);
                                targ.frags = targ.frags - 1;            // killed self
			rnum = targ.watertype;

			bprint (1,targ.netname);
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (1," sleeps with the fishes\n");
				else
					bprint (1," sucks it down\n");
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (1," gulped a load of slime\n");
				else
					bprint (1," can't exist on slime alone\n");
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint (1," burst into flames\n");
					return;
				}
				if (random() < 0.5)
					bprint (1," turned into hot slag\n");
				else
					bprint (1," visits the Volcano God\n");
				return;
			}
			if (attacker.classname == "explo_box")
			{
				bprint (1," blew up\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
///team
				if(infokey(targ,"gender") == "f") bprint(1," fell to her death\n");
				else bprint(1," fell to his death\n");
///team
				return;
			}
			if (targ.deathtype == "nail" || targ.deathtype == "supernail")
			{
				bprint (1," was spiked\n");
				return;
			}
			if (targ.deathtype == "laser")
 			{
				bprint (1," was zapped\n");
 				return;
 			}
			if (attacker.classname == "fireball")
			{
				bprint (1," ate a lavaball\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (1," tried to leave\n");
				return;
			}

			bprint (1," died\n");
		}
	}
};