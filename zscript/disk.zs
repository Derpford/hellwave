class disk : CustomInventory
{
	// Prints a message on pickup. Message defined in the map.
	string user_message;

	default
	{
		// This should come back after a bit.
		+Inventory.ALWAYSRESPAWN;
		Alpha 0; // needed for fade-in
		+WALLSPRITE;
		+FLOATBOB;
		scale 0.5;
		Inventory.PickupMessage "Found a disk.";
	}

	override void Tick()
	{
		super.Tick();
		angle += 1;
	}

	States
	{
		Spawn:
			DISK A 1 
			{
				A_FadeIn();
				if(alpha >= 1.0)
				{
					return ResolveState("Spin");
				}
				return ResolveState(null);
			}
			Loop;
		Spin:
			DISK A 16;
			DISK BC 4;
			DISK D 2;
			Loop;
		Pickup:
			DISK A 0 A_Print(""..invoker.user_message);
			Stop;
		Death:
			DISK BCD 3 A_FadeOut();
			Loop;
	}
}