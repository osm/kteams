// commands.qc

m4_define(Cmds, `(m4_dnl
ready,break,status2,status,powerups,dm,tp,timedown1,timeup1,m4_dnl
timedown,timeup,fragsdown,fragsup,dropquad,dropring,discharge,m4_dnl
options,silence,advanced,reset,rules,lock,spawn666,berzerk,m4_dnl
master,time5,time10,time15,time20,time25,time30,whoskin,whonot,who,droppack,m4_dnl
fairpacks,speed,spawn,about,ksound1,ksound2,ksound3,ksound4,ksound5,ksound6,m4_dnl
scores,qizmo,qtimer,qlag,qenemy,m4_dnl
maps,admin,forcestart,forcebreak,prewar,lockmap,commands)')

m4_define(`HELPTEXT',`m4_dnl
COLOR(`rules')...... show game rules
COLOR(`ready')...... when you feel ready
COLOR(`break')...... unready / vote matchend
COLOR(`options').... more commands
COLOR(`advanced')... even more commands
COLOR(`qi')úíï...... qizmo related commands
COLOR(`status')..... show server settings
COLOR(`status2').... more server settings
COLOR(`reset')...... set defaults
COLOR(`maps')....... list custom maps
COLOR(`who')........ player teamlist
COLOR(`whonot')..... players not ready
COLOR(`whoskin').... player skinlist
COLOR(`scores')..... prints teamscores
')

m4_define(`SHELPTEXT',`m4_dnl
COLOR(`status')..... show match settings
COLOR(`cam')........ camera help text
COLOR(`who')........ player teamlist
COLOR(`whoskin').... player skinlist
COLOR(`join')....... joins game
')

m4_define(`OPTSTEXT',`m4_dnl
COLOR(`timedown1').. -1 mins match time
COLOR(`timeup1').... +1 mins match time
COLOR(`timedown')... -5 mins match time
COLOR(`timeup')..... +5 mins match time
COLOR(`fragsdown').. -10 fraglimit
COLOR(`fragsup').... +10 fraglimit
COLOR(`dm')......... change deathmatch mode
COLOR(`tp')......... change teamplay mode
COLOR(`dropquad')... drop quad when killed
COLOR(`dropring')... drop ring when killed
COLOR(`droppack')... drop pack when killed
COLOR(`lock')....... change locking mode
')

m4_define(`ADVTEXT',`m4_dnl
COLOR(`spawn')...... change spawntype
COLOR(`speed')...... toggle sv_maxspeed
COLOR(`powerups')... ``quad, 666, ring & suit''
COLOR(`spawn666')... 2 secs of 666 on respawn
COLOR(`fairpacks').. best-weapon backpacks
COLOR(`discharge').. underwater discharges
COLOR(`silence').... toggle spectator talk
COLOR(`ber')úåòë.... toggle berzerk mode
')

m4_define(`QIZMOTEXT',`m4_dnl
COLOR(`qtimer')..... powerup timers
COLOR(`qlag')....... lagsettings
COLOR(`qenemy')..... enemy vicinity reporting
')

m4_define(`ADMTEXT',`m4_dnl
COLOR(`admin')....... give up admin rights
COLOR(`prewar')...... playerfire before game
COLOR(`lockmap')..... (un)locks current map
COLOR(`forcestart').. forces match to start
COLOR(`forcebreak').. forces match to end
COLOR(`master')...... toggles mastermode
')

m4_define(`MAPSTEXT',`m4_dnl
Vote for maps by typing the mapname`,'
for example \"COLOR(`dm4')\".
')

void() ShowCmds =
{
	if(self.k_admin == 2) sprint(self, PRINT_HIGH, "multiline(`ADMTEXT')");
	else {
		sprint(self, PRINT_HIGH, "multiline(`HELPTEXT')");
		if(stof(infokey(world, "k_admins"))) {
			sprint(self, PRINT_HIGH, "COLOR(`admin')...... toggle admin-mode\n");
		}
	}
};

void() ShowVersion =
{
	sprint(self, PRINT_CHAT, "\nThis is Kombat Teams KTVERSION\nby kemiKal_sWeMoB and Fang.\n\nSource, soundbanks, configs etc. at:\nhttp://www.kemikal.com\n");
};

void() SShowCmds =
{
	if(self.k_admin == 2) sprint(self, PRINT_HIGH, "multiline(`ADMTEXT')");
	else {
		sprint(self, PRINT_HIGH, "multiline(`SHELPTEXT')");
		if(stof(infokey(world, "k_admins"))) {
			sprint(self, PRINT_HIGH, "COLOR(`admin')...... toggle admin-mode\n");
		}
	}
};

void() ShowOpts =
{
	sprint(self, PRINT_HIGH, "multiline(`OPTSTEXT')");
};

void() ShowAdv =
{
	sprint(self, PRINT_HIGH, "multiline(`ADVTEXT')");
};

void() ShowQizmo =
{
	sprint(self, PRINT_HIGH, "multiline(`QIZMOTEXT')");
};

void() ShowMaps =
{
	local float f1;
	local string s1, s2;

	sprint(self, PRINT_HIGH, "multiline(`MAPSTEXT')");
	f1 = stof(infokey(world, "999"));
	if(f1 > 137) {
		sprint(self, PRINT_HIGH, "\n---COLOR(`list of custom maps')\n");
		f1 = 1000;
		s1 = ftos(f1);
		s2 = infokey(world, s1);
		while(s2 != "") {
			if(f1 & 1) {
				sprint2(self, PRINT_HIGH, s2, "\n");
			} else {
				sprint2(self, PRINT_HIGH, s2, "   ");
			}
			f1 = f1 + 1;
			s1 = ftos(f1);
			s2 = infokey(world, s1);
		}
		if(f1 & 1) sprint(self, PRINT_HIGH, "\n");
		sprint(self, PRINT_HIGH, "COLOR(`---end of list')\n");
	}

};

void() StuffAliases =
{
m4_define(FirstCmdImpulse, 20)
m4_define(CmdImpulse, FirstCmdImpulse)
foreach(x, Cmds,
`m4_define(`CMD_'x, CmdImpulse)
 alias_imp(x, CmdImpulse)m4_dnl
m4_define(`CmdImpulse', m4_incr(CmdImpulse))')
m4_define(LastCmdImpulse, m4_decr(CmdImpulse))
 alias_imp(`report',`IMP_REPORT')
};

void(string tog, string key) PrintToggle1 =
{
	sprint(self, PRINT_HIGH, tog);
	if(stof(infokey(world, key)) != 0) sprint(self, PRINT_HIGH, "On  ");
	else sprint(self, PRINT_HIGH, "Off ");
};

void(string tog, string key) PrintToggle2 =
{
	sprint(self, PRINT_HIGH, tog);
	if(stof(infokey(world, key)) != 0) sprint(self, PRINT_HIGH, "On\n");
	else sprint(self, PRINT_HIGH, "Off\n");
};

void() ModStatus =
{
	local entity p;
	local string tmp;
	local float n, f1, k_lockmin, k_lockmax;

	tmp = ftos(k_maxspeed);
	sprint3(self, PRINT_HIGH, "COLOR(`Maxspeed')       ", tmp, "\n");
	tmp = ftos(deathmatch);
	sprint3(self, PRINT_HIGH, "COLOR(`Deathmatch')     ", tmp, "   ");
	tmp = ftos(teamplay);
	sprint3(self, PRINT_HIGH, "COLOR(`Teamplay')       ", tmp, "\n");
	tmp = ftos(timelimit);
	sprint3(self, PRINT_HIGH, "COLOR(`Timelimit')      ", tmp, " ");
	if(timelimit < 10) sprint(self, PRINT_HIGH, "  ");
	else if(timelimit < 100) sprint(self, PRINT_HIGH, " ");
	tmp = ftos(fraglimit);
	sprint3(self, PRINT_HIGH, "COLOR(`Fraglimit')      ", tmp, "\n");
	PrintToggle1("COLOR(`Powerups')       ", "k_pow");
	PrintToggle2("COLOR(`Respawn 666')    ", "k_666");
	PrintToggle1("COLOR(`Drop Quad')      ", "dq");
	PrintToggle2("COLOR(`Drop Ring')      ", "dr");
	PrintToggle1("COLOR(`Fair Backpacks') ", "k_frp");
	PrintToggle2("COLOR(`Drop Backpacks') ", "dp");
	PrintToggle1("COLOR(`Discharge')      ", "k_dis");
	PrintToggle2("COLOR(`Ber')úCOLOR(`erk mode')   ", "k_bzk");
	if(match_in_progress == M_COUNTDOWN) {
		p = find(world, classname, "timer");
		tmp = ftos(p.cnt2);
		sprint3(self, PRINT_HIGH, "Counting down\nThe match will start in ", tmp, " second");
		if(p.cnt2 != 1) sprint(self, PRINT_HIGH, "s");
		sprint(self, PRINT_HIGH, "\n");
		return;
	}
	if(match_in_progress == M_MATCH) {
		p = find(world, classname, "timer");
		tmp = ftos(p.cnt);
		sprint3(self, PRINT_HIGH, "Match in progress\n", tmp, " minute");
		if(p.cnt != 1) sprint(self, PRINT_HIGH, "s");
		sprint(self, PRINT_HIGH, " remaining\n");
		if(k_vbreak) {
			tmp = ftos(k_vbreak);
			sprint3(self, PRINT_HIGH, "Votes for stopping: ", tmp, "\n");
		}
	}
};

void() ModStatus2 =
{
	local string tmp;
	local float f1;

	f1 = stof(infokey(world, "k_spw"));
	if(f1 == 2) sprint(self, PRINT_HIGH, "COLOR(`Kombat Teams respawns')\n");
	else if(f1 == 1) sprint(self, PRINT_HIGH, "COLOR(`Avoid spawnfrags and last spot')\n");
	else sprint(self, PRINT_HIGH, "COLOR(`Normal QW respawns')\n");
	if(stof(infokey(world, "k_duel"))) {
		sprint(self, PRINT_HIGH, "Server is in DUEL mode.\n");
	} else {
		sprint(self, PRINT_HIGH, "COLOR(`Server locking'): ");
		if(lock == 0) sprint(self, PRINT_HIGH, "Off\n");
		else if(lock == LOCK_ALL) sprint(self, PRINT_HIGH, "All\n");
		else if(lock == LOCK_TEAM) sprint(self, PRINT_HIGH, "Team\n");
	}
	if(!match_in_progress) {
		f1 = CountRTeams();
		tmp = ftos(f1);
		sprint2(self, PRINT_HIGH, "COLOR(`Teaminfo') (COLOR(`cur'): ", tmp);
		tmp = infokey(world, "k_lockmin");
		sprint2(self, PRINT_HIGH, " COLOR(`min'): ", tmp);
		tmp = infokey(world, "k_lockmax");
		sprint3(self, PRINT_HIGH, " COLOR(`max'): ", tmp, ")\n");
	}
	sprint(self, PRINT_HIGH, "COLOR(`Spectalk'): ");
    if(!stof(infokey(world, "k_spectalk"))) sprint(self, PRINT_HIGH, "off");
	else sprint(self, PRINT_HIGH, "on");
	f1 = stof(infokey(world, "fpd"));
	sprint2(self, PRINT_HIGH, "\n", "COLOR(`QIZMO lag'): ");
	if(f1 & 8) sprint(self, PRINT_HIGH, "off");
	else sprint(self, PRINT_HIGH, "on");
	sprint2(self, PRINT_HIGH, "\n", "COLOR(`QIZMO timers'): ");
	if(f1 & 2) sprint(self, PRINT_HIGH, "off");
	else sprint(self, PRINT_HIGH, "on");
	sprint2(self, PRINT_HIGH, "\n", "COLOR(`QIZMO enemy reporting'): ");
	if(f1 & 32) sprint(self, PRINT_HIGH, "off\n");
	else sprint(self, PRINT_HIGH, "on\n");
};

void() PlayerStatus =
{
	local entity p;
	local string tmp;

	if(!match_in_progress) {
		p = find(world, classname, "player");
		while(p != world) {
			if(p.netname != "") {
				if(p.k_admin == 2) sprint(self, PRINT_HIGH, "* ");
				sprint(self, PRINT_HIGH, p.netname);
				if(p.ready) {
					tmp = infokey(p, "team");
					if(tmp == "") sprint(self, PRINT_HIGH, " is ready\n");
					else sprint3(self, PRINT_HIGH, " is in team ", tmp, "\n");
				} else sprint(self, PRINT_CHAT, " is not ready\n");
			}
			p = find(p, classname, "player");
		}
		return;
	} else sprint(self, PRINT_HIGH, "Game in progress\n");
};

void() PlayerStatusS =
{
	local entity p;
	local string tmp;

	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			sprint(self, PRINT_HIGH, "[");
			tmp = infokey(p, "skin");
			sprint2(self, PRINT_HIGH, tmp, "] ");
			sprint2(self, PRINT_HIGH, p.netname, "\n");
		}
		p = find(p, classname, "player");
	}
};

void() PlayerStatusN =
{
	local entity p;
	local string tmp;

	if(!match_in_progress) {
		p = find(world, classname, "player");
		while(p != world) {
			if(p.netname != "" && !p.ready) {
				if(p.k_admin == 2) sprint(self, PRINT_HIGH, "* ");
				sprint2(self, PRINT_HIGH, p.netname, " COLOR(`is not ready')\n");
			}
			p = find(p, classname, "player");
		}
		return;
	} else sprint(self, PRINT_HIGH, "Game in progress\n");
};

void() ResetOptions =
{
	local entity p;
	local string s1;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	if(stof(infokey(world, "k_duel"))) cvar_set("teamplay", "0");
	else cvar_set("teamplay", "3");
	cvar_set("deathmatch", "1");
	s1 = infokey(world, "k_timetop");
	cvar_set("timelimit", s1);
	cvar_set("fraglimit", "0");
	localcmd("localinfo k_spw 2\n");
	localcmd("localinfo k_pow 1\n");
	localcmd("localinfo k_dis 1\n");
	localcmd("localinfo k_bzk 0\n");
	localcmd("localinfo k_666 0\n");
	localcmd("localinfo k_frp 1\n");
	localcmd("localinfo dq 0\n");
	localcmd("localinfo dr 0\n");
	localcmd("localinfo dp 1\n");
	localcmd("localinfo k_spectalk 1\n");
	cvar_set("sv_maxspeed", "320");
	k_maxspeed = 320;
	p = find(world, classname, "player");
	while(p != world) {
		p.maxspeed = k_maxspeed;
		p = find(p, classname, "player");
	}
	lock = LOCK_TEAM;
	bprint(PRINT_HIGH, "Options reset to default\n");
};

void() ReportMe =
{
	local entity p;
	local string t1, t2, h, at, av, r, wt, wa, pa1, pa2;
	local float f1;

	pa1 = "¨";
	pa2 = "): ";
	if(self.items & IT_ARMOR1) at = "ga:";
	if(self.items & IT_ARMOR2) at = "ya:";
	if(self.items & IT_ARMOR3) at = "ra:";
	wt = "axe:";
	f1 = 0;
	if(self.items & IT_SHOTGUN) {
		wt = "sg:";
		f1 = self.ammo_shells;
	}
	if(self.items & IT_NAILGUN) {
		wt = "ng:";
		f1 = self.ammo_nails;
	}
	if(self.items & IT_SUPER_SHOTGUN) {
		wt = "ssg:";
		f1 = self.ammo_shells;
	}
	if(self.items & IT_SUPER_NAILGUN) {
		wt = "sng:";
		f1 = self.ammo_nails;
	}
	if(self.items & IT_GRENADE_LAUNCHER) {
		wt = "gl:";
		f1 = self.ammo_rockets;
	}
	if(self.items & IT_LIGHTNING) {
		wt = "lg:";
		f1 = self.ammo_cells;
	}
	if(self.items & IT_ROCKET_LAUNCHER) {
		wt = "rl:";
		f1 = self.ammo_rockets;
	}
    p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			t1 = infokey(self, "team");
			t2 = infokey(p, "team");
			if(t1 == t2) {
				sprint(p, PRINT_CHAT, pa1);
				sprint(p, PRINT_CHAT, self.netname);
				sprint(p, PRINT_CHAT, pa2);
				if(self.armorvalue != 0) {
					av = ftos(self.armorvalue);
					sprint(p, PRINT_CHAT, at);
					sprint(p, PRINT_CHAT, av);
				} else sprint(p, PRINT_CHAT, "a:0");
				sprint(p, PRINT_CHAT, "  h:");
				h = ftos(self.health);
				sprint(p, PRINT_CHAT, h);
				sprint(p, PRINT_CHAT, "  ");
				sprint(p, PRINT_CHAT, wt);
				wa = ftos(f1);
				sprint(p, PRINT_CHAT, wa);
				if(self.items & IT_INVISIBILITY) sprint(p, PRINT_CHAT, "  …åùåó…‘");
				if(self.items & IT_INVULNERABILITY) sprint(p, PRINT_CHAT, "  …˜˜˜…‘");
				if(self.items & IT_QUAD) sprint(p, PRINT_CHAT, "  …ñõáäœ‘");
				sprint(p, PRINT_CHAT, "\n");
			}
		}
		p = find(p, classname, "player");
	}
};

void() ToggleRespawns =
{
	local float tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_spw"));
	if(tmp == 2) {
		bprint(PRINT_HIGH, "Normal QW respawns (avoid spawnfrags)\n");
		localcmd("localinfo k_spw 0\n");
	} else if(tmp == 0) {
		bprint(PRINT_HIGH, "Avoid spawnfrags and last spot\n");
		localcmd("localinfo k_spw 1\n");
	} else {
		bprint(PRINT_HIGH, "Kombat Teams respawns\n");
		localcmd("localinfo k_spw 2\n");
	}
};

void() ToggleRespawn666 =
{
	local float tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_666"));
	bprint(PRINT_HIGH, "COLOR(`Respawn 666') ");
	if(tmp != 0) {
		bprint(PRINT_HIGH, "disabled\n");
		localcmd("localinfo k_666 0\n");
	} else {
		bprint(PRINT_HIGH, "enabled\n");
		localcmd("localinfo k_666 1\n");
	}
};

void() TogglePowerups =
{
	local float tmp;
	local entity p, old;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_pow"));
	bprint(PRINT_HIGH, "COLOR(`Powerups') ");
	if(tmp != 0) {
		bprint(PRINT_HIGH, "disabled\n");
		localcmd("localinfo k_pow 0\n");
	    p = findradius(VEC_ORIGIN, 999999);
		while(p) {
			old = p.chain;
			if(p.classname == "item_artifact_invulnerability") p.effects = p.effects - (p.effects & EF_RED);
			if(p.classname == "item_artifact_super_damage") p.effects = p.effects - (p.effects & EF_BLUE);
			p = old;
		}
	} else {
		bprint(PRINT_HIGH, "enabled\n");
		localcmd("localinfo k_pow 1\n");
		p = findradius(VEC_ORIGIN, 999999);
		while(p) {
			old = p.chain;
			if(p.classname == "item_artifact_invulnerability") p.effects = p.effects | EF_RED;
			if(p.classname == "item_artifact_super_damage") p.effects = p.effects | EF_BLUE;
			p = old;
		}
	}
};

void() ToggleDischarge =
{
	local float tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_dis"));
	bprint(PRINT_HIGH, "COLOR(`Discharges') ");
	if(tmp != 0) {
		bprint(PRINT_HIGH, "disabled\n");
		localcmd("localinfo k_dis 0\n");
	} else {
		bprint(PRINT_HIGH, "enabled\n");
		localcmd("localinfo k_dis 1\n");
	}
};

void() ChangeDM =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	deathmatch = deathmatch + 1;
	if(deathmatch == 6) deathmatch = 1;
	tmp = ftos(deathmatch);
	bprint3(PRINT_HIGH, "COLOR(`Deathmatch') ", tmp, "\n");
	cvar_set("deathmatch", tmp);
};

void() ChangeTP =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	if(stof(infokey(world, "k_duel"))) {
		sprint(self, PRINT_CHAT, "console: duel mode disallows you to change teamplay setting\n");
		return;
	}
	teamplay = teamplay + 1;
	if(teamplay == 4) teamplay = 0;
	tmp = ftos(teamplay);
	bprint3(PRINT_HIGH, "COLOR(`Teamplay') ", tmp, "\n");
	cvar_set("teamplay", tmp);
};

void(float t) TimeDown =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	timelimit = timelimit - t;
	if(timelimit < 5) timelimit = 5;
	tmp = ftos(timelimit);
	bprint3(PRINT_HIGH, "COLOR(`Match length set to') ", tmp, " COLOR(`minutes')\n");
	cvar_set("timelimit", tmp);
};

void(float t) TimeUp =
{
	local string tmp;
	local float top;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	timelimit = timelimit + t;
	top = stof(infokey(world, "k_timetop"));
	if(timelimit > top) timelimit = top;
	tmp = ftos(timelimit);
	bprint3(PRINT_HIGH, "COLOR(`Match length set to') ", tmp, " COLOR(`minutes')\n");
	cvar_set("timelimit", tmp);
};

void(float t) TimeSet =
{
	local string tmp;
	local float top;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	timelimit = t;
	top = stof(infokey(world, "k_timetop"));
	if(timelimit > top) timelimit = top;
	tmp = ftos(timelimit);
	bprint3(PRINT_HIGH, "COLOR(`Match length set to') ", tmp, " COLOR(`minutes')\n");
	cvar_set("timelimit", tmp);
};

void() FragsDown =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	fraglimit = fraglimit - 10;
	if(fraglimit < 0) fraglimit = 0;
	tmp = ftos(fraglimit);
	bprint3(PRINT_HIGH, "COLOR(`Fraglimit set to') ", tmp, "\n");
	cvar_set("fraglimit", tmp);
};

void() FragsUp =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	fraglimit = fraglimit + 10;
	if(fraglimit > 100) fraglimit = 100;
	tmp = ftos(fraglimit);
	bprint3(PRINT_HIGH, "COLOR(`Fraglimit set to') ", tmp, "\n");
	cvar_set("fraglimit", tmp);
};

void() ToggleDropQuad =
{
	local float dq;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	dq = stof(infokey(world, "dq"));
	if(dq != 0) {
		localcmd("localinfo dq 0\n");
		bprint(PRINT_HIGH, "COLOR(`DropQuad') off\n");
		return;
	}
	localcmd("localinfo dq 1\n");
	bprint(PRINT_HIGH, "COLOR(`DropQuad') on\n");
};

void() ToggleDropRing =
{
	local float dr;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	dr = stof(infokey(world, "dr"));
	if(dr != 0) {
		localcmd("localinfo dr 0\n");
		bprint(PRINT_HIGH, "COLOR(`DropRing') off\n");
		return;
	}
	localcmd("localinfo dr 1\n");
	bprint(PRINT_HIGH, "COLOR(`DropRing') on\n");
};

void() ToggleDropPack =
{
	local float dp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	dp = stof(infokey(world, "dp"));
	if(dp != 0) {
		localcmd("localinfo dp 0\n");
		bprint(PRINT_HIGH, "COLOR(`DropPacks') off\n");
		return;
	}
	localcmd("localinfo dp 1\n");
	bprint(PRINT_HIGH, "COLOR(`DropPacks') on\n");
};

void() ToggleFairPacks =
{
	local float f1;

    if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "k_frp"));
	if(f1 != 0) {
		localcmd("localinfo k_frp 0\n");
		bprint(PRINT_HIGH, "COLOR(`Fairpacks') disabled\n");
		return;
	}
	localcmd("localinfo k_frp 1\n");
	bprint(PRINT_HIGH, "COLOR(`Fairpacks') enabled\n");
};

void() ToggleSpeed =
{
	local string s1;
	local entity p;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	if(k_maxspeed != 320) k_maxspeed = 320;
	else k_maxspeed = stof(infokey(world, "k_highspeed"));
	s1 = ftos(k_maxspeed);
	bprint(PRINT_HIGH, "COLOR(`Maxspeed set to') ");
	bprint(PRINT_HIGH, s1);
	bprint(PRINT_HIGH, "\n");
	cvar_set("sv_maxspeed", s1);
	p = find(world, classname, "player");
	while(p != world) {
		p.maxspeed = k_maxspeed;
		p = find(p, classname, "player");
	}
};

void() ToggleBerzerk =
{
	local float tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_bzk"));
	if(tmp != 0) {
		localcmd("localinfo k_bzk 0\n");
		bprint(PRINT_HIGH, "COLOR(`BerZerk mode') off\n");
		return;
	}
	localcmd("localinfo k_bzk 1\n");
	bprint(PRINT_HIGH, "COLOR(`BerZerk mode') on\n");
};

void() ToggleSpecTalk =
{
	local float tmp, tmp2;
	local string s1;

	if(match_in_progress && self.k_admin < 2) return;
	tmp2 = stof(infokey(world, "fpd"));
	tmp2 = tmp2 - (tmp2 & 64);
	if(match_in_progress == M_MATCH) {
		tmp = stof(infokey(world, "sv_spectalk"));
		bprint(PRINT_HIGH, "Spectalk ");
		if(tmp != 0) {
			localcmd("sv_spectalk 0\nserverinfo fpd ");
			tmp2 = tmp2 + 64;
			s1 = ftos(tmp2);
			localcmd(s1);
			localcmd("\nlocalinfo k_spectalk 0\n");
			bprint(PRINT_HIGH, "off: COLOR(`players can no longer hear spectators')\n");
			return;
		}
		localcmd("sv_spectalk 1\nserverinfo fpd ");
		s1 = ftos(tmp2);
		localcmd(s1);
		localcmd("\nlocalinfo k_spectalk 1\n");
		bprint(PRINT_HIGH, "on: COLOR(`players can now hear spectators')\n");
		return;
	} else {
		if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
			sprint(self, PRINT_CHAT, "console: command is locked\n");
			return;
		}
		tmp = stof(infokey(world, "k_spectalk"));
		bprint(PRINT_HIGH, "Spectalk ");
		if(tmp != 0) {
			localcmd("localinfo k_spectalk 0\n");
			bprint(PRINT_HIGH, "off: COLOR(`players cannot hear spectators during game')\n");
			return;
		}
		localcmd("localinfo k_spectalk 1\n");
		bprint(PRINT_HIGH, "on: COLOR(`players can hear spectators during game')\n");
	}
};

void() ShowRules =
{
	local string s1;

	if(stof(infokey(world, "k_duel"))) sprint(self, PRINT_HIGH, "Server is in duelmode.\n");
	else sprint(self, PRINT_HIGH, "Bind COLOR(`report') to a key.\nPressing that key will send\nyour status to your teammates.\n\nRemember that telefragging a teammate\ndoes not result in frags.\n");
	if(stof(infokey(world, "k_bzk")) != 0) {
		s1 = infokey(world, "k_btime");
		sprint3(self, PRINT_HIGH, "\nBERZERK mode is activated!\nThis means that when only ", s1, " seconds\nremains of the game, all players\ngets QUAD/OCTA powered.\n");
	}
    if(!stof(infokey(world, "k_spectalk"))) sprint(self, PRINT_HIGH, "\nSpectators will NOT be able to speak\nto you during the game...\n");
	sprint(self, PRINT_HIGH, "\n");
};

void() ChangeLock =
{
	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	lock = lock + 1;
    if(lock > LOCK_ALL) lock = 0;
	if(lock == 0) bprint(PRINT_HIGH, "COLOR(`Server locking') off\n");
	else if(lock == LOCK_ALL) bprint(PRINT_HIGH, "COLOR(`Server locked') - players cannot connect during game\n");
	else if(lock == LOCK_TEAM) bprint(PRINT_HIGH, "COLOR(`Teamlock on') - only players in existing teams can connect during game\n");
};

void(string sndname) TeamSay =
{
	local entity p;
	local string t1, t2;

    p = find(world, classname, "player");
	while(p != world) {
		if(p != self && teamplay && p.netname != "" && (stof(infokey(p, "k_sound")))) {
			t1 = infokey(self, "team");
			t2 = infokey(p, "team");
			if(t1 == t2) {
				stuffcmd(p, "play ");
				t1 = infokey(p, "k_sdir");
				if(t1) {
					stuffcmd(p, t1);
					stuffcmd(p, "/");
				}
				stuffcmd(p, sndname);
				stuffcmd(p, "\n");
			}
		}
		p = find(p, classname, "player");
	}
};

void() PrintScores =
{
	local string tmp, tmp2;
	local entity p, p2;
	local float f1;

	if(!match_in_progress) {
		sprint(self, PRINT_HIGH, "no game - no scores.\n");
		return;
	}
	p = find(world, classname, "player");
	while(p != world) {
		p.k_flag = 0;
		p = find(p, classname, "player");
	}
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && !p.k_flag && (infokey(p, "team") != "" && p.k_accepted == 2)) {
			p2 = p;
			f1 = 0;
			tmp = infokey(p, "team");
			sprint2(self, PRINT_HIGH, tmp, ": ");
			while (p2 != world) {
				tmp = infokey(p, "team");
				tmp2 = infokey(p2, "team");
				if(tmp == tmp2) {
					f1 = f1 + p2.frags;
					p2.k_flag = 1;
				}
				p2 = find(p2, classname, "player");
			}
			p2 = find(world, classname, "ghost");
			while(p2 != world) {
				if(!p2.k_flag) {
					tmp = ftos(p2.k_teamnum);
					tmp2 = infokey(world, tmp);
					tmp = infokey(p, "team");
					if(tmp == tmp2) {
						f1 = f1 + p2.frags;
						p2.k_flag = 1;
					}
				}
				p2 = find(p2, classname, "ghost");
			}
			tmp = ftos(f1);
			sprint2(self, PRINT_HIGH, tmp, "\n");
		}
		p = find(p, classname, "player");
	}
};

void() ToggleQTimer =
{
	local float f1, f2;
	local string s1;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "fpd"));
	f2 = f1 - (f1 & 2);
	if(f1 & 2) {
		localcmd("serverinfo fpd ");
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(PRINT_HIGH, "COLOR(`QiZmo timers') allowed\n");
		return;
	} else {
		localcmd("serverinfo fpd ");
		f2 = f2 + 2;
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(PRINT_HIGH, "COLOR(`QiZmo timers') disallowed\n");
	}
};

void() ToggleQLag =
{
	local float f1, f2;
	local string s1;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "fpd"));
	f2 = f1 - (f1 & 8);
	if(f1 & 8) {
		localcmd("serverinfo fpd ");
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(PRINT_HIGH, "COLOR(`QiZmo lag settings') in effect\n");
		return;
	} else {
		localcmd("serverinfo fpd ");
		f2 = f2 + 8;
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(PRINT_HIGH, "COLOR(`QiZmo lag settings') not in effect\n");
	}
};

void() ToggleQEnemy =
{
	local float f1, f2;
	local string s1;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, PRINT_CHAT, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "fpd"));
	f2 = f1 - (f1 & 32);
	if(f1 & 32) {
		localcmd("serverinfo fpd ");
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(PRINT_HIGH, "COLOR(`QiZmo enemy reporting') allowed\n");
		return;
	} else {
		localcmd("serverinfo fpd ");
		f2 = f2 + 32;
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(PRINT_HIGH, "COLOR(`QiZmo enemy reporting') disallowed\n");
	}
};

void() TeamCommands =
{
	if(self.impulse < FirstCmdImpulse || self.impulse > LastCmdImpulse) return;
	if(self.impulse == CMD_commands) ShowCmds();
	else if(self.impulse == CMD_options) ShowOpts();
	else if(self.impulse == CMD_advanced) ShowAdv();
	else if(self.impulse == CMD_ready) PlayerReady();
	else if(self.impulse == CMD_break) PlayerBreak();
	else if(self.impulse == CMD_status) ModStatus();
	else if(self.impulse == CMD_status2) ModStatus2();
	else if(self.impulse == CMD_who) PlayerStatus();
	else if(self.impulse == CMD_whoskin) PlayerStatusS();
	else if(self.impulse == CMD_whonot) PlayerStatusN();
	else if(self.impulse == CMD_spawn) ToggleRespawns();
	else if(self.impulse == CMD_powerups) TogglePowerups();
	else if(self.impulse == CMD_discharge) ToggleDischarge();
	else if(self.impulse == CMD_dm) ChangeDM();
	else if(self.impulse == CMD_tp) ChangeTP();
	else if(self.impulse == CMD_timedown1) TimeDown(1);
	else if(self.impulse == CMD_timeup1) TimeUp(1);
	else if(self.impulse == CMD_timedown) TimeDown(5);
	else if(self.impulse == CMD_timeup) TimeUp(5);
	else if(self.impulse == CMD_fragsdown) FragsDown();
	else if(self.impulse == CMD_fragsup) FragsUp();
	else if(self.impulse == CMD_dropquad) ToggleDropQuad();
	else if(self.impulse == CMD_dropring) ToggleDropRing();
	else if(self.impulse == CMD_droppack) ToggleDropPack();
	else if(self.impulse == CMD_silence) ToggleSpecTalk();
	else if(self.impulse == CMD_reset) ResetOptions();
	else if(self.impulse == CMD_rules) ShowRules();
	else if(self.impulse == CMD_lock) ChangeLock();
	else if(self.impulse == CMD_maps) ShowMaps();
	else if(self.impulse == CMD_spawn666) ToggleRespawn666();
	else if(self.impulse == CMD_admin) ReqAdmin();
	else if(self.impulse == CMD_forcestart) AdminForceStart();
	else if(self.impulse == CMD_forcebreak) AdminForceBreak();
	else if(self.impulse == CMD_prewar) TogglePreWar();
	else if(self.impulse == CMD_lockmap) ToggleMapLock();
	else if(self.impulse == CMD_master) ToggleMaster();
	else if(self.impulse == CMD_speed) ToggleSpeed();
	else if(self.impulse == CMD_fairpacks) ToggleFairPacks();
	else if(self.impulse == CMD_about) ShowVersion();
	else if(self.impulse == CMD_time5) TimeSet(5);
	else if(self.impulse == CMD_time10) TimeSet(10);
	else if(self.impulse == CMD_time15) TimeSet(15);
	else if(self.impulse == CMD_time20) TimeSet(20);
	else if(self.impulse == CMD_time25) TimeSet(25);
	else if(self.impulse == CMD_time30) TimeSet(30);
	else if(self.impulse == CMD_berzerk) ToggleBerzerk();
	else if(self.impulse == CMD_ksound1) TeamSay("ktsound1.wav");
	else if(self.impulse == CMD_ksound2) TeamSay("ktsound2.wav");
	else if(self.impulse == CMD_ksound3) TeamSay("ktsound3.wav");
	else if(self.impulse == CMD_ksound4) TeamSay("ktsound4.wav");
	else if(self.impulse == CMD_ksound5) TeamSay("ktsound5.wav");
	else if(self.impulse == CMD_ksound6) TeamSay("ktsound6.wav");
	else if(self.impulse == CMD_scores) PrintScores();
	else if(self.impulse == CMD_qizmo) ShowQizmo();
	else if(self.impulse == CMD_qtimer) ToggleQTimer();
	else if(self.impulse == CMD_qlag) ToggleQLag();
	else if(self.impulse == CMD_qenemy) ToggleQEnemy();
};