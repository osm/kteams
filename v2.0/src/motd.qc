// motd.qc

void() StuffAliases;
void() StuffCustomMaps;
void() StuffMapAliases;
float() CountPlayers;





void() MOTDThink =
{
	if(self.attack_finished < time || match_in_progress) {
		remove(self);
		return;
	}
	centerprint(self.owner, "Ëïíâáô Ôåáíó ²®° ÂÅÔÁ\nhttp://www.kemikal.com\n\nType \"ãïííáîäó\" for help\n");
	self.nextthink = time + 0.7;
};

void() SMOTDThink =
{
	if(self.attack_finished < time) {
		remove(self);
		return;
	}
	centerprint(self.owner, "Welcome spectator! This is\nËïíâáô Ôåáíó ²®° ÂÅÔÁ\nhttp://www.kemikal.com\n\nType \"ãïííáîäó\" for help\n\"êïéî\" to join game\n");
	self.nextthink = time + 0.7;
};

void() MOTDstuff3 =
{
	local entity p;

	p = self;
	self = self.owner;
	StuffCustomMaps();
	self = p;
	self.think = MOTDThink;
	self.nextthink = time + 0.3;
};

void() MOTDstuff2 =
{
	local entity p;

	p = self;
	self = self.owner;
	StuffMapAliases();
	self = p;
	self.think = MOTDstuff3;
	self.nextthink = time + 0.3;
};

void() MOTDStuff =
{
	local entity p;
	local string t, t2, tmp, s1;
	local float kick, f1, f2, f3;

	self.owner.k_teamnum = 0;
	self.owner.k_msgcount = time;
	self.owner.k_lastspawn = world;
	if(self.owner.k_accepted != 2) self.owner.k_accepted = 1;
	if(match_in_progress) {
		kick = 0;
		self.owner.ready = 1;
		self.owner.k_666 = 0;
		self.owner.k_vote = 0;
		self.owner.deaths = 0;
		if(lock == 2) kick = 1;
		else if(lock == 1) {
			kick = 1;
			p = find(world, classname, "player");
			while(p != world) {
				t = infokey(self.owner, "team");
				if(p != self.owner && p.netname != "" && infokey(p, "team") == t) {
					kick = 0;
					break;
				}
				p = find(p, classname, "player");
			}
			if(kick) {
				p = find(world, classname, "ghost");
				while(p != world) {
					t = ftos(p.k_teamnum);
					t2 = infokey(world, t);
					t = infokey(self.owner, "team");
					if(t == t2) {
						kick = 0;
						break;
					}
					p = find(p, classname, "ghost");
				}
			}
		}
		if(lock == 1 && kick == 1) sprint(self.owner, 2, "Set your team before connecting\n");
		else {
			f2 = CountPlayers();
			if(f2 >= k_attendees && stof(infokey(world, "k_exclusive"))) {
				sprint(self.owner, 2, "Sorry, all teams are full\n");
				kick = 1;
			}
		}
		if(kick) {
			self.owner.k_accepted = 0;
			if(lock == 2) sprint(self.owner, 2, "Match in progress, server locked\n");
			stuffcmd(self.owner, "\ndisconnect\n");
			remove(self);
			return;
		}
    }
	if(match_in_progress == 2) {
		f2 = 1;
		f3 = 0;
		while(f2 < k_userid && !f3)
		{
			t2 = ftos(f2);
			t = infokey(world, t2);
			if(t == self.owner.netname) f3 = 1;
			else f2 = f2 + 1;
		}
		if(f2 == k_userid) {
			bprint(2, self.owner.netname);
			bprint(2, " arrives late\n");
		} else {
			p = find(world, classname, "ghost");
			while(p != world && f3) {
				if(p.cnt == f2) f3 = 0;
				else p = find(p, classname, "ghost");
			}
			if(p != world) {
				t = ftos(p.k_teamnum);
				t2 = infokey(world, t);
				t = infokey(self.owner, "team");
				if(t != t2) {
					self.owner.k_accepted = 0;
					sprint(self.owner, 2, "Please join your old team and reconnect\n");
					stuffcmd(self.owner, "\ndisconnect\n");
					remove(self);
					return;
				}
				t2 = ftos(f2);
				localcmd("localinfo ");
				localcmd(t2);
				localcmd(" \"\"\n");
				bprint(2, self.owner.netname);
				bprint(2, " rejoins the game\n");
				self.owner.frags = p.frags;
				self.owner.deaths = p.deaths;
				self.owner.k_teamnum = p.k_teamnum;
				remove(p);
			} else {
				t2 = ftos(f2);
				localcmd("localinfo ");
				localcmd(t2);
				localcmd(" \"\"\n");
				bprint(2, self.owner.netname);
				bprint(2, " reenters the game without stats\n");
			}
		}
		tmp = infokey(self.owner, "team");
		if(tmp != "") {
			f1 = 665;
			while(k_teamid > f1 && !self.owner.k_teamnum) {
				f1 = f1 + 1;
				t = ftos(f1);
				s1 = infokey(world, t);
				tmp = infokey(self.owner, "team");
				if(tmp == s1) self.owner.k_teamnum = f1;
			}
			if(!self.owner.k_teamnum) {
				f1 = f1 + 1;
				s1 = ftos(f1);
				localcmd("localinfo ");
				localcmd(s1);
				localcmd(" \"");
				tmp = infokey(self.owner, "team");
				localcmd(tmp);
				localcmd("\"\n");
				k_teamid = f1;
				self.owner.k_teamnum = f1;
			}
		} else self.owner.k_teamnum = 666;
	} else {
		bprint(2, self.owner.netname);
		bprint(2, " entered the game\n");
	}
	StuffAliases();
	self.think = MOTDstuff2;
	self.nextthink = time + 0.3;
};

void() MakeMOTD =
{
	local entity motd;


	motd = spawn();
	motd.classname = "motd";
	motd.owner = self;
	motd.think = MOTDStuff;
	motd.nextthink = time + 0.1;
	motd.attack_finished = time + 7;
};

void() SMakeMOTD =
{
	local entity motd;


	motd = spawn();
	motd.classname = "smotd";
	motd.owner = self;
	motd.think = SMOTDThink;
	motd.nextthink = time + 0.1;
	motd.attack_finished = time + 7;
};