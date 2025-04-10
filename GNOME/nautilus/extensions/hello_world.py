from gi.repository import Nautilus, GObject

class HelloWorldExtension(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        pass

    def get_file_items(self, files):
        item = Nautilus.MenuItem(
            name="HelloWorldExtension::HelloWorld",
            label="Say Hello",
            tip="Say Hello to the World"
        )
        item.connect("activate", self.say_hello)
        return [item]
    
    def say_hello(self, files):
        print("Hello World")
