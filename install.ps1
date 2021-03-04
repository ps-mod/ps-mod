$path = "C:\tools\ps-mod"
New-Item -Path $path -ItemType Directory -Force
git clone https://github.com/ps-mod/ps-mod.git $path

Add-Content -Path ([Environment]::GetFolderPath("MyDocuments") + '\WindowsPowerShell\Microsoft.PowerShell_profile.ps1') -Value "`r`nImport-Module $path\load.ps1"
