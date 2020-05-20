class disk : HWUsable
{
	// Prints a message on pickup. Message defined in the map.
	string user_message;

	default
	{
		// This should come back after a bit.
		//+Inventory.ALWAYSRESPAWN;
		Alpha 1; // needed for fade-in
		+WALLSPRITE;
		+FLOATBOB;
		+SHOOTABLE; // FIX YOUR SHIT GRAF
		scale 0.5;
		Radius 32;
		Height 64;
		//Inventory.RespawnTics 140;
		//Inventory.PickupMessage "Found a disk.";
		//Inventory.PickupSound "disk/pickup";
	}

	override bool Used(Actor user)
	{
		user.A_Print(""..user_message,5);
		A_PlaySound("disk/pickup");
		threshold = 35;
		SetState(ResolveState("Spin"));
		return true;
	}

	override void Tick()
	{
		super.Tick();
		angle += 1;
	}

	States
	{
		Spawn:
			DISK A 0;
			DISK A 16;
			DISK BC 4;
			DISK D 2;
			Loop;
		Spin:
			DISK AAABBCCD 1 
			{ 
				angle += 7; 
				if(threshold<1)
				{ return ResolveState("Spawn"); }
				else
				{	threshold -= 1; return ResolveState(null); }
			}
			Loop;
		Death:
			DISK ABCD 1 A_FadeOut();
			Loop;
	}
}

class diskfadeFX : Actor
{
	// Fades out slowly.
	default
	{
		+WALLSPRITE;
		+FLOATBOB;
		scale 0.5;
		Alpha 1;
	}

	override void Tick()
	{
		super.Tick();
		angle += 8;
	}

	States
	{
		Spawn:
			DISK ABCD 1;
		Death:
			DISK ABCD 1 A_FadeOut(0.025);
			Loop;
	}
}