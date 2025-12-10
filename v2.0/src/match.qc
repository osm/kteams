// match.qc

void() NextLevel;
void() StopTimer;
void(float skip_log) EndMatch;

float() CountALLPlayers =
{
	local entity p;
	local float num;

	num = 0;
    p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") num = num + 1;
		p = find(p, classname, "player");
	}
	return num;
};

float() CountPlayers =
{
	local entity p;
	local float num;

	num = 0;
    p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && p.k_accepted == 2) num = num + 1;
		p = find(p, classname, "player");
	}
	return num;
};

float() CountTeams =
{
	local entity p, p2;
	local float num;
	local string s1, s2;

	num = 0;
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && p.k_accepted == 2) p.k_flag = 0;
		p = find(p, classname, "player");
	}
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && !p.k_flag && p.k_accepted == 2) {
			p.k_flag = 1;
			num = num + 1;
			p2 = find(p, classname, "player");
			while(p2 != world) {
				s1 = infokey(p, "team");
				s2 = infokey(p2, "team");
				if(s1 == s2 && s1 != "") p2.k_flag = 1;
				p2 = find(p2, classname, "player");
			}
		}
		p = find(p, classname, "player");
	}
	return num;
};

float() CountRTeams =
{
	local entity p, p2;
	local float num;
	local string s1, s2;

	num = 0;
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && p.k_accepted == 2) p.k_flag = 0;
		p = find(p, classname, "player");
	}
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && !p.k_flag && p.ready && p.k_accepted == 2) {
			p.k_flag = 1;
			num = num + 1;
			p2 = find(p, classname, "player");
			while(p2 != world) {
				s1 = infokey(p, "team");
				s2 = infokey(p2, "team");
				if(s1 == s2 && s1 != "") p2.k_flag = 1;
				p2 = find(p2, classname, "player");
			}
		}
		p = find(p, classname, "player");
	}
	return num;
};

float(float memcnt) CheckMembers =
{
	local entity p, p2;
	local string s1, s2;
	local float f1;

	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && p.k_accepted == 2) p.k_flag = 0;
		p = find(p, classname, "player");
	}
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && !p.k_flag && p.ready && p.k_accepted == 2) {
			p.k_flag = 1;
			f1 = 1;
			p2 = find(p, classname, "player");
			while(p2 != world) {
				s1 = infokey(p, "team");
				s2 = infokey(p2, "team");
				if(s1 == s2 && s1 != "") {
					p2.k_flag = 1;
					f1 = f1 + 1;
				}
				p2 = find(p2, classname, "player");
			}
			if(f1 < memcnt) return 0;
		}
		p = find(p, classname, "player");
	}
	return 1;
};

void(float skip_log) EndMatch =
{
	local entity p, p2, old;
	local string tmp, tmp2, s1;
	local float f1, f2;

	if(match_over) return;
	tmp = infokey(world, "k_host");
	if(tmp != "") cvar_set("hostname", tmp);
	match_over = 1;
	k_berzerk = 0;
	lightstyle(0, "m");
	f1 = stof(infokey(world, "fpd"));
	f1 = f1 - (f1 & 64);
	localcmd("serverinfo fpd ");
	tmp = ftos(f1);
	localcmd(tmp);
	localcmd("\nsv_spectalk 1\n");
	bprint(2, "The match is over\n");
	dprint("RESULT");
	if(skip_log) dprint("%stopped\n");
	else {
		p = find(world, classname, "player");
		while(p != world) {
			if(p.netname != "" && p.k_accepted == 2) {
				dprint2("%", p.netname);
				tmp = infokey(p, "team");
				dprint2("%t%", tmp);
				tmp = ftos(p.frags);
				dprint2("%fr%", tmp);
				p.ready = 0;
			}
			p = find(p, classname, "player");
		}
		tmp = ftos(fraglimit);
		dprint2("%fl%", tmp);
		tmp = ftos(timelimit);
		dprint2("%tl%", tmp);
		dprint2("%map%", mapname);
		dprint("\n");
		f1 = CountTeams();
		if(!stof(infokey(world, "k_duel")) && f1) {
			bprint(2, "\nTeam scores:\n");
			p = find(world, classname, "player");
			while(p != world) {
				if(p.netname != "" && !p.ready && (infokey(p, "team") != "" && p.k_accepted == 2)) {
					p2 = p;
					f1 = 0;
					tmp = infokey(p, "team");
					bprint2(2, tmp, ": ");
					while (p2 != world) {
						tmp = infokey(p, "team");
						tmp2 = infokey(p2, "team");
						if(tmp == tmp2) {
							f1 = f1 + p2.frags;
							p2.ready = 1;
						}
						p2 = find(p2, classname, "player");
					}
					f2 = 0;
					p2 = find(world, classname, "ghost");
					while(p2 != world) {
						if(!p2.ready) {
							s1 = ftos(p2.k_teamnum);
							tmp2 = infokey(world, s1);
							tmp = infokey(p, "team");
							if(tmp == tmp2) {
								f2 = f2 + p2.frags;
								p2.ready = 1;
							}
						}
						p2 = find(p2, classname, "ghost");
					}
					tmp = ftos(f1);
					bprint(2, tmp);
					if(f2 != 0) {
						bprint(2, " + (");
						tmp = ftos(f2);
						bprint2(2, tmp, ") = ");
						tmp = ftos(f1 + f2);
						bprint2(2, tmp, "\n");
					} else bprint(2, "\n");
				}
				p = find(p, classname, "player");
			}
		}
		p = find(world, classname, "player");
		while(p != world) {
			p.ready = 1;
			p = find(p, classname, "player");
		}
		bprint(3, "\n Player results   (FRAGS (RANK))\n");
		p = find(world, classname, "player");
		while(p != world) {
			if(p.netname != "" && p.k_accepted == 2 && p.ready) {
				p2 = p;
				while (p2 != world) {
					tmp = infokey(p, "team");
					tmp2 = infokey(p2, "team");
					if(tmp == tmp2) {
						bprint3(2, "[", tmp2, "] ");
						bprint2(2, p2.netname, "  ");
						tmp = ftos(p2.frags);
						bprint2(2, tmp, " (");
						tmp = ftos(p2.frags - p2.deaths);
						bprint2(2, tmp, ")\n");
						p2.ready = 0;
					}
					p2 = find(p2, classname, "player");
				}
			}
			p = find(p, classname, "player");
		}
	}
	p = find(world, classname, "ghost");
	while(p != world) {
		remove(p);
		p = find(p, classname, "ghost");
	}
	StopTimer();
	f1 = 666;
	while(k_teamid >= f1) {
		tmp = ftos(f1);
		localcmd("localinfo ");
		localcmd(tmp);
		localcmd(" \"\"\n");
		f1 = f1 + 1;
	}
	f1 = 1;
	while(k_userid >= f1) {
		tmp = ftos(f1);
		localcmd("localinfo ");
		localcmd(tmp);
		localcmd(" \"\"\n");
		f1 = f1 + 1;
	}
	NextLevel();
};

void() TimerThink =
// Called every second during a match. cnt = minutes, cnt2 = seconds left.
// Tells the time every now and then.
{
	local string tmp;
	local entity p;
	local float f1, f2;

	if(self.k_teamnum < time && !k_checkx) {
		k_checkx = 1;
	}
	f1 = CountPlayers();
	if(f1 < 1) {
		EndMatch(1);
		return;
	}
	self.cnt2 = self.cnt2 - 1;
	if(stof(infokey(world, "k_bzk"))) {
		f1 = stof(infokey(world, "k_btime"));
		f2 = floor(f1 / 60);
		f1 = f1 - (f2 * 60);
		f2 = f2 + 1;
		if(self.cnt2 == f1 && self.cnt == f2) {
			bprint(2, "BERZERK!!!!\n");
			lightstyle(0, "ob");
			k_berzerk = 1;
			p = find(world, classname, "player");
			while(p != world) {
				if(p.netname != "" && p.health > 0) {
					p.items = p.items | (4194304 | 1048576);
					p.super_time = 1;
					p.super_damage_finished = time + 3600;
					p.invincible_time = 1;
					p.invincible_finished = time + 2;
					p.k_666 = 1;
				}
				p = find(p, classname, "player");
			}
		}
	}
	if(!self.cnt2) {
		self.cnt2 = 60;
		self.cnt = self.cnt - 1;
		localcmd("serverinfo status \"");
		tmp = ftos(self.cnt);
		localcmd(tmp);
		localcmd(" min left\"\n");
		if(!self.cnt) {
			EndMatch(0);
			return;
		}
		if(self.cnt == 20 || self.cnt == 15 || self.cnt <= 10) {
			tmp = ftos(self.cnt);
			bprint2(2, tmp, " íéîõôå");
			if(self.cnt != 1) bprint(2, "ó");
			bprint(2, " òåíáéîéîç\n");
			self.nextthink = time + 1;
			return;
		}
	}
	if(self.cnt == 1) {
		if(self.cnt2 == 30 || self.cnt2 == 15 || self.cnt2 <= 10) {
			tmp = ftos(self.cnt2);
			bprint2(2, tmp, " óåãïîä");
			if(self.cnt2 != 1) bprint(2, "ó");
			bprint(2, "\n");
		}
	}
	self.nextthink = time + 1;
};

void() StartMatch =
// Kill the players, reset their frags and start the timer.
{
	local entity p, old;
	local string tmp, s1;
	local float f1, f2;

	k_checkx = 0;
	k_userid = 1;
	k_teamid = 666;
	localcmd("localinfo 1 \"\"\n");
	localcmd("localinfo 666 \"\"\n");
	match_in_progress = 2;
	dprint("MATCH STARTED");
	f1 = stof(infokey(world, "k_pow"));
	f2 = stof(infokey(world, "k_dm2mod"));
	p = findradius('0 0 0', 999999);
	while(p) {
		old = p.chain;
//going for the if content record..
		if(deathmatch > 3) {
			if(p.classname == "weapon_nailgun" || p.classname == "weapon_supernailgun"
				|| p.classname == "weapon_supershotgun" || p.classname == "weapon_rocketlauncher"
				|| p.classname == "weapon_grenadelauncher" || p.classname == "weapon_lightning") remove(p);
			else if(p.classname == "rocket" || p.classname == "grenade" || p.classname == "trigger_changelevel"
				|| (p.classname == "player" && p.netname == "")
				|| (!f1 && (p.classname == "item_artifact_invulnerability"
				|| p.classname == "item_artifact_super_damage"
				|| p.classname == "item_artifact_envirosuit"
				|| p.classname == "item_artifact_invisibility"))) remove(p);
		} else if(p.classname == "rocket" || p.classname == "grenade" || p.classname == "trigger_changelevel"
				|| (p.classname == "player" && p.netname == "")
				|| ((deathmatch == 2 && f2) &&
				(p.classname == "item_armor1" || p.classname == "item_armor2" || p.classname == "item_armorInv"))
				|| (!f1 && (p.classname == "item_artifact_invulnerability"
				|| p.classname == "item_artifact_super_damage"
				|| p.classname == "item_artifact_envirosuit"
				|| p.classname == "item_artifact_invisibility"))) remove(p);
		p = old;
	}
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			tmp = infokey(p, "team");
			dprint2("%", p.netname);
			dprint2("%t%", tmp);
			p.k_teamnum = 0;
			if(tmp != "") {
				f1 = 665;
				while(k_teamid > f1 && !p.k_teamnum) {
					f1 = f1 + 1;
					s1 = ftos(f1);
					s1 = infokey(world, s1);
					tmp = infokey(p, "team");
					if(tmp == s1) p.k_teamnum = f1;
				}
				if(!p.k_teamnum) {
					f1 = f1 + 1;
					s1 = ftos(f1);
					localcmd("localinfo ");
					localcmd(s1);
					localcmd(" \"");
					tmp = infokey(p, "team");
					localcmd(tmp);
					localcmd("\"\n");
					k_teamid = f1;
					p.k_teamnum = f1;
				}
			} else p.k_teamnum = 666;
			p.frags = 0;
			p.deaths = 0;
			old = self;
			self = p;
//			msg_entity = p;
//			WriteByte(1, 37);
//			WriteLong(1, 1);
//			WriteByte(1, 0);
			SetChangeParms();
			PutClientInServer();
			self = old;
		}
		p = find(p, classname, "player");
	}
	dprint("\n");
	bprint(2, "The match has begun!\n");
	tmp = infokey(world, "k_spectalk");
	localcmd("sv_spectalk ");
	localcmd(tmp);
	localcmd("\n");
	f2 = stof(tmp);
	f1 = stof(infokey(world, "fpd"));
	f1 = f1 - (f1 & 64) + (f2 * 64);
	localcmd("serverinfo fpd ");
	tmp = ftos(f1);
	localcmd(tmp);
	k_vbreak = 0;
	k_berzerk = 0;
	self.k_teamnum = time + 3;  //dirty i know, but why waste space?
	self.cnt = timelimit;
	self.cnt2 = 60;
	localcmd("\nserverinfo status \"");
	tmp = ftos(timelimit);
	localcmd(tmp);
	localcmd(" min left\"\n");
	self.think = TimerThink;
	self.nextthink = time + 1;
	tmp = infokey(world, "hostname");
	localcmd("localinfo k_host \"");
	localcmd(tmp);
	localcmd("\"\n");
	f1 = CountRTeams();
	f2 = CountPlayers();
	if(f1 == 2 && f2 > 2) {
		tmp = infokey(world, "hostname");
		localcmd("serverinfo hostname \"");
		localcmd(tmp);
		localcmd(" (");
		f2 = 0;
		old = world;
		p = find(world, classname, "player");
		while(p != world && !f2) {
			if(p.netname != "") {
				tmp = infokey(p, "team");
				localcmd(tmp);
				f2 = 1;
				old = p;
			}
			p = find(p, classname, "player");
		}
		localcmd(" vs. ");
		while(p != world && f2) {
			if(p.netname != "") {
				tmp = infokey(p, "team");
				s1 = infokey(old, "team");
				if(tmp != s1) {
					localcmd(tmp);
					f2 = 0;
				}
			}
			p = find(p, classname, "player");
		}
		localcmd(")\"\n");
	}
};

void() TimerStartThink =
// Called every second during the countdown.
{
	local string tmp;
	local float show, num, f1, f2, f3;

	self.cnt2 = self.cnt2 - 1;
	if(!self.cnt2) {
		WriteByte(2, 26);
		WriteString(2, "");
		f2 = stof(infokey(world, "k_lockmin"));
		f3 = stof(infokey(world, "k_lockmax"));
		f1 = CountRTeams();
		if(f1 < f2 || f1 > f3) {
			bprint(2, "Illegal number of teams, aborting...\n");
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
			match_in_progress = 0;
			localcmd("serverinfo status Standby\n");
			return;
		}
		StartMatch();
		return;
	}
	num = floor(self.cnt2 / 10);
	WriteByte(2, 26);
	WriteShort(2, 17162);	// \nC
	WriteShort(2, 30063);	// ou
	WriteShort(2, 29806);	// nt
	WriteShort(2, 28516);	// do
	WriteShort(2, 28279);	// wn
	WriteShort(2, 8250);	// :
	if(num) WriteByte(2, num + 48);
	num = self.cnt2 - num * 10;
	WriteByte(2, num + 48);
	WriteShort(2, 2570); // 0x0A0A = \n\n
	WriteByte(2, 10);
//deathmatch  x
	WriteShort(2, 58852);
	WriteShort(2, 62689);
	WriteShort(2, 60904);
	WriteShort(2, 62689);
	WriteShort(2, 59619);
	WriteShort(2, 8224);
	WriteByte(2, deathmatch + 48);
//(teamplay    x)
	if(teamplay) {
		WriteByte(2, 10);
		WriteShort(2, 58868);
		WriteShort(2, 60897);
		WriteShort(2, 60656);
		WriteShort(2, 63969);
		WriteShort(2, 8224);
		WriteShort(2, 8224);
		WriteByte(2, teamplay + 48);
	}
//(timelimit  xx)
	if(timelimit) {
		WriteShort(2, 62474);
		WriteShort(2, 60905);
		WriteShort(2, 60645);
		WriteShort(2, 60905);
		WriteShort(2, 62697);
		WriteShort(2, 8224);
		f1 = timelimit;
		num = floor(f1 / 10);
		f1 = f1 - (num * 10);
		if(num) WriteByte(2, num + 48);
		else WriteByte(2, 32);
		WriteByte(2, f1 + 48);
	}
//(fraglimit xxx)
	if(fraglimit) {
		WriteShort(2, 58890);
		WriteShort(2, 57842);
		WriteShort(2, 60647);
		WriteShort(2, 60905);
		WriteShort(2, 62697);
		WriteByte(2, 32);
		f1 = fraglimit;
		num = floor(f1 / 100);
		f1 = f1 - (num * 100);
		if(num) WriteByte(2, num + 48);
		else WriteByte(2, 32);
		num = floor(f1 / 10);
		f1 = f1 - (num * 10);
		WriteByte(2, num + 48);
		WriteByte(2, f1 + 48);
	}
	if(stof(infokey(world, "k_pow"))) WriteString(2, "\nwith powerups");
	else WriteString(2, "\nno powerups");
	self.nextthink = time + 1;
};

void() StartTimer =
// Spawns the timer and starts the countdown.
{
	local entity timer;

	timer = find(world, classname, "timer");
	while(timer != world) {
		remove(timer);
		timer = find(timer, classname, "timer");
	}
	timer = spawn();
	timer.owner = world;
	timer.classname = "timer";
	timer.cnt = 0;
	timer.cnt2 = stof(infokey(world, "k_count"));
	timer.cnt2 = timer.cnt2 + 1;
	timer.nextthink = time + 0.1;
	timer.think = TimerStartThink;
	match_in_progress = 1;
	localcmd("serverinfo status Countdown\n");
};

void() StopTimer =
// Whenever a countdown or match stops, remove the timer and reset everything.
{
	local entity t;

	match_in_progress = 0;
	t = find(world, classname, "timer");
	while(t != world) {
		t.nextthink = time + 0.1;
		t.think = SUB_Remove;
		t = find(t, classname, "timer");
	}
	localcmd("serverinfo status Standby\n");
};

void() PlayerReady =
// Called by a player to inform that (s)he is ready for a match.
{
	local entity p;
	local float nready, f1, k_lockmin, k_lockmax;
	local string tmp, s1, s2;

	if(intermission_running || match_in_progress == 2) return;
	if(self.ready) {
		sprint(self, 2, "Type break to unready yourself\n");
		return;
	}
	k_lockmin = stof(infokey(world, "k_lockmin"));
	k_lockmax = stof(infokey(world, "k_lockmax"));
	if(k_force) {
		nready = 0;
		p = find(world, classname, "player");
		while(p != world) {
			if(p.netname != "" && p.ready) {
				s1 = infokey(self, "team");
				s2 = infokey(p, "team");
				if(s1 == s2 && s1 != "") nready = 1;
			}
			p = find(p, classname, "player");
		}
		if(!nready) {
			sprint(self, 2, "Join an existing team!\n");
			return;
		}
	}
	self.ready = 1;
	self.k_vote = 0;
	self.effects = self.effects - (self.effects & 64);
	self.k_teamnum = 0;
	bprint2(2, self.netname, " is ready\n");
	nready = 0;
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && p.ready) nready = nready + 1;
		p = find(p, classname, "player");
	}
	f1 = CountRTeams();
	if(f1 < k_lockmin) {
		tmp = ftos(k_lockmin - f1);
		bprint(2, tmp);
		bprint(2, " íïòå ôåáí");
		if((k_lockmin - f1) != 1) bprint(2, "ó");
		bprint(2, " òåñõéòåä\n");
		return;
	}
	if(f1 > k_lockmax) {
		bprint(2, "Çåô òéä ïæ ");
		tmp = ftos(f1 - k_lockmax);
		bprint(2, tmp);
		bprint(2, " ôåáí");
		if((f1 - k_lockmax) != 1) bprint(2, "ó");
		bprint(2, "!\n");
		return;
	}
	k_attendees = CountPlayers();
	f1 = stof(infokey(world, "k_membercount"));
	if(CheckMembers(f1)) {
		if(nready == k_attendees && nready >= 2 && !k_force) {
			bprint(2, "All players ready\nTimer started\n");
			p = find(world, classname, "player");
			while(p != world) {
				if(p.netname != "") stuffcmd(p, "play items/protect2.wav\n");
				p = find(p, classname, "player");
			}
			StartTimer();
		}
	} else if(nready == k_attendees && nready >=2 && !k_force) {
		s1 = infokey(world, "k_membercount");
		bprint3(2, "Óåòöåò ÷áîôó áôìåáóô ", s1, " ðìáùåòó éî åáãè ôåáí\nWaiting...\n");
	}
};

void() PlayerBreak =
{
	local float f1, f2;

	if(!self.ready) return;
	if(!match_in_progress) {
		self.ready = 0;
		bprint2(2, self.netname, " is not ready\n");
		if(stof(infokey(world, "k_sready"))) self.effects = self.effects + 64;
		return;
	}
	if(match_in_progress == 1) {
		self.ready = 0;
		bprint2(2, self.netname, " óôïðó ôèå ãïõîôäï÷î\n");
		if(stof(infokey(world, "k_sready"))) self.effects = self.effects + 64;
		StopTimer();
		return;
	}
	if(self.k_vote) {
		bprint2(3, self.netname, " withdraws ");
		if(infokey(self, "gender") == "f") bprint(3, "her ");
		else bprint(3, "his ");
		bprint(3, "vote\n");
		self.k_vote = 0;
		k_vbreak = k_vbreak - 1;
		return;
	}
	bprint2(3, self.netname, " votes for stopping the match\n");
	self.k_vote = 1;
	k_vbreak = k_vbreak + 1;
	f1 = CountPlayers();
	f2 = (floor(f1 / 2)) + 1;
	if(k_vbreak >= f2) {
		bprint(2, "Match stopped by majority vote\n");
		EndMatch(1);
		return;
	}
};