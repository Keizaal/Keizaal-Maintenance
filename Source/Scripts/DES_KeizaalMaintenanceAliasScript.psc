scriptName DES_KeizaalMaintenanceAliasScript extends ReferenceAlias

;-- Properties --------------------------------------

Actor Property PlayerRef auto

;-- Variables ---------------------------------------

Bool Warned
Float fKeizaalVersion
Int fModCount
Float Property fCurrentKeizaalVersion = 7.100 auto
Float Property fLastIncompatibleKeizaalVersion = 7.100 auto
Int Property fCurrentModCount = 698 auto

;----------------------------------------------------

EVENT OnInit()
	fKeizaalVersion = fCurrentKeizaalVersion
	debug.Notification("Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
ENDEVENT

EVENT OnPlayerLoadGame()
	Maintenance()
ENDEVENT

FUNCTION Maintenance()
	CheckVersion()
	CheckModified()
ENDFUNCTION

FUNCTION CheckVersion()
	IF fKeizaalVersion < fCurrentKeizaalVersion
		IF fKeizaalVersion < fLastIncompatibleKeizaalVersion
			IF PlayerRef.GetParentCell()
				self.IncompatibleSave()
			ENDIF
		ELSE
			debug.Notification("Updating from Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
			fKeizaalVersion = fCurrentKeizaalVersion
			debug.Notification("Now running Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
		ENDIF
	ENDIF
ENDFUNCTION

FUNCTION CheckModified()
	fModCount = Game.GetModCount() + Game.GetLightModCount()
	IF Game.IsPluginInstalled("widescreen_skyui_fix.esp")
		fCurrentModCount = fCurrentModCount + 1
	ENDIF
	IF fModCount != fCurrentModCount
		IF PlayerRef.GetParentCell() && Warned != True
			ModifiedList()
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

	String modlistName = "Keizaal version " + StringUtil.getNthChar(fCurrentKeizaalVersion, 0) + "." + StringUtil.getNthChar(fCurrentKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fCurrentKeizaalVersion, 3) + "." + StringUtil.getNthChar(fCurrentKeizaalVersion, 4)

	ui.openCustomMenu("wabbawidget/wabbaMessage")
	utility.waitmenumode(0.1)
	int x = uicallback.create("CustomMenu", "main.setText")
		UICallback.PushString(x, modlistName)
		UICallback.PushString(x, messageText )
		UICallback.PushString(x, ButtonLeft)
		UICallback.PushString(x, ButtonRight)
	UICallback.Send(x)
ENDFUNCTION

;----------------------------------------------------

FUNCTION ModifiedList()
	
	String messageText = "This instance of Keizaal has been modified. \n \n If you attempt to continue playing, you forfeit all official support you would normally receive for this modlist."

	String ButtonLeft = "Continue "
	String ButtonRight = "Return to Main Menu"

	String modlistName = "Keizaal version " + StringUtil.getNthChar(fCurrentKeizaalVersion, 0) + "." + StringUtil.getNthChar(fCurrentKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fCurrentKeizaalVersion, 3) + "." + StringUtil.getNthChar(fCurrentKeizaalVersion, 4)

	ui.openCustomMenu("wabbawidget/wabbaMessage")
	utility.waitmenumode(0.1)
	int x = uicallback.create("CustomMenu", "main.setText")
		UICallback.PushString(x, modlistName)
		UICallback.PushString(x, messageText )
		UICallback.PushString(x, ButtonLeft)
		UICallback.PushString(x, ButtonRight)
	UICallback.Send(x)
ENDFUNCTION

;----------------------------------------------------

EVENT doAccept(String eventName, String strArg, Float numArg, Form sender)
	ui.CloseCustomMenu()
	game.QuitToMainMenu()
ENDEVENT

EVENT doIgnore(String eventName, String strArg, Float numArg, Form sender)
	UI.CloseCustomMenu()
	IF fKeizaalVersion < fCurrentKeizaalVersion
		debug.Notification("Updating from Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
		fKeizaalVersion = fCurrentKeizaalVersion
		debug.Notification("Now running Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
	ENDIF
	IF fModCount != fCurrentModCount
		Warned = True
	ENDIF
ENDEVENT

;----------------------------------------------------