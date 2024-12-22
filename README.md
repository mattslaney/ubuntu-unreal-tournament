# Ubuntu Unreal Tournament
Simple bash script to download and install UT GOTY on Ubuntu

Now that Epic Games have handed maintenance of the game over to OldUnreal and that the game is available freely and legally from archive.org OldUnreal host full game installers here. Unfortunately there is only a windows installer at present
 * https://www.oldunreal.com/downloads/unrealtournament/full-game-installers/

This script is to temporarily bridge the gap and allow me to install UT on Ubuntu from the same official source and apply the latest OldUnreal patch.
 * https://archive.org/details/ut-goty
 * https://github.com/OldUnreal/UnrealTournamentPatches

### Script Steps
 1. Downloads the two CD ISO's and latest patch 
 2. Mounts the iso's and copies the install files over to the install directory
 3. Apply the latest patch to the install directory
 4. Creates a 'ut' symlink in the games folder and creates a desktop entry

