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
