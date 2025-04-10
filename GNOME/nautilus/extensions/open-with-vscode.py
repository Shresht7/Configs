"""
Open the selected file or directory with Visual Studio Code
"""

# Imports
from gi.repository import Nautilus, GObject
from subprocess import call

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
    
    def open_vscode(self, menu, files):
        for file in files:
            filepath = '"' + file.get_location().get_path() + '"'   # Quote paths to avoid path shenanigans
            call("code " + filepath, shell=True)

            
