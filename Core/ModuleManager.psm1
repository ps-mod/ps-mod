function Import-PsModModul {
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
    git clone $url "$Global:rootFolder/$modulName"
    if($LASTEXITCODE){
        Set-Location $current
        return;
    }
    Add-Content -Path "$Global:rootFolder/modules.psm1" -Value "`r`nrequire $modulName #$url"
    if(Test-Path "$Global:rootFolder/$modulName/post_install.ps1"){
        Start-Process (Powershell.exe -File "$Global:rootFolder/$modulName/post_install.ps1") -NoNewWindow
    }
    Set-Location $current
    if(!$NoRestart){
        re
    }
}

function Remove-PsModModul {
    param (
        [Parameter(Mandatory=$True)]
        [string]
        $name
    )

    $current = Get-Location
    Set-Location $Global:rootFolder
    try {
        Remove-Item $name -r -Force -ErrorAction Stop
        $content = Get-Content "$Global:rootFolder/modules.psm1" | Where-Object {$_ -notmatch "require $name"}
        Set-Content "$Global:rootFolder/modules.psm1" $content
        $Newtext = (Get-Content -Path "$Global:rootFolder/modules.psm1" -Raw) -replace "(?s)`r`n\s*$"
        [system.io.file]::WriteAllText("$Global:rootFolder/modules.psm1",$Newtext)

        Set-Location $current
        re
    }
    catch {
        Write-Error (-join $Error)
        if($Global:rootFolder -match ".*OneDrive.*"){
            Write-Warning 'You are using OneDrive files-on-demand feature. While this is a pretty good feature, deleteing from powershell is disabled in shared folders for security reasons.'
            Write-Warning "You can solve this by 1. Automatically or manually remove the `"require`" statement from your load.ps1 file, then 2. Remove the $Global:rootFolder/$name folder."
            $decision = $Host.UI.PromptForChoice('Do you want to automatically remove the "require" statement from your load.ps1 file?', '', ('&Yes', '&No'), 0)
            if ($decision -eq 0) {
                $content = Get-Content "$Global:rootFolder/load.ps1" | Where-Object {$_ -notmatch "require $name"}
                Set-Content "$Global:rootFolder/load.ps1" $content
                $Newtext = (Get-Content -Path "$Global:rootFolder/load.ps1" -Raw) -replace "(?s)`r`n\s*$"
                [system.io.file]::WriteAllText("$Global:rootFolder/load.ps1",$Newtext)

                Write-Host "Now you can remove the module folder named $name" -ForegroundColor Green
                explorer .
                Set-Location $current
            }
        }
    }

}

Export-ModuleMember -Function Import-PsModModul, Remove-PsModModul