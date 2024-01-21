
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/SpatialMath } 

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
hello_world_device := class(creative_device):


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers: []player =  Playspace.GetPlayers()

        var FirstPosition: transform = transform{}
        var SecondPosition: transform = transform{}  
        
        if:
            FirstPlayer: player = AllPlayers[0]
            FortniteCharacter: fort_character = FirstPlayer.GetFortCharacter[]
            set FirstPosition = FortniteCharacter.GetTransform()
        then:
            Print("move or prepare to take damage")
            Sleep(10.0)

        if:
            Player:player = AllPlayers[0]
            FortniteCharacter: fort_character = Player.GetFortCharacter[]
            set SecondPosition = FortniteCharacter.GetTransform()
            DistanceBetweenPositions: float = DistanceXY(FirstPosition.Translation, SecondPosition.Translation)
            DistanceBetweenPositions < 1000.0

        then:
            Print("Distance moved {DistanceBetweenPositions}")
            Print("Applying damage")
            HurtPlayer(80.0)

    HurtPlayer(DamageAmount: float) : void = 
        # damages the playercharacter by 50
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers: []player =  Playspace.GetPlayers()

        if(Player: player = AllPlayers[0]):
            if(FortniteCharacter: fort_character = Player.GetFortCharacter[]):
                MyCharacterHealth: float = FortniteCharacter.GetHealth()
                DamageTodo: float = CalculateDamage(MyCharacterHealth, DamageAmount, 1.0)
                Print("Damage to do: {DamageTodo}")
                FortniteCharacter.Damage(DamageTodo)

    # HealPlayer method
    HealPlayer(HealAmount: float): void = 
        # heals the playercharacter by 50
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers: []player =  Playspace.GetPlayers()
        if (FirstPlayer: player = AllPlayers[0]) :
            if (FortniteCharacter: fort_character = FirstPlayer.GetFortCharacter[]) :
                FortniteCharacter.Heal(HealAmount)

    # Calculate damage
    CalculateDamage(PlayerHealth: float, DesiredDamageAmount: float, MinHealth: float): float =
         # If the damage amount would not eliminate the player, do that amount of damage
        if (PlayerHealth > DesiredDamageAmount) :
             return DesiredDamageAmount
        else if (PlayerHealth > MinHealth):
            return PlayerHealth - MinHealth
        else :
            return PlayerHealth