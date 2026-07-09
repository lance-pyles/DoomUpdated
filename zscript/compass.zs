class HUD_CompassHandler : StaticEventHandler
{
    override void RenderOverlay(RenderEvent e)
    {
		// 1. Fetch our custom user variable state from the local config file
        let compassToggle = CVar.GetCVar("draw_hud_compass", players[consoleplayer]);
        
        // Safety Gate: If the CVar doesn't exist yet, or is turned off, stop drawing immediately
        if (!compassToggle || !compassToggle.GetBool()) return;
		
        // 1. Check global engine states first
        if (automapactive || menuactive) return;

        // 2. Safely fetch the specific player viewing this client screen
        PlayerInfo pInfo = players[consoleplayer];
        if (!pInfo || !pInfo.mo) return;

        // 3. Fetch the player's smoothed rendering view angle
        double viewAngle = e.viewAngle;

        // Convert Doom angles to standard clockwise orientation (0 = North)
        double playerHeading = (450.0 - viewAngle);
        while (playerHeading >= 360.0) playerHeading -= 360.0;
        while (playerHeading < 0.0) playerHeading += 360.0;

        // Establish our higher-resolution 640x400 virtual HUD canvas
        int virtualWidth = 640;
        int virtualHeight = 400;
        int centerX = virtualWidth / 2;
        int compassY = 15; // Padding down from top edge

        // Setup fonts
        Font smallFnt = Font.GetFont("SmallFont");
        if (!smallFnt) return;

        // 4. Draw the static UI elements (The Center Indicator Tick)
        Screen.DrawText(smallFnt, Font.CR_RED, centerX - 2, compassY - 8, "v",
            DTA_VirtualWidth, virtualWidth, DTA_VirtualHeight, virtualHeight, DTA_KeepRatio, true);

        // 5. Define our major navigational markers and their explicit degree values
        static const string labels[] = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"};
        static const int degrees[]   = {0, 45, 90, 135, 180, 225, 270, 315};

        // 6. The Sliding Render Loop
        for (int i = 0; i < 8; i++)
        {
            double markerAngle = degrees[i];
            
            // Calculate shortest angular distance between player heading and the marker
            double diff = markerAngle - playerHeading;
            while (diff < -180.0) diff += 360.0;
            while (diff > 180.0)  diff -= 360.0;

            // FOV Culling: Only draw markers within roughly 60 degrees left or right of center
            if (abs(diff) < 60.0)
            {
                // Scale factor: 1 degree equals 2 pixels of displacement on screen
                int offsetX = int(diff * 2.0);
                int finalX = centerX + offsetX;

                // Center-proximity styling: Bright gold if pointing close to it, dark gray if at the edges
                int textColor = Font.CR_DARKGRAY;
                if (abs(diff) < 7.5)       textColor = Font.CR_GOLD;
                else if (abs(diff) < 30.0) textColor = Font.CR_WHITE;

                // Calculate half text width to keep it perfectly centered on its degree coordinate
                int textWidth = smallFnt.StringWidth(labels[i]);
                int drawX = finalX - (textWidth / 2);

                // Draw the directional character
                Screen.DrawText(smallFnt, textColor, drawX, compassY, labels[i],
                    DTA_VirtualWidth, virtualWidth, DTA_VirtualHeight, virtualHeight, DTA_KeepRatio, true);
            }
        }

        // 7. Draw the exact angle digits directly below the center tick mark
        string angleStr = String.Format("%03d", int(playerHeading));
        int angleWidth = smallFnt.StringWidth(angleStr);
        Screen.DrawText(smallFnt, Font.CR_GOLD, centerX - (angleWidth / 2), compassY + 12, angleStr,
            DTA_VirtualWidth, virtualWidth, DTA_VirtualHeight, virtualHeight, DTA_KeepRatio, true);
			
			    PlayerInfo pi = players[consoleplayer];

    if (!pi || !pi.mo || !pi.mo.player)
        return;

    Weapon weap = pi.mo.player.ReadyWeapon;

    if (!weap)
        return;

    Screen.DrawText(
        SmallFont,
        Font.CR_WHITE,
       
        10,
        300, weap.GetClassName()
    );
			
    }
}

class AutomapCompassHandler : StaticEventHandler
{
    override void RenderOverlay(RenderEvent e)
    {
		// 1. Fetch our custom user variable state from the local config file
        let compassToggle = CVar.GetCVar("draw_automap_compass", players[consoleplayer]);
        
        // Safety Gate: If the CVar doesn't exist yet, or is turned off, stop drawing immediately
        if (!compassToggle || !compassToggle.GetBool()) return;
		
        // Only render if the player has the automap open
        if (!automapactive) return;

        // Get the accurate interpolated view angle of the current camera
        double viewAngle = e.viewAngle;

        // Doom Engine maps 0 to East and 90 to North (counter-clockwise).
        // This formula translates it to a standard 0-360 clockwise compass (0 = North, 180 = South).
        double compassAngle = (450.0 - viewAngle);
        
        // Keep the angle bounded between 0 and 359
        while (compassAngle >= 360.0) compassAngle -= 360.0;
        while (compassAngle < 0.0) compassAngle += 360.0;

        // Divide 360 degrees into 8 cardinal/intercardinal segments (45 degrees each)
        static const string dirs[] = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" };
        int dirIndex = int((compassAngle + 22.5) / 45.0) % 8;
        string dirStr = dirs[dirIndex];

        // Format the string (e.g., "NE (45)")
        string compassText = String.Format("%s (%d)", dirStr, int(compassAngle));

        // Safely fetch GZDoom's classic small font
        Font smallFnt = Font.GetFont("SmallFont");
        if (!smallFnt) return;

        // Positions the text based on a virtual 320x200 space so it scales perfectly 
        // regardless of screen resolution.
        int posX = 10; // 10 pixels from the left edge
        int posY = 10; // 10 pixels down from the top edge

        // Draw the text to the screen in a clean Gold color
        Screen.DrawText(smallFnt, Font.CR_GOLD, posX, posY, compassText, 
            DTA_VirtualWidth, 320, 
            DTA_VirtualHeight, 200,
            DTA_KeepRatio, true);
			
    PlayerInfo pi = players[consoleplayer];

    if (!pi || !pi.mo || !pi.mo.player)
        return;

    Weapon weap = pi.mo.player.ReadyWeapon;

    if (!weap)
        return;

    Screen.DrawText(
        SmallFont,
        Font.CR_WHITE,
       
        10,
        10, weap.GetClassName()
    );


	}
			
}
