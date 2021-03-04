$path = "C:\tools"
New-Item -Path $path -ItemType Directory -Force
git clone https://github.com/ps-mod/ps-mod.git $path
git clone https://github.com/ps-mod/Core.git ($path + '\ps-mod')
Add-Content -Path ([Environment]::GetFolderPath("MyDocuments") + '\WindowsPowerShell\Microsoft.PowerShell_profile.ps1') -Value "`r`nImport-Module $path\ps-mod\load.ps1"