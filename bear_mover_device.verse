
using { /Fortnite.com/Devices }
using {/Fortnite.com/Characters}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
bear_mover_device := class(creative_device):
    @editable var Monster : creative_prop = creative_prop{}
    @editable var MonsterMutator: mutator_zone_device = mutator_zone_device{}
    @editable var EndCinematic : cinematic_sequence_device = cinematic_sequence_device{}
    @editable var FlashlightGranter : item_granter_device = item_granter_device{}
    @editable var GameMusic: audio_player_device = audio_player_device{}
    @editable var RadioDeviceGame : radio_device = radio_device{}
    @editable var RadioDeviceChase : radio_device = radio_device{}    

    var MonsterSpottedPlayer: logic = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # Subscribe to the mutator's events
        MonsterMutator.AgentEntersEvent.Subscribe(OnPlayerSpotted)
        #get the player
        Players := GetPlayspace().GetPlayers()
            if(Player := Players[0], Agent := agent[Player]):
                GameMusic.Register(Agent)
                RadioDeviceChase.Stop()
                RadioDeviceChase.Register(Agent)
                FlashlightGranter.GrantItem(Agent)


    OnPlayerSpotted(Agent: agent): void =
        # if monsterspottedplayer is already true then spotted again- we end the game
        if(MonsterSpottedPlayer = true):
           Monster.Dispose()
           EndCinematic.Play()
        else:

            RadioDeviceGame.Stop()
            RadioDeviceChase.Play()
            Players := GetPlayspace().GetPlayers()
            if(Player := Players[0]):
                spawn:
                    FirstEncounterCoolDown()
                spawn:
                    FollowPlayer(Monster, Player)

    FirstEncounterCoolDown()<suspends>:void =
        Sleep(2.0)
        set MonsterSpottedPlayer = true

    FollowPlayer(Enemy : creative_prop, Player : player)<suspends>: void =
        var PreviousTime : float = GetSimulationElapsedTime()
        MoveSpeed := 0.1
        loop:
                Sleep(0.0)
                CurrentTime := GetSimulationElapsedTime()
                DeltaTime := CurrentTime - PreviousTime
                set PreviousTime = CurrentTime
                if(PlayerCharacter := Player.GetFortCharacter[], Enemy.IsValid[]):
                    PropLocation := Enemy.GetTransform().Translation
                    PlayerLocation := PlayerCharacter.GetTransform().Translation


                    #Rotate the player z rotation to face the player location
                    if(LookDirection := (PlayerLocation - PropLocation).MakeUnitVector[]):
                        Yaw := RadiansToDegrees(ArcTan(LookDirection.Y, LookDirection.X)) - 90.0
                        Pitch := 0.0 #RadiansToDegrees(ArcTan(LookDirection.Z, Sqrt((LookDirection.X * LookDirection.X) + (LookDirection.Y * LookDirection.Y))))
                        Roll := 0.0

                        NewRotation := MakeRotationFromYawPitchRollDegrees(Yaw, Pitch, Roll)

                        #Movement
                        LerpLocation := Lerp(PropLocation, PlayerLocation, DeltaTime * MoveSpeed)
                        FinalLocation := vector3{X := LerpLocation.X, Y:= LerpLocation.Y, Z:= PropLocation.Z}

                        if:
                            Enemy.TeleportTo[FinalLocation, NewRotation]
