
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;
void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage;
void(float skip_log) EndMatch;

/*SERVER
void() monster_death_use;
*/

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == 7)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), 1, self);
		if (trace_fraction == 1)
			return 1;
		if (trace_ent == targ)
			return 1;
		return 0;
	}

	traceline(inflictor.origin, targ.origin, 1, self);
	if (trace_fraction == 1)
		return 1;
	traceline(inflictor.origin, targ.origin + '15 15 0', 1, self);
	if (trace_fraction == 1)
		return 1;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', 1, self);
	if (trace_fraction == 1)
		return 1;
	traceline(inflictor.origin, targ.origin + '-15 15 0', 1, self);
	if (trace_fraction == 1)
		return 1;
	traceline(inflictor.origin, targ.origin + '15 -15 0', 1, self);
	if (trace_fraction == 1)
		return 1;

	return 0;
};


/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;

// TEAM -->
	if (self.classname == "player")
                self.dead_time = time;
// <-- TEAM

	if (self.health < -99)
		self.health = -99;              // don't let sbar look bad if a player

	if (self.movetype == 7 || self.movetype == 0)
	{       // doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;

// bump the monster counter
	if (self.flags & 32)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (2, 27);
	}

	ClientObituary(self, attacker);

	self.takedamage = 0;
	self.touch = SUB_Null;
	self.effects = 0;

/*SERVER
	monster_death_use();
*/
	self.th_die ();

	self = oself;
};


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local   vector  dir;
	local   entity  oldself;
	local   float   save;
	local   float   take;
	local   string  s;
	local   string  attackerteam, targteam;


	if (!targ.takedamage)
		return;

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time && inflictor.classname != "door")
		if (deathmatch == 4)
			damage = damage * 8;
		else
        		damage = damage * 4;

// save damage based on the target's armor level

	save = ceil(targ.armortype*damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;     // lost all armor
		targ.items = targ.items - (targ.items & (8192 | 16384 | 32768));
	}

	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & 8)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	damage_inflictor = inflictor;

// figure momentum add
	if ( (inflictor != world) && (targ.movetype == 3) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		// Set kickback for smaller weapons
//Zoid -- use normal NQ kickback
//		// Read: only if it's not yourself doing the damage
//		if ( (damage < 60) & ((attacker.classname == "player") & (targ.classname == "player")) & ( attacker.netname != targ.netname))
//			targ.velocity = targ.velocity + dir * damage * 11;
//		else
		// Otherwise, these rules apply to rockets and grenades
		// for blast velocity
			targ.velocity = targ.velocity + dir * damage * 8;

		// Rocket Jump modifiers
		if ( (rj > 1) & ((attacker.classname == "player") & (targ.classname == "player")) & ( attacker.netname == targ.netname))
			targ.velocity = targ.velocity + dir * damage * rj;
	}

// check for godmode or invincibility
	if (targ.flags & 64)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, 3, "items/protect3.wav", 1, 1);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
//ZOID 12-13-96: self.team doesn't work in QW.  Use keys
	attackerteam = infokey(attacker, "team");
	targteam = infokey(targ, "team");

	if ((teamplay == 1) && (targteam == attackerteam) &&
		(attacker.classname == "player") && (attackerteam != "") &&
		inflictor.classname !="door")
		return;
	if ((teamplay == 3) && (targteam == attackerteam) &&
		(attacker.classname == "player") && (attackerteam != "") &&
		(targ != attacker)&& inflictor.classname !="door")
		return;

// do the damage
        if (match_in_progress == 2 || attacker.classname == "teledeath") // TEAM
        	targ.health = targ.health - take;

	if (targ.health <= 0)
	{
		Killed (targ, attacker);
// check if sudden death is the case
		if(k_sudden_death && targ.classname == "player" ) EndMatch(0);
		return;
	}

// react to the damage
	oldself = self;
	self = targ;

/*SERVER
	if ( (self.flags & 32) && attacker != world)
	{
	// get mad unless of the same class (except for soldiers)
		if (self != attacker && attacker != self.enemy)
		{
			if ( (self.classname != attacker.classname)
			|| (self.classname == "monster_army" ) )
			{
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;
				self.enemy = attacker;
				FoundTarget ();
			}
		}
	}
*/
	if (self.th_pain)
	{
		self.th_pain (attacker, take);
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage =
{
	local   float   points;
	local   entity  head;
	local   vector  org;

	head = findradius(inflictor.origin, damage+40);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{
                                                head.deathtype = dtype;
						T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/*
============
T_BeamDamage
============
*/
void(entity attacker, float damage) T_BeamDamage =
{
	local   float   points;
	local   entity  head;

	head = findradius(attacker.origin, damage+40);

	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};
