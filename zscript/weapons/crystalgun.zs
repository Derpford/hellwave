class crystalgun : weapon
{
	default
	{
		Weapon.AmmoUse 0;
		Weapon.SlotNumber 2;
	}

	States
	{
		Spawn:
			TNT1 A 0; // Given to player at start of game.
			Loop;
		Ready:
			CRYS A 1 A_WeaponReady();
			Loop;
		Select:
			CRYS C 4 A_Raise(24);
			CRYS B 4 A_Raise(24);
			CRYS A 4 A_Raise(24);
			Loop;
		Deselect:
			CRYS ABC 4 A_Lower(24);
			Loop;
		Fire:
			CRYS C 0 
			{
				A_FireProjectile("crystalshot");
				A_PlaySound("crystal/shot");
			}
			CRYS CC 1 A_WeaponOffset(0,12,WOF_ADD);
			CRYS C 6;
			CRYS BBBBBBAAAAAA 1 A_WeaponOffset(0,-2,WOF_ADD);
			Goto Ready;
	}
}

class crystalshot : actor
{
	default
	{
		PROJECTILE;
		+ROLLSPRITE;
		+MTHRUSPECIES;
		renderstyle "add";
		damagefunction 20;
		//scale 2;
		speed 35;
	}

	States
	{
		spawn:
			CRYP A 1 Bright
			{
				roll += 16;
				Actor fx = spawn("crystalfx", pos);
				fx.roll = roll;
			}
			Loop;
		Death:
			CRYP A 1 Bright A_FadeOut();
			Loop;
	}
}

class crystalfx : actor
{
	default
	{
		+NOINTERACTION;
		+ROLLSPRITE;
		renderstyle "add";
	}

	States
	{
		spawn:
			CRYP A 1 Bright A_FadeOut();
			Loop;
	}
}