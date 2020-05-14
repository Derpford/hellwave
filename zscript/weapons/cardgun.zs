class CardGun : Weapon
{
	// Shoots moneysplosions. Don't overdraft it.
	float weproll;
	default
	{
		+ROLLSPRITE; // hacky bullshit lol
	}

	override void Tick()
	{
		Super.Tick();
		weproll = (weproll + 8.0)%360;
		A_SetRoll(weproll);
	}

	States
	{
		Select:
			CARD A 1 A_Raise();
			Loop;
		Deselect:
			CARD A 1 A_Lower();
			Loop;
		Ready:
			CARD A 1 A_WeaponReady();
			Loop;
		Fire:
			CARD A 0
			{ A_FireProjectile("CardShot"); }
			CARD A 12;
			Goto Ready;
	}
}

class CardShot : Actor
{
	// Big dollar sign that splits into little dollar signs.
	default
	{
		Projectile;
		speed 10;
		radius 6;
		height 24;
		+WALLSPRITE;
		+MTHRUSPECIES;
		Scale 2;
	}

	states
	{
		Spawn:
			DOLL ABCD 2 { angle += 12; }
			Loop;
		Death:
			DOLL A 0
			{
				A_FaceTarget();
				for(int i = 0; i<4; i++)
				{
					A_SpawnProjectile("CardFrag",0,0,45+90*i,CMF_AIMDIRECTION);
				}
			}
			DOLL ABCD 1; 
			Stop;
	}
}

class CardFrag : Actor
{
	// Smol dollar sign that shoots off.
	default
	{
		+WALLSPRITE;
		+NOINTERACTION;
		Speed 0;
		ReactionTime 6;
		RenderStyle "add";
	}

	states
	{
		Spawn:
			DOLL ABCD 3
			{
				A_SpawnItemEX("CardTrail");	
				angle += 40;
				Thrust(4,angle);
				A_Explode(5,128);
				A_Countdown();
			}
			Loop;
		Death:
			TNT1 A 0;
			Stop;
	}
}

class CardTrail : Actor
{
	// Trail for the dollar sign.
	default
	{
		+WALLSPRITE;
		+NOINTERACTION;
		ReactionTime 8;
		RenderStyle "add";
	}

	states
	{
		Spawn:
			DOLL ABCD 1 A_CountDown();
			Loop;
	}
}


