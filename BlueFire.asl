state("PROA34-Win64-Shipping")
{
	float TotalCentiseconds : 0x42C4EA0, 0x30, 0xE8, 0x258, 0x10B8, 0x260;
	//the timer, starts at milliseconds, stored as 4byte and is slightly off displayed timer
}

startup
{
	vars.Log = (Action<object>)((output) => print("[Blue Fire] " + output));
	vars.MenuTime = 0f;

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

 	settings.Add("firekeep", false, "Firekeep");
	settings.Add("Chest_A02_Keep_Key_01", false, "First Old Key", "firekeep");
	settings.Add("Spirit_A02_RiverSpirit", false, "Double Dash Spirit", "firekeep");
	settings.Add("Shrine: 7 -> 4", false, "Firekeep Shrine", "firekeep");
	settings.Add("Area: 1 -> 8", false, "Transition to Arcane", "firekeep");

	settings.Add("arcane", false, "Arcane");
	settings.Add("Shrine: 4 -> 3", false, "Arcane Shrine", "arcane");
	settings.Add("Area: 8 -> 0", false, "Elevator Transition", "arcane");
	settings.Add("IDTutorial_Spin Attack", false, "Spin Attack Ability", "arcane");
	settings.Add("Area: 0 -> 4", false, "Forest Shrine Transition", "arcane");

	settings.Add("forest", false, "Forest Shrine");
	settings.Add("IDTutorial_Wall Run", false, "Wallrun Ability", "forest");
	settings.Add("BossDoor_Gru_SkipCutscene", false, "Gruh Entry", "forest");
	settings.Add("BossGuardianGru", false, "Gruh Dead", "forest");

	settings.Add("uthas", false, "Uthas Temple");
	settings.Add("MeetBremur", false, "Graveyard Key", "uthas");
	settings.Add("Area: 10 -> 3", false, "Transition to Uthas Temple", "uthas");
	settings.Add("IDTutorial_Double Jump", false, "Double Jump Ability", "uthas");
	settings.Add("BossDoor_Boo_SkipCutscene", false, "Croh Entry", "uthas");
	settings.Add("BossGuardianBoo", false, "Croh Dead", "uthas");
	
	settings.Add("temple", false, "Temple Garden");
	settings.Add("IDTutorial_Warp", false, "Fast Travel Ability", "temple");
	settings.Add("Area: 11 -> 10", false, "Transition to Abandoned Path", "temple");
	settings.Add("CS: VonCinematicVessel", false, "AP Soul Fragments Start", "temple");
	settings.Add("BP_BeiraVesselBase_Graveyard", false, "AP Soul Fragments End", "temple");
	settings.Add("CS: Door_A02_WaterWays_04_3", false, "TG Soul Fragments Start", "temple");
	settings.Add("BP_BeiraVesselBase_TempleGardens", false, "TG Soul Fragments End", "temple");

	settings.Add("firefall", false, "Firefall River");
	settings.Add("CS: DoorLever_A01_City_6", false, "FFR Soul Fragments Start", "firefall");
	settings.Add("BP_BeiraVesselBase_LakeMolva", false, "FFR Soul Fragments End", "firefall");

	settings.Add("steamHouse", false, "Steam House");
	settings.Add("SteamHouseMusicIntro", false, "Steam House Intro", "steamHouse");
	settings.Add("SteamMachineActivator_1", false, "Fix Boiler 1", "steamHouse");
	settings.Add("Elevator_ExitArea_SteamHouse-RustCity", false, "Fix Boiler 3", "steamHouse");
	settings.Add("BossLordSirion_SkipCutscene", false, "Sirion Entry", "steamHouse");
	settings.Add("TeleportTemple14", false, "Sirion Dead", "steamHouse");

	settings.Add("soul", false, "Soul Fragments");
	settings.Add("CS: DoorLever3", false, "Intro Soul Fragments Start", "soul");
	settings.Add("BP_BeiraVesselBase_GameIntro", false, "Intro Soul Fragments End", "soul");
	settings.Add("BossLordBeira_SkipCutscene", false, "Beira Entry", "soul");
	settings.Add("TeleportTemple2", false, "Beira Dead", "soul");

	settings.Add("water", false, "Waterways");
	settings.Add("BossLordSamael_SkipCutscene", false, "Samael Entry", "water");
	settings.Add("TeleportTemple9", false, "Samael Dead", "water");
	
	settings.Add("queen", false, "Queen");
	settings.Add("Queen_SkipCutscene", false, "Queen Entry", "queen");
	settings.Add("BossQueen", false, "Queen Dead", "queen");

	settings.Add("debug", false, "[DEBUG] Show tracked values on overlay");

	vars.splitOnNextCutscene = false; 
}

init
{
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
					new MemoryWatcher<float>(new DeepPointer(gWorld, 0x30, 0xE8, 0x258, 0x10B8, 0x260)) { Name = "TotalCentiseconds" },
					new StringWatcher(new DeepPointer(gWorld, 0x428, 0x0), 255) { Name = "GWorldName" },
					new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x188, 0x351)) { Name = "LastCheckpoint" },
					new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x30, 0xE8, 0x288, 0x700)) { Name = "StreamingChunk" },
					new MemoryWatcher<IntPtr>(new DeepPointer(gWorld, 0x188, 0x300 + 0x8)) { Name = "EventsArray"},
					new MemoryWatcher<int>(new DeepPointer(gWorld, 0x188, 0x300 + 0x8 + 0x8)) { Name = "EventsSize"},
					new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x30, 0xE8, 0x258, 0xe70)) { Name = "Cutscene" },	
				};

				vars.Log("Found GWorld at 0x" + gWorld.ToString("X") + ".");
				break;
			}

			Thread.Sleep(2000);
		}

		vars.Log("Exiting scan thread.");
	});

	vars.ScanThread.Start();

	current.Event = "Null";
}

update
{
	if (vars.ScanThread.IsAlive) return false;

	vars.Data.UpdateAll(game);
	current.Centiseconds = vars.Data["TotalCentiseconds"].Current;

	 if (vars.Data["EventsSize"].Changed && vars.Data["EventsSize"].Current > 1)
	{
		var eventsPtr = game.ReadPointer((IntPtr)vars.Data["EventsArray"].Current + (((int)vars.Data["EventsSize"].Current - 1) * 0x10));
		current.Event = game.ReadString(eventsPtr, 255);
		vars.Log(current.Event);
	}

	if (settings["debug"])
	{
		vars.SetTextComponent("---------DEBUG---------", "");
		vars.SetTextComponent("Last CP:", vars.Data["LastCheckpoint"].Current.ToString());
		vars.SetTextComponent("Chunk:", vars.Data["StreamingChunk"].Current.ToString());
		vars.SetTextComponent("IsCutscene:", vars.Data["Cutscene"].Current.ToString());
		vars.SetTextComponent("Event:", current.Event);
	} 
}

start
{
	return old.Centiseconds < 1f && current.Centiseconds >= 1f;
}

reset
{
	return current.Centiseconds < 0.5f;
}

gameTime
{
	if (current.Centiseconds > 0)
		return TimeSpan.FromSeconds(current.Centiseconds / 100f);
}

isLoading
{
	return true;
}

split
{
	
 	if (vars.splitOnNextCutscene && vars.Data["Cutscene"].Changed)
	{
		vars.splitOnNextCutscene = false;
		return settings["CS: " + current.Event];
	}

	// Split when event is updated
	if (vars.Data["EventsSize"].Changed)
	{
		if (current.Event == "VonCinematicVessel" || current.Event == "DoorLever_A01_City_6" || current.Event == "DoorLever3")
		{
			vars.splitOnNextCutscene = true;
			return false;
		}
		if (current.Event == "TeleportTemple")
		{
			return settings[current.Event + vars.Data["StreamingChunk"].Current.ToString()];
		}
		return settings[current.Event];
	}

	// Split when fireshrine is updated
	if (vars.Data["LastCheckpoint"].Changed)
	return settings["Shrine: " + vars.Data["LastCheckpoint"].Old + " -> " + vars.Data["LastCheckpoint"].Current]; 

	// Split when streaming chunk changes (area transitions)
	if (vars.Data["StreamingChunk"].Changed)
	{		
		if (vars.Data["StreamingChunk"].Current == 11 && current.Event == "Door_A02_WaterWays_04_3")
		{
			vars.splitOnNextCutscene = true;
			return false;
		}
		return settings["Area: " + vars.Data["StreamingChunk"].Old.ToString() + " -> " + vars.Data["StreamingChunk"].Current.ToString()];
	} 
}
