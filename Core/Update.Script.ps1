Write-Host "Updating modules..."
Write-Output "==========================="
$dir = Get-ChildItem $Global:rootFolder | Where-Object {$_.PSIsContainer -and ($_.Name -notmatch '^\..+')}
$dir | ForEach-Object {
    Set-Location $_.FullName
    Write-Host $_.Name": " -NoNewline
    git pull 2> $a
    if($LASTEXITCODE){
        Write-Host "private module"
    }
    Write-Host "__________________________"
}