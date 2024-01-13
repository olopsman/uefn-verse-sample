
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
spawner_button := class(creative_device):

    @editable
    Button: button_device = button_device{}

    @editable
    ItempSpawner: item_spawner_device = item_spawner_device{}

    # Container for storing event subscriptions
    var Subscriptions: []cancelable = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        ButtonSubscription := Button.InteractedWithEvent.Subscribe(OnButtonInteractedWith)

        # Add the subscription to the Subscriptions array so that it can be cancelled later
        if (set Subscriptions[0] = ButtonSubscription) :
            Print("Subscribed to the button's InteractedWithEvent and set subscription in Subscriptions")


    OnButtonInteractedWith(InPlayer: agent): void =      
        ItempSpawner.SpawnItem()
        Print("Player interacted with button and spawned item")
        var Coins : int = 500
        Print("Coins: {Coins}")
        Cents := 200
        Print("Cents: {Cents}")
        # Acccess the cancelable variable for the InteractedWithEvent subscription
        if (ButtonSubscription := Subscriptions[0]):
            # Cancel the subscription
            ButtonSubscription.Cancel()
            Print("Unsubscribed from the button's InteractedWithEvent and removed subscription from Subscriptions")