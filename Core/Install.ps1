Import-Module "$Global:rootFolder/Core/ModuleManager.psm1"
Get-Content $params[0] | ForEach-Object {
    Import-PsModModul $_.ToString() -NoRestart
}
Remove-Module ModuleManager
Read-Host "Press ENTER to restart Powershell"
re