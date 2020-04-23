class Heart : Actor
{
	
	// Keep it safe.
	Actor owner;
	int regentimer;

	default
	{
		+SHOOTABLE;
		+SOLID;
		//+THRUACTORS;
		species "HellwavePlayer";
		height 64;
		radius 12;

		health 100;
		+FLOATBOB;
		FloatBobStrength 0.25;
		painchance 256;
	}

	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		// Set our regen timer.
		regentimer = 0;
	}

	override int DamageMobj(Actor inflictor, Actor src, int damage, Name mod, int flags, double angle)
	{
		console.printf(""..inflictor.GetClassName());
		if(inflictor == owner)
		{ return 0; }// Can't damage yourself anymore.

		regentimer = 70; // Two seconds must pass before you can start regenerating.
		return super.DamageMobj(inflictor,src,damage,mod,flags,angle);
	}

	override void Tick()
	{
		// Chase the player.
		let plr = HellwavePlayer(owner);
		if(Distance3D(owner) > 64 && plr.HeartFollow)
		{
			// Follow the player!
			
			vector3 mov = (0,0,0);
			Vector3 goal = Vec3To(owner);
			if(goal.length() != 0) // div by zero checks~!
			{
				mov = (goal.x/goal.length(), goal.y/goal.length(), goal.z/goal.length());
			}
			if(goal.length()>72)
			{
				vel = mov*8;
			}
			else
			{
				vel = vel/2;
			}
		}

		// Draw the health bar.
		double face = AngleTo(owner);
		for(int i = 0; i<100; i++)
		{
			if(i<5 || i>94)
			{
				A_SpawnParticle("682da7",SPF_FULLBRIGHT|SPF_RELPOS,1,1,face+i-50,8,0,32);
			}
			else if(health>i)
			{
				A_SpawnParticle("b99bd0",SPF_FULLBRIGHT|SPF_RELPOS,1,1,face+i-50,8,0,32);
			}
		}

		if(regentimer < 1 && health < 100)
		{
			health += 1;
		}
		else
		{
			regentimer -= 1;
		}

		super.Tick();
	}

	states
	{
		spawn:
			HART A random(30,35) bright;
			HART B 4 bright;
			HART C 3 bright;
			HART B 4 bright;
			Loop;
		pain:
			HART B 2 bright { owner.A_Pain(); }
			HART C 1 bright;
			HART B 2 bright;
			HART A random(12,16) bright;
			goto spawn;
		death:
			HART A 16 bright
			{
				owner.bInvulnerable = false;
				owner.DamageMobj(self,self,999,"None",DMG_FORCED);
			}
			HART B 4 bright;
			HART D 5 bright;
			HART E 6 bright;
			TNT1 A 1;

			stop;

	}
}