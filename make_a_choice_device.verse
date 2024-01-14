
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
make_a_choice_device := class(creative_device):

    @editable
    MakeChoice: trigger_device = trigger_device{}

    @editable
    RedButton: button_device = button_device{}

    @editable
    BlueButton: button_device = button_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        MakeChoice.TriggeredEvent.Await()

        race:
            block:
                RedButton.InteractedWithEvent.Await()
                Print("Red button pressed")
            block:
                BlueButton.InteractedWithEvent.Await()
                Print("Blue button pressed")
