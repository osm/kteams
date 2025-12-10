// admin.qc

float() CountPlayers;
float() CountRTeams;
void() AdminMatchStart;
void() StopTimer;
void() NextLevel;
void(float skip_log) EndMatch;

void() ReqAdmin =
{
	local entity motd;

	if(self.k_admin == 2) {
		bprint2(PRINT_HIGH, self.netname, " is no longer an admin.\n");
		self.k_admin = 0;
		return;
	}
	if(self.k_admin) return;
	if(!stof(infokey(world, "k_admins"))) {
		sprint(self, PRINT_HIGH, "NO ADMINS ON THIS SERVER!\n");
		return;
	}
	self.k_admin = 1;
	self.k_adminc = 6;
	self.k_added = 0;
	sprint(self, PRINT_HIGH, "Use COLOR(`impulses') to enter code\n");
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
			bprint2(PRINT_HIGH, self.netname, " COLOR(`gains admin status!')\n");
			sprint(self, PRINT_HIGH, "Type COLOR(`commands') for info\n");
			self.k_admin = 2;
		} else {
			self.k_admin = 0;
			sprint(self, PRINT_HIGH, "Access denied...\n");
		}
	} else {
		s1 = ftos(self.k_adminc);
		sprint2(self, PRINT_HIGH, s1, " COLOR(`more to go')\n");
	}
};

void() ReadyThink =
{
	local float i1, i2;

	if(self.owner.classname == "player" && !self.owner.ready) {
		k_force = 0;
		bprint2(PRINT_HIGH, self.owner.netname, " interrupts countdown\n");
		remove(self);
		return;
	}
	if(self.owner.classname != "player" && !k_force) {
		bprint2(PRINT_HIGH, self.owner.netname, " interrupts countdown\n");
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
	WriteByte(MSG_ALL, SVC_CENTERPRINT);
	WriteShort(MSG_ALL, 2570);
	WriteShort(MSG_ALL, 2570);
	i2 = floor(i1 / 10);
	if(i2) WriteByte(MSG_ALL, i2 + 48);
	i1 = i1 - i2 * 10;
	WriteByte(MSG_ALL, i1 + 48);
	WriteString(MSG_ALL, " seconds to gamestart\n COLOR(`Join an existing team') ");
	self.nextthink = time + 1;
};

void() AdminForceStart =
{
	local entity mess;
	local float f1, k_lockmin, k_lockmax;
	local string tmp;

	if(match_in_progress || self.k_admin != 2) return;
	if(self.classname == "player" && !self.ready) {
			sprint(self, PRINT_HIGH, "Ready yourself first\n");
			return;
	}
	k_lockmin = stof(infokey(world, "k_lockmin"));
	k_lockmax = stof(infokey(world, "k_lockmax"));
	f1 = CountRTeams();
	if(f1 < k_lockmin) {
			tmp = ftos(k_lockmin - f1);
			sprint2(self, PRINT_HIGH, tmp, " more team");
			if((k_lockmin - f1) != 1) sprint(self, PRINT_HIGH, "s");
			sprint(self, PRINT_HIGH, " required.\n");
			return;
	}
	if(f1 > k_lockmax) {
			sprint(self, PRINT_HIGH, "Get rid of ");
			tmp = ftos(f1 - k_lockmax);
			sprint2(self, PRINT_HIGH, tmp, " team");
			if((f1 - k_lockmax) != 1) sprint(self, PRINT_HIGH, "s");
			sprint(self, PRINT_HIGH, "!\n");
			return;
	}
	f1 = CountPlayers();
	if(f1) {
		bprint2(PRINT_HIGH, self.netname, " forces matchstart!\n");
		k_force = 1;
		mess = spawn();
		mess.classname = "mess";
		mess.owner = self;
		mess.think = ReadyThink;
		mess.nextthink = time + 0.1;
		mess.attack_finished = 10 + 1;
	}
	else sprint(self, PRINT_HIGH, "Can't issue! More players needed.\n");
};

void() AdminMatchStart =
{
	local entity p;
	local float f1;

	f1 = 0;
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			if(p.ready && p.k_accepted == 2) {
				f1 = f1 + 1;
			} else {
				sprint(p, PRINT_HIGH, "\nBye bye! Pay attention next time.\n");
				stuffcmd(p, "disconnect\n");
				remove(p);
			}
		}
		p = find(p, classname, "player");
	}
	k_attendees = f1;
	if(k_attendees) StartTimer();
	else {
		bprint(PRINT_HIGH, "Can't start! More players needed.\n");
		StopTimer();
		NextLevel();
	}
};

void() AdminForceBreak =
{
	local entity p;
	local float f1;
	local string tmp;

	if(self.k_admin == 2 && self.classname != "player" && !match_in_progress) {
		k_force = 0;
		return;
	}
	if(self.k_admin != 2 || !match_in_progress) return;
	if(self.classname != "player" && match_in_progress == M_COUNTDOWN) {
		k_force = 0;
		StopTimer();
		return;
	}
	dprint("%forcebreak%");
	dprint(self.netname);
	dprint("\n");
	bprint2(PRINT_HIGH, self.netname, " forces a break!\nMATCH OVER!!\n");
	EndMatch(0);
};

void() TogglePreWar =
{
	local float tmp;

	if(self.k_admin != 2) return;
	tmp = stof(infokey(world, "k_prewar"));
	if(tmp != 0) {
		localcmd("localinfo k_prewar 0\n");
		if(!match_in_progress) bprint(PRINT_HIGH, "Players may COLOR(`NOT') fire before match!\n");
		else sprint(self, PRINT_HIGH, "Players may COLOR(`NOT') fire before match!\n");
		return;
	}
	localcmd("localinfo k_prewar 1\n");
	if(!match_in_progress) bprint(PRINT_HIGH, "Players may fire before match.\n");
	else sprint(self, PRINT_HIGH, "Players may fire before match.\n");
};

void() ToggleMapLock =
{
	local float tmp;

	if(self.k_admin != 2) return;
	tmp = stof(infokey(world, "k_lockmap"));
	if(tmp != 0) {
		localcmd("localinfo k_lockmap 0\n");
		if(!match_in_progress) bprint2(PRINT_HIGH, self.netname, " unlocks map.\n");
		else sprint(self, PRINT_HIGH, "Map unlocked.\n");
		return;
	}
	localcmd("localinfo k_lockmap 1\n");
	if(!match_in_progress) bprint(PRINT_HIGH, "Map is locked!\n");
	else sprint(self, PRINT_HIGH, "Map is locked!\n");
};

void() ToggleMaster =
{
	local float f1;
	local string s1;

	if(self.k_admin != 2) return;
	f1 = stof(infokey(world, "k_master"));
	f1 = 1 - f1;
	if(f1) {
		bprint2(PRINT_HIGH, self.netname, " sets mastermode!\nPlayers may NOT alter settings\n");
	} else bprint(PRINT_HIGH,"Mastermode disabled\nPlayers can now alter settings\n");
	s1 = ftos(f1);
	localcmd("localinfo k_master ");
	localcmd(s1);
	localcmd("\n");
};