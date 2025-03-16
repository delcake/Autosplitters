state("ffxiv_dx11", "2025.02.27.000.000(11450158)")
{
    uint playerStatus: 0x25E2980, 0x1D0;
    /*
        0 = Online
        5 = Link Dead
        12 = Busy
        14 = Triple Triad Match
        15 = Cutscene
        17 = AFK
        18 = Group Pose
        21 = Looking to Meld Materia
        22 = Roleplaying
        23 = Looking for Party
        25 = Duty Registration Pending
        26 = Party Finder Active
        27 = Mentor
        28 = PvE Mentor
        29 = Trade Mentor
        30 = PvP Mentor
        31 = Returning Adventurer
        32 = New Adventurer
    */
    ulong promptState: 0x25DF670, 0x8, 0x90, 0x50, 0x70;
    string64 questName: 0x27CD618, 0x18, 0xE0, 0x238, 0xE2;
}

startup
{
    vars.startingQuests = new List<string>() {
        // A Realm Reborn
        "To the Bannock",           // Gridania
        "On to Summerford",         // Limsa Lominsa
        "We Must Rebuild",          // Ul'dah
        "It's Probably Pirates",
        "Shadow of Darkness",
        "All Good Things",
        "The Price of Principles",
        "Traitor in the Midst",
        // Heavensward
        "Coming to Ishgard",
        "The Wyrm's Lair",
        "An Uncertain Future",
        "Promises Kept",
        // Stormblood
        "Beyond the Great Wall",
        "Here There Be Xaela",
        "Arenvald's Adventure",
        "Sisterly Act",
        // Shadowbringers
        "The Syrcus Trench",
        "When It Rains",
        "Shaken Resolve",
        "Alisaie's Quest",
        // Endwalker
        "The Next Ship to Sail",
        "Skies Aflame",
        "Newfound Adventure",
        "Currying Flavor",
        // Dawntrail
        "A New World to Explore",
        "The Long Road to Xak Tural",
        // Hildibrand
        "The Rise and Fall of Gentlemen",
        "A Gentleman Falls, Rather than Flies",
        "A Hingan Tale: Nashu Goes East",
        "The Sleeping Gentleman"
    };
}

start
{
    // Start on accepting the opening quest of any NG+ category, with
    // fallback to handle quests that launch directly into a cutscene.
    if (old.promptState == 1 && current.promptState == 0) {
        return vars.startingQuests.Contains(current.questName);
    } else if (current.playerStatus == 15 && current.playerStatus != old.playerStatus) {
        return vars.startingQuests.Contains(current.questName);
    }
}

split
{
    // Splits on any quest complete.
    return old.promptState == 2 && current.promptState == 0;
}