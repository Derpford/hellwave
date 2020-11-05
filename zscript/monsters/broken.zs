class Broken : actor
{
	// A broken jpeg left to stew in its own madness.
	default
	{
		health 32;
		MONSTER;
		height 48;
		radius 16;
		+float;
		+flatsprite;
		+nogravity;
		+spawnfloat;
		speed 2; // Nearly immobile, you have enough to keep track of as it is.
	}

	states
	{
		spawn:
			brkn a 1 A_Look();
			loop;
		see:
			brkn a 4 A_Chase();
			loop;
	}
}