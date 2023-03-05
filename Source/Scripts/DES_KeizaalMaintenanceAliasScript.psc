scriptName DES_KeizaalMaintenanceAliasScript extends ReferenceAlias

;-- Properties --------------------------------------

Actor Property PlayerRef auto

;-- Variables ---------------------------------------

Float fKeizaalVersion
Float fCurrentKeizaalVersion = 7.00100
Float fLastIncompatibleKeizaalVersion = 7.00000

;----------------------------------------------------

EVENT OnInit()
	fKeizaalVersion = fCurrentKeizaalVersion
	debug.Notification("Keizaal version " + fKeizaalVersion)
	WSSetup()
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

;----------------------------------------------------

FUNCTION WSSetup()

GlobalVariable WS_ESOCenter = Game.GetFormFromFile(0x54CF62, "WayshrinesIFT.esp") as GlobalVariable
GlobalVariable WS_VariableCompleteQuest01 = Game.GetFormFromFile(0x2D3AFC, "WayshrinesIFT.esp") as GlobalVariable
GlobalVariable WS_VariableSoulCostUse = Game.GetFormFromFile(0x14BCE7, "WayshrinesIFT.esp") as GlobalVariable
GlobalVariable WS_VariableSoulCostActivate = Game.GetFormFromFile(0x14BCE8, "WayshrinesIFT.esp") as GlobalVariable
Quest WS_Questline = Game.GetFormFromFile(0xB8C26, "WayshrinesIFT.esp") as Quest 

	WS_Questline.Start()
	utility.wait(0.100000)
	WS_Questline.CompleteQuest()
	WS_VariableCompleteQuest01.SetValue(1)
	WS_VariableSoulCostUse.SetValue(0)
	WS_VariableSoulCostActivate.SetValue(0)
	WS_ESOCenter.SetValue(1)
	
ENDFUNCTION