Write-Output '¤ Welcome to the PS-Mod Installer'
Write-Output '¤ This script will install PS-Mod to your system'

Write-Warning '¤ This script does not need admin rights if you install PS-Mod to your user profile only. If you want to install PS-Mod to the system, you need admin rights.'
Write-Warning '¤ Ps-Mod cannot be uninstalled automatically. For uninstallation instructions, please see the README.md file'

# Check if PS-Mod is already installed
if(Test-Command 'psmod') {
    Write-Output '¤ PS-Mod is already installed'
    Write-Output '¤ Please uninstall it first'
    exit
}

$defaultPath = 'C:\tools\ps-mod'
if($IsLinux){
    $defaultPath = '$HOME/.ps-mod'
}

# Ask for installation path
$path = Read-Host "¤ Please enter the installation path. Default is $path"

if($path -eq '') {
    $path = $defaultPath
}

Write-Output "¤ Cloning PS-Mod repository to $path"
New-Item -Path $path -ItemType Directory -Force
git clone https://github.com/ps-mod/ps-mod.git $path

Write-Output '¤ Adding PS-Mod to profiles'
Write-Warning '¤ This script will modify your profile files. You may want to backup them first.'
Write-Warning '¤ If you are running this script in non-admin mode, you will see some errors. You can ignore them.'
$profiles = (
    $profile.CurrentUserAllHosts,
    $profile.CurrentUserCurrentHost,
    $profile.AllUsersAllHosts,
    $profile.AllUsersCurrentHost
)
$content = "`r`nImport-Module $path\load.ps1 # PS-Mod"
$profiles | ForEach-Object {
    New-Item -Path (Split-Path -Path $_) -ItemType Directory -Force
    Add-Content -Path ($_) -Value $content -Force
}

Write-Output '¤ PS-Mod has been installed successfully'


function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}