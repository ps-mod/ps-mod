$Global:rootFolder = $PSScriptRoot

function require($path) {
    $p = Join-Path -Path $Global:rootFolder -ChildPath $path
    $p = Join-Path -Path $p -ChildPath ($path + ".psm1")
    Import-Module $p
}

function Run-Script {
    param(
        [Parameter(Mandatory=$false, Position = 0)]
        $innerFunc,
        [Parameter(
                Mandatory=$false,
                ValueFromRemainingArguments=$true,
                Position = 1
        )][string[]]
        $params
    )
    if(!$innerFunc.Contains('/')){
        $innerFunc = "$innerFunc/$innerFunc"
    }
    $path = "$Global:rootFolder/$innerFunc.Script.ps1 "
    $path = $path -replace '\\', '/'
    if($params){
        Start-Process powershell -ArgumentList ($path + ($params -join " ")) -NoNewWindow -Wait
    }else{
        Start-Process powershell -ArgumentList $path -NoNewWindow -Wait
    }
}

function psmod{
    param(
        [Parameter(Mandatory=$false, Position = 0)]
        $innerFunction,
        [Parameter(
                Mandatory=$false,
                ValueFromRemainingArguments=$true,
                Position = 1
        )][string[]]
        $params
    )

    switch($innerFunction){
        {$_ -in ('list', 'read', 'help', 'check', 'update', 'install')} {
            Run-Script "Core/$innerFunction" $params
        }
        'require' {
            Import-Module "$Global:rootFolder/Core/ModuleManager.psm1"
            Import-PsModModul $params[0]
            Remove-Module ModuleManager
        }
        'remove' {
            Import-Module "$Global:rootFolder/Core/ModuleManager.psm1"
            Remove-PsModModul $params[0]
            Remove-Module ModuleManager
        }
        default {
            Run-Script $innerFunction $params
        }
    }
}

require Core
if(Test-Path "$Global:rootFolder/modules.psm1")
{
    Import-Module "$Global:rootFolder/modules.psm1"
}

