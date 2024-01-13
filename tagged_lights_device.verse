
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Simulation }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# Derive from the `tag` class in the Verse.org/Simulation/Tags module to create a new Gameplay Tag.
puzzle_light := class(tag){}

log_tagged_lights_puzzle := class(log_channel){}

# A Verse-authored creative device that can be placed in a level
tagged_lights_device := class(creative_device):

    # default state
    @editable
    var LightsState : []logic = array{false, false, false, false}

    # array to store customizable devices tagged with puzzle light tag
    @editable
    var Lights : []customizable_light_device = array{}

    # method to setup the puzzle
    SetupPuzzleLights() :  void =
        Logger.Print("Setting up puzzle lights")

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Hello, world!")
        Print("2 + 2 = {2 + 2}")