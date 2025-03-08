state("Tenerezza", "v1.0")
{
    ushort      bossHP: 0x9194C, 0x88;
    uint        inBossFight: 0x914B4;
    string32    Event: 0xAFD0, 0x1A0;
    string32    Location: 0xAFD0, 0x212;
    byte        flagIndy1: 0x8FAAB;  // Rescued Indy in the Wastelands stage. (Value 0->1)
    byte        flagIndy2: 0x8FAB8;  // Found Indy in Forest stage. (Value 2->3)
    byte        flagKathy: 0x8FAC3;  // Retrieved gems from Kathy in Forest Stage. (Value 0->1)
}

state("Tenerezza", "v1.0.0.1")
{
    ushort      bossHP: 0xA250C, 0x88;
    uint        inBossFight: 0xA2074;
    string32    Event: 0xAFD0, 0x1A0;
    string32    Location: 0xAFD0, 0x212;
    byte        flagIndy1: 0xA066B;  // Rescued Indy in the Wastelands stage. (Value 0->1)
    byte        flagIndy2: 0xA0678;  // Found Indy in Forest stage. (Value 2->3)
    byte        flagKathy: 0xA0683;  // Retrieved gems from Kathy in Forest Stage. (Value 0->1)
}

init {
    if (modules.First().ModuleMemorySize == 2646016) {
        version = "v1.0";
    } else if (modules.First().ModuleMemorySize == 2719744) {
        version = "v1.0.0.1";
    }
}

startup
{
    refreshRate = 30;

    settings.Add("splits", true, "Split Points");
    settings.CurrentDefaultParent = "splits";
    settings.Add("IndyCS1Flag", true, "Indy Wastelands Cutscene (インディーCS1)");
    settings.Add("k_St2_SP01.SCR", true, "Lolo (ロロ)");
    settings.Add("K_Sp06_Room03.SCR", true, "Shalom (シャーロム)");
    settings.Add("k_St3_P05.SCR", true, "Cellius (セリウス)");
    settings.Add("IndyCS2Flag", true, "Indy Forest Cutscene (インディーCS2)");
    settings.Add("K_Sp12_WindGorge_Sp.SCR", true, "Nuvola (ヌーヴォラ)");
    settings.Add("k_St5_P04.SCR", true, "Mercurio (メリクーリオ)");
    settings.Add("KathyCSFlag", true, "Kathy Forest Cutscene (キャッシィCS)");
    settings.Add("k_st1_act7.SCR", true, "Croix (クロワ)");
    settings.Add("K_Sp06_Room15.SCR", true, "Shalom SE (シャーロムSE)");
    settings.Add("K_Sp08_Room01.SCR", true, "Eleky (エレキ)");
    settings.Add("K_Sp05_P06.SCR", true, "Shalom XP (シャーロムXP)");
    settings.Add("K_Sp05_P07.SCR", true, "Dezelt (デゼルと)");
}

start
{
    return current.Event == "PARA.SCR" && old.Location == "" && current.Location == "town_part01.SCR";
}

split
{
    bool bossDefeated = old.bossHP != current.bossHP && current.bossHP == 0 && current.inBossFight == 1;

    if (settings["IndyCS1Flag"] && old.flagIndy1 == 0 && current.flagIndy1 == 1) return true;
    if (settings["IndyCS2Flag"] && old.flagIndy2 == 2 && current.flagIndy2 == 3) return true;
    if (settings["KathyCSFlag"] && old.flagKathy == 0 && current.flagKathy == 1) return true;

    if (bossDefeated) {
        if (settings[current.Location]) return true;
    }
}

reset
{
    return old.Event != current.Event && current.Event == "PARA.SCR" && current.Location == "";
}