class JetpackHUD : EventHandler
{

	override void RenderOverlay(RenderEvent event)
	{

		int fuelAmount = 0;
		bool showMessage = true;
		
		if (consoleplayer < 0) { return; }
		if (players[consoleplayer].mo == null) { return; }

		PlayerPawn player = PlayerPawn(players[consoleplayer].mo);
		if (player == null) { return; }

		JetpackItem pack = JetpackItem(player.FindInventory("JetpackItem"));
		if (pack == null) { return; }
		if (pack != null) { fuelAmount = pack.Fuel; }

		//todo reuse method and just pick font color on case
		//case?
		if (pack.Fuel > 74)
		{
			Screen.DrawText(Font.FindFont("SmallFont"), Font.CR_GREEN, 20, 20, String.Format("JETPACK FUEL: %i", fuelAmount), DTA_VirtualWidth, 320, DTA_VirtualHeight, 200);
		}
		else if (pack.Fuel > 49)
		{
			Screen.DrawText(Font.FindFont("SmallFont"), Font.CR_YELLOW, 20, 20, String.Format("JETPACK FUEL: %i", fuelAmount), DTA_VirtualWidth, 320, DTA_VirtualHeight, 200);
		}
		else if (pack.Fuel > 24)
		{
			Screen.DrawText(Font.FindFont("SmallFont"), Font.CR_ORANGE, 20, 20, String.Format("JETPACK FUEL: %i", fuelAmount), DTA_VirtualWidth, 320, DTA_VirtualHeight, 200);
		}
		else if (pack.Fuel > 19)
		{
			Screen.DrawText(Font.FindFont("SmallFont"), Font.CR_RED, 20, 20, String.Format("JETPACK FUEL: %i", fuelAmount), DTA_VirtualWidth, 320, DTA_VirtualHeight, 200);
		}
		else
		{
			if ((Level.time % 20) < 10)
			{
				Screen.DrawText(Font.FindFont("SmallFont"), Font.CR_RED, 20, 20, String.Format("JETPACK FUEL: %i", fuelAmount), DTA_VirtualWidth, 320, DTA_VirtualHeight, 200);
			}

		}	

	}
	
}