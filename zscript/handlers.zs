class HeartHandler : EventHandler
{
	override void WorldLoaded(WorldEvent e)
	{
	// Spawn hearts here.
	}

	override void PlayerEntered(PlayerEvent e)
	{
		PlayerInfo plr = players[e.PlayerNumber];
		let plrmob = HellwavePlayer(plr.mo);
		plrmob.HeartSpawn();
	}

	override void WorldUnloaded(WorldEvent e)
	{
	// And despawn them here.
		ThinkerIterator ht = ThinkerIterator.Create("Heart");
		actor nheart;
		nheart = Heart(ht.next());
		while(nheart)
		{
			nheart.A_Die("safe");
			nheart = Heart(ht.next());
		}
	}
}

class UseKeyHandler : EventHandler
{

	override void RenderOverlay(RenderEvent e)
	{
		let plr = HellwavePlayer(players[consoleplayer].mo);
		if(plr == null)
		{ return; }
		if(plr.FoundUsable)
		{
			int k1, k2 = Bindings.GetKeysForCommand("+use");
			string usekey = Bindings.NameKeys(k1,k2);
			string msg = "Press "..usekey.." to interact";
			int x = (Screen.GetWidth()*0.5) - (smallFont.StringWidth(msg)*0.5);
			int y = Screen.GetHeight()*0.4;
			Screen.DrawText("SMALLFNT",0,x,y,msg);
		}
	}
}
