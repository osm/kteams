// admin.qc

float() CountPlayers;
float() CountRTeams;
void() AdminMatchStart;
void() NextLevel;
void(float skip_log) EndMatch;

void() ReqAdmin =
{
	local entity motd;

	if(self.k_admin == 2) {
		bprint2(2, self.netname, " is no longer an admin.\n");
		self.k_admin = 0;
		return;
	}
	if(self.k_admin) return;
	if(!stof(infokey(world, "k_admins"))) {
		sprint(self, 2, "NO ADMINS ON THIS SERVER!\n");
		return;
	}
	self.k_admin = 1;
	self.k_adminc = 6;
	self.k_added = 0;
	sprint(self, 2, "Use ινπυμσεσ to enter code\n");
};

void() AdminImpBot =
{
	local float coef, i1;
	local string s1;

	if(self.k_adminc == 0) {
		self.k_admin = 0;
		return;
	}
	i1 = self.k_adminc - 1;
	coef = self.impulse;
	while(i1) {
		coef = coef * 10;
		i1 = i1 - 1;
	}
	self.k_added = self.k_added + coef;
	self.k_adminc = self.k_adminc - 1;
	if(!self.k_adminc) {
		if(self.k_added == stof(infokey(world, "k_admincode"))) {
			bprint2(2, self.netname, " gains admin status!\n");
			sprint(self, 2, "Type γονναξδσ for info\n");
			self.k_admin = 2;
		} else {
			self.k_admin = 0;
			sprint(self, 2, "Access denied...\n");
		}
	} else {
		s1 = ftos(self.k_adminc);
		sprint2(self, 2, s1, " νοςε το ηο\n");
	}
};

void() ReadyThink =
{
	local float i1, i2;

	if(self.owner.classname == "player" && !self.owner.ready) {
		k_force = 0;
		bprint2(2, self.owner.netname, " interrupts countdown\n");
		remove(self);
		return;
	}
	if(self.owner.classname != "player" && !k_force) {
		bprint2(2, self.owner.netname, " interrupts countdown\n");
		remove(self);
		return;
	}
	self.attack_finished = self.attack_finished - 1;
	i1 = self.attack_finished;
	if(!i1) {
		k_force = 0;
		AdminMatchStart();
		remove(self);
		return;
	}
	WriteByte(2, 26);
	WriteShort(2, 2570);
	WriteShort(2, 2570);
	i2 = floor(i1 / 10);
	if(i2) WriteByte(2, i2 + 48);
	i1 = i1 - i2 * 10;
	WriteByte(2, i1 + 48);
	WriteString(2, " seconds to gamestart\n Κοιξ αξ εψιστιξη τεαν ");
	self.nextthink = time + 1;
};

void() AdminForceStart =
{
	local entity mess;
	local float f1, k_lockmin, k_lockmax;
	local string tmp;

	if(match_in_progress || self.k_admin != 2) return;
	if(self.classname == "player" && !self.ready) {
			sprint(self, 2, "Ready yourself first\n");
			return;
	}
	k_lockmin = stof(infokey(world, "k_lockmin"));
	k_lockmax = stof(infokey(world, "k_lockmax"));
	f1 = CountRTeams();
	if(f1 < k_lockmin) {
			tmp = ftos(k_lockmin - f1);
			sprint2(self, 2, tmp, " more team");
			if((k_lockmin - f1) != 1) sprint(self, 2, "s");
			sprint(self, 2, " required.\n");
			return;
	}
	if(f1 > k_lockmax) {
			sprint(self, 2, "Get rid of ");
			tmp = ftos(f1 - k_lockmax);
			sprint2(self, 2, tmp, " team");
			if((f1 - k_lockmax) != 1) sprint(self, 2, "s");
			sprint(self, 2, "!\n");
			return;
	}
	f1 = CountPlayers();
	if(f1) {
		bprint2(2, self.netname, " forces matchstart!\n");
		k_force = 1;
		mess = spawn();
		mess.classname = "mess";
		mess.owner = self;
		mess.think = ReadyThink;
		mess.nextthink = time + 0.1;
		mess.attack_finished = 10 + 1;
	}
	else sprint(self, 2, "Can't issue! More players needed.\n");
};

void() AdminMatchStart =
{
	local entity p;
	local float f1;

	f1 = 0;
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			if(p.ready) {
				f1 = f1 + 1;
				sound(p, 4, "items/protect2.wav", 1, 1);
			} else {
				sprint(p, 2, "\nBye bye! Pay attention next time.\n");
				stuffcmd(p, "disconnect\n");
				remove(p);
			}
		}
		p = find(p, classname, "player");
	}
	k_attendees = CountPlayers();
	if(k_attendees) StartTimer();
	else {
		bprint(2, "Can't start! More players needed.\n");
		NextLevel();
	}
};

void() AdminForceBreak =
{
	local entity p;
	local float f1;
	local string tmp;

	if(self.k_admin != 2 || !match_in_progress) return;
	if(self.classname != "player" && k_force) {
		k_force = 0;
		return;
	}
	dprint("%forcebreak%");
	dprint(self.netname);
	dprint("\n");
	bprint2(2, self.netname, " forces a break!\nMATCH OVER!!\n");
	EndMatch(0);
};

void() TogglePreWar =
{
	local float tmp;

	if(self.k_admin != 2) return;
	tmp = stof(infokey(world, "k_prewar"));
	if(tmp != 0) {
		localcmd("localinfo k_prewar 0\n");
		if(!match_in_progress) bprint(2, "Players may NOT fire before match!\n");
		else sprint(self, 2, "Players may NOT fire before match!\n");
		return;
	}
	localcmd("localinfo k_prewar 1\n");
	if(!match_in_progress) bprint(2, "Players may fire before match.\n");
	else sprint(self, 2, "Players may fire before match.\n");
};

void() ToggleMapLock =
{
	local float tmp;

	if(self.k_admin != 2) return;
	tmp = stof(infokey(world, "k_lockmap"));
	if(tmp != 0) {
		localcmd("localinfo k_lockmap 0\n");
		if(!match_in_progress) bprint2(2, self.netname, " unlocks map.\n");
		else sprint(self, 2, "Map unlocked.\n");
		return;
	}
	localcmd("localinfo k_lockmap 1\n");
	if(!match_in_progress) bprint(2, "Map is locked!\n");
	else sprint(self, 2, "Map is locked!\n");
};

void() ToggleMaster =
{
	if(self.k_admin != 2) return;
	k_master = 1 - k_master;
	if(k_master) {
		bprint2(2, self.netname, " sets mastermode!\nPlayers may NOT alter settings\n");
		return;
	} else bprint(2,"Mastermode disabled\nPlayers can now alter settings\n");
};