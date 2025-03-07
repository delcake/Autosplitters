state("PAWin32Submission", "HD Remaster")
{
    uint chapter: 0xC77458, 0x8, 0x0, 0x8, 0x4C;
    uint bossHP: 0xCB31E4, 0xC0, 0x8, 0xC40;
    uint bossMaxHP: 0xCB31E4, 0xC0, 0x8, 0xC44;
}

start
{
    // Only works on fresh launch of the game. Chapter value isn't reset
    // when returned to the main menu. Need to determine a better option.
    if (old.chapter == 99 && current.chapter == 0) {
        return true;
    }
}

split
{
    // Motorcycle segment counts as a separate chapter, so disregard when it occurs.
    if (old.chapter == 83 || current.chapter == 83) {
        return false;
    }

    // Final split occurs on scripted last hit to boss.
    if (current.chapter == 11 && current.bossMaxHP == 42000) {
        return old.bossHP == 100 && current.bossHP == 0;
    }

    // Otherwise, simply split when moving to a new chapter.
    return old.chapter != current.chapter;
}
