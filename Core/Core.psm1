function re {
    <#
    .Synopsis
        Restart Powershell here
    #>
    Start-Process powershell -WorkingDirectory $PWD
    exit
}

function su {
    <#
    .Synopsis
        Start an adminstrator powershell here and close this process
    #>
    Start-Process powershell.exe -verb runAs -ArgumentList '-NoExit', '-Command', ('cd '+$pwd)
    exit
}

function services? {
    <#
    .Synopsis
        List all running service
    #>
    if(Test-Administrator){
        Get-Service | ConvertTo-HTML -Property Name, Status > ($Global:rootFolder + "\ps_services.html")
        Invoke-Item ($Global:rootFolder + "\ps_services.html")
        Start-Sleep -s 3
        Remove-Item ($Global:rootFolder + "\ps_services.html") -Force
    }else {
        Start-Process powershell.exe -verb runAs -ArgumentList '-Command', 'services?'  
    }
}

function Test-Administrator  
{
    <#
    .Synopsis
        Return true if current host process has administrator rights
    #>
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function Import-Env {
    <#
    .Summary
        Read an env file and return it as a hastable
    .Parameter fileLocation
        env file location
    #>
    param (
        # Env File Location
        [Parameter(Mandatory=$true)]
        [string]
        $fileLocation
    )
    $hash = @{}
    $str = Get-Content $fileLocation
    foreach ($item in $str) {
        if($item.Length -gt 0){
            try {
                $pos = $item.IndexOf("=")
                $leftPart = $item.Substring(0, $pos)
                $rightPart = $item.Substring($pos+1)
                
                $hash.Add($leftPart, $rightPart)   
            } catch {}
        }
    }
    return $hash
}

function Export-Env {
    <#
    .Summary
        Save a hashmap as an env file
    #>
    param (
        # Env hash
        [Parameter(Mandatory=$true)]
        [hashtable]
        $hash,

        # output file
        [Parameter(Mandatory=$true)]
        [string]
        $file
    )
    $temp = ''
    foreach($item in $hash.GetEnumerator()){
        $temp += "$($item.Name)=$($item.Value)`n"
    }
    $temp > (".\" + $file)
}

Export-ModuleMember -Function Export-Env, re, su, services?, sudo, Test-Administrator, include, Import-Env