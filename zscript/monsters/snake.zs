class snakehead : actor
{
	// Snake boss. Spawns a tail behind it. Treasure AF.
	default
	{
		+SHOOTABLE;
		+SOLID;
		+THRUSPECIES;
		+FLOATBOB;
		FloatBobStrength 0.5;
		+FLOAT;
		+NOGRAVITY;
		+SPAWNFLOAT;
		speed 10;
	}

	override void PostBeginPlay()
	{
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

	}
}

class snakebody : snakehead
{
	// Transfers damage up the chain.
	Actor owner;
	Actor tail;

	void Attach(Actor head, int length)
	{
		if(length>0)
		{
			owner = head;
			tail = spawn("snakebody",pos);
			let next = snakebody(tail);
			if(length>1) { next.Attach(self,length-1); }
		}
	}

	override void Tick()
	{
		
		if(Distance3D(owner) > 64)
		{
			// Follow the snek!
			
			Vector3 mov = (0,0,0);
			Vector3 goal = Vec3To(owner);
			Vector2 goal2d = (goal.x,goal.y);

			if(goal.length() != 0) // div by zero checks~!
			{
				mov = (goal.x/goal.length(), goal.y/goal.length(), goal.z/goal.length());
			}

			if(goal.length()>72)
			{
				if(vel.length()<12)
				{ 
					vel += mov*4;
				}
				else if(vel.length()<6) // We can't see the player, so use a lower top speed.
				{ 
					vel += mov*4;
				}
				vel = vel*0.9;
			}
			else
			{
				vel = vel/2;
			}
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
		/*Death:
			HART BCDE 1;
			Stop;*/
	}
}
