state("Anthem")
{
	bool isLoading: 0x046C63E0, 0x128;
	bool matchmaking: 0x475E190;
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var timingMessage = MessageBox.Show(
			"This game uses RTA w/o Loads as the main timing method.\n"
			+ "LiveSplit is currently set to show Real Time (RTA).\n"
			+ "Would you like to set the timing method to RTA w/o Loads?",
			"Anthem | LiveSplit",
			MessageBoxButtons.YesNo, MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
}

exit
{
	timer.IsGameTimePaused = true;
}

isLoading
{
	if (current.isLoading) return true;
	if (current.matchmaking) return true;
	return false;
}
