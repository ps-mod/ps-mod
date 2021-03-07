$path = "C:\tools\ps-mod"
$content = "`r`nImport-Module $path\load.ps1"
New-Item -Path $path -ItemType Directory -Force
git clone https://github.com/ps-mod/ps-mod.git $path

Add-Content -Path ([Environment]::GetFolderPath("MyDocuments") + '\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1') -Value $content
Add-Content -Path ([Environment]::GetFolderPath("MyDocuments") + '\WindowsPowerShell\Microsoft.PowerShell_profile.ps1') -Value $content
Add-Content -Path ([Environment]::GetFolderPath("MyDocuments") + '\WindowsPowerShell\PowerShellISE_profile.ps1') -Value $content
Add-Content -Path ([Environment]::GetFolderPath("MyDocuments") + '\WindowsPowerShell\Profile.ps1') -Value $content
Add-Content -Path ("$PsHome\Microsoft.PowerShell_profile.ps1") -Value $content
Add-Content -Path ("$PsHome\Profile.ps1") -Value $content
