scriptName DES_KeizaalMaintenanceAliasScript extends ReferenceAlias

;-- Properties --------------------------------------

Actor Property PlayerRef auto

;-- Variables ---------------------------------------

Float fKeizaalVersion
Float fCurrentKeizaalVersion = 6.50300
Float fLastIncompatibleKeizaalVersion = 6.50000

;----------------------------------------------------

EVENT OnInit()
	fKeizaalVersion = fCurrentKeizaalVersion
	debug.Notification("Keizaal version " + fKeizaalVersion)
ENDEVENT

EVENT OnPlayerLoadGame()
	Maintenance()
ENDEVENT

FUNCTION Maintenance()
	IF fKeizaalVersion < fCurrentKeizaalVersion
		IF fKeizaalVersion < fLastIncompatibleKeizaalVersion
			IF PlayerRef.GetParentCell()
				self.IncompatibleSave()
			ENDIF
		ELSE
			debug.Notification("Updating from Keizaal version " + fKeizaalVersion as String)
			fKeizaalVersion = fCurrentKeizaalVersion
			debug.Notification("Now running Keizaal version " + fKeizaalVersion as String)
		ENDIF
	ENDIF
ENDFUNCTION

;----------------------------------------------------

FUNCTION IncompatibleSave()
	registerForModEvent("wabbaMenu_Accept", "doAccept")
	registerForModEvent("wabbaMenu_Ignore", "doIgnore")
	;this registers to recieve an event when you click the buttons in the menu.
	
	String messageText = "This update is savegame incompatible. \n \n If you attempt to continue playing with this savegame, you forfeit all official support you would normally receive for this modlist."

	String ButtonLeft = "Continue "
	String ButtonRight = "Return to Main Menu"

	String modlistName = "Keizaal version " + fCurrentKeizaalVersion

	ui.openCustomMenu("wabbawidget/wabbaMessage")
	utility.waitmenumode(0.1)
	int x = uicallback.create("CustomMenu", "main.setText")
		UICallback.PushString(x, modlistName)
		UICallback.PushString(x, messageText )
		UICallback.PushString(x, ButtonLeft)
		UICallback.PushString(x, ButtonRight)
	UICallback.Send(x)
ENDFUNCTION
	
EVENT doAccept(String eventName, String strArg, Float numArg, Form sender)
	ui.CloseCustomMenu()
	game.QuitToMainMenu()
ENDEVENT

EVENT doIgnore(String eventName, String strArg, Float numArg, Form sender)
	UI.CloseCustomMenu()
	debug.Notification("Updating from Keizaal version " + fKeizaalVersion)
	fKeizaalVersion = fCurrentKeizaalVersion
	debug.Notification("Now running Keizaal version " + fKeizaalVersion)
ENDEVENT