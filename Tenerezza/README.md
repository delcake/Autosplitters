This ASL auto splitter supports both version 1.0 and 1.0.0.1 of Tenerezza, and can be used with [LiveSplit](https://livesplit.org/) to:

1. Start the timer when beginning any game mode (NG/NG+).
2. Split on every boss defeated at the moment they reach zero HP.
3. Split on the completion of certain mandatory cutscenes that advance the game.
4. Reset an active run when quitting to main menu.

This autosplitter is available directly in LiveSplit, and you only need to choose to Activate it when configuring your splits for the game. If you prefer to use the Scriptable Auto Splitter component method, perform the following steps:

1. Add a Scriptable Auto Splitter component to your LiveSplit layout.
2. Select the `Tenerezza.asl` file within the component's layout settings.
3. De-select any functions or individual splits you don't want the auto splitter to manage for you.

Known issues:

1. It is possible to cause a split by defeating a boss, but still die before the boss fight fully finishes. If choosing the continue the run, roll back the split before re-fighting the boss as the next boss death will re-trigger the split.