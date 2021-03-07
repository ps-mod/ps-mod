$moduleName = $args[0]
if($args.Contains('-r')){
    return "$Global:rootFolder\$moduleName\README.md"
}

Write-Output "$moduleName README content"
Write-Output "----------------------"
Get-Content -Path "$Global:rootFolder\$moduleName\README.md"