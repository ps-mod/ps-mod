$path = "C:\tools\ps-mod"
if($IsLinux){
    $path = "~/tools/ps-mod"
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
    if(Test-Path $_){
        Add-Content -Path ($_) -Value $content
    }
}