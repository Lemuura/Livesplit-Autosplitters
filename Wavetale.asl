state("Wavetale")
{
	bool isLoading : "GameAssembly.dll", 0x02801DD8, 0xB8, 0xA8, 0x100, 0x48, 0x138, 0x98;
	int scene : "UnityPlayer.dll", 0x184A0D0, 0x48, 0x98;
	string255 cutscene : "UnityPlayer.dll", 0x017E11B8, 0xB8, 0x8, 0xA0, 0x120, 0x10, 0x48, 0x0;
	string255 dialog : "GameAssembly.dll", 0x02801DD8, 0xB8, 0xA8, 0x110, 0x148, 0x50, 0x10, 0x30, 0x60, 0x1E;
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var timingMessage = MessageBox.Show(
			"This game uses RTA w/o Loads as the main timing method.\n"
			+ "LiveSplit is currently set to show Real Time (RTA).\n"
			+ "Would you like to set the timing method to RTA w/o Loads?",
			"Wavetale | LiveSplit",
			MessageBoxButtons.YesNo, MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}

	settings.Add("0", true, "Place seed in Dandelion Core (end of run)");

	settings.Add("orchard", false, "Night Orchard");
	settings.Add("20", false, "Tutorial", "orchard");
	settings.Add("1", false, "Lighthouse Charged", "orchard");

	settings.Add("plaza", false, "Plaza");
	settings.Add("2", false, "Reach Plaza", "plaza");
	settings.Add("21", false, "Return Sparks", "plaza");
	settings.Add("3", false, "Sparkcaster Activated", "plaza");

	settings.Add("rig", false, "Rig Field");
	settings.Add("4", false, "Rescued Klout", "rig");
	settings.Add("5", false, "Emergency Switch Activated", "rig");
	settings.Add("22", false, "Back to Plaza", "rig");
	settings.Add("6", false, "Returned to Orchard", "rig");

	settings.Add("sleepy", false, "Sleepy Triplets");
	settings.Add("7", false, "Serpent Reveal", "sleepy");
	settings.Add("8", false, "Talk to Edward", "sleepy");
	settings.Add("23", false, "Spark Tank Fuse", "sleepy");
	settings.Add("9", false, "Activated Spark Tank", "sleepy");
	settings.Add("10", false, "Returned to Orchard", "sleepy");

	settings.Add("candle", false, "Candle Hill");
	settings.Add("11", false, "Charlie Encounter", "candle");
	settings.Add("12", false, "Start Boss Fight", "candle");
	settings.Add("13", false, "Finished Boss Fight", "candle");
	settings.Add("14", false, "Filling Station Complete", "candle");

	settings.Add("needle", false, "Needleprick Peaks");
	settings.Add("15", false, "Rufus Gloomed Up", "needle");
	settings.Add("16", false, "Whistlers Saves Sigrid", "needle");
	settings.Add("17", false, "Returned to Orchard", "needle");

	settings.Add("flowering", false, "Flowering Archipelago");
	settings.Add("18", false, "Inside the Carcass", "flowering");
	settings.Add("19", false, "Boss Fight", "flowering");

	vars.completedSplits = new List<string>{};
	vars.splitList = new List<string>
	{
		"CutScn_Dandelion_DandelionBreaks_01_PP",
		"NIGHTORCHARD_LighthouseCharged", 						// After we finish the first quest
		"PLAZA_ReachPlaza", 									// When we enter the Plaza for the first time and talk to Morris
		"PLAZA_SparkcasterActivated", 							// At the end of Plaza, after activating the Sparkcaster
		"CutScn_RigfieldEast_RescuingKlout_01_PP", 				// After we enter Rigfield and save Klout
		"PLAZA_EmergencySwitchActivated", 						// At the end of Rigfield
		"NIGHTORCHARD_FogPushed", 								// After returning to the Orchard
		"SLEEPY_SigridSerpentSlithers", 						// During Sleepy Triplets intro 
		"SLEEPY_EdwardSparkTank", 								// First time talking to Edward
		"SLEEPY_EdwardTankActivated", 							// After completing Sleepy Triplets
		"NIGHTORCHARD_NeedPirates", 							// After returning to the Orchard
		"CANDLEHILL_CharlieEncounter",							// After arriving to Candle Hill
		"CANDLEHILL_SerpentRising",								// Boss fight
		"CANDLEHILL_FindPeppie",								// End of boss fight
		"CANDLEHILL_FillingStationComplete",					// End of Candle Hill
		"NEEDLEPRICK_RufusGloomedUp",							// Arrived at Needle Prick
		"CutScn_NeedlePrickPeaks_WhistlersSavesSigrid_01_PP",	// End of Needle Prick
		"CutScn_NightOrchard_QuarrelWithGrandma_01_PP",			// Return to the Orchard
		"FLOWERING_InsideTheCarcass", 							// Inside the Carcass
		"DANDELION_TheCore",									// Final boss
		"CutScn_NightOrchard_TheWave_01_PP",
		"PLAZA_ReturnSparksContinued",
		"PLAZA_BackAtPlaza",
		"SLEEPY_EdwardSparkTankFuse",
	};	
}

split
{
	string split = null;

	if (old.dialog != current.dialog)
		split = current.dialog;
		
	if (old.cutscene != current.cutscene)
		split = current.cutscene;

	if (split == null || vars.completedSplits.Contains(split))
		return;
	
	if (vars.splitList.Contains(split))
	{
		vars.completedSplits.Add(split);
		return settings[vars.splitList.IndexOf(split).ToString()];
	}	
}

start
{
	return current.scene == 2;
}

onStart
{
	vars.completedSplits.Clear();
}

isLoading
{
	return (current.isLoading || current.scene == 3);
}