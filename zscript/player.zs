class HellwavePlayer : PlayerPawn
{
	// Invulnerable, but spawns a Heart when he spawns in.
	// When the Heart dies, you die.

	bool HeartFollow;
	Actor heart;

	default
	{
		Player.DisplayName "Unfortunate Soul";
		+Invulnerable;
		+THRUSPECIES;
		+FloatBob;
		FloatBobStrength 0.25;
		Player.StartItem "crystalgun";
	}

	void HeartSpawn()
	{
		//TODO: Move all heart handling to an event handler.
		ThinkerIterator ht = ThinkerIterator.Create("Heart", STAT_DEFAULT);
		Actor nheart;
		bool found = false;
		bool end = false;
		/*while(!found & !end)
		{
			let nheart = Heart(ht.next());
			if(nheart != null)
			{
				if(nheart.owner == self)
				{
					found = true;
					break;
				}
			}
			else
			{
				end = true;
			}
		}
		*/
		Vector3 newpos = Vec3Angle(32.0, angle);

		if(found == true)
		{
			nheart.setXYZ(newpos);
		}
		else
		{
			let nheart = Heart(spawn("Heart",newpos));
			nheart.owner = self;
			heart = nheart;
		}
		// Spawns a new heart.
	}

	override void PostBeginPlay()
	{
		//HeartSpawn();	
		super.PostBeginPlay();
	}

	override void Tick()
	{
		// Set a variable here that the heart can check to see if it needs to follow.
		int buttons = GetPlayerInput(INPUT_BUTTONS);
		if(buttons & BT_SPEED)
		{
			// Holding walk or run makes the heart stop.
			HeartFollow = false;
		}
		else
		{
			HeartFollow = true;
		}

		if(heart == null)
		{
			// We need a new heart! 
			//HeartSpawn();
		}
		super.Tick();
	}
	
	states
	{
		Spawn:
			PLYR A 35;
			PLYR BCB 12;
			Loop;
		Death:
			HART BCDE 1;
			Stop;
	}
}