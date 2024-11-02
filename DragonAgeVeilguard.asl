state("Dragon Age The Veilguard", "1.0.0")
{
    bool isLoading : 0x06295B08;
    string100 mapPath : 0x05E95BD8, 0x3C2;
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 0x73A7000: version = "1.0.0"; break;
        default:        version = "1.0.0"; break;
    }

    current.map = String.Empty;
}

startup
{
    vars.Log = (Action<object>)((output) => print("[DATV] " + output));

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
    }
}