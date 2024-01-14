using { /Fortnite.com/Devices }
 using { /Verse.org/Simulation }

 spawner_button := class(creative_device):
     @editable
     Button:button_device = button_device{}
     @editable
     ItemSpawner:item_spawner_device = item_spawner_device{}

     # Container for storing event subscriptions
     var Subscriptions:[]cancelable = array{}

     OnBegin<override>()<suspends>:void=
         ButtonSubscription := Button.InteractedWithEvent.Subscribe(OnButtonInteractedWith)

         # Add the cancelable result to a spot in the Subscriptions array.
         if(set Subscriptions[0] = ButtonSubscription):
             Print("Subscribed to the Button's InteractedWithEvent and set the subscription in Subscriptions!")

     OnButtonInteractedWith(InPlayer:agent):void=
         ItemSpawner.SpawnItem()

         # Access the cancelable variable for the InteractedWithEvent subscription
         if(ButtonSubscription := Subscriptions[0]):
             ButtonSubscription.Cancel()
             Print("Canceled this InteractedWithEvent")