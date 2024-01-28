
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

##import ui
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath}

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
coin_counter_accolade_device := class(creative_device):

    @editable
    AccoladeDevice : accolades_device = accolades_device{}

    #Gold Totals
    GoldTotal: int = 10
    var GoldCollected: int = 0

    # get player location so we can display the ui
    var Players : []player = array{}
    var UIButton : button_loud = button_loud{}



    TextForUI<localizes>(Collected: int, Total: int) : message = "Gold Collected : {Collected} / {Total}"   

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        #subscribe to the accolade device
        AccoladeDevice.TestAwardEvent.Subscribe(GoldCounter)

        #get player
        set Players = GetPlayspace().GetPlayers()
        if (Player := Players[0]):
            CreateUI(Player)

    GoldCounter(Agent: agent): void =
        set GoldCollected += 1
        Print("Gold {GoldCollected}")
        ## change the text on the ui
        UIButton.SetText(TextForUI(GoldCollected, GoldTotal))

    CreateUI(Player: player): void =
        #create the ui
        if(PlayerUI := GetPlayerUI[Player]):
            UIButton.SetText(TextForUI(0, GoldTotal))
            MyCanvas : canvas = canvas:
                Slots := array:
                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 0.15, Y := 0.0}, Maximum := vector2{X := 0.15, Y := 0.0}}
                        Offsets := margin{Top := 50.0, Left := 50.0, Right := 50.0, Bottom := 50.0}
                        Alignment := vector2{X := 0.5, Y := 0.5}
                        SizeToContent := true
                        Widget := UIButton
            PlayerUI.AddWidget(MyCanvas)