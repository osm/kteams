KOMBAT TEAMS v2.21
------------------

Kombat Teams is a QUAKEWORLD ONLY patch by kemiKal_sWeMoB, Cenobite, Sturm and
Fang which means to simplify all forms of deathmatch games (1-1, 2-2, 4-4,
3-3-3, 31-1 etc.).

It's a public release and provided with absolutely no warranties.  The authors
take no responsibility for the behaviour and functionality of it.  If you have
any problems with 2.20 or suggestions then mail cenobite at address below.

kemiKal :  kemikal@kemikal.com
cenobite:  cenobite@barrysworld.com
sturm   :  silicon@inf.bme.hu
fang    :  tjp@cc.jyu.fi

The latest official version of Kombat Teams can always be found on:
http://hosted.barrysworld.com/kteam

In case you are wondering I took over from kemikal since he is busy with
other things :)  This is not *my* mod its his so dont forget this people ;0


INSTALLATION
------------

Create a directory called "kteam" in your quakedirectory and copy all files
supplied with the patch into it. Edit the "server.cfg" file to your liking
and start the server by typing "qwsv +gamedir kteam". Please refer to the
quakeworld server documentation if you want your server to show up on any of
the masterservers available.  For best server performance, run your server on
a machine using unix (or any of its clones) or a PC running WINDOWS NT. Please
make sure that you use the QuakeWorld 2.3 server to run the patch.

For those people that are upgrading from v2.07 then please read K_newstuff.txt.
This will explain to you all the new commands available as well as all the
player/server settings.


PLAYER COMMANDS EXPLAINED
-------------------------
* "about":
     Shows you the version number of the patch and a small note.

* "ready":
     Tell the server that you're ready for some action.

* "break":  ("notready")
     PREGAME:   tells the server that you're not ready after all.
     COUNTDOWN: stops the countdown (maybe to change some settings).
     MATCH:     toggle your vote for match-break (if you've got a majority
                voting with you, the match will stop and results won't be
                logged).

* "dm":
     Steps through deathmatch-modes 1-5.

* "tp":
     Steps through teamplay-modes 0-3.

* "powerups":
     Toggles the availability of powerups during game (quad/666/ring/env.suit).
     With version 2.10, "timer jammer" was introduced. The timer jammer
     respawns powerups randomly at -3 to +3 seconds from its normal time.
     Toggle sequence:   off - on - on (w/ timer jammer) Pre game, quad and
     666 will glow if powerups are enabled and not if not :)

* "official":
     Set common teamplay 4on4 settings to ease matchstart. See history.txt for
     details.

* "discharge":
     Toggles if players should be allowed to "discharge" in water.  If disabled,
     players will only loose all their cells on discharge but not actually
     harm anyone.

* "spawn":
     Toggles between
     0. qw respawns (avoid spawnfrags)
     1. kt spawnsafety
     2. kombat teams respawns
     See technical notes for details.

* "spawn666":
     Toggles player invulnerability on respawn during match.  The
     invulnerability (666) will last for 2 secs but the player will not glow
     to give away spawnposition.  Should the player attack with any weapon
     but axe or shotgun during these 2 seconds, his/her 666 will vanish.

* "berzerk":
     Toggles berzerk mode.  Berzerk mode is meant to release agression built up
     after a cautious game.  When only "k_btime" seconds remains of the game,
     all players gets QUAD/OCTA powered for the remainder of the match and
     the whole level starts strobing.  The first 2 seconds, everyone enjoys
     a bit of satan's power.  (The 2 seconds of 666 was put in to prevent
     disastrous berzerk rocketjumps)

* "rules":
     Prints vital information (selected goodies from this document) depending
     on what is enabled and what is not.

* "reset":
     Resets server to default (see SERVER RESET)

* "maps":
     Displays custom maps supported by the server.

* "dropring":
     Toggles dropring (dr 0/1)

* "dropquad":
     Toggles dropquad (dq 0/1)

* "droppack":
     Toggles dropbackpack (dp 0/1)

* "lock":
     Steps through the serverlock-types.  See technical notes for imformation
     about them.

* "silence":
     Toggles the ability for spectators to talk to players during match.
     (k_spectalk 0/1) Also toggles the spectator -> player voice feature of
     qizmo (fpd 64).

* "fragsup":
     Fraglimit +10 (will not rise above 100 frags).

* "fragsdown":
     Fraglimit -10 (minimum is 0).

* "timeup":
     Timelimit +5 (will not rise above "k_timetop" mins).

* "timedown":
     Timelimit -5 (will not go under 5 mins).

* "timeup1":
     Timelimit +1 (will not rise above 60 mins).

* "timedown1":
     Timelimit -1 (will not go under 5 mins).

* "timeX":
     Where X = 5, 10, 15, 20, 25 or 30.  Sets timelimit accordingly (will
     not go above "k_timetop" mins).

* "status":
     Prints match-settings.

* "status2":
     Even more match-settings printouts.

* "who":
     Prints playerlist.

* "whonot":
     Prints players not ready.  If you are admin this is printed to all players.

* "list":
     Prints a list of not ready players, can be done once every 10 seconds.

* "whoskin":
     Prints all players skins.

* "whovote":
     PREGAME:   shows number of votes for mapchange and number of votes for
     pickup MATCH:     shows number of votes for stopping the match

* "speed":
     Toggles sv_maxspeed (320/k_highspeed)

* "fairpacks":
     Toggles if backpacks will contain former-weapon-in-hand or
     former-best-weapon or last weapon fired. (k_frp 0/1/2)

* "pickup":
     Toggles your vote for a "pickup" game.  See technical notes.

* "report":
     See technical notes.

* "scores":
     Prints teamscores during game. Adds frags for dropped players (ie GHOSTS).
     Also outs remaining matchtime.  It will only show scores in matches that
     involves 2 teams (no more, no less) and at least 3 players on match-start.
     Shows minutes with seconds as XX.

* "stats":
     Prints playerstats during or after a game.

* "efficiency":
     Prints player efficiences during or after a game.

* "overtime":
     Switches between either Overtime mode being off, on and suddendeath.

* "overtimeup":
     Increments the time to add on until it reaches 10 then loops back to 1.

* "k_soundX":
     Where X is a value between 1 and 6.  Plays a soundfile on all your
     teammates computers (if they've got the k_flags "k_sound" flag set). If
     you want your client to play sounds that your teammates triggers, type
     (in the console):
            setinfo k_flags 1
     Your teammates must have the files "ktsound1.wav" - "ktsound6.wav" in
     their "id1/sound" directory or they won't hear anything regardless of
     the k_sound flag.  Remember: If you trigger ktsound1.wav, it will play
     the ktsound1.wav that resides on your teammates disk/s, not the one on
     yours.
     *** The default samples are:
         ktsound1.wav "Home"
         ktsound2.wav "Cellar"
         ktsound3.wav "Tower"
         ktsound4.wav "Help/Assist"
         ktsound5.wav "Warning"
         ktsound6.wav "Report"

     The standard soundbanks can be found at http://hosted.barrysworld.com/kteam
     To be able to use your samples on any server running KT1.96 or higher -
     put the samples in your "ID1/sound" directory (if "sound" doesn't exist,
     create it yourself).  Alternatively you can create subdirectories inside
     ID1/sound called "male", "female" etc. and put the desired soundbanks
     into these - then during game you can tell Kombat Teams that you want
     a female voice by typing (in the console):
            setinfo k_sdir "female"

* ("admin"):
     If admins are allowed on the server, this is how you become one.
     A six digit code will then be asked of you.  Each digit is entered by
     an impulse command between 1 and 9.

* "captain"
  command announces team captain election. After two votings have been
  accomplished, server enters team picker mode where non-captain players receive
  a number which is represented as their frags if you press +showscores.
  Captains pick alternately by typing the number or the appropriate impulse
  of the player they want in their team until all players are chosen. The
  last free player is automatically set to the other team since there's no
  other choice really. Players entering the server during team picking are
  numbered and marked free unless they have the team of one of the captains,
  in which case they are accepted for their team. Players picked get their
  master's team and color and cannot be picked once again in the same procedure.

* "elect"
  command announces admin election with k_allowvoteadmin checked.  Voting by
  yes/no, majority vote makes you admin.

SPECTATOR COMMANDS EXPLAINED
----------------------------
* "stats":
     Prints playerstats during or after agame.

* "efficiency":
     Prints player efficiences during or after a game.

* "status":
     Prints match-settings.

* "status2":
     Even more match-settings printouts.

* "who":
     Prints playerlist.

* "whonot":
     Prints players not ready.

* "whoskin":
     Prints all players skins.

* "whovote":
     PREGAME: shows number of votes for mapchange and number of votes for pickup
     MATCH:   shows number of votes for stopping the match

* "scores":
     Prints teamscores during game. Adds frags for dropped players (ie GHOSTS).
     Also outs remaining matchtime.  It will only show scores in matches that
     involves 2 teams (no more, no less) and atleast 3 players on match-start.

* "cam":
     Shows info on KT's built-in camera functions.

* "join":
     Reconnects to server as a player (spectator 0 and reconnect).

* ("admin"):
     If admins are allowed on the server, this is how you become one.
     A six digit code will then be asked of you.  Each digit is entered by
     an impulse command between 1 and 9.

ADMIN COMMANDS EXPLAINED
------------------------
* "kick":
     If k_allowkick is set to 1 then you are allowed to kick on the server.

     The server will be stepping through all players and spectators and you can
     choose by typing y/n about their kick. When you're done, type "kick" again
     and you'll leave kick mode.

     You can kick any player and spectator. If you miss a player/spectator
     keep typing "n" and it will go back to the start.

* "admin":
     Relieve you of your admin rights.

* "master":
     Toggles mastermode.  In mastermode, only admins may change matchsettings
     (dm/tp/powerups etc).  Mastermode also functions as a maplock.

* "forcestart":
     Gives players 10 seconds to ready themselves, after which they get kicked
     if they're still not ready.  Readied admins may type break to interrupt
     the countdown.  Countdown then commences as usual.  ***PLEASE NOTE***
     If you do start a match this was it locks the server out from new people
     joining so be warned.

* "forcebreak":
     Forces match to end.  Results will be logged as usual but
     "%forcebreak%<adminname>" will tell statistics-programs that the match
     was ended unnaturally and by whom.

* "forcepause":
     Toggles pause during match.

* "lockmap":
     Toggles maplock.  If maplock is enabled, only admins may change map.

* "prewar":
     Toggles the "k_prewar" flag.  When k_prewar = 1:  players can fire prior
     to match
                         (actually they can fire during too :))
     When k_prewar = 0:  players can't fire prior to match
                         (this is the discipline setting)

* "freeze"
  command toggles if lifts and platforms should work before matchstart.
  At countdown start map is frozen so that no doors are open at beginning.

* "rpickup"
  Random Team Picker by an admin will sort players and set to team "red"
  or "blue", reset their skins and change the colors to red and blue.
  (guess which team gets which :p)



NOTE: spectator admins can also use the following commands:
      /tp /dm /powerups /official /timeup /timedown /spawn /silence /reset /maps
      /qpoint /qlag /qenemy

QIZMO COMMANDS EXPLAINED ------------------------
* "qlag":
     fpd XOR 8.  Toggles lockout of the Qizmo lag-set features.

* "qenemy":
     fpd XOR 32.  Toggles lockout of the Qizmo enemies in the vicinity
     reporting.

* "qpoint":
     fpd XOR 128.  Toggles lockout of the Qizmo item-point function. (%x
     %y reporting).

! Note that the Qizmo commands uses a serverinfo key called "fpd" that is
common to almost all
  other proxies as well: Cheapo, NF-Proxy, ProxyLite.  The commands are named
  after the Qizmo because the "fpd" key was introduced by its authors.

!! for more information on Qizmo, Cheapo, ProxyLite and NF proxy, look elsewere
on the web.


SERVER.CFG EXPLAINED
--------------------
A sample server.cfg is included in the KOMBAT TEAMS package, please use that and
modify it as your heart desires. Settings such as startup values for deathmatch,
teamplay and settings for other standard QW servervariables are in there.

PLAYER INFOKEYS EXPLAINED:
--------------------------
A sample kombat.cfg is
included in the KOMBAT TEAMS package, cut'n'paste it to your personal config
and modify it as you see fit. Player infokeys can be set from the console
or in script files with "setinfo <key> <value>". If you for example want
female style messages you should set gender to "f"; this is done by typing
"setinfo gender f".

* "gender":
  Controls genderbased messages such as "checks his glasses".  Gender is always
  considered male unless gender equals "f". Thus: setinfo gender m =
  "checks his glasses" "was telefragged by his teammate" etc.  setinfo gender f
  = "checks her glasses" "was telefragged by her teammate" etc.  setinfo gender
  allelse = "checks his glasses" "was telefragged by his teammate" etc.

* "k_sdir":
  See "k_soundX" under "player commands explained".

* "k_nick":
  If defined, it changes the output format of /report.	"(yournamehere):"
  at the start of the line get replaced with k_nick. Example: Your name is
  "kemiKal_sWeMoB", you set your k_nick to "-kK-".  Now, in Kombat Teams
  versions previous to 2.10 you would see: (kemiKal_sWeMoB): a:0  h:100  sg:25
  In version 2.10 or above however (if you got k_nick defined), it will read:
  -kK-	a:0  h:100  sg:25

* "k_flags":
  Add flagvalues together to customize your settings.  excample: type  "setinfo
  k_flags 3"  in console to enable teamsounds and
	    autoscreenshot (("k_sound" = 1 + "k_sshot" = 2) = 3).
  FLAGVALUES: ----------- 1 = "k_sound"    See "k_soundX" under "player commands
  explained" 2 = "k_sshot"    Automatically take screenshot scoreboard at
  the end of a game


KOMBAT TEAMS technical notes
----------------------------

*** MAXRATE AND MINRATE If this is set to anything above 0 then it checks
players on connect to see if their rate is either above or below the allowed
settings.  It also checks throughout game to see if anyone is trying to fool
kteam :)

This can be very useful at lans since you can set min and max to 10000 and
people cannot forget about changing their rate i.e modem players always
forget :)

*** OVERTIME If it is switched on then when game ends it will check the scores.
If they are equal it will add on the time specified in k_exttime.  If the game
is again a draw after that time has counted down it will add it on again etc..
Could be some long games heh.


*** KOMBAT TEAMS IN DUEL MODE :

If k_duel is set to 1, the server will not allow teamplay changes.  Meaning,
if you're running a 1-1 server - set k_duel to 1 and teamplay to 0.  Also,
/forcestart or the idle bot forcestart usually requiers you to join an existing
team while counting down, this is not the case in duel mode.


*** THE OPTIONAL MODIFIED DEATHMATCH 2 MODE :

Setting the flag "k_dm2mod" in the server.cfg to 1 removes all armor on the
map at matchstart if deathmatch mode 2 is chosen. The normal dmm2 is available
by setting the same serverflag to "0".


*** WHAT'S THE DIFFERENCE BETWEEN THE RESPAWN-TYPES? :

Kombat Teams respawns differs from the normal QW respawns (also available in
the patch) in that they spawn players on a spawnpoint even though someone else
is occupying it. There's exceptions to this rule however, a player that has
just spawned is considered a no spawn-target for 120 gameticks and a player
can never spawn on the same spot twice in a row (unless the map contains less
than 2 spawnpoints or all spawnpoints are full).  For the first 3 seconds of
a match, Kombat Teams respawns will attempt to avoid spawnfrags entirely (note
that this is only for the spawntype "Kombat Teams respawns").  To have yourself
spawned at what you consider to be a bad spawn before the match starts as not
to get there won't work, the patch doesn't take pregame spawns into account.
This type of respawns is by default enabled in KT since the patch's main
function is to handle teamgames and we don't want any camping on important
spots (like RA on dm4 for example).  With the release of version 2.07, "KT
SpawnSafety" was introduced.  KT SpawnSafety means to avoid telefrags during
games as much as possible (even if all spawnpoints are full) and tries to
avoid spawning you at the same spot twice in a row.


*** WHAT'S UP WITH THE LEVEL EXITS? :

KT removes all "level-exits" at the start of each match. You will be able
to walk through those teleporters without anything happening. Pre-game, you
can still change level by walking through them (if the server's "samelevel"
is set accordingly).


*** WHAT "report" REALLY REPORTS:

Best illustrated by example output, here's a couple:

(player): a:0  h:100  sg:25	  (no armor, 100 health and a shotgun with
25 shells) (player): ga:30  h:30  rl:5	     (30 worth of green armor, 30
health and rocket launcher
				  with 5 rockets)
(player): ra:200  h:250  rl:100  [-quad-]
				  (200 units of red armor, 250 health, a
				  rocket launcher with 100 rockets and the
				  player is quadpowered)

ARMOR TYPES: green (GA) yellow (YA) and red (RA) WEAPONS: (this is the
importancy order from lowest to highest)
	 axe (AXE) shotgun (SG) nailgun (NG) super shotgun (SSG) super nailgun
	 (SNG) grenade launcher (GL) lightning gun (LG) rocker launcher (RL)


*** WHAT'S WITH ALL THOSE "his glasses" AND "his death" TEXTS? :

Quake (and QW) uses male orientated messages that may or may not annoy you
depending on your gender. Since the legend tells that there are a few girls
and women out there gibbing with the rest of us, KT's got a function that
displays genderbased messages accordingly. Your gender is determined as MALE
by default but can be set to female by typing (in the console):
		      setinfo gender f
(alternatively, you can put that line in your autoexec.cfg).  Anything other
than an "f" is considered a MALE..


*** ABOUT TEAM-TELEFRAGS:

If you get telefragged by one of your teammates, s/he doesn't get any frags
for it but you get a death registred (not a -1 on frags but a +1 on deaths).


*** LOCKTYPES:

OFF  = no locking.  ALL  = lockout all players trying to enter if game is
in progress.  TEAM = lockout all players trying to enter during match if
their team is not set to
       one of the teams playing.

Serversettings that functions as locks of a sort, are: k_lockmin (minimum number
of teams in game) k_lockmax (maximum number of teams in game) k_membercount
(minimum number of players in each team) k_exclusive (if set, maxplayers is
locked on matchstart)


*** SERVER RESET:

On /reset, KT will execute the file "configs/reset.cfg" on the server.
The ZIPped package of Kombat Teams should contain this directory and file.
That file is to be considered as the server "defaults" and can be freely
reconfigured as the server admin see fits.  If the server allow admins, admins
may also execute special admin configs on the server, where the server keeps
settings for different leagues, gametypes etc.	This is done like this:
     1. become an admin by /admin and the correct sequence of impulses
     2. change /team to the name of the config you want to execute on the server
	(for example /team 1vs1, /team lock, /team dql etc.).
     3. now type /reset 4. if the server finds your config
     (configs/<yourteam>.cfg) the server will
	exectue it and out a message to the player(s) that the server is
	setup according to your desires. if you are in team "", KT will simply
	execute "configs/reset.cfg" instead.


*** ALIEN MAPS:

Since KT support maps that some people might not have on their hd it also
allows the serveradmin to set a defaultmap to which it will change to when the
last player on the server logs out.  In older versions of KT players could
log off during mapchange which could leave the server empty on an unwanted
map; KT now checks a minute after mapchange if the server is empty or not -
if it is, KT switches back to k_defmap.  Alternatively ofcourse, the admin
(you) can allow map downloading.  The localinfo value to set defaultmap is
called "k_defmap". If "k_defmap" is not set - KT won't try to change to the
default map.


*** THE IDLE BOT:

This is a mean fellow.	If activated (by setting k_idletime above 0) he will
wait for at least 50% of the players on the server to go ready, after that he
will nag on the others to go ready every 5 seconds thereafter (and seconds
4, 3, 2 and 1).  After "k_idletime" seconds have passed (since 50% of the
players got ready) the idlebot will kick all players that have failed to go
ready and start normal countdown if more than 2 players remain on the server.
It is only recommended that you use the idlebot for public servers that are
1vs1 or 2vs2 oriented.	Don't annoy your guests ;D


*** /PICKUP:

A simple function. If a majority (> 50%) of the players vote for "pickup",
KT will set all the players skins to "base", their color to 0 (white) and
their team to "" (nothing).  If an admin types this command the everyone is
automatically set to the above.


*** PROXIES AND IMPULSES:

Kombat Teams uses all impulses between 1 and 100, above 100 custom maps are
placed. So if you're using "best weapon" impulses with your proxy, make sure
that you use an impulse between 1 and 7 or as high as possible for proper
operation.


Special thanks to the people who have suffered the most:
--------------------------------------------------------
			   McCoy Bannor Tomppa Zoid Strider

Thank you!
----------
The co-authors: Cenobite, Sturm and Fang
All members of TSL,
JeePster, oKKun, HonK, Leon (Godfather of SweMob), FuN: Agorn - Awful Swede -
Haywire - Zevlion - Kurgan, Axu, Perkele, Adze, HellsAngel, Paralyzer, Yyrkoon,
Descenman, Heksen, CrazyMac, Rodan, oWl, Garfield, sLoP, Sister Death, Sandman,
Blom, Paul Chambers, Thoth, Postman Phat, Zarjazz, Acquiesce, Nator, Spin,
Zibbo, Frick, CiC, Caustic, Rob J, Amok, Jezaja, X-Man, TC-Dade, Deeper,
Lion, Jimbob.

If you know that you've made a contribution and you do not appear in the
above list, e-mail me and I'll remedy the situation.

Also a big "thank you" to all you people using the patch as players and/or
admins; this modification has depended on your input and will continue to do so.


enjoy,

Ceno (cenobite@barrysworld.com)
sturm (silicon@inf.bme.hu)