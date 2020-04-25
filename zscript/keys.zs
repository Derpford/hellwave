Class BlueIconKey : Key
{
	// Blue key object.
	default
	{
		Inventory.PickupMessage "Found a blue symbol...";
		Species "BlueCard";
		Inventory.Icon "bicoa0";
		Inventory.PickupSound "disk/pickup";
	}

	States
	{
		Spawn:
			BKEY A 16;
			BKEY B 4;
	}
}

Class RedIconKey : Key
{
	// Red key object.
	default
	{
		Inventory.PickupMessage "Found a Red symbol...";
		Species "RedCard";
		Inventory.Icon "ricoa0";
		Inventory.PickupSound "disk/pickup";
	}

	States
	{
		Spawn:
			RKEY A 16;
			RKEY B 4;
	}
}