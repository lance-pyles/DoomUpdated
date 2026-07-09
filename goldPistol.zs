class GoldBullets : Ammo
{
    Default
    {
        Inventory.Amount 10;           // Amount given per pickup
        Inventory.MaxAmount 100;       // Low max capacity for high-tier ammo
        Inventory.PickupMessage "Found rare Gold bullets!";
        Inventory.Icon "CLIPA0";      // Change to your custom HUD icon
        Tag "Gold Bullets";
    }
    States
    {
        Spawn:
            CELL A -1;                // The sprite that appears on the ground
            Stop;
    }
}

class GoldChaingun : DoomWeapon
{
	Default
	{
		Weapon.SelectionOrder 2;
		Weapon.AmmoUse 1;
		
		Weapon.AmmoType "GoldBullets";
		Inventory.PickupMessage "You picked up the Golden Chaingun!";
		//Obituary "$OB_MPCHAINGUN";
		Tag "Golden Chaingun";
	}
	States
	{
	Ready:
		GHGG A 1 A_WeaponReady;
		Loop;
	Deselect:
		GHGG A 1 A_Lower;
		Loop;
	Select:
		GHGG A 1 A_Raise;
		Loop;
Fire:
    GHGG A 4
    {
        A_StartSound("weapons/chngun", CHAN_WEAPON);
        A_RailAttack(
            5000,
            0,
            true,
            "",
            "",
            RGF_SILENT,
            0,
            "BulletPuff",5.6
        );
        A_GunFlash();
    }
    CHGG B 4
    {
        A_StartSound("weapons/chngun", CHAN_WEAPON);
        A_RailAttack(
            5000,
            0,
            true,
            "",
            "",
            RGF_SILENT,
            0,
            "BulletPuff",5.6
        );
        A_GunFlash();
    }
    CHGG B 0 A_ReFire;
    Goto Ready;
	Flash:
		CHGF A 5 Bright A_Light1;
		Goto LightDone;
		CHGF B 5 Bright A_Light2;
		Goto LightDone;
	Spawn:
		MGUN A -1;
		Stop;
	}
}

class GoldPistol : Pistol
{
	
	Default
	{
		Weapon.AmmoType "GoldBullets"; // Requires gold bullets to shoot
        Weapon.AmmoUse 1;                 // Uses 1 bullet per shot
		Weapon.SelectionOrder 1; // Lower number means player switches to it automatically
		-WEAPON.WIMPY_WEAPON;      // Removes the "weak weapon" flag so it is treated as powerful
		Inventory.PickupMessage "You picked up the Golden Pistol!";
		Tag "Golden Pistol";
	}
	
	States
	{
	Ready:
		GISG A 1 A_WeaponReady;
		Loop;
	Deselect:
		GISG A 1 A_Lower;
		Loop;
	Select:
		GISG A 1 A_Raise;
		Loop;

	Flash:
		PISF A 7 Bright A_Light1;
		Goto LightDone;
		PISF A 7 Bright A_Light1;
		Goto LightDone;
 	Spawn:
		PIST A -1;
		Stop;
	
	AltFire:
		GISG A 2;
		PISG B 3
		{		
			A_RailAttack(5000, 0, true, "", "", RGF_SILENT, 0, "BulletPuff", 5.6);						
			A_StartSound("weapons/pistol", CHAN_WEAPON); //play the sound explicitly on the weapon channel			
			A_GunFlash(); // This triggers the muzzle flash state inherited from Pistol
		}
				
		PISG C 2;	
		Goto Fire;
	
	Fire:
		GISG A 4;
		PISG B 6
		{		
			A_RailAttack(5000, 0, true, "", "", RGF_SILENT, 0, "BulletPuff", 5.6);						
			A_StartSound("weapons/pistol", CHAN_WEAPON); //play the sound explicitly on the weapon channel			
			A_GunFlash(); // This triggers the muzzle flash state inherited from Pistol
		}
				
		PISG C 4;
		PISG B 5 A_ReFire;
		Goto Ready;
	}
}