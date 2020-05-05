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
		Player.StartItem "crystalgun";
	}

	void HeartSpawn()
	{
		// TODO: Make a thinker-iterator here to see if there's any Heart that currently has us as its Owner.
		Vector3 newpos = Vec3Angle(32.0, angle);
		let nheart = Heart(spawn("Heart",newpos));
		nheart.owner = self;
		heart = nheart;
		// Spawns a new heart.
	}

	override void PostBeginPlay()
	{
		HeartSpawn();	
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
			HeartSpawn();
		}
		super.Tick();
	}
}