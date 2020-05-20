class RedNPC : HWUsable
{
	// Exists solely to carry DIALOGUE.
	default
	{
	 	+SOLID;
		+SHOOTABLE; // why do NPCs have to be +SHOOTABLE
		+INVULNERABLE; // lol skyrim NPCs
		+FLOATBOB;
		HWUsable.verb "talk to";
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
	default
	{
		tag "Shopkeeper";
	}
	// Did you know? The kids love deeznuts! And FartNut is the most popular nut around!
}
