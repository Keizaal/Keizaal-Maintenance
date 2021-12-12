Scriptname DES_KeizaalMaintenanceAliasScript extends ReferenceAlias
 
Float fKeizaalVersion = 6.012
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
	If fKeizaalVersion < 6.100 ; Current version
		If fKeizaalVersion
			Debug.Trace("Updating from version " + fKeizaalVersion)
			int ibutton = DES_KeizaalUpdateMessage.Show()
				if ibutton == 1
					Game.QuitToMainMenu()
				endif
			Utility.Wait(1)
            DES_KeizaalRespec.Cast(PlayerRef)
		Else
			Debug.Trace("Initializing for the first time.")
		EndIf
		fKeizaalVersion = 6.100
		Debug.Notification("Keizaal version: " + fKeizaalVersion)
	EndIf
EndFunction

;******************************************************

Function InitializeMaintenance()
	IF MQ101.GetStage() <= 250
		fKeizaalVersion = 6.100
		Debug.Notification("Keizaal version: " + fKeizaalVersion)
	ENDIF
EndFunction

Quest Property MQ101 Auto
Spell Property DES_KeizaalRespec Auto
Actor Property PlayerRef Auto