Scriptname DES_KeizaalMaintenanceScript extends Quest  
 
Actor Property PlayerRef Auto
GlobalVariable Property DES_KeizaalVersion Auto
Spell Property DES_KeizaalRespec Auto

Event OnInit()
	RegisterForUpdate(10)
EndEvent
 
Event OnUpdate()
float fVersion = DES_KeizaalVersion.GetValue()
	IF (fVersion < 6020)
		 DES_KeizaalVersion.SetValue(6020)
			DES_KeizaalRespec.Cast(PlayerRef)
			Debug.Notification("Now running Keizaal version: 6.0.2")
	ENDIF
EndEvent