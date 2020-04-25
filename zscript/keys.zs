Class IconKey : Key
{
	// Spinny.
	default
	{
		Inventory.PickupSound "disk/pickup";
		+WALLSPRITE;
		+FLOATBOB;
	}

	override void Tick()
	{
		super.tick();
		angle += 1;
	}
}

Class BlueIconKey : IconKey
{
	// Blue key object.
	default
	{
		Inventory.PickupMessage "Found a blue symbol...";
		Species "BlueCard";
		Inventory.Icon "bicoa0";
	}

	States
	{
		Spawn:
			BKEY A 16;
			BKEY B 4;
	}
}

Class RedIconKey : IconKey
{
	// Red key object.
	default
	{
		Inventory.PickupMessage "Found a Red symbol...";
		Species "RedCard";
		Inventory.Icon "ricoa0";
	}

	States
	{
		Spawn:
			RKEY A 16;
			RKEY B 4;
	}
}