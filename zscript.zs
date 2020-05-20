version "4.3"

// Base classes.

class HWUsable : Actor 
{
	default
	{
		+SHOOTABLE;
		+INVULNERABLE;
	}
	override bool Used(actor user)
	{
		console.printf("Boink! Unimplemented 'Used' function!");
		return false;
	}
}

// Key objects.
#include "zscript/heart.zs"
#include "zscript/handlers.zs"
#include "zscript/player.zs"
#include "zscript/disk.zs"

// NPCs.
#include "zscript/npc.zs"

// Actual keys.
#include "zscript/keys.zs"

// Combat objects.
#include "zscript/monsters/twanger.zs"
#include "zscript/monsters/snake.zs"
#include "zscript/weapons/crystalgun.zs"
#include "zscript/weapons/cardgun.zs"
