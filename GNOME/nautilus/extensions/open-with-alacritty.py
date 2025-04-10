"""
Nautilus extension to open the current directory with Alacritty
"""

# Imports
from gi.repository import Nautilus, GObject
from subprocess import call
from typing import List

# Open with Alacritty Extension
class AlacrittyExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_background_items(self, current_folder: Nautilus.FileInfo) -> List[Nautilus.MenuItem]:
        """
        Creates a context-menu item for opening the current directory in Alacritty
        """
        item = Nautilus.MenuItem(
            name = "AlacrittyExtension::Open",
            label = "Open with Alacritty",
            tip = "Open the current directory in Alacritty"
        )
        item.connect("activate", self.open, [current_folder])
        return [item]

    def open(self, menu: Nautilus.MenuItem, files: Nautilus.FileInfo):
        """
        Opens the specified directory in Alacritty
        """
        for file in files:
            filepath = '"' + file.get_location().get_path() + '"'  # Quote paths to handle spaces and special characters
            call("alacritty " + "--working-directory " + filepath, shell=True)

