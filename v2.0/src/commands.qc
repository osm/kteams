// commands.qc

















void() ShowCmds =
{
	if(self.k_admin == 2) sprint(self, 2, "αδνιξ....... give up admin rights\nπςεχας...... playerfire before game\nμογλναπ..... (un)locks current map\nζοςγεσταςτ.. forces match to start\nζοςγεβςεαλ.. forces match to end\nναστες...... toggles mastermode\n");
	else {
		sprint(self, 2, "ςυμεσ...... show game rules\nςεαδω...... when you feel ready\nβςεαλ...... unready / vote matchend\nοπτιοξσ.... more commands\nαδφαξγεδ... even more commands\nριϊνο...... qizmo related commands\nστατυσ..... show server settings\nστατυσ².... more server settings\nςεσετ...... set defaults\nναπσ....... list custom maps\nχθο........ player teamlist\nχθοξοτ..... players not ready\nχθοσλιξ.... player skinlist\nσγοςεσ..... prints teamscores\n");
		if(stof(infokey(world, "k_admins"))) {
			sprint(self, 2, "αδνιξ...... toggle admin-mode\n");
		}
	}
};

void() ShowVersion =
{
	sprint(self, 3, "\nThis is Kombat Teams 2.0 BETA\nby kemiKal_sWeMoB and Fang.\n\nSource, soundbanks, configs etc. at:\nhttp://www.kemikal.com\n");
};

void() SShowCmds =
{
	if(self.k_admin == 2) sprint(self, 2, "αδνιξ....... give up admin rights\nπςεχας...... playerfire before game\nμογλναπ..... (un)locks current map\nζοςγεσταςτ.. forces match to start\nζοςγεβςεαλ.. forces match to end\nναστες...... toggles mastermode\n");
	else {
		sprint(self, 2, "στατυσ..... show match settings\nγαν........ camera help text\nχθο........ player teamlist\nχθοσλιξ.... player skinlist\nκοιξ....... joins game\n");
		if(stof(infokey(world, "k_admins"))) {
			sprint(self, 2, "αδνιξ...... toggle admin-mode\n");
		}
	}
};

void() ShowOpts =
{
	sprint(self, 2, "τινεδοχξ±.. -1 mins match time\nτινευπ±.... +1 mins match time\nτινεδοχξ... -5 mins match time\nτινευπ..... +5 mins match time\nζςαησδοχξ.. -10 fraglimit\nζςαησυπ.... +10 fraglimit\nδν......... change deathmatch mode\nτπ......... change teamplay mode\nδςοπρυαδ... drop quad when killed\nδςοπςιξη... drop ring when killed\nδςοππαγλ... drop pack when killed\nμογλ....... change locking mode\n");
};

void() ShowAdv =
{
	sprint(self, 2, "σπαχξ...... change spawntype\nσπεεδ...... toggle sv_maxspeed\nποχεςυπσ... quad, 666, ring & suit\nσπαχξ¶¶¶... 2 secs of 666 on respawn\nζαιςπαγλσ.. best-weapon backpacks\nδισγθαςηε.. underwater discharges\nσιμεξγε.... toggle spectator talk\nβεςϊεςλ.... toggle berzerk mode\n");
};

void() ShowQizmo =
{
	sprint(self, 2, "ρτινες..... powerup timers\nρμαη....... lagsettings\nρεξενω..... enemy vicinity reporting\n");
};

void() ShowMaps =
{
	local float f1;
	local string s1, s2;

	sprint(self, 2, "Vote for maps by typing the mapname,\nfor example \"δν΄\".\n");
	f1 = stof(infokey(world, "999"));
	if(f1 > 137) {
		sprint(self, 2, "\n---μιστ οζ γυστον ναπσ\n");
		f1 = 1000;
		s1 = ftos(f1);
		s2 = infokey(world, s1);
		while(s2 != "") {
			if(f1 & 1) {
				sprint2(self, 2, s2, "\n");
			} else {
				sprint2(self, 2, s2, "   ");
			}
			f1 = f1 + 1;
			s1 = ftos(f1);
			s2 = infokey(world, s1);
		}
		if(f1 & 1) sprint(self, 2, "\n");
		sprint(self, 2, "---εξδ οζ μιστ\n");
	}

};

void() StuffAliases =
{



 stuffcmd(self.owner, "alias ready \"impulse 20\"\n");
 stuffcmd(self.owner, "alias break \"impulse 21\"\n");
 stuffcmd(self.owner, "alias status2 \"impulse 22\"\n");
 stuffcmd(self.owner, "alias status \"impulse 23\"\n");
 stuffcmd(self.owner, "alias powerups \"impulse 24\"\n");
 stuffcmd(self.owner, "alias dm \"impulse 25\"\n");
 stuffcmd(self.owner, "alias tp \"impulse 26\"\n");
 stuffcmd(self.owner, "alias timedown1 \"impulse 27\"\n");
 stuffcmd(self.owner, "alias timeup1 \"impulse 28\"\n");
 stuffcmd(self.owner, "alias timedown \"impulse 29\"\n");
 stuffcmd(self.owner, "alias timeup \"impulse 30\"\n");
 stuffcmd(self.owner, "alias fragsdown \"impulse 31\"\n");
 stuffcmd(self.owner, "alias fragsup \"impulse 32\"\n");
 stuffcmd(self.owner, "alias dropquad \"impulse 33\"\n");
 stuffcmd(self.owner, "alias dropring \"impulse 34\"\n");
 stuffcmd(self.owner, "alias discharge \"impulse 35\"\n");
 stuffcmd(self.owner, "alias options \"impulse 36\"\n");
 stuffcmd(self.owner, "alias silence \"impulse 37\"\n");
 stuffcmd(self.owner, "alias advanced \"impulse 38\"\n");
 stuffcmd(self.owner, "alias reset \"impulse 39\"\n");
 stuffcmd(self.owner, "alias rules \"impulse 40\"\n");
 stuffcmd(self.owner, "alias lock \"impulse 41\"\n");
 stuffcmd(self.owner, "alias spawn666 \"impulse 42\"\n");
 stuffcmd(self.owner, "alias berzerk \"impulse 43\"\n");
 stuffcmd(self.owner, "alias master \"impulse 44\"\n");
 stuffcmd(self.owner, "alias time5 \"impulse 45\"\n");
 stuffcmd(self.owner, "alias time10 \"impulse 46\"\n");
 stuffcmd(self.owner, "alias time15 \"impulse 47\"\n");
 stuffcmd(self.owner, "alias time20 \"impulse 48\"\n");
 stuffcmd(self.owner, "alias time25 \"impulse 49\"\n");
 stuffcmd(self.owner, "alias time30 \"impulse 50\"\n");
 stuffcmd(self.owner, "alias whoskin \"impulse 51\"\n");
 stuffcmd(self.owner, "alias whonot \"impulse 52\"\n");
 stuffcmd(self.owner, "alias who \"impulse 53\"\n");
 stuffcmd(self.owner, "alias droppack \"impulse 54\"\n");
 stuffcmd(self.owner, "alias fairpacks \"impulse 55\"\n");
 stuffcmd(self.owner, "alias speed \"impulse 56\"\n");
 stuffcmd(self.owner, "alias spawn \"impulse 57\"\n");
 stuffcmd(self.owner, "alias about \"impulse 58\"\n");
 stuffcmd(self.owner, "alias ksound1 \"impulse 59\"\n");
 stuffcmd(self.owner, "alias ksound2 \"impulse 60\"\n");
 stuffcmd(self.owner, "alias ksound3 \"impulse 61\"\n");
 stuffcmd(self.owner, "alias ksound4 \"impulse 62\"\n");
 stuffcmd(self.owner, "alias ksound5 \"impulse 63\"\n");
 stuffcmd(self.owner, "alias ksound6 \"impulse 64\"\n");
 stuffcmd(self.owner, "alias scores \"impulse 65\"\n");
 stuffcmd(self.owner, "alias qizmo \"impulse 66\"\n");
 stuffcmd(self.owner, "alias qtimer \"impulse 67\"\n");
 stuffcmd(self.owner, "alias qlag \"impulse 68\"\n");
 stuffcmd(self.owner, "alias qenemy \"impulse 69\"\n");
 stuffcmd(self.owner, "alias maps \"impulse 70\"\n");
 stuffcmd(self.owner, "alias admin \"impulse 71\"\n");
 stuffcmd(self.owner, "alias forcestart \"impulse 72\"\n");
 stuffcmd(self.owner, "alias forcebreak \"impulse 73\"\n");
 stuffcmd(self.owner, "alias prewar \"impulse 74\"\n");
 stuffcmd(self.owner, "alias lockmap \"impulse 75\"\n");
 stuffcmd(self.owner, "alias commands \"impulse 76\"\n");

 stuffcmd(self.owner, "alias report \"impulse 99\"\n");
};

void(string tog, string key) PrintToggle1 =
{
	sprint(self, 2, tog);
	if(stof(infokey(world, key)) != 0) sprint(self, 2, "On  ");
	else sprint(self, 2, "Off ");
};

void(string tog, string key) PrintToggle2 =
{
	sprint(self, 2, tog);
	if(stof(infokey(world, key)) != 0) sprint(self, 2, "On\n");
	else sprint(self, 2, "Off\n");
};

void() ModStatus =
{
	local entity p;
	local string tmp;
	local float n, f1, k_lockmin, k_lockmax;

	tmp = ftos(k_maxspeed);
	sprint3(self, 2, "Ναψσπεεδ       ", tmp, "\n");
	tmp = ftos(deathmatch);
	sprint3(self, 2, "Δεατθνατγθ     ", tmp, "   ");
	tmp = ftos(teamplay);
	sprint3(self, 2, "Τεανπμαω       ", tmp, "\n");
	tmp = ftos(timelimit);
	sprint3(self, 2, "Τινεμινιτ      ", tmp, " ");
	if(timelimit < 10) sprint(self, 2, "  ");
	else if(timelimit < 100) sprint(self, 2, " ");
	tmp = ftos(fraglimit);
	sprint3(self, 2, "Ζςαημινιτ      ", tmp, "\n");
	PrintToggle1("Ποχεςυπσ       ", "k_pow");
	PrintToggle2("Òεσπαχξ ¶¶¶    ", "k_666");
	PrintToggle1("Δςοπ Ρυαδ      ", "dq");
	PrintToggle2("Δςοπ Òιξη      ", "dr");
	PrintToggle1("Ζαις Βαγλπαγλσ ", "k_frp");
	PrintToggle2("Δςοπ Βαγλπαγλσ ", "dp");
	PrintToggle1("Δισγθαςηε      ", "k_dis");
	PrintToggle2("Βεςϊεςλ νοδε   ", "k_bzk");
	if(match_in_progress == 1) {
		p = find(world, classname, "timer");
		tmp = ftos(p.cnt2);
		sprint3(self, 2, "Counting down\nThe match will start in ", tmp, " second");
		if(p.cnt2 != 1) sprint(self, 2, "s");
		sprint(self, 2, "\n");
		return;
	}
	if(match_in_progress == 2) {
		p = find(world, classname, "timer");
		tmp = ftos(p.cnt);
		sprint3(self, 2, "Match in progress\n", tmp, " minute");
		if(p.cnt != 1) sprint(self, 2, "s");
		sprint(self, 2, " remaining\n");
		if(k_vbreak) {
			tmp = ftos(k_vbreak);
			sprint3(self, 2, "Votes for stopping: ", tmp, "\n");
		}
	}
};

void() ModStatus2 =
{
	local string tmp;
	local float f1;

	f1 = stof(infokey(world, "k_spw"));
	if(f1 == 2) sprint(self, 2, "Λονβατ Τεανσ ςεσπαχξσ\n");
	else if(f1 == 1) sprint(self, 2, "Αφοιδ σπαχξζςαησ αξδ μαστ σποτ\n");
	else sprint(self, 2, "Ξοςναμ ΡΧ ςεσπαχξσ\n");
	if(stof(infokey(world, "k_duel"))) {
		sprint(self, 2, "Server is in DUEL mode.\n");
	} else {
		sprint(self, 2, "Σεςφες μογλιξη: ");
		if(lock == 0) sprint(self, 2, "Off\n");
		else if(lock == 2) sprint(self, 2, "All\n");
		else if(lock == 1) sprint(self, 2, "Team\n");
	}
	if(!match_in_progress) {
		f1 = CountRTeams();
		tmp = ftos(f1);
		sprint2(self, 2, "Τεανιξζο (γυς: ", tmp);
		tmp = infokey(world, "k_lockmin");
		sprint2(self, 2, " νιξ: ", tmp);
		tmp = infokey(world, "k_lockmax");
		sprint3(self, 2, " ναψ: ", tmp, ")\n");
	}
	sprint(self, 2, "Σπεγταμλ: ");
    if(!stof(infokey(world, "k_spectalk"))) sprint(self, 2, "off");
	else sprint(self, 2, "on");
	f1 = stof(infokey(world, "fpd"));
	sprint2(self, 2, "\n", "ΡΙΪΝΟ μαη: ");
	if(f1 & 8) sprint(self, 2, "off");
	else sprint(self, 2, "on");
	sprint2(self, 2, "\n", "ΡΙΪΝΟ τινεςσ: ");
	if(f1 & 2) sprint(self, 2, "off");
	else sprint(self, 2, "on");
	sprint2(self, 2, "\n", "ΡΙΪΝΟ εξενω ςεποςτιξη: ");
	if(f1 & 32) sprint(self, 2, "off\n");
	else sprint(self, 2, "on\n");
};

void() PlayerStatus =
{
	local entity p;
	local string tmp;

	if(!match_in_progress) {
		p = find(world, classname, "player");
		while(p != world) {
			if(p.netname != "") {
				if(p.k_admin == 2) sprint(self, 2, "* ");
				sprint(self, 2, p.netname);
				if(p.ready) {
					tmp = infokey(p, "team");
					if(tmp == "") sprint(self, 2, " is ready\n");
					else sprint3(self, 2, " is in team ", tmp, "\n");
				} else sprint(self, 3, " is not ready\n");
			}
			p = find(p, classname, "player");
		}
		return;
	} else sprint(self, 2, "Game in progress\n");
};

void() PlayerStatusS =
{
	local entity p;
	local string tmp;

	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			sprint(self, 2, "[");
			tmp = infokey(p, "skin");
			sprint2(self, 2, tmp, "] ");
			sprint2(self, 2, p.netname, "\n");
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
				if(p.k_admin == 2) sprint(self, 2, "* ");
				sprint2(self, 2, p.netname, " ισ ξοτ ςεαδω\n");
			}
			p = find(p, classname, "player");
		}
		return;
	} else sprint(self, 2, "Game in progress\n");
};

void() ResetOptions =
{
	local entity p;
	local string s1;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
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
	lock = 1;
	bprint(2, "Options reset to default\n");
};

void() ReportMe =
{
	local entity p;
	local string t1, t2, h, at, av, r, wt, wa, pa1, pa2;
	local float f1;

	pa1 = "¨";
	pa2 = "): ";
	if(self.items & 8192) at = "ga:";
	if(self.items & 16384) at = "ya:";
	if(self.items & 32768) at = "ra:";
	wt = "axe:";
	f1 = 0;
	if(self.items & 1) {
		wt = "sg:";
		f1 = self.ammo_shells;
	}
	if(self.items & 4) {
		wt = "ng:";
		f1 = self.ammo_nails;
	}
	if(self.items & 2) {
		wt = "ssg:";
		f1 = self.ammo_shells;
	}
	if(self.items & 8) {
		wt = "sng:";
		f1 = self.ammo_nails;
	}
	if(self.items & 16) {
		wt = "gl:";
		f1 = self.ammo_rockets;
	}
	if(self.items & 64) {
		wt = "lg:";
		f1 = self.ammo_cells;
	}
	if(self.items & 32) {
		wt = "rl:";
		f1 = self.ammo_rockets;
	}
    p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			t1 = infokey(self, "team");
			t2 = infokey(p, "team");
			if(t1 == t2) {
				sprint(p, 3, pa1);
				sprint(p, 3, self.netname);
				sprint(p, 3, pa2);
				if(self.armorvalue != 0) {
					av = ftos(self.armorvalue);
					sprint(p, 3, at);
					sprint(p, 3, av);
				} else sprint(p, 3, "a:0");
				sprint(p, 3, "  h:");
				h = ftos(self.health);
				sprint(p, 3, h);
				sprint(p, 3, "  ");
				sprint(p, 3, wt);
				wa = ftos(f1);
				sprint(p, 3, wa);
				if(self.items & 524288) sprint(p, 3, "  …εωεσ…‘");
				if(self.items & 1048576) sprint(p, 3, "  ……‘");
				if(self.items & 4194304) sprint(p, 3, "  …ρυαδ‘");
				sprint(p, 3, "\n");
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
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_spw"));
	if(tmp == 2) {
		bprint(2, "Normal QW respawns (avoid spawnfrags)\n");
		localcmd("localinfo k_spw 0\n");
	} else if(tmp == 0) {
		bprint(2, "Avoid spawnfrags and last spot\n");
		localcmd("localinfo k_spw 1\n");
	} else {
		bprint(2, "Kombat Teams respawns\n");
		localcmd("localinfo k_spw 2\n");
	}
};

void() ToggleRespawn666 =
{
	local float tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_666"));
	bprint(2, "Òεσπαχξ ¶¶¶ ");
	if(tmp != 0) {
		bprint(2, "disabled\n");
		localcmd("localinfo k_666 0\n");
	} else {
		bprint(2, "enabled\n");
		localcmd("localinfo k_666 1\n");
	}
};

void() TogglePowerups =
{
	local float tmp;
	local entity p, old;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_pow"));
	bprint(2, "Ποχεςυπσ ");
	if(tmp != 0) {
		bprint(2, "disabled\n");
		localcmd("localinfo k_pow 0\n");
	    p = findradius('0 0 0', 999999);
		while(p) {
			old = p.chain;
			if(p.classname == "item_artifact_invulnerability") p.effects = p.effects - (p.effects & 128);
			if(p.classname == "item_artifact_super_damage") p.effects = p.effects - (p.effects & 64);
			p = old;
		}
	} else {
		bprint(2, "enabled\n");
		localcmd("localinfo k_pow 1\n");
		p = findradius('0 0 0', 999999);
		while(p) {
			old = p.chain;
			if(p.classname == "item_artifact_invulnerability") p.effects = p.effects | 128;
			if(p.classname == "item_artifact_super_damage") p.effects = p.effects | 64;
			p = old;
		}
	}
};

void() ToggleDischarge =
{
	local float tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_dis"));
	bprint(2, "Δισγθαςηεσ ");
	if(tmp != 0) {
		bprint(2, "disabled\n");
		localcmd("localinfo k_dis 0\n");
	} else {
		bprint(2, "enabled\n");
		localcmd("localinfo k_dis 1\n");
	}
};

void() ChangeDM =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	deathmatch = deathmatch + 1;
	if(deathmatch == 6) deathmatch = 1;
	tmp = ftos(deathmatch);
	bprint3(2, "Δεατθνατγθ ", tmp, "\n");
	cvar_set("deathmatch", tmp);
};

void() ChangeTP =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	if(stof(infokey(world, "k_duel"))) {
		sprint(self, 3, "console: duel mode disallows you to change teamplay setting\n");
		return;
	}
	teamplay = teamplay + 1;
	if(teamplay == 4) teamplay = 0;
	tmp = ftos(teamplay);
	bprint3(2, "Τεανπμαω ", tmp, "\n");
	cvar_set("teamplay", tmp);
};

void(float t) TimeDown =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	timelimit = timelimit - t;
	if(timelimit < 5) timelimit = 5;
	tmp = ftos(timelimit);
	bprint3(2, "Νατγθ μεξητθ σετ το ", tmp, " νιξυτεσ\n");
	cvar_set("timelimit", tmp);
};

void(float t) TimeUp =
{
	local string tmp;
	local float top;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	timelimit = timelimit + t;
	top = stof(infokey(world, "k_timetop"));
	if(timelimit > top) timelimit = top;
	tmp = ftos(timelimit);
	bprint3(2, "Νατγθ μεξητθ σετ το ", tmp, " νιξυτεσ\n");
	cvar_set("timelimit", tmp);
};

void(float t) TimeSet =
{
	local string tmp;
	local float top;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	timelimit = t;
	top = stof(infokey(world, "k_timetop"));
	if(timelimit > top) timelimit = top;
	tmp = ftos(timelimit);
	bprint3(2, "Νατγθ μεξητθ σετ το ", tmp, " νιξυτεσ\n");
	cvar_set("timelimit", tmp);
};

void() FragsDown =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	fraglimit = fraglimit - 10;
	if(fraglimit < 0) fraglimit = 0;
	tmp = ftos(fraglimit);
	bprint3(2, "Ζςαημινιτ σετ το ", tmp, "\n");
	cvar_set("fraglimit", tmp);
};

void() FragsUp =
{
	local string tmp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	fraglimit = fraglimit + 10;
	if(fraglimit > 100) fraglimit = 100;
	tmp = ftos(fraglimit);
	bprint3(2, "Ζςαημινιτ σετ το ", tmp, "\n");
	cvar_set("fraglimit", tmp);
};

void() ToggleDropQuad =
{
	local float dq;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	dq = stof(infokey(world, "dq"));
	if(dq != 0) {
		localcmd("localinfo dq 0\n");
		bprint(2, "ΔςοπΡυαδ off\n");
		return;
	}
	localcmd("localinfo dq 1\n");
	bprint(2, "ΔςοπΡυαδ on\n");
};

void() ToggleDropRing =
{
	local float dr;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	dr = stof(infokey(world, "dr"));
	if(dr != 0) {
		localcmd("localinfo dr 0\n");
		bprint(2, "ΔςοπÒιξη off\n");
		return;
	}
	localcmd("localinfo dr 1\n");
	bprint(2, "ΔςοπÒιξη on\n");
};

void() ToggleDropPack =
{
	local float dp;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	dp = stof(infokey(world, "dp"));
	if(dp != 0) {
		localcmd("localinfo dp 0\n");
		bprint(2, "ΔςοπΠαγλσ off\n");
		return;
	}
	localcmd("localinfo dp 1\n");
	bprint(2, "ΔςοπΠαγλσ on\n");
};

void() ToggleFairPacks =
{
	local float f1;

    if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "k_frp"));
	if(f1 != 0) {
		localcmd("localinfo k_frp 0\n");
		bprint(2, "Ζαιςπαγλσ disabled\n");
		return;
	}
	localcmd("localinfo k_frp 1\n");
	bprint(2, "Ζαιςπαγλσ enabled\n");
};

void() ToggleSpeed =
{
	local string s1;
	local entity p;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	if(k_maxspeed != 320) k_maxspeed = 320;
	else k_maxspeed = stof(infokey(world, "k_highspeed"));
	s1 = ftos(k_maxspeed);
	bprint(2, "Ναψσπεεδ σετ το ");
	bprint(2, s1);
	bprint(2, "\n");
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
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	tmp = stof(infokey(world, "k_bzk"));
	if(tmp != 0) {
		localcmd("localinfo k_bzk 0\n");
		bprint(2, "ΒεςΪεςλ νοδε off\n");
		return;
	}
	localcmd("localinfo k_bzk 1\n");
	bprint(2, "ΒεςΪεςλ νοδε on\n");
};

void() ToggleSpecTalk =
{
	local float tmp, tmp2;
	local string s1;

	if(match_in_progress && self.k_admin < 2) return;
	tmp2 = stof(infokey(world, "fpd"));
	tmp2 = tmp2 - (tmp2 & 64);
	if(match_in_progress == 2) {
		tmp = stof(infokey(world, "sv_spectalk"));
		bprint(2, "Spectalk ");
		if(tmp != 0) {
			localcmd("sv_spectalk 0\nserverinfo fpd ");
			tmp2 = tmp2 + 64;
			s1 = ftos(tmp2);
			localcmd(s1);
			localcmd("\nlocalinfo k_spectalk 0\n");
			bprint(2, "off: πμαωεςσ γαξ ξο μοξηες θεας σπεγτατοςσ\n");
			return;
		}
		localcmd("sv_spectalk 1\nserverinfo fpd ");
		s1 = ftos(tmp2);
		localcmd(s1);
		localcmd("\nlocalinfo k_spectalk 1\n");
		bprint(2, "on: πμαωεςσ γαξ ξοχ θεας σπεγτατοςσ\n");
		return;
	} else {
		if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
			sprint(self, 3, "console: command is locked\n");
			return;
		}
		tmp = stof(infokey(world, "k_spectalk"));
		bprint(2, "Spectalk ");
		if(tmp != 0) {
			localcmd("localinfo k_spectalk 0\n");
			bprint(2, "off: πμαωεςσ γαξξοτ θεας σπεγτατοςσ δυςιξη ηανε\n");
			return;
		}
		localcmd("localinfo k_spectalk 1\n");
		bprint(2, "on: πμαωεςσ γαξ θεας σπεγτατοςσ δυςιξη ηανε\n");
	}
};

void() ShowRules =
{
	local string s1;

	if(stof(infokey(world, "k_duel"))) sprint(self, 2, "Server is in duelmode.\n");
	else sprint(self, 2, "Bind ςεποςτ to a key.\nPressing that key will send\nyour status to your teammates.\n\nRemember that telefragging a teammate\ndoes not result in frags.\n");
	if(stof(infokey(world, "k_bzk")) != 0) {
		s1 = infokey(world, "k_btime");
		sprint3(self, 2, "\nBERZERK mode is activated!\nThis means that when only ", s1, " seconds\nremains of the game, all players\ngets QUAD/OCTA powered.\n");
	}
    if(!stof(infokey(world, "k_spectalk"))) sprint(self, 2, "\nSpectators will NOT be able to speak\nto you during the game...\n");
	sprint(self, 2, "\n");
};

void() ChangeLock =
{
	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	lock = lock + 1;
    if(lock > 2) lock = 0;
	if(lock == 0) bprint(2, "Σεςφες μογλιξη off\n");
	else if(lock == 2) bprint(2, "Σεςφες μογλεδ - players cannot connect during game\n");
	else if(lock == 1) bprint(2, "Τεανμογλ οξ - only players in existing teams can connect during game\n");
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
		sprint(self, 2, "no game - no scores.\n");
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
			sprint2(self, 2, tmp, ": ");
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
			sprint2(self, 2, tmp, "\n");
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
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "fpd"));
	f2 = f1 - (f1 & 2);
	if(f1 & 2) {
		localcmd("serverinfo fpd ");
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(2, "ΡιΪνο τινεςσ allowed\n");
		return;
	} else {
		localcmd("serverinfo fpd ");
		f2 = f2 + 2;
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(2, "ΡιΪνο τινεςσ disallowed\n");
	}
};

void() ToggleQLag =
{
	local float f1, f2;
	local string s1;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "fpd"));
	f2 = f1 - (f1 & 8);
	if(f1 & 8) {
		localcmd("serverinfo fpd ");
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(2, "ΡιΪνο μαη σεττιξησ in effect\n");
		return;
	} else {
		localcmd("serverinfo fpd ");
		f2 = f2 + 8;
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(2, "ΡιΪνο μαη σεττιξησ not in effect\n");
	}
};

void() ToggleQEnemy =
{
	local float f1, f2;
	local string s1;

	if(match_in_progress) return;
	if(stof(infokey(world, "k_master")) && self.k_admin < 2) {
		sprint(self, 3, "console: command is locked\n");
		return;
	}
	f1 = stof(infokey(world, "fpd"));
	f2 = f1 - (f1 & 32);
	if(f1 & 32) {
		localcmd("serverinfo fpd ");
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(2, "ΡιΪνο εξενω ςεποςτιξη allowed\n");
		return;
	} else {
		localcmd("serverinfo fpd ");
		f2 = f2 + 32;
		s1 = ftos(f2);
		localcmd(s1);
		localcmd("\n");
		bprint(2, "ΡιΪνο εξενω ςεποςτιξη disallowed\n");
	}
};

void() TeamCommands =
{
	if(self.impulse < 20 || self.impulse > 76) return;
	if(self.impulse == 76) ShowCmds();
	else if(self.impulse == 36) ShowOpts();
	else if(self.impulse == 38) ShowAdv();
	else if(self.impulse == 20) PlayerReady();
	else if(self.impulse == 21) PlayerBreak();
	else if(self.impulse == 23) ModStatus();
	else if(self.impulse == 22) ModStatus2();
	else if(self.impulse == 53) PlayerStatus();
	else if(self.impulse == 51) PlayerStatusS();
	else if(self.impulse == 52) PlayerStatusN();
	else if(self.impulse == 57) ToggleRespawns();
	else if(self.impulse == 24) TogglePowerups();
	else if(self.impulse == 35) ToggleDischarge();
	else if(self.impulse == 25) ChangeDM();
	else if(self.impulse == 26) ChangeTP();
	else if(self.impulse == 27) TimeDown(1);
	else if(self.impulse == 28) TimeUp(1);
	else if(self.impulse == 29) TimeDown(5);
	else if(self.impulse == 30) TimeUp(5);
	else if(self.impulse == 31) FragsDown();
	else if(self.impulse == 32) FragsUp();
	else if(self.impulse == 33) ToggleDropQuad();
	else if(self.impulse == 34) ToggleDropRing();
	else if(self.impulse == 54) ToggleDropPack();
	else if(self.impulse == 37) ToggleSpecTalk();
	else if(self.impulse == 39) ResetOptions();
	else if(self.impulse == 40) ShowRules();
	else if(self.impulse == 41) ChangeLock();
	else if(self.impulse == 70) ShowMaps();
	else if(self.impulse == 42) ToggleRespawn666();
	else if(self.impulse == 71) ReqAdmin();
	else if(self.impulse == 72) AdminForceStart();
	else if(self.impulse == 73) AdminForceBreak();
	else if(self.impulse == 74) TogglePreWar();
	else if(self.impulse == 75) ToggleMapLock();
	else if(self.impulse == 44) ToggleMaster();
	else if(self.impulse == 56) ToggleSpeed();
	else if(self.impulse == 55) ToggleFairPacks();
	else if(self.impulse == 58) ShowVersion();
	else if(self.impulse == 45) TimeSet(5);
	else if(self.impulse == 46) TimeSet(10);
	else if(self.impulse == 47) TimeSet(15);
	else if(self.impulse == 48) TimeSet(20);
	else if(self.impulse == 49) TimeSet(25);
	else if(self.impulse == 50) TimeSet(30);
	else if(self.impulse == 43) ToggleBerzerk();
	else if(self.impulse == 59) TeamSay("ktsound1.wav");
	else if(self.impulse == 60) TeamSay("ktsound2.wav");
	else if(self.impulse == 61) TeamSay("ktsound3.wav");
	else if(self.impulse == 62) TeamSay("ktsound4.wav");
	else if(self.impulse == 63) TeamSay("ktsound5.wav");
	else if(self.impulse == 64) TeamSay("ktsound6.wav");
	else if(self.impulse == 65) PrintScores();
	else if(self.impulse == 66) ShowQizmo();
	else if(self.impulse == 67) ToggleQTimer();
	else if(self.impulse == 68) ToggleQLag();
	else if(self.impulse == 69) ToggleQEnemy();
};