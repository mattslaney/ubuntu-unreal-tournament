#!/bin/bash

INSTALL=/usr/local/games/unrealtournament
DOWNLOADS=$HOME/Downloads

UT_GOTY_CD1="https://archive.org/download/ut-goty/UT_GOTY_CD1.iso"
UT_GOTY_CD2="https://archive.org/download/ut-goty/UT_GOTY_CD2.iso"
LATEST_PATCH="https://api.github.com/repos/OldUnreal/UnrealTournamentPatches/releases/latest"

# Fetch the ISOs
if [ ! -f "$DOWNLOADS/UT_GOTY_CD1.iso" ]; then
    echo "Downloading UT_GOTY_CD1.iso"
    curl -o "$DOWNLOADS/UT_GOTY_CD1.iso" -L $UT_GOTY_CD1 
fi

if [ ! -f "$DOWNLOADS/UT_GOTY_CD2.iso" ]; then
    echo "Downloading UT_GOTY_CD2.iso"
    curl -o "$DOWNLOADS/UT_GOTY_CD2.iso" -L $UT_GOTY_CD2  
fi

# Mount the ISOs
mkdir -p "$DOWNLOADS/UT_GOTY_CD1"
mkdir -p "$DOWNLOADS/UT_GOTY_CD2"
cd1=$(udisksctl loop-setup -f $DOWNLOADS/UT_GOTY_CD1.iso | grep -o '/loop[0-9]*')
cd2=$(udisksctl loop-setup -f $DOWNLOADS/UT_GOTY_CD2.iso | grep -o '/loop[0-9]*')
sudo mount "/dev$cd1" "$DOWNLOADS/UT_GOTY_CD1"
sudo mount "/dev$cd2" "$DOWNLOADS/UT_GOTY_CD2"

# Copy the Install Files over
sudo mkdir -p $INSTALL 
sudo cp -rv $DOWNLOADS/UT_GOTY_CD1/* $INSTALL
sudo cp -rv $DOWNLOADS/UT_GOTY_CD2/* $INSTALL

# Unmount the ISOs
sudo umount $DOWNLOADS/UT_GOTY_CD1
sudo umount $DOWNLOADS/UT_GOTY_CD2
udisksctl loop-delete -p "block_devices$cd1"
udisksctl loop-delete -p "block_devices$cd2"
rm -r "$DOWNLOADS/UT_GOTY_CD1"
rm -r "$DOWNLOADS/UT_GOTY_CD2"

# Fetch the latest OldUnreal Patch
patch_json=$(curl -s https://api.github.com/repos/OldUnreal/UnrealTournamentPatches/releases/latest)
patch_tag=$(echo $patch_json | jq -r '.tag_name')
echo "Latest patch version: $patch_tag"
if [ ! -f "$DOWNLOADS/$patch_tag.tar.bz2" ]; then
    patch_url=$(echo $patch_json | jq -r '.assets[] | select(.name | test("Linux-amd64")) | .browser_download_url')
    echo "Downloading $patch_url"
    curl -o "$DOWNLOADS/$patch_tag.tar.bz2" -L $patch_url
fi

# Apply the patch
sudo tar -xjvf "$DOWNLOADS/$patch_tag.tar.bz2" -C "$INSTALL"

# Create a link to the game binary
sudo ln -s $INSTALL/System64/ut-bin-amd64 /usr/local/games/ut

# Create a desktop entry
sudo bash -c 'cat <<EOL > "/usr/share/applications/unrealtournament.desktop"
[Desktop Entry]
Version='"$patch_tag"'
Type=Application
Name=Unreal Tournament
Comment=Play Unreal Tournament
Exec=/usr/local/games/unrealtournament/System64/ut-bin-amd64
Icon=/usr/local/games/unrealtournament/Help/Unreal.ico
Terminal=false
Categories=Game;
EOL'

