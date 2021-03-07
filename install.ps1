$path = "C:\tools\ps-mod"
if($IsLinux){
    $path = "$HOME/tools/ps-mod"
}
$content = "`r`nImport-Module $path\load.ps1"
New-Item -Path $path -ItemType Directory -Force
git clone https://github.com/ps-mod/ps-mod.git $path

$profiles = (
    $profile.CurrentUserAllHosts,
    $profile.CurrentUserCurrentHost,
    $profile.AllUsersAllHosts,
    $profile.AllUsersCurrentHost
)

$profiles | ForEach-Object {
    New-Item -Path (Split-Path -Path $_) -ItemType Directory -Force
    Add-Content -Path ($_) -Value $content -Force
}