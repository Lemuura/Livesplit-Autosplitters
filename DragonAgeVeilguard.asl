state("Dragon Age The Veilguard", "Patch 4")
{
    bool isLoading : 0x062A01F8;
    string100 mapPath : 0x05E9FC58, 0x3C2;
}
state("Dragon Age The Veilguard", "Patch 3")
{
    bool isLoading : 0x0629EFF8;
    string100 mapPath : 0x05E9EC58, 0x3C2;
}
state("Dragon Age The Veilguard", "Patch 2")
{
    bool isLoading : 0x0629AE08;
    string100 mapPath : 0x05E9AC58, 0x3C2;
}
state("Dragon Age The Veilguard", "Patch 1")
{
    bool isLoading : 0x0629DE88;
    string100 mapPath : 0x05E9DC58, 0x3C2;
}
state("Dragon Age The Veilguard", "Launch Patch")
{
    bool isLoading : 0x06295B08;
    string100 mapPath : 0x05E95BD8, 0x3C2;
}

init
{
    var mms = modules.First().ModuleMemorySize;
    vars.WriteLog("Module memory size: " + mms.ToString("X"));
    switch (mms)
    {
        case 0x73A7000: version = "Launch Patch"; break;
        case 0x73AF000: version = "Patch 1"; break;
        case 0x73AC000: version = "Patch 2"; break;
        case 0x73B0000: version = "Patch 3"; break;
        case 0x73B1000: version = "Patch 4"; break;
        default:        vars.WriteLog("Unknown version."); break;
    }

    current.map = String.Empty;
}

startup
{
    string LOGFILE = "_DragonAgeTheVeilguard.log";
    vars.Log = (Action<object>)((output) => print("[DATV] " + output));

    if (!File.Exists(LOGFILE))
    {
        File.Create(LOGFILE);
    }
    
    Func<object, bool> WriteLog = (data) =>
    {
        using (StreamWriter wr = new StreamWriter(LOGFILE, true)) {
            wr.WriteLine(
                DateTime.Now.ToString(@"HH\:mm\:ss.fff") + (timer != null && timer.CurrentTime.GameTime.HasValue ? 
                " | " + timer.CurrentTime.GameTime.Value.ToString("G").Substring(3, 11) : "") + ": " + data);
        }
        vars.Log(data);
        return true;
    };
    vars.WriteLog = WriteLog;

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Dragon Age: The Veilguard",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    vars.MainMenu = "frontend";

    //vars.PowerUpType = new ExpandoObject();
    //vars.PowerUpType.FlyAndSlice = 0;
}

isLoading
{
    return current.isLoading || current.map == vars.MainMenu;
}

start
{
    return  old.map == vars.MainMenu && current.map == "MinrathousStreetsPrologue";
}

update
{
    if (current.mapPath != String.Empty && (current.mapPath != old.mapPath || current.map == String.Empty))
    {
        current.map = System.Text.RegularExpressions.Regex.Match(current.mapPath, @".*\/(.*)\/.*").Groups[1].ToString();
        vars.WriteLog("New map: \"" + current.mapPath + "\"");
        vars.WriteLog("Short:   \"" + current.map + "\"");
    }
}