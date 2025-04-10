"""
Open the selected file or directory with Visual Studio Code
"""

# Imports
from gi.repository import Nautilus, GObject
from subprocess import call
from typing import List

# Open with VSCode Extension
class VSCodeExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_file_items(self, files):
        item = Nautilus.MenuItem(
            name="VSCodeExtension::Open",
            label="Open with VS Code",
            tip="Opens the selected files with Visual Studio Code"
        )
        item.connect("activate", self.open_vscode, files)
        return [item]
    
    def get_background_items(self, current_folder: Nautilus.FileInfo) -> List[Nautilus.MenuItem]:
        """
        Handles the context-menu option when right-clicking an empty space in a directory
        """
        item = Nautilus.MenuItem(
            name = "VSCodeExtension::OpenDirectory",
            label = "Open with VS Code",
            tip = "Opens the current directory with Visual Studio Code"
        )
        item.connect("activate", self.open_vscode, [current_folder])
        return [item]

    def open_vscode(self, menu, files):
        for file in files:
            filepath = '"' + file.get_location().get_path() + '"'   # Quote paths to avoid path shenanigans
            call("code " + filepath, shell=True)

            
