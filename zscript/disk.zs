class disk : Inventory
{
	// Prints a message on pickup based on its arg0string.

	default
	{
		// This should come back after a bit.
		+Inventory.ALWAYSRESPAWN;
		Alpha 0; // needed for fade-in
		+WALLSPRITE;
		+FLOATBOB;
	}

	override void Tick()
	{
		super.Tick();
		if(instatesequence(curstate,ResolveState("Spin")))
		{
			angle += 1;
		}
	}

	States
	{
		Spawn:
			DISK A 1 
			{
				A_FadeIn();
				if(alpha == 1.0)
				{
					return ResolveState("Spin");
				}
				return ResolveState(null);
			}
			Loop;
		Spin:
			DISK A 6;
			DISK BC 3;
			DISK D 2;
			Loop;
		Death:
			DISK BCD 3 A_FadeOut();
			Loop;
	}
}