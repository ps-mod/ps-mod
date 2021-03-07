Set-Content -Path "$Global:rootFolder\out.csv" -Value "Module Name;Repository"
Get-Content -Path "$Global:rootFolder\modules.psm1" | Where-Object {$_ -match "require ([a-zA-Z.0-9-&]+) ?#?(.*)"} | ForEach-Object {
    $regex = $_ | Select-String -Pattern "require ([a-zA-Z.0-9-&]+) ?#?(.*)"
    $moduleName = $regex.Matches.Groups[1].Value
    $git = 'Private'
    if($regex.Matches.Groups.Count -gt 2){
        $git = $regex.Matches.Groups[2].Value
    }
    Add-Content -Path "$Global:rootFolder\out.csv" -Value "$moduleName;$git"
}

Import-Csv "$Global:rootFolder\out.csv" -Delimiter ';' | Format-Table
Remove-Item "$Global:rootFolder\out.csv"