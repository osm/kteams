// Most of the stuff done by rc\sturm is here

void() TimerThink =
{
	local float f1;
	local string tmp;
	local entity p;

	mytime = mytime + 1;
// s: minutes
	f1 = (timelimit - mytime) / 60;
	if(floor(f1) == f1 && f1) {
		bprint(2, "");
		tmp = ftos(f1);
		bprint(2, tmp);
		if(f1 == 1)
			bprint(2, "‘ minute remaining\n");
		else 
			bprint(2, "‘ minutes remaining\n");
	}
// s: seconds
	f1 = timelimit - mytime;
	if((f1 == 30 || f1 == 15 || f1 <= 10) && f1 > 0) {
		bprint(2, "");
		tmp = ftos(f1);
		bprint(2, tmp);
		if(f1 == 1)
			bprint(2, "‘ second\n");
		else
			bprint(2, "‘ seconds\n");
		if(f1 < 6) {
			p = find(world, classname, "player");
			while(p != world) {
				if(p.netname != "")
					stuffcmd(p, "play buttons/switch04.wav\n");
				p = find(p, classname, "player");
			}
		}
	}
	self.nextthink = time + 1;
};

void() PrintScores =
{
	local float f1, f2;
	local string tmp;
	local entity p;

	if(timelimit) {
		f1 = timelimit - mytime;
		f2 = floor(f1 / 60);
		tmp = ftos(f2);
		sprint(self, 2, "");
		sprint(self, 2, tmp);
		f1 = f1 - f2 * 60;
		sprint(self, 2, ":");
		tmp = ftos(f1);
		sprint(self, 2, tmp);
		sprint(self, 2, "‘ remaining\n");
	}
	if(fraglimit) {

// s: probably low enough for a start value :)
		f1 = -99999;

		p = find(world, classname, "player");
		if(p == world) f1 = 0;
		while(p != world) {
			if(p.netname != "")
				if(p.frags > f1) f1 = p.frags;
			p = find(p, classname, "player");
		}
		tmp = ftos(fraglimit - f1);
		sprint(self, 2, "");
		sprint(self, 2, tmp);
		if(fraglimit - f1 == 1)
			sprint(self, 2, "‘ frag to go\n");
		else
			sprint(self, 2, "‘ frags to go\n");
	}
};

void(string name) SendMessage =
{
	local string s1, s2;
	local entity p;

	p = find(world, classname, "player");
	while((p != world && p.netname != name) || p == self)
		p = find(p, classname, "player");
	if(p != world) {
		s1 = infokey(self, "premsg");
		s2 = infokey(self, "postmsg");
		bprint(3, self.netname);
		bprint(3, ": ");
		bprint(3, s1);
		bprint(2, name);
		bprint(3, s2);
		bprint(3, "\n");
	} else
		stuffcmd(self, "echo No name to display\n");
};			

void() PrintCommands =
{
	sprint(self, 2, "φοτε....... vote for mapchange\nωεσ........ give a vote\nξο......... withdraw a vote\nσγοςεσ..... print game info\nαβουτ...... kombat teams FFA info\nλιμμες..... who killed you last\nφιγτιν..... who you last killed\nξεχγονες... last player joined\n");
};

void() PrintSCommands =
{
	sprint(self, 2, "κοιξ....... join the game\nσγοςεσ..... print game info\nαβουτ...... kombat teams FFA info\n");
};

void() ShowVersion =
{
        sprint(self, 3, "\nThis is Kombat Teams 2.20 FFA\nby Cenobite and Sturm.\n\nSource, configs etc. at:\nhttp://www.barrysworld.com/kteam\n");
};

void() StuffThink =
{
	sprint(self.owner, 2, "Welcome to Λονβατ Τεανσ ²®²° ΖΖΑ mod\nType γονναξδσ for help\n");
	stuffcmd(self.owner, "alias vote \"impulse 13\"\n");
	stuffcmd(self.owner, "alias yes \"impulse 14\"\n");
	stuffcmd(self.owner, "alias no \"impulse 15\"\n");
	stuffcmd(self.owner, "alias scores \"impulse 16\"\n");
	stuffcmd(self.owner, "alias commands \"impulse 17\"\n");
	stuffcmd(self.owner, "alias killer \"impulse 18\"\n");
	stuffcmd(self.owner, "alias victim \"impulse 19\"\n");
	stuffcmd(self.owner, "alias newcomer \"impulse 20\"\n");
	stuffcmd(self.owner, "alias about \"impulse 21\"\n");
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};
