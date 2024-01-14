scriptName DES_KeizaalMaintenanceAliasScript extends ReferenceAlias
import SKSE

;-- Properties --------------------------------------

Actor Property PlayerRef auto

;-- Variables ---------------------------------------

Bool Property bEnableChecks  auto
Float Property fCurrentKeizaalVersion  auto
Float Property fLastIncompatibleKeizaalVersion auto
Int Property iCurrentModCount auto
Int Property iCurrentSimonRimModCount auto

Bool bWarned
Float fKeizaalVersion
Int iModCount

;----------------------------------------------------

EVENT OnInit()
	PullFromINI()
	fKeizaalVersion = fCurrentKeizaalVersion
	debug.Notification("Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
	IF bEnableChecks != False
		CheckVersion()
		CheckModified()
	ENDIF
ENDEVENT
	
EVENT OnPlayerLoadGame()
	Maintenance()
ENDEVENT

FUNCTION Maintenance()
	PullFromIni()
	IF bEnableChecks != False
		CheckVersion()
		CheckModified()
	ENDIF
ENDFUNCTION

FUNCTION PullFromINI()
	bEnableChecks = PapyrusINIManipulator.PullBoolFromIni("Data/skse/plugins/ModlistUpdateChecker.ini", "Custom", "bEnableChecks", true)
	fCurrentKeizaalVersion = PapyrusINIManipulator.PullFloatFromIni("Data/skse/plugins/ModlistUpdateChecker.ini", "Custom", "fCurrentVersion", 0.000)
	fLastIncompatibleKeizaalVersion = PapyrusINIManipulator.PullFloatFromIni("Data/skse/plugins/ModlistUpdateChecker.ini", "Custom", "fIncompatibleVersion", 0.000)
	iCurrentModCount = PapyrusINIManipulator.PullIntFromIni("Data/skse/plugins/ModlistUpdateChecker.ini", "Custom", "iModNumber", 0)
	iCurrentSimonRimModCount = PapyrusINIManipulator.PullIntFromIni("Data/skse/plugins/ModlistUpdateChecker.ini", "Custom", "iModNumberSimonRim", 0)
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
	iModCount = Game.GetModCount() + Game.GetLightModCount()
	IF PlayerRef.GetParentCell() && bWarned != True
		IF !Game.IsPluginInstalled("MysticismMagic.esp")
			IF iModCount != iCurrentModCount
				ModifiedList()
			ENDIF
		ELSE
			IF iModCount != iCurrentSimonRimModCount
				ModifiedList()		
			ENDIF
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
	registerForModEvent("wabbaMenu_Accept", "doAccept")
	registerForModEvent("wabbaMenu_Ignore", "doIgnore")
	;this registers to recieve an event when you click the buttons in the menu.
	
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
	utility.waitmenumode(0.1)
	ui.CloseCustomMenu()
	game.QuitToMainMenu()
ENDEVENT

EVENT doIgnore(String eventName, String strArg, Float numArg, Form sender)
	utility.waitmenumode(0.1)
	UI.CloseCustomMenu()
	IF fKeizaalVersion < fCurrentKeizaalVersion
		debug.Notification("Updating from Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
		fKeizaalVersion = fCurrentKeizaalVersion
		debug.Notification("Now running Keizaal v" + StringUtil.getNthChar(fKeizaalVersion, 0) + "." + StringUtil.getNthChar(fKeizaalVersion, 2) + "." +  StringUtil.getNthChar(fKeizaalVersion, 3) + "." + StringUtil.getNthChar(fKeizaalVersion, 4))
	ENDIF
	IF iModCount != iCurrentModCount
		bWarned = True
	ENDIF
ENDEVENT

;----------------------------------------------------