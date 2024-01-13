
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

    @editable
    Buttons : []button_device = array{}

    @editable
    ItemSpawner : item_spawner_device = item_spawner_device{}

    ButtonsToLights : [][]int = array{array{0,3}, array{0, 1, 2}, array{0, 1}, array{1} }

    @editable
    var SolvedLightsState : []logic = array{true, true, true, true}

    # method to setup the puzzle
    SetupPuzzleLights() :  void =
        # find all devices tagged with puzzle light tag and save them in an array named TaggedActors(inferred)
        TaggedActors := GetCreativeObjectsWithTag(puzzle_light{})
        <#
        For each device with the puzzle_light tag, check if it's a customizable_light_device by trying to cast it to that type.
        If it is, get its initial LightState to TurnOn() or TurnOff() the LightDevice.
        Save all the tagged customizable_light_device in the Lights array.
        #>
        set Lights = for:
            ActorIndex -> TaggedActor : TaggedActors
            # cast the actor to a customizable light device
            LightDevice := customizable_light_device[TaggedActor]
            ShouldLightBeOn := LightsState[ActorIndex]
        do:
            Print("Adding light at index {ActorIndex} to Lights array with State: {if (ShouldLightBeOn?) then "On" else "Off"}")
            if (ShouldLightBeOn?) then LightDevice.TurnOn() else LightDevice.TurnOff()
            LightDevice
           

    ToggleLights(LightIndices : []int) : void =
        # for each light index in the array, toggle the light
        for:
            LightIndex : LightIndices
            Light := Lights[LightIndex]
            IsLightOn := LightsState[LightIndex]
        do:
            Print("Toggling light at index {LightIndex} {if (IsLightOn?) then "Off" else "On"}")       
            NewLightState :=
                if (IsLightOn?):
                    Light.TurnOff()
                    false
                else:
                    Light.TurnOn()
                    true
            if(set LightsState[LightIndex] = NewLightState) : 
                Print("updated the state for light at {LightIndex}")

        if (IsPuzzleSolved[]):
            Print("Puzzle solved")
            ItemSpawner.Enable()

    IsPuzzleSolved()<decides><transacts> : void =
      
        for:
            LightIndex -> IsLightOn : LightsState
            IsLightOnInSolution := SolvedLightsState[LightIndex]
        do:
            IsLightOn = IsLightOnInSolution
        
        # Print("Checking if puzzle is solved")
        
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        SetupPuzzleLights()

        for:
            ButtonIndex -> Button : Buttons
            LightIndices := ButtonsToLights[ButtonIndex]
        do:
#            button_event_handler{Indices := LightIndices, PuzzleDevice := Self}
            Button.InteractedWithEvent.Subscribe(button_event_handler{Indices := LightIndices, PuzzleDevice := Self}.OnButtonPressed)



        # Use the first element of ButtonsToLights to test the method ToggleLights
        if (LightIndices : []int = ButtonsToLights[0]) :
            ToggleLights(LightIndices)

button_event_handler := class():
    # Positions used to access the lights this button controls.
    Indices : []int
    # tagged_lights_puzzle that created this button_event_handler so we can call functions on it.
    PuzzleDevice : tagged_lights_device

    OnButtonPressed(InPlayer: agent) : void =
        # Tell the PuzzleDevice to toggle the lights at the positions this button controls.
        PuzzleDevice.ToggleLights(Indices)