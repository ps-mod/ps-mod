# About PS-Mod: Core
This is the main package of the PS-Mod. These functions are utility functions, which ease your day-to-day work in PowerShell

# Commands
## re
Restarts your powershell in the current working directory

### Usage
```ps
re
```

## su
Restarts your powershell in the current working directory with administrator rights

### Usage
```ps
su
```

## Test-Administrator
Returns true if the current powershell instance has administrator rights, else otherwise.

### Usage
```ps
# in 'something.ps1'
if(Test-Administrator){
    # Do something as admin
}
else {
    # Do something as user
}
```

## Import-Env
Imports an env file and creates a [hash table](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-5.1) from it.

### Syntax
```ps
Import-Hash <Path>
```
### Usage
#### .env:
```env
MY_VARIABLE=Foo Bar
```
#### Something.ps1:
```ps
$hash = Import-Hash '.\.env'
Write-Output $hash.MY_VARIABLE
```
Outputs:
> `Foo Bar`

## Export-Env
Takes a [hash table](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-5.1) and writes it to a file as key value pairs.

### Syntax
```ps
Export-Env <Hash table> <Path to output file>
```

### Usage
```ps
$hash = @{ Number = 1; Shape = "Square"; Color = "Blue"}
Export-Env $hash '.\.env'
```
Creates the `.env` file which looks like this:
```
Number=1
Shape=Square
Color=Blue
```