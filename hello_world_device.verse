
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
hello_world_device := class(creative_device):

    # editable modifier to allow the button to be configured in the UI
    @editable
    MyButtonDevice: button_device = button_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Hello, world!")
        Print("2 + 2 = {2 + 2}")
        MyButtonDevice.InteractedWithEvent.Subscribe(OnButtonInteractedWith)

    # method
    OnButtonInteractedWith(InAgent: agent): void =
        Print("Player interacted with button")