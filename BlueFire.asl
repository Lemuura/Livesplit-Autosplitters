state("PROA34-Win64-Shipping"){}

startup
{
	vars.Log = (Action<object>)((output) => print("[Blue Fire] " + output));
	vars.MenuTime = 0f;

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var timingMessage = MessageBox.Show(
			"This game uses IGT as the main timing method.\n"
			+ "LiveSplit is currently set to show Real Time (RTA).\n"
			+ "Would you like to set the timing method to IGT?",
			"Blue Fire | LiveSplit",
			MessageBoxButtons.YesNo, MessageBoxIcon.Question
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

	string[,] _settings = 
	{
		{ "transitions", "Cinematic_Area_Intro_Arcane_CutsceneReveal", "Enter Arcane Tunnels from Firekeep"},
		{ "transitions", "0 Pos: 49000 0 -2500", "Enter elevator from Tunnels"},
		{ "transitions", "StoneheartIntroMusic", "Enter Stoneheart City proper"},
		//{ "transitions", "NuosTempleIntroCutsceneMusic", "Enter Forest Shrine from Stoneheart City"},
		{ "transitions", "Area: 0 -> 4", "Enter Forest Shrine from Stoneheart City"},
		{ "transitions", "Area: 10 -> 3", "Enter Uthas Temple from Abandoned Path"},
		{ "transitions", "GraveyardMusicIntro", "Enter Abandoned Path from stoneheart city"},
		{ "transitions", "5 Pos: 9000 10700 -28000", "Enter firefall from Temple Gardens"},
		{ "transitions", "Area: 12 -> 13", "Enter godess chamber"},

		{ "shrines", "Shrine: 4", "Unlock Firekeep Shrine"},
		{ "shrines", "Shrine: 3", "Unlock Arcane Tunnels Shrine"},
		{ "shrines", "Shrine: 0", "Unlock Stoneheart Shrine"},
		{ "shrines", "Shrine: 1", "Unlock Abandoned Path Shrine"},
		{ "shrines", "Shrine: 2", "Unlock Temple Gardens Shrine"},
		{ "shrines", "Shrine: 5", "Unlock Firefall River Shrine"},
		{ "shrines", "Shrine: 6", "Unlock Steam House Shrine"},

		{ "bosses", "BossDoor_Gru", 	"Gruh Entry"},
		{ "bosses", "NuosTempleEndCutscene", 				"Gruh Dead"},
		{ "bosses", "BossDoor_Boo", 	"Croh Entry"},
		{ "bosses", "UthasEndCutscene", 				"Croh Dead"},
		{ "bosses", "BossLordSirion_SkipCutscene",	"Sirion Entry"},
		{ "bosses", "TeleportTemple14", 			"Sirion Dead"},
		{ "bosses", "BossLordBeira_SkipCutscene", 	"Beira Entry"},
		{ "bosses", "TeleportTemple2",				"Beira Dead"},
		{ "bosses", "BossLordSamael_SkipCutscene",	"Samael Entry"},
		{ "bosses", "TeleportTemple9",				"Samael Dead"},
		{ "bosses", "Queen_SkipCutscene",			"Queen Entry"},
		{ "bosses", "BossQueen", 					"Queen Dead"},

		{ "eventSplits", "abilities", "Abilities"},
			{ "abilities", "IDTutorial_Spin Attack", 	"Spin Attack"},
			{ "abilities", "IDTutorial_Wall Run",		"Wallrun"},
			{ "abilities", "IDTutorial_Double Jump",	"Double Jump"},
			{ "abilities", "IDTutorial_Warp",			"Fast Travel"},
			{ "abilities", "IDTutorial_FireBall",		"Fireball"},
			
		{ "eventSplits", "weapons", "Weapons"},
			{ "weapons", "Chest_A01_TempleGardens_Sword_SilverBlades", "silver blades"},
			{ "weapons", "MiaGiveSwords", "iron justice"},
			{ "weapons", "Pickup_Rose", "grab rose for kinas"},
			{ "weapons", "NPC_Master_BarriStage2_NPCBoundActor", "kinas"},
			{ "weapons", "Chest_A01_Graveyard_IceDestroyers", "ice swords"},
			{ "weapons", "Chest_A01_TempleGardens_Sword_Shanks", "shanks"},

		{ "eventSplits", "spirits", "Spirits"},
			{ "spirits", "Spirit_A02_RiverSpirit",		"Fire Keep Tear"},
			{ "spirits", "Spirit_A02_ToxicRat",			"Aerial Rat"},

		{ "eventSplits", "soul", "Soul Fragments"},
			{ "soul", "VonGiveVesselCutscene", "obtain vesssel souls"},
			{ "soul", "10 Pos: -42600 -31700 18500", "AP Soul Fragments Start"},
			{ "soul", "BP_BeiraVesselBase_Graveyard", "AP Soul Fragments End"},
			{ "soul", "11 Pos: -61 -6700 1400", "TG Soul Fragments Start"},
			{ "soul", "BP_BeiraVesselBase_TempleGardens", "TG Soul Fragments End"},
			{ "soul", "5 Pos: -45400 -54300 -45000", "FFR Soul Fragments Start"},
			{ "soul", "BP_BeiraVesselBase_LakeMolva", "FFR Soul Fragments End"},
			{ "soul", "1 Pos: 69660 -57300 -34000", "FireKeep Soul Fragments Start"},
			{ "soul", "BP_BeiraVesselBase_GameIntro", "FireKeep Soul Fragments End"},
			
		//{ "eventSplits", "flames", "Sammy Flames"},
		//	{ "flames", "Door_A02_WaterWays_04_3", "AP flame"},

		{ "eventSplits", "firekeep", "Firekeep"},
			{ "firekeep", "1 Pos: 70000 -99000 -38000", "First fight starts"},
			{ "firekeep", "Chest_A02_Keep_Key_01", 		"First Old Key"},
			{ "firekeep", "FirstVoidCompleted", 		"First Void Completed"},
			{ "firekeep", "1 Pos: 66800 -40700 -35000", "BoxRoom entry"},
			{ "firekeep", "Cinematic_Area_Intro9_CutsceneReveal", "BoxRoom entry2"},

		{ "eventSplits", "stoneheart", "Stoneheart City"},
			{ "stoneheart", "MeetBremur", "Get Graveyard Key from Bremur"},
			{ "stoneheart", "MeetMork", "Talk to Mork"},

		{ "eventSplits", "foresttemple", "Forest Temple"},
			{ "foresttemple", "Chest_A01_Nuos_Key_2", "first key"},
			{ "foresttemple", "Chest_A01_Nuos_MasterKey", "tree master key"},
			
		{ "eventSplits", "uthastemple", "Uthas Temple"},
			{ "uthastemple", "Chest_A01_Uthas_Key_05", "key by bossdoor"},
			{ "uthastemple", "Chest_A01_Uthas_MasterKey2", "top master key"},

		{ "eventSplits", "steamhouse", "Steam House"},
			{ "steamhouse", "SteamHouseMusicIntro", "Steam House Intro"},
			{ "steamhouse", "mirakey", "Steam Key"},
			{ "steamhouse", "SteamMachineActivator_2", "Fix Boiler 2"},
			{ "steamhouse", "Elevator_ExitArea_SteamHouse-RustCity", "Fix Last Boiler"},
			
			

	};

	settings.Add("transitions", false, "Area Transition Splits");
	settings.Add("shrines", false, "Shrine Splits");
	settings.Add("bosses", false, "Boss Splits");
	settings.Add("eventSplits", false, "Event Splits");
	settings.Add("debug", false, "[DEBUG] Show tracked values on overlay");
	
	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent	= _settings[i, 0];
		string id 		= _settings[i, 1];
		string desc 	= _settings[i, 2];

		settings.Add(id, false, desc, parent);
	}

	vars.splitName = "";
	vars.shrineBeen = new List<string>(){};
	vars.shrineBeen.Add("a");

	vars.PositionSplits = new Dictionary<int, Vector3f[]>
	{
		{
            1, // Name of streaming chunk 1 (fk)
            new Vector3f[]
			{
				new Vector3f(69660, -57300, -34000), // fk vessel
				new Vector3f(70000, -99000, -38000), // first fight
			} 
        },
		{
            0, // city
            new Vector3f[]
			{
				new Vector3f(49000, 0, -2500), // loading into city
			} 
        },
		{
            10, // AP
            new Vector3f[]
			{
				new Vector3f(-42600, -31700, 18500), // AP vessel
			} 
        },
		{
            11, // TG
            new Vector3f[]
			{
				new Vector3f(-61, -6700, 1400), // TG vessel
			}
		},
		{
			5, // FFR
            new Vector3f[]
			{
				new Vector3f(9000, 10700, -28000), // entry from tg
				//new Vector3f(5100, 11800, -29000), // idk what these coords are
				new Vector3f(-45400, -54300, -45000)
			} 
        },
	};

	Func<int, Vector3f, Tuple<bool, string>> CheckPositionSplits = (targetChunk, currentPosition) =>
    {
		if (targetChunk == null || currentPosition.Equals(new Vector3f(0, 0, 0)))
			return Tuple.Create<bool, string>(false, null);

        if (!vars.PositionSplits.ContainsKey(targetChunk))
            return Tuple.Create<bool, string>(false, null);

		var coordlist = vars.PositionSplits[targetChunk];
		var distanceThreshold = 1000; // Edit this to be whatever distance you need
		//1000 is enough to catch the entire vessel souls

        for (int i = 0; i < coordlist.Length; ++i)
        {
			var targetPosition = coordlist[i];
			var offset = currentPosition.Distance(targetPosition);

			if (offset > distanceThreshold)
				continue;

			string split = targetChunk + " Pos: " + targetPosition.ToString();
			vars.Log(split);

			return Tuple.Create(true, split);
        }

        return Tuple.Create<bool, string>(false, null);
    }; 
    vars.CheckPositionSplits = CheckPositionSplits;

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
					new StringWatcher(new DeepPointer(gWorld, 0x428, 0x28), 255) { Name = "WorldPath" },
					new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x188, 0x351)) { Name = "LastCheckpoint" },
					new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x30, 0xE8, 0x288, 0x700)) { Name = "StreamingChunk" },
					new MemoryWatcher<IntPtr>(new DeepPointer(gWorld, 0x188, 0x300 + 0x8)) { Name = "EventsArray"},
					new MemoryWatcher<int>(new DeepPointer(gWorld, 0x188, 0x300 + 0x8 + 0x8)) { Name = "EventsSize"},
					new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x30, 0xE8, 0x258, 0xe70)) { Name = "Cutscene" },
					new MemoryWatcher<Vector3f>(new DeepPointer(gWorld, 0x30, 0xE8, 0x258, 0x130, 0x1D0)){ Name = "PlayerPosition" },	
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
	current.Centiseconds = 2;
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
		vars.SetTextComponent("Pos:", vars.Data["PlayerPosition"].Current.ToString());
	} 
}

start
{
	if (current.Event != old.Event && current.Event == "IntroScene") //requires some extra logic on reset but is much faster
		return true;
	//return old.Centiseconds < 1f && current.Centiseconds >= 1f; //does work, is slower on activation
}

onStart
{
	vars.shrineBeen.Clear();
}

reset
{
	if (current.Event != old.Event && current.Event == "IntroScene")
		return true;
	return current.Centiseconds < 0.5f && current.Event != "IntroScene" && current.Event != "FixResolution";
}

gameTime
{
	if (current.Centiseconds == 2) //make sure the timer starts on 0.00
		return TimeSpan.FromSeconds(0f);
	if (current.Centiseconds > 0)
		return TimeSpan.FromSeconds(current.Centiseconds / 100f);
}

isLoading
{
	return true;
}

split
{
	if (vars.Data["WorldPath"].Current == "Menu/MainMenu")
		return false;

	// Split when event is updated
	if (vars.Data["EventsSize"].Changed)
	{
		if (current.Event == "TeleportTemple")
		{
			return settings[current.Event + vars.Data["StreamingChunk"].Current.ToString()];
		}
		return settings[current.Event];
	}

	// Split when fireshrine is updated
	if (vars.Data["LastCheckpoint"].Changed)
	{
		vars.splitName = "Shrine: " + vars.Data["LastCheckpoint"].Current;
		if (vars.shrineBeen.Contains(vars.Data["LastCheckpoint"].Current.ToString()))
			return false;
		if (settings[vars.splitName])
		{
				vars.shrineBeen.Add(vars.Data["LastCheckpoint"].Current.ToString());
				return true;
		}
	}
		

	// Split when streaming chunk changes (area transitions)
	if (vars.Data["StreamingChunk"].Changed)
	{		
		return settings["Area: " + vars.Data["StreamingChunk"].Old.ToString() + " -> " + vars.Data["StreamingChunk"].Current.ToString()];
	} 

	// Split when position matches in cutscene
	if (vars.Data["Cutscene"].Changed && vars.Data["Cutscene"].Current)
	{
		var split = vars.CheckPositionSplits(vars.Data["StreamingChunk"].Current, vars.Data["PlayerPosition"].Current);

		if (split.Item1) {
			return settings[split.Item2];
		}
	}
}
