$a = Get-Content -Path "$Global:rootFolder\modules.psm1" | Where-Object {$_ -match ("require "+ $args[0])}
$a = $a | Select-String -Pattern ("require " + $args[0] + " #(.+)")
if($a.Matches.Length -eq 0){
    if($args.Contains('-r')){
        return ''
    }
    Write-Warning "No repository defined for this module"
    return;
}
$a = $a.Matches.Groups[1].Value
if($args.Contains('-r')){
    return $a
}
Start-Process $a