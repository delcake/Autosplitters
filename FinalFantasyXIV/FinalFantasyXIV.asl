// Version: 2025.02.27.000.000(11450158)
state("ffxiv_dx11")
{
    ulong questPrompt: 0x25DF670, 0x8, 0x90, 0x50, 0x70;
}

start
{
    // Start on accepting a quest.
    return old.questPrompt == 1 && current.questPrompt == 0;
}

split
{
    // Splits on quest complete.
    return old.questPrompt == 2 && current.questPrompt == 0;
}