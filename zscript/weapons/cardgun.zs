class CardUIHandler : EventHandler
{
	override void RenderOverlay(RenderEvent e)
	{
		PlayerInfo plr = players[consoleplayer];
		let card = CardGun(plr.readyweapon);
		if(card != null)
		{
			int debt = card.heat;
			int max = card.maxheat;
			string cash = String.Format("Debt: -%d/%d",debt,max);
			Screen.DrawText("BIGFONT",0,400,800,cash);
		}
	}
}

class CardGun : Weapon
{
	// Shoots moneysplosions. Don't overdraft it.
	float weproll;
	int heat;
	int maxheat;
	property Heat: maxheat;
	default
	{
		+ROLLSPRITE; // hacky bullshit lol
		+WALLSPRITE;
		+NOGRAVITY; // necessary for spawn height because of how roll+spin works
		Weapon.SlotNumber 3;
		CardGun.Heat 250;
	}

	override void Tick()
	{
		Super.Tick();
		weproll = (weproll + 8.0)%360;
		A_SetRoll(weproll);
		if(heat>0){ heat -= 1; }

	}

	/*override void RenderOverlay(RenderEvent e)
	{
		string cash = StringFormat("Debt: -%d/500");
		Screen.DrawText("BIGFONT",0,400,800,num);
	}*/

	States
	{
		Spawn:
			CARF A 1 { angle += 8; }
			Loop;
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
			{
				//TODO: Overheat mechanic.
				if(invoker.heat>invoker.maxheat)
				{
					return resolvestate("Ready");
				}
				else
				{
					invoker.heat += 35;
					return resolvestate(null);
				}
			}
			CARD A 0
			{ A_FireProjectile("CardShot"); A_WeaponOffset(0,12,WOF_ADD); }
			CARD AAAAAAAAAAAA 1 A_WeaponOffset(0,-1,WOF_ADD);
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
		RenderStyle "add";
	}

	states
	{
		Spawn:
			DOLL ABCD 2 bright { angle += 12; A_SpawnItemEX("CardTrail"); }
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
			DOLL ABCD 1 A_Explode(15,64);
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


