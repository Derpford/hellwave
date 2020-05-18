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
		Vector3 newpos = Vec3Angle(32.0, angle);

		let nheart = Heart(spawn("Heart",newpos));
		nheart.owner = self;
		heart = nheart;
		
		// Spawns a new heart.
	}

	void CheckForUsables()
	{
		bool found = false;
		let search = BlockThingsIterator.Create(self,64);
		let toucher = search.next();
		while(!found)
		{
			if(toucher is "HWUsable")
			{
				found = true;
				KeyBindings kb;
				int k1, k2 = kb.GetKeysForCommand("+use");
				string usekey = kb.NameKeys(k1,k2);
				int x = Screen.GetWidth()/2;
				int y = Screen.GetHeight()/2;
				Screen.DrawText("SMALLFNT",0,x,y,"Press USE");
			}
			toucher = search.next();
		}
	}

	override void PostBeginPlay()
	{
		//HeartSpawn();	
		super.PostBeginPlay();
	}

	override void Tick()
	{
		CheckForUsables();
		// Set a variable here that the heart can check to see if it needs to follow.
		int buttons = GetPlayerInput(INPUT_BUTTONS);
		int oldbuttons = GetPlayerInput(INPUT_OLDBUTTONS);
		if(buttons & BT_ZOOM && !oldbuttons & BT_ZOOM)
		{
			if(HeartFollow)
			{
				HeartFollow = false;
			}
			else
			{
				HeartFollow = true;
			}
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