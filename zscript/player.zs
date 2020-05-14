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
		let nheart = Heart(spawn("Heart",newpos));
		nheart.owner = self;
		heart = nheart;
		
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