#!/bin/bash

# Copy selected files to the sync folder (~/Sync)

# Exit the script on any errors as this will run in the background, we don't want it to be stuck and taking up memory
set -e  # Causes the script to exit im immediately if there are any errors.
set -u  # Causes the script to exit if we do not define a variable when it is expanded.
set -o pipefail # Makes sure that if any part of a pipeline fails, the script knows about.

# Path to the sync folder
SYNC_FOLDER=~/Sync

# Ensure the sync folder exists
mkdir -p "$SYNC_FOLDER"

# Copy each selected file to the sync folder
for file in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    if [ -f "$file" ]; then # if, file
        cp "$file" "$SYNC_FOLDER"
    elif [ -d "$file" ]; then # else if directory
        cp -r "$file" "$SYNC_FOLDER"
    fi
done

# Notify the user
notify-send "Nautilus Script" "Files copied to the Sync folder"
