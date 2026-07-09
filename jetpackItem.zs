class JetpackItem : Inventory
{

    int Fuel;
	int FuelMax;
	bool hovering;
	bool thrusting;

    Default
    {
	
        Inventory.MaxAmount 1;
        Inventory.PickupMessage "Picked up a Jetpack!";
        Inventory.Icon "JETPA0";
		
    }
	
	override void Tick()
	{
	
		Super.Tick();
		
		PlayerPawn p = PlayerPawn(players[consoleplayer].mo);
		if (p == null) { return; }
		
		let cmd = p.player.cmd;
		thrusting = false;
		hovering = false;
        if (Fuel > 0)
		{
		
			thrusting = (cmd.buttons & BT_JUMP);
			hovering = (cmd.buttons & BT_USE);
			int drain = 0;
			double forwardMove = cmd.forwardmove;
			double sideMove = cmd.sidemove;
							
			if (hovering)
			{

				p.Vel.Z = 0;

				if (forwardMove != 0 || sideMove != 0)
				{
        
					Vector3 forward;
					Vector3 right;					
					
					forward.X = cos(p.Angle);
					forward.Y = sin(p.Angle);
					forward.Z = 0;					
					
					right.X = cos(p.Angle - 90);
					right.Y = sin(p.Angle - 90);
					right.Z = 0;					
					
					// Normalize movement input
					forwardMove /= 256.0;
					sideMove /= 256.0;

					double moveScaleX = CVar.GetCVar("jetpack_accel_x", players[consoleplayer]).GetFloat();
					double moveScaleY = CVar.GetCVar("jetpack_accel_y", players[consoleplayer]).GetFloat();

					p.Vel.X += (forward.X * forwardMove + right.X * sideMove) * moveScaleX;
					p.Vel.Y += (forward.Y * forwardMove + right.Y * sideMove) * moveScaleY;
					
				}


				drain = 20; //slow hover fuel drain

				if (forwardMove != 0) { drain -= 1; }
				if (sideMove != 0) { drain -= 1; }
				if (level.time % drain == 0) { Fuel--; }

				return;
			
			}
	
			if (thrusting)
			{
			
                //vertical thrust
                p.Vel.Z += CVar.GetCVar("jetpack_accel_z", players[consoleplayer]).GetFloat();
				
				if (forwardMove != 0 || sideMove != 0)
				{
					
					Vector3 forward;
					Vector3 right;

					forward.X = cos(p.Angle);
					forward.Y = sin(p.Angle);
					forward.Z = 0;

					right.X = cos(p.Angle - 90);
					right.Y = sin(p.Angle - 90);

					//normalize movement input
					forwardMove /= 256.0;
					sideMove /= 256.0;

					double moveScaleX = CVar.GetCVar("jetpack_accel_x", players[consoleplayer]).GetFloat();
					double moveScaleY = CVar.GetCVar("jetpack_accel_y", players[consoleplayer]).GetFloat();
			
					p.Vel.X += (forward.X * forwardMove + right.X * sideMove) * moveScaleX;
					p.Vel.Y += (forward.Y * forwardMove + right.Y * sideMove) * moveScaleY;
					
				}
				
				drain = 5; //normal thrust fuel drain
				if (forwardMove != 0) { drain -= 1; }
				if (sideMove != 0) { drain -= 1; }                				
                if (level.time % drain == 0) { Fuel--; }
				
				return;
				
			}
			
		}
		
		if (CVar.GetCVar("jetpack_recharges_on_ground", players[consoleplayer]).GetBool())
		{
			if (p.Pos.Z <= p.floorz) //player is on the ground				
			{
					
				if (level.time % 7 == 0 && Fuel < FuelMax) // recharge every 7 tics
				{
					
					Fuel += 1;
						
				}
					
			}
				
		}
	
	}
	
    override void AttachToOwner(Actor other)
    {
	
        Super.AttachToOwner(other);

        Fuel = 10;
		FuelMax = 100;

    }

    States
    {
	
		Spawn:
			JETP A -1;
			Stop;
		
    }
	
}