state("DrLangeskov") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
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
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["LevelID"] = mono.Make<int>("UIMenu", "_instance", "LevelID");
		vars.Helper["CurrentItem"] = mono.MakeString("DialogueUI", "_instance", "_currentItem");

		return true;
	});
}

split
{
 	if (old.CurrentItem != current.CurrentItem && current.CurrentItem == "Thank you so much!")
	{
		vars.Sw.Start();
	}

	if (vars.Sw.ElapsedMilliseconds >= 2800)
	{
		vars.Sw.Reset();
		return true;
	}

	if (current.CurrentItem)
	{
		var index = vars.Lines.IndexOf(current.CurrentItem);
		return index != -1 && settings[index.ToString()];
	}
}

start
{
	return old.LevelID != current.LevelID && current.LevelID == 0;
}

onReset
{
	vars.Sw.Reset();
}
