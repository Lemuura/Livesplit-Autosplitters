state("DragonAgeInquisition", "1.01")
{
    int isLoading : 0x029032F8, 0xD0, 0x38, 0x40, 0xC0, 0x224;
    int start : 0x02945040, 0x30, 0xB0;
    int isCutscene : 0x029589B8, 0x84;
    string75 Map : 0x028E3910, 0x68, 0x40, 0xE8, 0x4;
    float x : 0x0288D920, 0x10, 0x0, 0x90, 0x20, 0x0, 0x0;
    float y : 0x0288D920, 0x10, 0x0, 0x90, 0x20, 0x0, 0x4;
    float z : 0x0288D920, 0x10, 0x0, 0x90, 0x20, 0x0, 0x8;
}

state("DragonAgeInquisition", "1.11")
{
    int isLoading : 0x0297E4A8, 0xD0, 0x38, 0x40, 0x100, 0xE98;
    int start : 0x029C01F0, 0x30, 0xB0;
    int isCutscene : 0x029D3B78, 0x84;
    string75 Map : 0x0295B8A8, 0x68, 0x40, 0xE8, 0x4;
    float x : 0x02906220, 0x10, 0x0, 0x90, 0x20, 0x20, 0x0;
    float y : 0x02906220, 0x10, 0x0, 0x90, 0x20, 0x20, 0x4;
    float z : 0x02906220, 0x10, 0x0, 0x90, 0x20, 0x20, 0x8;
}

startup
{
    // Any% splits
    settings.Add("any%", false, "Any%");
    settings.Add("demon", false, "Leliana/Roderick cutscene", "any%");
    settings.Add("haven", true, "Haven", "any%");
    settings.Add("crestwood", true, "Crestwood", "any%");
    settings.Add("emprise", true, "Emprise du Lion", "any%");
    settings.Add("skyhold1", true, "Skyhold 1", "any%");
    settings.Add("skyhold2", true, "Skyhold 2 (Split on exit game)", "any%");
    settings.Add("stormcoast", true, "The Storm Coast", "any%");
    settings.Add("arborwilds", true, "Arbor Wilds", "any%");
    settings.Add("mythaltemple", true, "Temple of Mythal", "any%");
    settings.Add("templechamber", false, "Petitioner's Chamber", "mythaltemple");
    settings.Add("skyhold3", true, "Skyhold 3", "any%");
    settings.Add("mythalaltar", true, "Altar of Mythal", "any%");
    settings.Add("skyhold4", true, "Skyhold 4", "any%");
    settings.Add("finale", true, "Corypheus", "any%");

    // All Dragons splits
    settings.Add("alldragons", false, "All Dragons (Currently not used)");

    // Trespasser splits
    settings.Add("trespasser", false, "Trespasser");
}

init
{
    vars.splitOnExit = false;
    if (modules.First().ModuleMemorySize == 116293632){
        version = "1.01";
    } else if (modules.First().ModuleMemorySize == 103342080){
        version = "1.11";
    } else {
        //Unknown version, assuming 1.11
        version = "1.11";
    }
}

exit
{
    timer.IsGameTimePaused = true;
    if (vars.splitOnExit)
    {
        new TimerModel() { CurrentState = timer }.Split();
        vars.splitOnExit = false;
    }
    
}

split
{
    // Any% splits
    if (settings["any%"])
    {
        // Split on Corypheus death cutscene
        var x = -139 - current.x;
        var z = 44 - current.z;
        var distanceSquared = x * x + z * z;
        if (distanceSquared < 4000 && old.isCutscene <= 65537 && current.isCutscene == 16842753 && current.Map == "Layouts/FrostbackMountains/Finale/Finale")
        {
            return true;
        }
    }
    if (settings["demon"])
    {
        var x = -335 - current.x;
        var z = -113 - current.z;
        var distanceSquared = x * x + z * z;
        if (distanceSquared < 4000 && old.isCutscene <= 65537 && current.isCutscene == 16842753 && current.Map == "Layouts/FrostbackMountains/FrostbackMountains/FrostbackMountains")
        {
            return true;
        }
    }
    if (settings["haven"])
    {
        var x = -618 - current.x;
        var z = 159 - current.z;
        var distanceSquared = x * x + z * z;
        if (distanceSquared < 4000 && current.isLoading == 0 && (old.isCutscene == 65536 || old.isCutscene == 16842752) && current.isCutscene == 16842753 && current.Map == "Layouts/FrostbackMountains/FrostbackMountains/FrostbackMountains")
        {
            return true;
        }
    }
    if (settings["crestwood"] && old.Map == "Layouts/FrostbackMountains/FrostbackMountains/FrostbackMountains" && current.Map == "Layouts/Ferelden/fer_Wilderness_010/fer_Wilderness_010")
    {
        return true;
    }
    if (settings["emprise"] && old.Map == "Layouts/Ferelden/fer_Wilderness_010/fer_Wilderness_010" && current.Map == "Layouts/TheDales/TheDales_Highlands/TheDales_Highlands")
    {
        return true;
    }
    if (settings["skyhold1"] && old.Map == "Layouts/TheDales/TheDales_Highlands/TheDales_Highlands" && current.Map == "Layouts/InquisitorBase2/MainBase/MainBase")
    {
        return true;
    }
    //Skyhold2 is listed under update and exit.
    if (settings["stormcoast"] && old.Map == "Layouts/InquisitorBase2/MainBase/MainBase" && current.Map == "Layouts/ThematicLevels/the_StormCoast_540/the_StormCoast_540")
    {
        return true;
    }
    if (settings["arborwilds"] && old.Map == "Layouts/ThematicLevels/the_StormCoast_540/the_StormCoast_540" && current.Map == "Layouts/ArborWilds/ArborWilds_Main/ArborWilds_Main")
    {
        return true;
    }
    if (settings["mythaltemple"] && old.Map == "Layouts/ArborWilds/ArborWilds_Main/ArborWilds_Main" && current.Map == "Layouts/ArborWilds/myt_TempleOfMythal/myt_TempleOfMythal")
    {
        return true;
    }
    if (settings["templechamber"])
    {
        var x = 1 - current.x;
        var z = 175 - current.z;
        var distanceSquared = x * x + z * z;
        if (distanceSquared < 1000 && old.isCutscene <= 65537 && current.isCutscene == 16842753 && current.Map == "Layouts/ArborWilds/myt_TempleOfMythal/myt_TempleOfMythal")
        {
            return true;
        }
    }
    if (settings["skyhold3"] && old.Map == "Layouts/ArborWilds/myt_TempleOfMythal/myt_TempleOfMythal" && current.Map == "Layouts/InquisitorBase2/MainBase/MainBase")
    {
        return true;
    }
    if (settings["mythalaltar"] && old.Map == "Layouts/InquisitorBase2/MainBase/MainBase" && current.Map == "Layouts/ArborWilds/ArborWilds_Main/ArborWilds_Main")
    {
        return true;
    }
    if (settings["skyhold4"] && old.Map == "Layouts/ArborWilds/ArborWilds_Main/ArborWilds_Main" && current.Map == "Layouts/InquisitorBase2/MainBase/MainBase")
    {
        return true;
    }
    if (settings["finale"] && old.Map == "Layouts/InquisitorBase2/MainBase/MainBase" && current.Map == "Layouts/FrostbackMountains/Finale/Finale")
    {
        return true;
    }

    // All Dragons splits

    // Trespasser splits
    if (settings["trespasser"])
    {
        // Split on Solas Trespasser ending cutscene
        var x = -405 - current.x;
        var z = 795 - current.z;
        var distanceSquared = x * x + z * z;
        if (distanceSquared < 4000 && old.isCutscene <= 65537 && current.isCutscene == 16842753 && current.Map == "DLC_Blue/Layouts/DLCBlue_Solas_Dungeon/DLCBlue_Solas_Dungeon")
        {
            return true;
        }
    }
    /*
    var x =  - current.x;
    var z =  - current.z;
    var distanceSquared = x * x + z * z;
    if (distanceSquared < 4000 
     */

    return false;
}

update
{
    if (settings["skyhold2"] && version == "1.01" && current.Map == "Layouts/InquisitorBase2/MainBase/MainBase")
    {
        vars.splitOnExit = true;
    }
}

start
{
    if (current.start == 10 && old.start == 10000)
    {
        return true;
    }
    return false;
}

isLoading
{
    return current.isLoading == 0;
}

// Biiiig credit to Fzzy2j, couldn't have made this without his help <3