
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
accolade_example_device := class(creative_device):

    @editable
    Accolades:accolades_device = accolades_device{}
       
    @editable
    ConditionalButton:conditional_button_device = conditional_button_device{}

    OnBegin<override>()<suspends>:void=
        ConditionalButton.ActivatedEvent.Subscribe(BountyComplete)

    # Awards score to the player who activated
    # the ConditionalButton
    BountyComplete(Agent:agent):void=
        Accolades.Award(Agent)