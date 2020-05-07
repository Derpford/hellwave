class snakehead : actor
{
	// Snake boss. Spawns a tail behind it. Treasure AF.
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
		speed 20;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		let tail = snakebody(spawn("snakebody",pos));
		tail.Attach(self, 8);
	}

	states
	{
		Spawn:
			HART B 1 A_Look();
			Loop;
		See:
			HART B 1 A_Chase();
		Pain:
			HART ABC 1;
			Goto Spawn;
		Death:
			HART BCDE 1;
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
			if(Distance3D(owner) > 64)
			{
				// Follow the snek!
				
				goal = Vec3To(owner);
			}
			
			Vector2 goal2d = (goal.x,goal.y);

			if(goal.length() != 0) // div by zero checks~!
			{
				mov = (goal.x/goal.length(), goal.y/goal.length(), goal.z/goal.length());
			}

			if(goal.length()>72)
			{
				vel = goal/8;
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
	}
}
