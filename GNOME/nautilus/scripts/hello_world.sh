#!/bin/bash

# Exit the script on any errors as this will run in the background, we don't want it to be stuck and taking up memory
set -e  # Causes the script to exit im immediately if there are any errors.
set -u  # Causes the script to exit if we do not define a variable when it is expanded.
set -o pipefail # Makes sure that if any part of a pipeline fails, the script knows about.

zenity --info --title "Selected Files" --text "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
