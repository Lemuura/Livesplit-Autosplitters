state("DrLangeskov") {}

startup
{
	vars.Log = (Action<object>)((output) => print("[DrLangeskov] " + output));

	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
    var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
    vars.Helper = Activator.CreateInstance(type, timer, this);
    vars.Helper.GameName = "Dr. Langeskov";

	vars.Sw = new Stopwatch();
	vars.Lines = new List<string>
	{
		"Here's the thing. The game's live, which makes it impossible to insert you...",
		"The thing is, our entire Weather Department and half the Wildlife Crews—", 
		"Right. First things first; could you bring up the lights? ",
		"Right, this is all—it's so safe.",
		"Ugh, I hate this room.",
		"Ehm, just down the steps. ",
		"Woah, oh my god, are you okay?",
	};	

	settings.Add("0", false, "Enter Publicity and Liaisons Front Desk");
	settings.Add("1", false, "Enter Backstage");
	settings.Add("2", false, "Enter Lighting");
	settings.Add("3", false, "Enter Wildlife Preparation");
	settings.Add("4", false, "Enter Weather Control");
	settings.Add("5", false, "Enter Elevator");
	settings.Add("6", false, "Walkway Collapse");
}

init
{
	vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
    {
        var UIMenu = mono.GetClass("UIMenu");
        vars.Helper["LevelID"] = UIMenu.Make<int>("_instance", "LevelID");

		var DialogueUI = mono.GetClass("DialogueUI");
		vars.Helper["CurrentItem"] = DialogueUI.MakeString("_instance", "_currentItem" ,0xC);

        return true;
    });

    vars.Helper.Load();
}

update
{
	if (!vars.Helper.Loaded || !vars.Helper.Update())
        return false;
}

split
{
 	if ( vars.Helper["CurrentItem"].Current == "Thank you so much!" )
	{
		vars.Sw.Start();
	}

	if (vars.Sw.ElapsedMilliseconds >= 2800)
	{
		vars.Sw.Reset();
		return true;
	}

	if (vars.Helper["CurrentItem"].Changed)
	{
		var index = vars.Lines.IndexOf(vars.Helper["CurrentItem"].Current);
		if (index == -1)
			return false;
		return settings[index.ToString()];
	}
}

start
{
	return vars.Helper["LevelID"].Changed && vars.Helper["LevelID"].Current == 0;
}

onReset
{
	vars.Sw.Reset();
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}