// Captain functions introduced by rc\sturm
// here we use k_captains for storing the number of captains.
// one elected captain is worth 1, player being elected is worth 0.5 :)

// Check if picking should be finished

// pick the player
void(entity p) SetPlayerParams =
{
	local string infoteam, infocolor;

	if(k_captainturn == 1) {
		k_captainturn = 2;
		infoteam = infokey(world, "captteam1");
		infocolor = infokey(world, "captcolor1");
	} else {
		k_captainturn = 1;
		infoteam = infokey(world, "captteam2");
		infocolor = infokey(world, "captcolor2");
	}

	bprint4(2, p.netname, " set to team �", infoteam, "�\n");

	stuffcmd(p, "break\nteam \"");
	stuffcmd(p, infoteam);
	stuffcmd(p, "\"\ncolor ");
	stuffcmd(p, infocolor);
	stuffcmd(p, "\n");
	p.frags = 0;
	p.k_picked = self.k_captain;
};

void() PrintCaptainInTurn =
{
	local entity p;

	p = find(world, classname, "player");
	while(p != world && p.k_captain != k_captainturn)
		p = find(p, classname, "player");
	bprint2(2, p.netname, " is picking\n");
};

void() CheckFinishCaptain =
{
	local float f1 = 0;
	local entity p, lastone, oldself;

// s: calculate how many players are free
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && p.frags) {
			lastone = p;
			f1 = f1 + 1;
		}
		p = find(p, classname, "player");
	}
	if(f1 == 1) {
		p = find(world, classname, "player");
		while(p.k_captain != k_captainturn)
			p = find(p, classname, "player");
		oldself = self;
		self = p;
		SetPlayerParams(lastone);
		self = oldself;
		bprint(2, "All players chosen. Captain modes exited\n");
		f1 = 0;
	}	
	if(!f1) {
		p = find(world, classname, "player");
		while(p != world) {
			if(p.k_captain) {
				if(oldself.netname == "")
					sprint(p, 2, "You are no longer a captain\n");
				p.k_captain = p.k_picked = 0;
			}
			p = find(p, classname, "player");
		}
		k_captains = 0;
	}
};

void() CaptainPickPlayer =
{
	local entity p;

	if(self.k_captain != k_captainturn) {
		sprint(self, 2, "It's ��� your turn\n");
		return;
	}
	p = find(world, classname, "player");
	while(p != world && p.frags != self.impulse)
		p = find(p, classname, "player");
	if(p.frags != self.impulse) {
		sprint(self, 2, "No such player. Pick another one\n");
		return;
	}
	SetPlayerParams(p);
	sprint3(p, 2, "You were picked by ", self.netname, "\nTime to go ready\n");
	CheckFinishCaptain();
	if(k_captains) PrintCaptainInTurn();
};

void() ExitCaptain =
{
	local entity p;
	local string tmp;

	if(self.k_captain == 1 || self.k_captain == 2) {
		self.k_captain = 0;
		if(k_captains == 2) {
			bprint(2, "Player picking aborted\n");
			p = find(world, classname, "player");
			while(p != world) {
				if(p.frags) p.frags = 0;
				p = find(p, classname, "player");
			}
		}
		k_captains = k_captains - 1;
		if(floor(k_captains)) tmp = "�1�";
		else tmp = "No";
		bprint2(2, tmp, " captain present\n");
	}
};

void() BecomeCaptain =
{
	local float f1;
	local entity p, electguard;
	local string tmp, s2;

// s: check if we are being elected or we are a captain already
	if(self.k_captain) {
		if(self.k_captain > 10) {
			bprint2(2, self.netname, " aborts election");
			bprint(3, "\n");
			AbortElect();
		} else {
			bprint2(2, self.netname, " is no longer a captain.\n");
			ExitCaptain();
		}
		return;
	}

	if(match_in_progress || intermission_running) return;

	if(stof(infokey(world, "k_duel"))) {
		sprint(self, 2, "No team picking in duel mode\n");
		return;
	}

	f1 = CountPlayers();
	if(f1 < 3) {
		sprint(self, 2, "Not enough players present\n");
		return;
	}

	if(!teamplay) {
		sprint(self, 2, "Set proper teamplay mode first\n");
		return;
	}
	if(k_captains == 2) {
		sprint(self, 2, "Only 2 captains are allowed\n");
		return;
	}

// s: no captain election if any election in progress
	if(k_velect) {
		sprint(self, 2, "An election is already in progress\n");
		return;
	}

// s: no captains with team ""
	if(infokey(self, "team") == "") {
		sprint(self, 2, "Set your team name first\n");
		return;
	}

// search if a captain already has the same team
	p = find(world, classname, "player");
	while(p != world && !p.k_captain)
		p = find(p, classname, "player");
	tmp = infokey(p, "team");
	if(infokey(self, "team") == tmp) {
		sprint3(self, 2, "A ������� with team �", tmp, "� already exists\nChoose a new team name\n");
		return;
	}
// check if a captain already has the same colors
	tmp = infokey(self, "topcolor");
	s2 = infokey(self, "bottomcolor");
	if(tmp == infokey(p, "topcolor") && s2 == infokey(p, "bottomcolor")) {
		sprint(self, 2, "A ������� with your color already exists\nChange to new color\n");
		return;
	}

// announce the election
	k_velect = 1;
	k_captains = k_captains + 0.5;
	bprint2(2, self.netname, " has requested ");
	bprint(3, "captain");
	bprint(2, " status\nType ��� in console to approve\n");
	sprint(self, 2, "Type ������� to abort election\n");

// s: give a number for the captain (1 or 2); a number > 10 means election
	if(p.k_captain == 1)
		self.k_captain = 12;
	else
		self.k_captain = 11;

// s: spawn the cool dude
	electguard = spawn(); // Check the 1 minute timeout for election
	electguard.owner = world;
	electguard.classname = "electguard";
	electguard.think = ElectThink;
	electguard.nextthink = time + 60;
};

void() BeginPicking =
{
	local entity p;
	local float num;
	local string tmp;

	if(CountPlayers() < 3) {
		bprint(2, "Not enough players present\nCaptain modes exited\n");
		p = find(world, classname, "player");
		while(p != world) {
			if(p.k_captain && p.netname != "") {
				sprint(p, 2, "You are no longer a captain\n");
				p.k_captain = 0;
			}
			p = find(p, classname, "player");
		}
		k_captains = 0;
		return;
	}
	num = 1;
	bprint(2, "Both �������� elected\nTeam picking begins\n");
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "") {
			if(p.k_captain) {
				sprint(p, 2, "\nUse ������� or �������� to choose\n");
				tmp = infokey(p, "team");
				if(p.k_captain == 1)
					localcmd("localinfo captteam1 \"");
				else	localcmd("localinfo captteam2 \"");
				localcmd(tmp);
				if(p.k_captain == 1)
					localcmd("\"\nlocalinfo captcolor1 \"");
				else	localcmd("\"\nlocalinfo captcolor2 \"");
				tmp = infokey(p, "topcolor");
				localcmd(tmp);
				localcmd(" ");
				tmp = infokey(p, "bottomcolor");
				localcmd(tmp);
				localcmd("\"\n");
			} else {
				stuffcmd(p, "break\ncolor 0\nskin \"\"\nteam \"\"\n");
				p.frags = num;
				num = num + 1;
			}
			p.k_msgcount = time + 1;
		}
		p = find(p, classname, "player");
	}
	num = random();
	if(num < 0.5) k_captainturn = 1;
	else k_captainturn = 2;
	PrintCaptainInTurn();
};
