class HellwavePlayer : PlayerPawn
{
	// Invulnerable, but spawns a Heart when he spawns in.
	// When the Heart dies, you die.

	bool HeartFollow;
	bool FoundUsable;
	string UsableName;
	string UsableVerb;
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
		Vector3 newpos = Vec3Angle(32.0, angle);

		let nheart = Heart(spawn("Heart",newpos));
		nheart.owner = self;
		heart = nheart;
		
		// Spawns a new heart.
	}

	bool CheckForUsables()
	{
		bool FoundUsable = false;
		/*let search = BlockThingsIterator.Create(self,64);
		while(search.next())
		{
			if(search.Thing is "HWUsable")
			{
				//target = search.Thing;
				//console.printf("angle: "..CheckIfTargetInLOS(40));
				//if(AngleTo(search.Thing)>=-30 && AngleTo(search.Thing)<=30)
				//{
					FoundUsable = true;
				//}
			}
		}*/
		FLineTraceData search;
		bool hit = linetrace(angle, 64, pitch, TRF_ALLACTORS, 32, data: search);
		if(search.HitActor is "HWUsable") 
		{ 
			FoundUsable = true; 
			let thing = HWUsable(search.HitActor);
			UsableName = thing.GetTag("object");
			UsableVerb = thing.verb;
		}
		return FoundUsable;
	}

	override void PostBeginPlay()
	{
		//HeartSpawn();	
		HeartFollow = true;
		super.PostBeginPlay();
	}

	override void Tick()
	{
		FoundUsable = CheckForUsables();
		// Set a variable here that the heart can check to see if it needs to follow.
		int buttons = GetPlayerInput(INPUT_BUTTONS);
		int oldbuttons = GetPlayerInput(INPUT_OLDBUTTONS);
		bool zoom = buttons & BT_ZOOM && !(oldbuttons & BT_ZOOM);
		bool run = buttons & BT_SPEED;
		
		if(zoom)
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

		if(run)
		{
			//TODO: Make heart warp to front of player.
			heart.Warp(self,16, flags: WARPF_WARPINTERPOLATION);
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

