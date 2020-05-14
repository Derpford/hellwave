class snakehead : actor
{
	// Snake boss. Spawns a tail behind it. Treasure AF.
	Actor tail;
	int DodgeTimer;
	int MissileTimer;

	default
	{
		+SHOOTABLE;
		+SOLID;
		+THRUSPECIES;
		Species "Snake";
		+FLOATBOB;
		FloatBobStrength 0.4;
		+FLOAT;
		+NOGRAVITY;
		+SPAWNFLOAT;
		+FRIGHTENED;
		speed 12;
		health 100;
		radius 12;
		height 32;
		MinMissileChance 300;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		tail = spawn("snakebody",pos);
		let next = snakebody(tail);
		next.Attach(self, 8);
		DodgeTimer = random(35,70);
	}

	override void tick()
	{
		super.tick();
		DodgeTimer -= 1;
		MissileTimer -= 1;
		if(DodgeTimer<1)
		{
			if(Vec3To(target).length()>512)
			{
				bFRIGHTENED = false;
			}
			else if(Vec3To(target).length()<256)
			{
				bFRIGHTENED = true;
			}
			DodgeTimer = random(35,70);
		}
		else
		{

		}
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
		Missile:
			HART A 0
			{
				if(MissileTimer>1) { return ResolveState("see"); }
				else { return ResolveState(null); }
			}
			HART AABBCC 1 A_Chase(flags: CHF_FASTCHASE);
			HART C 1 
			{
				if(tail!=null)
				{
					let next = SnakeBody(tail);
					next.WaveAttack();
				}
				A_Chase(flags: CHF_FASTCHASE);
				MissileTimer = random(35,70);
				
			}
			Goto See;
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

	void WaveAttack()
	{
		// Sets state to WaveAttack, then sets FloatBobStrength to 1.
		// WaveAttack state handles firing projectile and cascading to the next one.
		if(health > 0)
		{
			FloatBobStrength = 1.0;
			SetState(ResolveState("WaveAttack"));
		}
	}

	override void Tick()
	{
		Super.Tick();	

		// Slowly reduce FloatBobStrength back to 0.5.
		if(FloatBobStrength > 0.5)
		{
			FloatBobStrength = max(FloatBobStrength-0.1, 0.5);
		}

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
		else
		{
			// No head.
			A_Die("final");
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
		WaveAttack:
			HART BC 3;
			HART C 1 
			{
				target = owner;
				A_FaceTarget();
				A_SpawnProjectile("SnakeShot",0,-32,90,CMF_AIMDIRECTION,20);
				A_SpawnProjectile("SnakeShot",0,32,-90,CMF_AIMDIRECTION,20);
			}
			HART A 1
			{
				if(tail!=null)
				{
					let next = SnakeBody(tail);
					next.WaveAttack();
				}
			}
			Goto Spawn;
		Death:
			HART BCDE 1;
			HART E 0
			{
				if(tail!=null) // We don't need to check if the tail is the head, that's silly.
				{
					let next = snakebody(tail);
					next.owner = self.owner; // Our tail now points to its new owner...
				}
				if(owner is "snakehead")
				{
					let head = snakehead(owner);
					if(head!=null) { head.tail = tail; } // If the head is our owner, it points to the next tail section.
				}
				else if(owner is "snakebody")
				{
					let head = snakebody(owner);
					if(head!=null) { head.tail = tail; } // And if the owner is another tail segment, it's updated now.
				}
				
			}
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

class SnakeShot : Actor
{
	// Spinny zappy sprite.
	default
	{
		+ROLLSPRITE;
		Height 32;
		Radius 8;
		Speed 10;
		Projectile;
		DamageFunction (30);
	}

	Override void Tick()
	{
		Super.Tick();
		roll += 16;
	}

	states
	{
		Spawn:
			SNSH A 1;
			Loop;
		Death:
			SNSH A 1 A_FadeOut();
			Loop;
	}
}
