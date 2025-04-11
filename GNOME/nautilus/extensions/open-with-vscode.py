"""
Nautilus extension to open selected files or directories in Visual Studio Code.
"""

# Imports
from gi.repository import Nautilus, GObject
from subprocess import call
from typing import List

# Open in VSCode Extension
class VSCodeExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_file_items(self, files: List[Nautilus.FileInfo]) -> List[Nautilus.MenuItem]:
        """
        Creates a context menu item for opening selected files or directories in Visual Studio Code.
        """
        item = Nautilus.MenuItem(
            name = "VSCodeExtension::Open",
            label = "Open in VS Code",
            tip = "Opens the selected files in Visual Studio Code"
        )
        item.connect("activate", self.open_vscode, files)
        return [item]
    
    def get_background_items(self, current_folder: Nautilus.FileInfo) -> List[Nautilus.MenuItem]:
        """
        Creates a context menu item for opening the current directory in Visual Studio Code.
        """
        item = Nautilus.MenuItem(
            name = "VSCodeExtension::OpenDirectory",
            label = "Open in VS Code",
            tip = "Opens the current directory in Visual Studio Code"
        )
        item.connect("activate", self.open_vscode, [current_folder])
        return [item]

    def open_vscode(self, menu: Nautilus.MenuItem, files: List[Nautilus.FileInfo]):
        """
        Opens the specified files or directories in Visual Studio Code using the `code` CLI.
        """
        for file in files:
            filepath = '"' + file.get_location().get_path() + '"'  # Quote paths to handle spaces and special characters
            call("code " + filepath, shell=True)
