class snakehead : actor
{
	// Snake boss. Spawns a tail behind it. Treasure AF.
	Actor tail;

	default
	{
		+SHOOTABLE;
		+SOLID;
		+THRUSPECIES;
		Species "Snake";
		+FLOATBOB;
		FloatBobStrength 0.5;
		+FLOAT;
		+NOGRAVITY;
		+SPAWNFLOAT;
		+FRIGHTENED;
		speed 15;
		health 100;
		radius 12;
		height 32;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		tail = spawn("snakebody",pos);
		let next = snakebody(tail);
		next.Attach(self, 8);
	}

	states
	{
		Spawn:
			HART B 1 A_Look();
			Loop;
		See:
			HART B 1 A_Chase(flags: CHF_FASTCHASE);
			Loop;
		Pain:
			HART ABC 1;
			Goto Spawn;
		Death:
			HART BCDE 1;
			HART E 0
			{
				tail.A_Die("final");
			}
			Stop;

	}
}

class snakebody : actor
{
	// Transfers damage up the chain.
	Actor owner;
	Actor tail;

	default
	{
		+SHOOTABLE;
		+SOLID;
		+THRUSPECIES;
		Species "Snake";
		+FLOATBOB;
		FloatBobStrength 0.5;
		+FLOAT;
		+NOGRAVITY;
		+SPAWNFLOAT;
		Health 100;
		radius 12;
		height 32;
	}

	void Attach(Actor head, int length)
	{
		if(length>0)
		{
			owner = head;
			if(length>1) 
			{ 
				tail = spawn("snakebody",pos);
				let next = snakebody(tail);
				next.Attach(self,length-1); 
			}
		}
	}

	override void Tick()
	{
		Super.Tick();	

		Vector3 mov = (0,0,0);
		Vector3 goal = pos;
		if(owner != null)
		{
			if(Distance3D(owner) > 16)
			{
				// Follow the snek!
				
				goal = Vec3To(owner);
			}
			
			Vector2 goal2d = (goal.x,goal.y);

			if(goal.length() != 0) // div by zero checks~!
			{
				mov = (goal.x/goal.length(), goal.y/goal.length(), goal.z/goal.length());
			}

			if(goal.length()>32)
			{
				vel = goal/2;
			}
			vel = vel/2;
		}
	}

	states
	{
		Spawn:
			HART A 1;
			Loop;
		Pain:
			HART BC 1;
			Goto Spawn;
		Death:
			HART BCDE 1;
			Stop;
		Death.final:
			HART BCDE 1;
			HART E 0
			{
				if(tail!=null) { tail.A_Die("final"); }
			}
			stop;
	}
}
