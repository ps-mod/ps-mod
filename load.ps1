$Global:rootFolder = $PSScriptRoot

function require($path) {
    $p = Join-Path -Path $PSScriptRoot -ChildPath $path
    $p = Join-Path -Path $p -ChildPath ($path + ".psm1")
    Import-Module $p
}

function Import-JustNopModul {
    param (
        [Parameter(Mandatory=$True)]
        [string]
        $url,
        [Parameter(Mandatory=$False)]
        [switch]
        $NoRestart = $False
    )
    $current = Get-Location
    if($url -notmatch '\.git$'){
        if($url -notmatch '.+[/\\].+'){
            $url = "https://github.com/ps-mod/$url.git"
        }
        else{
            $url = "https://github.com/$url.git"
        }
    }
    $regex = $url | Select-String -Pattern ".+\/(.+)\/([a-zA-Z-_0-9&]+)\.git"
    $modulName = $regex.Matches.Groups[2].Value
    git clone $url "$PSScriptRoot/$modulName"
    if($LASTEXITCODE){
        Set-Location $current
        return;
    }
    Add-Content -Path "$PSScriptRoot/load.ps1" -Value "`r`nrequire $modulName #$url"
    if(Test-Path "$PSScriptRoot/$modulName/post_install.ps1"){
        Start-Process (Powershell.exe -File "$PSScriptRoot/$modulName/post_install.ps1") -NoNewWindow
    }
    Set-Location $current
    if(!$NoRestart){
        re
    }
}

function Remove-JustNopModul {
    param (
        [Parameter(Mandatory=$True)]
        [string]
        $name
    )

    $current = Get-Location
    Set-Location $PSScriptRoot
    try {
        Remove-Item $name -r -Force -ErrorAction Stop
        $content = Get-Content "$PSScriptRoot/load.ps1" | Where-Object {$_ -notmatch "require $name"}
        Set-Content "$PSScriptRoot/load.ps1" $content
        $Newtext = (Get-Content -Path "$PSScriptRoot/load.ps1" -Raw) -replace "(?s)`r`n\s*$"
        [system.io.file]::WriteAllText("$PSScriptRoot/load.ps1",$Newtext)

        Set-Location $current
        re
    }
    catch {
        Write-Error (-join $Error)
        if($PSScriptRoot -match ".*OneDrive.*"){
            Write-Warning 'You are using OneDrive files-on-demand feature. While this is a pretty good feature, deleteing from powershell is disabled in shared folders for security reasons.'
            Write-Warning "You can solve this by 1. Automatically or manually remove the `"require`" statement from your load.ps1 file, then 2. Remove the $PSScriptRoot/$name folder."
            $decision = $Host.UI.PromptForChoice('Do you want to automatically remove the "require" statement from your load.ps1 file?', '', ('&Yes', '&No'), 0)
            if ($decision -eq 0) {
                $content = Get-Content "$PSScriptRoot/load.ps1" | Where-Object {$_ -notmatch "require $name"}
                Set-Content "$PSScriptRoot/load.ps1" $content
                $Newtext = (Get-Content -Path "$PSScriptRoot/load.ps1" -Raw) -replace "(?s)`r`n\s*$"
                [system.io.file]::WriteAllText("$PSScriptRoot/load.ps1",$Newtext)

                Write-Host "Now you can remove the module folder named $name" -ForegroundColor Green
                explorer .
                Set-Location $current
            }
        }
    }
        
}

function psmod{
    param(
        [Parameter(Mandatory=$false)]
        $innerFunc,
        [Parameter(Mandatory=$false)]
        $moduleName,
        [parameter(Mandatory=$false)]
        [switch]$redirect = $false
    )

    if($innerFunc -eq 'list'){
        Set-Content -Path "$PSScriptRoot\out.csv" -Value "Module Name;Repository"
        $a = Get-Content -Path "$PSScriptRoot\load.ps1" | Where-Object {$_ -match "require ([a-zA-Z.0-9-&]+) ?#?(.*)"} | ForEach-Object {
            $regex = $_ | Select-String -Pattern "require ([a-zA-Z.0-9-&]+) ?#?(.*)"
            $moduleName = $regex.Matches.Groups[1].Value
            $git = 'Private'
            if($regex.Matches.Groups.Count -gt 2){
                $git = $regex.Matches.Groups[2].Value
            }
            Add-Content -Path "$PSScriptRoot\out.csv" -Value "$moduleName;$git"
        }

        Import-Csv "$PSScriptRoot\out.csv" -Delimiter ';' | Format-Table
        Remove-Item "$PSScriptRoot\out.csv"
    }elseif(($innerFunc -eq 'read') -or ($innerFunc -eq 'help')){
        if($redirect){
            return "$PSscriptRoot\$moduleName\README.md"
        }

        Write-Output "$moduleName README content"
        Write-Output "----------------------"
        Get-Content -Path "$PSscriptRoot\$moduleName\README.md"
    }
    elseif ($innerFunc -eq 'check') {
        $a = Get-Content -Path "$PSScriptRoot\load.ps1" | Where-Object {$_ -match "require $moduleName"}
        $a = $a | Select-String -Pattern "require $moduleName #(.+)"
        if($a.Matches.Length -eq 0){
            if($redirect){
                return ''
            }
            Write-Warning "No repository defined for this module"
            return;
        }
        $a = $a.Matches.Groups[1].Value
        if($redirect){
            return $a
        }
        Start-Process $a
    }elseif ($innerFunc -eq 'require') {
        Import-JustNopModul $moduleName
    }
    elseif ($innerFunc -eq 'remove') {
        Remove-JustNopModul $moduleName
    }
    elseif ($innerFunc -eq 'update') {
        Write-Host "Updating modules..."
        Write-Output "==========================="
        $dir = Get-ChildItem $PSScriptRoot | Where-Object {$_.PSIsContainer -and ($_.Name -notmatch '^\..+')}
        $dir | ForEach-Object {
            Set-Location $_.FullName
            Write-Host $_.Name": " -NoNewline
            git pull 2> $a
            if($LASTEXITCODE){
                Write-Host "private module"
            }
            Write-Host "__________________________"
        }
    }
    elseif ($innerFunc -eq 'install') {
        Get-Content $moduleName | ForEach-Object {
            Import-JustNopModul $_.ToString() -NoRestart
        }
        Read-Host "Press ENTER to restart Powershell"
        re
    }
}

New-Alias storm phpstorm64

require Core
