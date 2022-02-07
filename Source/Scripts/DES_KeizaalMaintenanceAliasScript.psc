Scriptname DES_KeizaalMaintenanceAliasScript extends ReferenceAlias
 
Float fKeizaalVersion
Message Property DES_KeizaalUpdateMessage Auto

Event OnInit()
	InitializeMaintenance()
	Maintenance()
EndEvent

Event OnPlayerLoadGame()
	InitializeMaintenance()
	Maintenance()
EndEvent

Function Maintenance()
	If fKeizaalVersion < 6.21 ; Current version
		If fKeizaalVersion
			Debug.Trace("Updating from version " + fKeizaalVersion)
			If fKeizaalVersion < 6.2 ; Latest incompatible version
				int ibutton = DES_KeizaalUpdateMessage.Show()
					if ibutton == 1
						Game.QuitToMainMenu()
					endif
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