// maps.qc

m4_define(First_Map_Impulse, 100)
m4_define(Available_Maps, `(m4_dnl
e1m1,e1m2,e1m3,e1m4,e1m5,e1m6,e1m7,e1m8,m4_dnl
e2m1,e2m2,e2m3,e2m4,e2m5,e2m6,e2m7,m4_dnl
e3m1,e3m2,e3m3,e3m4,e3m5,e3m6,e3m7,m4_dnl
e4m1,e4m2,e4m3,e4m4,e4m5,e4m6,e4m7,e4m8,m4_dnl
dm1,dm2,dm3,dm4,dm5,dm6,start,end,m4_dnl
)')

float() CountPlayers;

void() StuffMapAliases =
{
m4_define(`running_impulse', First_Map_Impulse)

foreach(x, Available_Maps,
`	alias_imp2(x, running_impulse)
m4_define(`running_impulse', m4_incr(running_impulse))')
};

m4_define(`LAST_MAP_IMPULSE',m4_decr(running_impulse))

void() StuffCustomMaps =
{
	local float f1, f2;
	local string s1, s2;

	f1 = LAST_MAP_IMPULSE + 1;
	f2 = 1000;
	s1 = ftos(f2);
	s2 = infokey(world, s1);
	while(s2 != "") {
		stuffcmd(self, "alias ");
		stuffcmd(self, s2);
		stuffcmd(self, " \"");
		stuffcmd(self, "impulse ");
		s1 = ftos(f1);
		stuffcmd(self, s1);
		stuffcmd(self, "\"\n");
		f1 = f1 + 1;
		f2 = f2 + 1;
		s1 = ftos(f2);
		s2 = infokey(world, s1);
	}
	f1 = f1 - 1;
	s1 = infokey(world, "999");
	if(s1 == "") {
		localcmd("localinfo 999 \"");
		s1 = ftos(f1);
		localcmd(s1);
		localcmd("\"\n");
	}
};

void() SelectMap =
{
	local float f1, f2, f3;
	local string s1, s2;
	local entity p;

	f1 = stof(infokey(world, "999"));
	if(self.impulse > f1) return;
	if((stof(infokey(world, "k_lockmap")) || stof(infokey(world, "k_master"))) && self.k_admin < 2) {
		sprint(self, PRINT_HIGH, "MAP IS LOCKED!\nYou are NOT allowed to change!\n");
		return;
	}
	f3 = 0;
	if(!k_vbreak) {
		bprint2(PRINT_CHAT, self.netname, " suggests map ");
		k_vbreak = self.impulse;
		self.k_vote = self.impulse;
	} else {
		if(k_vbreak == self.impulse) {
			if(self.k_vote != self.impulse) {
				f1 = CountPlayers();
				if(f1 < 3) bprint2(PRINT_CHAT, self.netname, " agrees to map ");
				else bprint2(PRINT_CHAT, self.netname, " agrees on map ");
				self.k_vote = self.impulse;
			} else {
				sprint(self, PRINT_HIGH, "--- your vote is still good ---\n");
				f3 = 1;
			}
		} else {
			p = find(world, classname, "player");
			while(p != world) {
				p.k_vote = 0;
				p = find(p, classname, "player");
			}
			bprint2(PRINT_CHAT, self.netname, " would rather play on ");
			k_vbreak = self.impulse;
			self.k_vote = self.impulse;
		}
	}
	if(!f3) {
	m4_define(`running_impulse', First_Map_Impulse)
	foreach(x, Available_Maps,
	` if (self.impulse == running_impulse)
		bprint(PRINT_HIGH, "x");
	m4_define(`running_impulse', m4_incr(running_impulse)) else') {
			f1 = self.impulse + 999 - LAST_MAP_IMPULSE;
			s1 = ftos(f1);
			s2 = infokey(world, s1);
			bprint(PRINT_HIGH, s2);
		}
	bprint(PRINT_HIGH, "\n");
	}
	f1 = CountPlayers();
	f2 = (floor(f1 / 2)) + 1;
	f1 = 0;
	p = find(world, classname, "player");
	while(p != world) {
		if(p.netname != "" && p.k_vote == k_vbreak) f1 = f1 + 1;
		p = find(p, classname, "player");
	}
	if(f1 < f2 && self.k_admin != 2) return;
	if(self.k_admin == 2) {
		bprint(PRINT_HIGH, "Admin veto\n");
	} else {
		bprint(PRINT_HIGH, "Majority votes for mapchange.\n");
	}
m4_define(`running_impulse', First_Map_Impulse)
foreach(x, Available_Maps,
` if (self.impulse == running_impulse)
	localcmd("map x\n");
m4_define(`running_impulse', m4_incr(running_impulse)) else') {
		f1 = self.impulse + 999 - LAST_MAP_IMPULSE;
		s1 = ftos(f1);
		localcmd("map ");
		s2 = infokey(world, s1);
		localcmd(s2);
		localcmd("\n");
	}
};