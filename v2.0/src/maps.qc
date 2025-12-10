// maps.qc




float() CountPlayers;

void() StuffMapAliases =
{


	stuffcmd(self, "alias e1m1 \"impulse 100\"\n");
	stuffcmd(self, "alias e1m2 \"impulse 101\"\n");
	stuffcmd(self, "alias e1m3 \"impulse 102\"\n");
	stuffcmd(self, "alias e1m4 \"impulse 103\"\n");
	stuffcmd(self, "alias e1m5 \"impulse 104\"\n");
	stuffcmd(self, "alias e1m6 \"impulse 105\"\n");
	stuffcmd(self, "alias e1m7 \"impulse 106\"\n");
	stuffcmd(self, "alias e1m8 \"impulse 107\"\n");
	stuffcmd(self, "alias e2m1 \"impulse 108\"\n");
	stuffcmd(self, "alias e2m2 \"impulse 109\"\n");
	stuffcmd(self, "alias e2m3 \"impulse 110\"\n");
	stuffcmd(self, "alias e2m4 \"impulse 111\"\n");
	stuffcmd(self, "alias e2m5 \"impulse 112\"\n");
	stuffcmd(self, "alias e2m6 \"impulse 113\"\n");
	stuffcmd(self, "alias e2m7 \"impulse 114\"\n");
	stuffcmd(self, "alias e3m1 \"impulse 115\"\n");
	stuffcmd(self, "alias e3m2 \"impulse 116\"\n");
	stuffcmd(self, "alias e3m3 \"impulse 117\"\n");
	stuffcmd(self, "alias e3m4 \"impulse 118\"\n");
	stuffcmd(self, "alias e3m5 \"impulse 119\"\n");
	stuffcmd(self, "alias e3m6 \"impulse 120\"\n");
	stuffcmd(self, "alias e3m7 \"impulse 121\"\n");
	stuffcmd(self, "alias e4m1 \"impulse 122\"\n");
	stuffcmd(self, "alias e4m2 \"impulse 123\"\n");
	stuffcmd(self, "alias e4m3 \"impulse 124\"\n");
	stuffcmd(self, "alias e4m4 \"impulse 125\"\n");
	stuffcmd(self, "alias e4m5 \"impulse 126\"\n");
	stuffcmd(self, "alias e4m6 \"impulse 127\"\n");
	stuffcmd(self, "alias e4m7 \"impulse 128\"\n");
	stuffcmd(self, "alias e4m8 \"impulse 129\"\n");
	stuffcmd(self, "alias dm1 \"impulse 130\"\n");
	stuffcmd(self, "alias dm2 \"impulse 131\"\n");
	stuffcmd(self, "alias dm3 \"impulse 132\"\n");
	stuffcmd(self, "alias dm4 \"impulse 133\"\n");
	stuffcmd(self, "alias dm5 \"impulse 134\"\n");
	stuffcmd(self, "alias dm6 \"impulse 135\"\n");
	stuffcmd(self, "alias start \"impulse 136\"\n");
	stuffcmd(self, "alias end \"impulse 137\"\n");

};



void() StuffCustomMaps =
{
	local float f1, f2;
	local string s1, s2;

	f1 = 137 + 1;
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
		sprint(self, 2, "MAP IS LOCKED!\nYou are NOT allowed to change!\n");
		return;
	}
	f3 = 0;
	if(!k_vbreak) {
		bprint2(3, self.netname, " suggests map ");
		k_vbreak = self.impulse;
		self.k_vote = self.impulse;
	} else {
		if(k_vbreak == self.impulse) {
			if(self.k_vote != self.impulse) {
				f1 = CountPlayers();
				if(f1 < 3) bprint2(3, self.netname, " agrees to map ");
				else bprint2(3, self.netname, " agrees on map ");
				self.k_vote = self.impulse;
			} else {
				sprint(self, 2, "--- your vote is still good ---\n");
				f3 = 1;
			}
		} else {
			p = find(world, classname, "player");
			while(p != world) {
				p.k_vote = 0;
				p = find(p, classname, "player");
			}
			bprint2(3, self.netname, " would rather play on ");
			k_vbreak = self.impulse;
			self.k_vote = self.impulse;
		}
	}
	if(!f3) {
	
	 if (self.impulse == 100)
		bprint(2, "e1m1");
	 else if (self.impulse == 101)
		bprint(2, "e1m2");
	 else if (self.impulse == 102)
		bprint(2, "e1m3");
	 else if (self.impulse == 103)
		bprint(2, "e1m4");
	 else if (self.impulse == 104)
		bprint(2, "e1m5");
	 else if (self.impulse == 105)
		bprint(2, "e1m6");
	 else if (self.impulse == 106)
		bprint(2, "e1m7");
	 else if (self.impulse == 107)
		bprint(2, "e1m8");
	 else if (self.impulse == 108)
		bprint(2, "e2m1");
	 else if (self.impulse == 109)
		bprint(2, "e2m2");
	 else if (self.impulse == 110)
		bprint(2, "e2m3");
	 else if (self.impulse == 111)
		bprint(2, "e2m4");
	 else if (self.impulse == 112)
		bprint(2, "e2m5");
	 else if (self.impulse == 113)
		bprint(2, "e2m6");
	 else if (self.impulse == 114)
		bprint(2, "e2m7");
	 else if (self.impulse == 115)
		bprint(2, "e3m1");
	 else if (self.impulse == 116)
		bprint(2, "e3m2");
	 else if (self.impulse == 117)
		bprint(2, "e3m3");
	 else if (self.impulse == 118)
		bprint(2, "e3m4");
	 else if (self.impulse == 119)
		bprint(2, "e3m5");
	 else if (self.impulse == 120)
		bprint(2, "e3m6");
	 else if (self.impulse == 121)
		bprint(2, "e3m7");
	 else if (self.impulse == 122)
		bprint(2, "e4m1");
	 else if (self.impulse == 123)
		bprint(2, "e4m2");
	 else if (self.impulse == 124)
		bprint(2, "e4m3");
	 else if (self.impulse == 125)
		bprint(2, "e4m4");
	 else if (self.impulse == 126)
		bprint(2, "e4m5");
	 else if (self.impulse == 127)
		bprint(2, "e4m6");
	 else if (self.impulse == 128)
		bprint(2, "e4m7");
	 else if (self.impulse == 129)
		bprint(2, "e4m8");
	 else if (self.impulse == 130)
		bprint(2, "dm1");
	 else if (self.impulse == 131)
		bprint(2, "dm2");
	 else if (self.impulse == 132)
		bprint(2, "dm3");
	 else if (self.impulse == 133)
		bprint(2, "dm4");
	 else if (self.impulse == 134)
		bprint(2, "dm5");
	 else if (self.impulse == 135)
		bprint(2, "dm6");
	 else if (self.impulse == 136)
		bprint(2, "start");
	 else if (self.impulse == 137)
		bprint(2, "end");
	 else {
			f1 = self.impulse + 999 - 137;
			s1 = ftos(f1);
			s2 = infokey(world, s1);
			bprint(2, s2);
		}
	bprint(2, "\n");
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
		bprint(2, "Admin veto\n");
	} else {
		bprint(2, "Majority votes for mapchange.\n");
	}

 if (self.impulse == 100)
	localcmd("map e1m1\n");
 else if (self.impulse == 101)
	localcmd("map e1m2\n");
 else if (self.impulse == 102)
	localcmd("map e1m3\n");
 else if (self.impulse == 103)
	localcmd("map e1m4\n");
 else if (self.impulse == 104)
	localcmd("map e1m5\n");
 else if (self.impulse == 105)
	localcmd("map e1m6\n");
 else if (self.impulse == 106)
	localcmd("map e1m7\n");
 else if (self.impulse == 107)
	localcmd("map e1m8\n");
 else if (self.impulse == 108)
	localcmd("map e2m1\n");
 else if (self.impulse == 109)
	localcmd("map e2m2\n");
 else if (self.impulse == 110)
	localcmd("map e2m3\n");
 else if (self.impulse == 111)
	localcmd("map e2m4\n");
 else if (self.impulse == 112)
	localcmd("map e2m5\n");
 else if (self.impulse == 113)
	localcmd("map e2m6\n");
 else if (self.impulse == 114)
	localcmd("map e2m7\n");
 else if (self.impulse == 115)
	localcmd("map e3m1\n");
 else if (self.impulse == 116)
	localcmd("map e3m2\n");
 else if (self.impulse == 117)
	localcmd("map e3m3\n");
 else if (self.impulse == 118)
	localcmd("map e3m4\n");
 else if (self.impulse == 119)
	localcmd("map e3m5\n");
 else if (self.impulse == 120)
	localcmd("map e3m6\n");
 else if (self.impulse == 121)
	localcmd("map e3m7\n");
 else if (self.impulse == 122)
	localcmd("map e4m1\n");
 else if (self.impulse == 123)
	localcmd("map e4m2\n");
 else if (self.impulse == 124)
	localcmd("map e4m3\n");
 else if (self.impulse == 125)
	localcmd("map e4m4\n");
 else if (self.impulse == 126)
	localcmd("map e4m5\n");
 else if (self.impulse == 127)
	localcmd("map e4m6\n");
 else if (self.impulse == 128)
	localcmd("map e4m7\n");
 else if (self.impulse == 129)
	localcmd("map e4m8\n");
 else if (self.impulse == 130)
	localcmd("map dm1\n");
 else if (self.impulse == 131)
	localcmd("map dm2\n");
 else if (self.impulse == 132)
	localcmd("map dm3\n");
 else if (self.impulse == 133)
	localcmd("map dm4\n");
 else if (self.impulse == 134)
	localcmd("map dm5\n");
 else if (self.impulse == 135)
	localcmd("map dm6\n");
 else if (self.impulse == 136)
	localcmd("map start\n");
 else if (self.impulse == 137)
	localcmd("map end\n");
 else {
		f1 = self.impulse + 999 - 137;
		s1 = ftos(f1);
		localcmd("map ");
		s2 = infokey(world, s1);
		localcmd(s2);
		localcmd("\n");
	}
};