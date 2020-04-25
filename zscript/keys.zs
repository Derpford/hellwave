Class BlueIconKey : Key
{
	// Blue key object.
	default
	{
		Inventory.PickupMessage "Found a blue symbol...";
		Species "BlueCard";
		Inventory.Icon "LITEBLUE1";
		Inventory.PickupSound "disk/pickup";
	}

	States
	{
		Spawn:
			BKEY A 16;
			BKEY B 4;
	}
}