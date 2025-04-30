state("ffxiv_dx11") {}

// It may be required to run LiveSplit as an Administrator to be able to use the autosplitter on vanilla FFXIV installations.

startup
{
    // Define all settings for the autosplitter.
    settings.Add("options", true, "Advanced Options");
	settings.Add("debug_file", false, "Save debug log to LiveSplit program directory", "options");
}

init
{
    // Debug message handler
	string DebugPath = System.IO.Path.GetDirectoryName(Application.ExecutablePath) + "\\" + game.ProcessName + "_debug.log";
	Action<string> DebugLog = (message) => {
		message = "[" + DateTime.Now.ToString("HH:mm:ss") + "] " + message;
		if (settings["debug_file"]) {
			using(System.IO.StreamWriter stream = new System.IO.StreamWriter(DebugPath, true)) {
				stream.WriteLine(message);
				stream.Close();
			}
		}
		print("[FFXIV_LR] " + message);
	};
	vars.DebugLog = DebugLog;

	// Establish required pointer locations.
    IntPtr loadingRelPtr = IntPtr.Zero;
	IntPtr activeCharacterRelPtr = IntPtr.Zero;

    var loadingTarget = new SigScanTarget(3, "48 8B 05 ?? ?? ?? ?? 4C 8B 40 ?? 45 8B 40");
	var activeCharacterTarget = new SigScanTarget(3, "48 8D 05 ?? ?? ?? ?? 8B 6C 24");

	var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);

	bool scanningError = false;
    if ((loadingRelPtr = scanner.Scan(loadingTarget)) != IntPtr.Zero) {
        print("Loading signature found at 0x" + loadingRelPtr.ToString("X"));
    } else {
		scanningError = true;
	}
	
	if ((activeCharacterRelPtr = scanner.Scan(activeCharacterTarget)) != IntPtr.Zero) {
		print("Active character signature found at 0x" + activeCharacterRelPtr.ToString("X"));
	} else {
		scanningError = true;
	}
	
	if (scanningError) {
		throw new Exception("[FFXIV_LR] Unable to locate one or more critical signatures");
	}

	vars.loadingRelPtr = loadingRelPtr;
    vars.loadingPtr = loadingRelPtr + 0x4 + game.ReadValue<int>(loadingRelPtr);

	vars.activeCharacterRelPtr = activeCharacterRelPtr;
	vars.activeCharacterPtr = activeCharacterRelPtr + 0x4 + game.ReadValue<int>(activeCharacterRelPtr);

	vars.watchers = new MemoryWatcherList() {
        (vars.loading = new MemoryWatcher<int>(new DeepPointer(vars.loadingPtr, 0x20, 0x6910, 0x178, 0x8))),
		(vars.activeCharacter = new MemoryWatcher<int>(new DeepPointer(vars.activeCharacterPtr, 0x30)))
	};
}

update
{
	// Perform all watcher state updates.
	vars.watchers.UpdateAll(game);
}

exit
{
	// Pause the timer if the process is closed, such as if the game has crashed.
	timer.IsGameTimePaused = true;
}

isLoading
{
	return vars.loading.Current == 1 || vars.activeCharacter.Current == 0;
}

onStart
{
	vars.DebugLog("Timer started");
	vars.DebugLog(" - Loading signature position: 0x" + vars.loadingRelPtr.ToString("X"));
    vars.DebugLog(" - Loading pointer position: 0x" + vars.loadingPtr.ToString("X"));
	vars.DebugLog(" - Active character signature position: 0x" + vars.activeCharacterRelPtr.ToString("X"));
	vars.DebugLog(" - Active character pointer position: 0x" + vars.activeCharacterPtr.ToString("X"));
}