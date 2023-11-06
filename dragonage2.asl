state("DragonAge2", "1.00")
{
    int isLoading : 0x9330E4; // Loading is 16842753
    int start : 0x939ED8;
    string255 map : 0x0094B950, 0x74, 0xB4, 0xB4, 0x5C, 0x0, 0xA8, 0x0;
    int meredith : 0x9657A4;
    //
}

state("DragonAge2", "1.04")
{
    int isLoading : 0x93A144; 
    // int isLoading : 0x95869C, 0x1D0;
    int start : 0x940F38;
    string255 map : 0x00952FB8, 0x324, 0x44, 0x4, 0x10, 0x50, 0xA8, 0x0;
    int meredith : 0x97CF64;
}

init
{
    vars.currentMap = "";
    vars.oldMap = "";

    if (modules.First().ModuleMemorySize == 11522048){
        version = "1.00";
    } else if (modules.First().ModuleMemorySize == (12394496 | 12406784)){
        version = "1.04";
    } else {
        // unknown version, assuming 1.04
        version = "1.04";
    }

    vars.accountDP = new DeepPointer(0x9560F8, 0x0);
    current.account = "";
}

startup
{
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var timingMessage = MessageBox.Show(
			"This game uses RTA w/o Loads as the main timing method.\n"
			+ "LiveSplit is currently set to show Real Time (RTA).\n"
			+ "Would you like to set the timing method to RTA w/o Loads?",
			"Dragon Age 2 | LiveSplit",
			MessageBoxButtons.YesNo, MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}

    settings.Add("meredith", false, "Split when Meredith dies (end of run)");

    settings.Add("pro", false, "Prologue splits");
    settings.Add("act1", false, "Act 1 splits");
    settings.Add("act2", false, "Act 2 splits");
    settings.Add("act3", false, "Act 3 splits");
    settings.Add("misc", false, "Misc");

    settings.CurrentDefaultParent = "pro";
    settings.Add("pro000ar_blightlands_fake -> pro000ar_blightlands_real", false,    "Completed tutorial");
    settings.Add("pro000ar_blightlands_real -> pro000ar_gallow_court", false,        "Enter Gallows");

    settings.CurrentDefaultParent = "act1";
    settings.Add("pro000ar_gallow_court -> dae120ar_hightown", false,                "When Act 1 starts");
    settings.Add("dae150ar_sundermount -> dae110ar_lowtown", false,                  "Enter Lowtown from Sundermount");
    settings.Add("dae110ar_docks -> dae170ar_gallows", false,                        "Enter Gallows from Docks");
    settings.Add("mag100ar_eau_road -> dae110ar_docks_nt", false,                    "Enter Docks Night from Wilmod's Camp");
    settings.Add("dae170ar_gallows -> dae160ar_wounded_coast", false,                "Enter Wounded Coast from Gallows");
    settings.Add("mag100ar_encounter -> mag101ar_caverns", false,                    "Enter cavern in Wounded Coast Approach");
    settings.Add("dae120ar_hightown -> dre180ar_deep_roads", false,                  "Enter Deep Roads");
    
    settings.CurrentDefaultParent = "act2";
    settings.Add("dae111ar_gamlens_house_nt -> dae221ar_keep", false,                "When Act 2 starts");
    settings.Add("dae210ar_docks -> dae270ar_gallows", false,                        "Enter Gallows from Docks");
    settings.Add("qun231ar_varnell_hideout -> dae221ar_player_home_nt", false,       "Enter Estate from Ser Varnell's Refuge");
    settings.Add("dae221ar_player_home_nt -> dae221ar_keep", false,                  "Enter Viscount's Keep from Estate");
    
    settings.CurrentDefaultParent = "act3";
    settings.Add("qcr221ar_keep -> dae320ar_hightown", false,                        "When Act 3 starts");
    settings.Add("dae370ar_gallows -> dae321ar_player_home_nt", false,               "Enter Estate from Gallows");
    settings.Add("mcr371ar_gallows_prison_nt -> mcr371ar_gallows_templar_nt", false, "After Orsino dies");

    settings.CurrentDefaultParent = "misc";
    settings.Add("censor", false, "Censor email address shown in main menu");
}

exit
{
    timer.IsGameTimePaused = true;
}

start
{
    return old.start == 150 && current.start >= 151;
}

isLoading
{
    return current.isLoading == 16842753;
}

split
{
    vars.oldMap = vars.currentMap;
    if (current.map != null && current.map.Length > 1) 
        vars.currentMap = current.map;

    if (settings["meredith"] && vars.currentMap == "mcr370ar_gallows_nt" && old.meredith == 0 && current.meredith == 1)
        return true;

    if (vars.oldMap == vars.currentMap)
        return false;

    return settings[vars.oldMap + " -> " + vars.currentMap];
}

update
{
    
    if (!settings["censor"])
        return;

    IntPtr strPtr;
    vars.accountDP.DerefOffsets(game, out strPtr);

    string str = game.ReadString(strPtr, 100);
    if (str == null)
        return;

    string censorMsg = "CENSORED";
    if (str != censorMsg)
    {
        byte [] strInBytes = new byte[censorMsg.Length * 2 + 1];
        Encoding.Unicode.GetBytes(censorMsg).CopyTo(strInBytes, 0);
        game.WriteBytes(strPtr, strInBytes);
    }
    
}


