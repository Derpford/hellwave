class Broken : actor
{
	double dpit;
	// A broken jpeg left to stew in its own madness.
	default
	{
		health 32;
		MONSTER;
		height 48;
		radius 16;
		+float;
		+wallsprite;
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
		missile:
			brkn a 5
			{
				for(int i = 0; i<4;i++)
				{
					let bm = BrokenMissile(A_SpawnProjectile("BrokenMissile"));
					bm.tracer = target;
					bm.ang = i*90;
				}
			}
			goto see;
		death:
			brkn a 1 
			{ 
				vel.z += 5; 
				vel.x += random(-2,2); vel.y += random(-2,2);
				dpit = frandom(-3,3);
				pitch = -90+dpit;
				bWALLSPRITE = false; bFLATSPRITE = true; bNOGRAVITY = false; 
			}
			brkn a 1 A_NoBlocking();
		deathloop:
			brkn a 1 { pitch += dpit; }
			loop;
		crash:
			brkn a 1 { pitch = 0; }
			brkn a -1;
			stop;
	}
}

class BrokenMissile : actor
{
	// Vibrating squares and circles.
	double ang;

	default
	{
		PROJECTILE;
		damagefunction(15);
		speed 1;
		ReactionTime 64;
	}

	states
	{
		Spawn:
			brks abcb 1 bright 
			{
				ang += 4;
				A_Countdown();
				A_Warp(AAPTR_TRACER,sin(ang)*128,cos(ang)*128,32,flags: WARPF_ABSOLUTEOFFSET|WARPF_COPYINTERPOLATION);
			}
			loop;
		Death:
			brks abcb 2 A_FadeOut();
			tnt1 a -1;
			stop;
	}
}