Scriptname DES_KeizaalMaintenanceAliasScript extends ReferenceAlias
 
Float fKeizaalVersion

;******************************************************

Event OnInit()
	InitializeMaintenance()
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

;Event doAccept(string eventName, string strArg, float numArg, Form sender)
;     
;endEvent

event doIgnore(string eventName, string strArg, float numArg, Form sender)
     Game.QuitToMainMenu()
endEvent

;******************************************************

Function Maintenance()
	If fKeizaalVersion < 6.21 ; Current version
		If fKeizaalVersion
			Debug.Trace("Updating from version " + fKeizaalVersion)
			If fKeizaalVersion < 6.30 ; Latest incompatible version
				IncompatibleSave()
			EndIf
		Else
			Debug.Trace("Initializing for the first time.")
		EndIf
		fKeizaalVersion = 6.21
		Debug.Notification("Keizaal version: " + fKeizaalVersion)
	EndIf
EndFunction

;******************************************************

Function InitializeMaintenance()
	IF MQ101.GetStage() <= 250
		fKeizaalVersion = 6.21
		Debug.Notification("Keizaal version: " + fKeizaalVersion)
	ENDIF
EndFunction

Quest Property MQ101 Auto

;******************************************************

Function IncompatibleSave()     
        registerForModEvent("wabbaMenu_Accept", "doAccept")
        registerForModEvent("wabbaMenu_Ignore", "doIgnore")
        ;this registers to recieve an event when you click the buttons in the menu.
        
        string messageText = "<FONT size=40>6.2.1</Font> \n This update is savegame incompatible. If you attempt to continue playing with this savegame, you forfeit all official support you would normally receive for this modlist."

        string ButtonLeft = "Continue"
        string ButtonRight = "Return to Main Menu"
        
        String modlistName = "Keizaal"
         
        ui.openCustomMenu("wabbawidget/wabbaMessage")
        utility.waitmenumode(0.1)
        int x = uicallback.create("CustomMenu", "main.setText")
            UICallback.PushString(x, modlistName)
            UICallback.PushString(x, messageText )
            UICallback.PushString(x, ButtonLeft)
            UICallback.PushString(x, ButtonRight)
        UICallback.Send(x)
EndFunction