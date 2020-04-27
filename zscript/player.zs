class HellwavePlayer : PlayerPawn
{
	// Invulnerable, but spawns a Heart when he spawns in.
	// When the Heart dies, you die.

	bool HeartFollow;

	default
	{
		Player.DisplayName "Unfortunate Soul";
		+Invulnerable;
		+THRUSPECIES;
		Player.StartItem "crystalgun";
	}

	override void PostBeginPlay()
	{
		Vector3 newpos = Vec3Angle(32.0, angle);
		let heart = Heart(spawn("Heart",newpos));
		heart.owner = self;
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
		super.Tick();
	}
}