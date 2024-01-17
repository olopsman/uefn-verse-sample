
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }

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
        HurtPlayer()
        Print("Player hurt")
        HealPlayer()
        Print("Player healed")


    HurtPlayer(): void = 
        # damages the playercharacter by 50
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers: []player =  Playspace.GetPlayers()
        if (FirstPlayer: player = AllPlayers[0]) :
            if (FortniteCharacter: fort_character = FirstPlayer.GetFortCharacter[]) :
                FortniteCharacter.Damage(50.0)

    # HealPlayer method
    HealPlayer(): void = 
        # heals the playercharacter by 50
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers: []player =  Playspace.GetPlayers()
        if (FirstPlayer: player = AllPlayers[0]) :
            if (FortniteCharacter: fort_character = FirstPlayer.GetFortCharacter[]) :
                FortniteCharacter.Heal(50.0)