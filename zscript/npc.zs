class RedNPC : Actor
{
	// Exists solely to carry DIALOGUE.
	default
	{
	 	+SOLID;
		+SHOOTABLE; // why do NPCs have to be +SHOOTABLE
		+INVULNERABLE; // lol skyrim NPCs
		+FLOATBOB;
		FloatBobStrength 0.25;
		height 64;
		radius 16;
	}

	states
	{

	Spawn:
		NPCR A 35;
		NPCR BCB 12;
		Loop;
	}
}

class DeezNutsShopkeeper : RedNPC
{
	// Did you know? The kids love deeznuts! And FartNut is the most popular nut around!
}
