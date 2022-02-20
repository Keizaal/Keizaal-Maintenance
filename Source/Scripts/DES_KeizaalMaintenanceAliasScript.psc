Scriptname DES_KeizaalMaintenanceAliasScript extends ReferenceAlias

Float fKeizaalVersion
Float fCurrentKeizaalVersion = 6.21
Float fLastIncompatibleKeizaalVersion = 6.20
Actor Property PlayerRef Auto

;******************************************************

Event OnInit()
	fKeizaalVersion = fCurrentKeizaalVersion ; Current version
	Debug.Notification("Keizaal version " + fKeizaalVersion)
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

Event doAccept(string eventName, string strArg, float numArg, Form sender)
	 UI.CloseCustomMenu()
	 Game.QuitToMainMenu()
endEvent

event doIgnore(string eventName, string strArg, float numArg, Form sender)
	 UI.CloseCustomMenu()
	 Debug.Notification("Updating from Keizaal version " + fKeizaalVersion)
	 fKeizaalVersion = fCurrentKeizaalVersion ; Current version
	 Debug.Notification("Now running Keizaal version " + fKeizaalVersion)
endEvent

;******************************************************

Function Maintenance()
	If fKeizaalVersion < fCurrentKeizaalVersion ; Current version
		If fKeizaalVersion < fLastIncompatibleKeizaalVersion ; Last incompatible version
			If PlayerRef.GetParentCell()
				IncompatibleSave()
			EndIf
		Else
			Debug.Notification("Updating from Keizaal version " + fKeizaalVersion)
			fKeizaalVersion = fCurrentKeizaalVersion ; Current version
			Debug.Notification("Now running Keizaal version " + fKeizaalVersion)
		EndIf
	EndIf
EndFunction

;******************************************************

Function IncompatibleSave()
        registerForModEvent("wabbaMenu_Accept", "doAccept")
        registerForModEvent("wabbaMenu_Ignore", "doIgnore")
        ;this registers to recieve an event when you click the buttons in the menu.
        
        string messageText = "This update is savegame incompatible. \n \n If you attempt to continue playing with this savegame, you forfeit all official support you would normally receive for this modlist."

        string ButtonLeft = "Continue "
        string ButtonRight = "Return to Main Menu"
        
        String modlistName = "Keizaal version " + fCurrentKeizaalVersion
		 
        ui.openCustomMenu("wabbawidget/wabbaMessage")
        utility.waitmenumode(0.1)
        int x = uicallback.create("CustomMenu", "main.setText")
            UICallback.PushString(x, modlistName)
            UICallback.PushString(x, messageText )
            UICallback.PushString(x, ButtonLeft)
            UICallback.PushString(x, ButtonRight)
        UICallback.Send(x)
EndFunction