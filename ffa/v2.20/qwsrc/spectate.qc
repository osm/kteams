// Spectator functions
// Added Aug11'97 by Zoid <zoid@idsoftware.com>
//
// These functions are called from the server if they exist.
// Note that Spectators only have one think since they movement code doesn't
// track them much.  Impulse commands work as usual, but don't call
// the regular ImpulseCommand handler in weapons.qc since Spectators don't
// have any weapons and things can explode.
//
//   --- Zoid.

/*
===========
SpectatorConnect

called when a spectator connects to a server
============
*/
void() SpectatorConnect =
{
	bprint (PRINT_MEDIUM, "Spectator ");
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " entered the game\n");

	sprint(self, 2, "Welcome to ������ ����� ��� ��� mod\nType �������� for help\n");

	stuffcmd(self, "alias join \"impulse 13\"\n");
	stuffcmd(self, "alias scores \"impulse 16\"\n");
	stuffcmd(self, "alias commands \"impulse 17\"\n");
	stuffcmd(self, "alias about \"impulse 21\"\n");

	self.goalentity = world; // used for impulse 1 below
};

/*
===========
SpectatorDisconnect

called when a spectator disconnects from a server
============
*/
void() SpectatorDisconnect =
{
	bprint (PRINT_MEDIUM, "Spectator ");
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " left the game\n");
};

/*
================
SpectatorImpulseCommand

Called by SpectatorThink if the spectator entered an impulse
================
*/
void() SpectatorImpulseCommand =
{
	if (self.impulse == 1) {
		// teleport the spectator to the next spawn point
		// note that if the spectator is tracking, this doesn't do
		// much
		self.goalentity = find(self.goalentity, classname, "info_player_deathmatch");
		if (self.goalentity == world)
			self.goalentity = find(self.goalentity, classname, "info_player_deathmatch");
		if (self.goalentity != world) {
			setorigin(self, self.goalentity.origin);
			self.angles = self.goalentity.angles;
			self.fixangle = TRUE;           // turn this way immediately
		}
	}
	else if(self.impulse == 13) stuffcmd(self, "spectator 0; wait; wait; reconnect\n");
	else if(self.impulse == 16) PrintScores();
	else if(self.impulse == 17) PrintSCommands();
	else if(self.impulse == 21) ShowVersion();
	self.impulse = 0;
};

/*
================
SpectatorThink

Called every frame after physics are run
================
*/
void() SpectatorThink =
{
	// self.origin, etc contains spectator position, so you could
	// do some neat stuff here

	if (self.impulse)
		SpectatorImpulseCommand();
};
