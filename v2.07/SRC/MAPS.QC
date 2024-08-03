// maps.qc - Axu<FAQ> (ams@iki.fi)




void() StuffMapAliases =
{


	stuffcmd(self.owner, "alias e1m1 \"impulse 100\"\n");
	stuffcmd(self.owner, "alias e1m2 \"impulse 101\"\n");
	stuffcmd(self.owner, "alias e1m3 \"impulse 102\"\n");
	stuffcmd(self.owner, "alias e1m4 \"impulse 103\"\n");
	stuffcmd(self.owner, "alias e1m5 \"impulse 104\"\n");
	stuffcmd(self.owner, "alias e1m6 \"impulse 105\"\n");
	stuffcmd(self.owner, "alias e1m7 \"impulse 106\"\n");
	stuffcmd(self.owner, "alias e1m8 \"impulse 107\"\n");
	stuffcmd(self.owner, "alias e2m1 \"impulse 108\"\n");
	stuffcmd(self.owner, "alias e2m2 \"impulse 109\"\n");
	stuffcmd(self.owner, "alias e2m3 \"impulse 110\"\n");
	stuffcmd(self.owner, "alias e2m4 \"impulse 111\"\n");
	stuffcmd(self.owner, "alias e2m5 \"impulse 112\"\n");
	stuffcmd(self.owner, "alias e2m6 \"impulse 113\"\n");
	stuffcmd(self.owner, "alias e2m7 \"impulse 114\"\n");
	stuffcmd(self.owner, "alias e3m1 \"impulse 115\"\n");
	stuffcmd(self.owner, "alias e3m2 \"impulse 116\"\n");
	stuffcmd(self.owner, "alias e3m3 \"impulse 117\"\n");
	stuffcmd(self.owner, "alias e3m4 \"impulse 118\"\n");
	stuffcmd(self.owner, "alias e3m5 \"impulse 119\"\n");
	stuffcmd(self.owner, "alias e3m6 \"impulse 120\"\n");
	stuffcmd(self.owner, "alias e3m7 \"impulse 121\"\n");
	stuffcmd(self.owner, "alias e4m1 \"impulse 122\"\n");
	stuffcmd(self.owner, "alias e4m2 \"impulse 123\"\n");
	stuffcmd(self.owner, "alias e4m3 \"impulse 124\"\n");
	stuffcmd(self.owner, "alias e4m4 \"impulse 125\"\n");
	stuffcmd(self.owner, "alias e4m5 \"impulse 126\"\n");
	stuffcmd(self.owner, "alias e4m6 \"impulse 127\"\n");
	stuffcmd(self.owner, "alias e4m7 \"impulse 128\"\n");
	stuffcmd(self.owner, "alias e4m8 \"impulse 129\"\n");
	stuffcmd(self.owner, "alias dm1 \"impulse 130\"\n");
	stuffcmd(self.owner, "alias dm2 \"impulse 131\"\n");
	stuffcmd(self.owner, "alias dm3 \"impulse 132\"\n");
	stuffcmd(self.owner, "alias dm4 \"impulse 133\"\n");
	stuffcmd(self.owner, "alias dm5 \"impulse 134\"\n");
	stuffcmd(self.owner, "alias dm6 \"impulse 135\"\n");
	stuffcmd(self.owner, "alias start \"impulse 136\"\n");
	stuffcmd(self.owner, "alias end \"impulse 137\"\n");
	stuffcmd(self.owner, "alias ukooldm1 \"impulse 138\"\n");
	stuffcmd(self.owner, "alias ukooldm2 \"impulse 139\"\n");
	stuffcmd(self.owner, "alias ukooldm3 \"impulse 140\"\n");
	stuffcmd(self.owner, "alias ukooldm4 \"impulse 141\"\n");
	stuffcmd(self.owner, "alias ukooldm5 \"impulse 142\"\n");
	stuffcmd(self.owner, "alias ukooldm6 \"impulse 143\"\n");
	stuffcmd(self.owner, "alias ukooldm7 \"impulse 144\"\n");
	stuffcmd(self.owner, "alias ukooldm8 \"impulse 145\"\n");
	stuffcmd(self.owner, "alias ukooldm9 \"impulse 146\"\n");
	stuffcmd(self.owner, "alias aerowalk \"impulse 147\"\n");
	stuffcmd(self.owner, "alias dapak1 \"impulse 148\"\n");
	stuffcmd(self.owner, "alias dapak2 \"impulse 149\"\n");
	stuffcmd(self.owner, "alias dapak3 \"impulse 150\"\n");
	stuffcmd(self.owner, "alias dapak4 \"impulse 151\"\n");
	stuffcmd(self.owner, "alias dapak5 \"impulse 152\"\n");
	stuffcmd(self.owner, "alias dapak6 \"impulse 153\"\n");
	stuffcmd(self.owner, "alias dapak7 \"impulse 154\"\n");
	stuffcmd(self.owner, "alias dapak8 \"impulse 155\"\n");
	stuffcmd(self.owner, "alias dapak9 \"impulse 156\"\n");
	stuffcmd(self.owner, "alias trimp \"impulse 157\"\n");
	stuffcmd(self.owner, "alias ukcldm1 \"impulse 158\"\n");
	stuffcmd(self.owner, "alias ukcldm2 \"impulse 159\"\n");
	stuffcmd(self.owner, "alias ukcldm3 \"impulse 160\"\n");
	stuffcmd(self.owner, "alias ukcldm4 \"impulse 161\"\n");
	stuffcmd(self.owner, "alias ukcldm5 \"impulse 162\"\n");
	stuffcmd(self.owner, "alias base32b \"impulse 163\"\n");
	stuffcmd(self.owner, "alias death32c \"impulse 164\"\n");

};



void() SelectMap =
{
        if (self.impulse > 164) return;


		if((stof(infokey(world, "k_lockmap")) || k_master) && self.k_admin < 2) {
			sprint(self, 2, "MAP IS LOCKED!\nYou are NOT allowed to change!\n");
			return;
		}
		bprint(2, "\n");
		bprint2(3, self.netname, " changes map\n");
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
 else if (self.impulse == 138)
	localcmd("map ukooldm1\n");
 else if (self.impulse == 139)
	localcmd("map ukooldm2\n");
 else if (self.impulse == 140)
	localcmd("map ukooldm3\n");
 else if (self.impulse == 141)
	localcmd("map ukooldm4\n");
 else if (self.impulse == 142)
	localcmd("map ukooldm5\n");
 else if (self.impulse == 143)
	localcmd("map ukooldm6\n");
 else if (self.impulse == 144)
	localcmd("map ukooldm7\n");
 else if (self.impulse == 145)
	localcmd("map ukooldm8\n");
 else if (self.impulse == 146)
	localcmd("map ukooldm9\n");
 else if (self.impulse == 147)
	localcmd("map aerowalk\n");
 else if (self.impulse == 148)
	localcmd("map dapak1\n");
 else if (self.impulse == 149)
	localcmd("map dapak2\n");
 else if (self.impulse == 150)
	localcmd("map dapak3\n");
 else if (self.impulse == 151)
	localcmd("map dapak4\n");
 else if (self.impulse == 152)
	localcmd("map dapak5\n");
 else if (self.impulse == 153)
	localcmd("map dapak6\n");
 else if (self.impulse == 154)
	localcmd("map dapak7\n");
 else if (self.impulse == 155)
	localcmd("map dapak8\n");
 else if (self.impulse == 156)
	localcmd("map dapak9\n");
 else if (self.impulse == 157)
	localcmd("map trimp\n");
 else if (self.impulse == 158)
	localcmd("map ukcldm1\n");
 else if (self.impulse == 159)
	localcmd("map ukcldm2\n");
 else if (self.impulse == 160)
	localcmd("map ukcldm3\n");
 else if (self.impulse == 161)
	localcmd("map ukcldm4\n");
 else if (self.impulse == 162)
	localcmd("map ukcldm5\n");
 else if (self.impulse == 163)
	localcmd("map base32b\n");
 else if (self.impulse == 164)
	localcmd("map death32c\n");
 else return;
};