class twanger : actor replaces DoomImp
{
	// Malicious flying caution symbol.
	default
	{
		health 40;
		MONSTER;
		+float;
		speed 5;
	}

	states
	{
		spawn:
			twng a 2 A_Look();
			loop;
		see:
			twng a 2 A_Chase();
			loop;
		missile:
			twng b 4 A_SpawnProjectile("twangerMissile");
			twng cd 4;
			goto see;
		pain:
			twng cb 6;
			goto see;
		death:
			twng d 4 A_Scream();
			twng cba 4 A_Fall();
		fadeloop:
			twng c 1 A_FadeOut();
			loop;

	}

}

class twangerMissile : actor
{
	// Twangers fire spinny triangle beams.

	default
	{
		+MISSILE;
		+NOGRAVITY;
		speed 20;
		damage (10);
	}

	states
	{
		Spawn:
			twnp abcd 3;
			loop;
		Death:
			twnp efea 4;
			tnt1 a 0;
			stop;
	}

}