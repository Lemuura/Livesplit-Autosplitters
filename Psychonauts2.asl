state("Psychonauts2-Win64-Shipping")			
{
	// Not used anymore, sigscanning instead.
	//bool isLoading : 0x0554CE10, 0x180, 0x6C0, 0x30; // unreflected bool on UP2LevelTransitionManager
	//int sequenceID : 0x0554CE10, 0x180, 0x488, 0x80, 0x10;
}
state("Psychonauts2-WinGDK-Shipping"){}

startup
{
	vars.Log = (Action<object>)((output) => print("[P2] " + output));

	// Code by Micrologist
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Psychonauts 2",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

		vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
		var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
		var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
		if (textSetting == null)
		{
			var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
			var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
			timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
			textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
			textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
		}
		if (textSetting != null)
			textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});

	settings.Add("3701259", true, "Loboto's Labyrinth");
	settings.Add("3681270", true, "Hub 1");
	settings.Add("3666044", true, "Hollis' Classroom");
	settings.Add("3663925", true, "Hollis' Hot Streak");
	settings.Add("3672328", true, "Casino");
	settings.Add("3650297", true, "Ford 1");
	settings.Add("3721497", true, "Quarry");
	settings.Add("3721662", true, "Enter Compton's Mind");
	settings.Add("3642860", true, "Compton's Cookoff");
	settings.Add("3650042", true, "Ford's Follicles");
	settings.Add("3647840", true, "Strike City");
	settings.Add("3657816", true, "Psi King");
	settings.Add("3650152", true, "Cruller's Correspondence");
	settings.Add("3649254", true, "Sharkophagus");
	settings.Add("3630885", true, "Enter Bob's Mind");
	settings.Add("3631050", true, "Bob's Bottles");
	settings.Add("3696082", true, "Enter Cassie's Mind");
	settings.Add("3635183", true, "Cassie's Collection");
	settings.Add("3706190", true, "Lucrecia's Lament");
	settings.Add("3652977", true, "Fatherland Follies");

	settings.Add("subsplits", false, "Subsplits");
	settings.Add("psiKing", false, "Psi King", "subsplits");
	settings.Add("sub 3658406", false, "Vision", "psiKing");
	settings.Add("sub 3658921", false, "Mouth Nose", "psiKing");
	settings.Add("sub 3659636", false, "Ear Hand", "psiKing");

	settings.Add("bobsBottles", false, "Bob's Bottles", "subsplits");
	settings.Add("sub 3632433", false, "Tia's Bottle", "bobsBottles");
	settings.Add("sub 3632653", false, "Truman's Bottle", "bobsBottles");
	settings.Add("sub 3630435", false, "Helmut's Bottle", "bobsBottles");

	settings.Add("cassiesCollection", false, "Cassie's Collection", "subsplits");
	settings.Add("sub 3634633", false, "Children's Corner", "cassiesCollection");
	settings.Add("sub 3636109", false, "Literature Lane", "cassiesCollection");

	settings.Add("lucrecia", false, "Lucrecia's Lament", "subsplits");
	settings.Add("sub 3705915", false, "Circus", "lucrecia");

	settings.Add("debug", false, "[DEBUG] Show tracked values on overlay");
}

init
{
	timer.IsGameTimePaused = false;

	vars.CancelSource = new CancellationTokenSource();
	vars.ScanThread = new Thread(() =>
	{
		vars.Log("Starting scan thread.");

		var gWorld = IntPtr.Zero;
		var gWorldTrg = new SigScanTarget(10, "80 7C 24 ?? 00 ?? ?? 48 8B 3D ???????? 48")
		{ OnFound = (p, s, ptr) => ptr + 0x4 + p.ReadValue<int>(ptr) };

		var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);
		var token = vars.CancelSource.Token;

		while (!token.IsCancellationRequested)
		{
			if (gWorld == IntPtr.Zero && (gWorld = scanner.Scan(gWorldTrg)) != IntPtr.Zero)
			{
				vars.Data = new MemoryWatcherList
				{
					new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x180, 0x6C0, 0x30)) { Name = "Loading" },
					new MemoryWatcher<int>(new DeepPointer(gWorld, 0x180, 0x488, 0x80, 0x10)) { Name = "SequenceID" },
					new StringWatcher(new DeepPointer(gWorld, 0x4A0, 0x14), 255) { Name = "World" },
				};

				vars.Log("Found GWorld at 0x" + gWorld.ToString("X") + ".");
				break;
			}

			Thread.Sleep(2000);
		}

		vars.Log("Exitng scan thread.");
	});

	vars.ScanThread.Start();
}

isLoading
{
	return vars.Data["Loading"].Current;
}

exit
{
	timer.IsGameTimePaused = true;
}

update
{
	if (vars.ScanThread.IsAlive) return false;

	vars.Data.UpdateAll(game);

	if (settings["debug"])
	{
		vars.SetTextComponent("--------------DEBUG--------------", "");
		vars.SetTextComponent("ID:", vars.Data["SequenceID"].Current.ToString());
		vars.SetTextComponent("World:", vars.Data["World"].Current);
		vars.SetTextComponent("Loading:", vars.Data["Loading"].Current.ToString());
	}
	
}

start
{
	if (vars.Data["World"].Current == "/Entry/Entry")
		return (vars.Data["SequenceID"].Current == 3701534);
}

split
{
	// Maligula ending split
	if (vars.Data["SequenceID"].Old == 3633671 && vars.Data["SequenceID"].Current == 3633353)
		return true;

	// Split on loads
	if (vars.Data["Loading"].Old == false && vars.Data["Loading"].Current == true)
		return settings[vars.Data["SequenceID"].Current.ToString()];

	// Split on sequence change (cutscenes, dialogue)
	if (settings["subsplits"])
	{
		if (vars.Data["SequenceID"].Old != vars.Data["SequenceID"].Current)
		return settings["sub " + vars.Data["SequenceID"].Current.ToString()];
	}
	
}