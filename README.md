# About PS-Mod
PS-Mod is a powershell script manager. You can pull in scripts from others or create and publish your own.
# Security
The project is in a VERY EARLY ALPHA STATE. 

PS-Mod **DOES NOT INCLUDE** any security features at the moment. To use PS-Mod, first you have to enable powershell script execution on your computer. _This is a security risk in itself_. 

> **NEVER** run scripts unknown to you.

Before installing/running any powershell script make sure you **know and understand** the content of the module.
# Installation
Open powershell as administrator and run the following command:
```ps
Set-ExecutionPolicy Bypass -Scope Process -Force ; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 ;Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ps-mod/ps-mod/main/install.ps1'))
```
You can review the installation script [here](https://github.com/ps-mod/ps-mod/blob/main/install_ps-mod.ps1).

# Commands
## require
Installs a PS-Mod module

### Syntax:
```
psmod require <package or git url>
```
### Usage:
```ps
psmod require Laravel
```
---
## remove
Uninstalls a PS-Mod module

### Syntax:
```
psmod remove <package or git url>
```
### Usage:
```ps
psmod remove Laravel
```
---
## list
Get all modules installed through PS-Mod
### Usage:
```ps
psmod list
```
---
## read
Read the documentation of a specific module.

### Options
| Switch | Name | Description |
|  ---   |  --- |     ---     |
| -r | Redirect | Return the path to README.md instead of README.md content

### Syntax:
```
psmod read <module> [-r]
```

### Usage:
```ps
psmod read Laravel
```
Or as a prameter:
```ps
code (psmod read Laravel -r)
```
---
## check
Open the repository of a specific module

## Options
| Switch | Name | Description |
|  ---   |  --- |     ---     |
| -r | Redirect | Return the path to repository instead of opening it in the browser

### Syntax:
```
psmod check <module> [-r]
```

### Usage:
```ps
psmod check Laravel
```
Or as a prameter:
```ps
code (psmod check Laravel -r)
```
---
## update
Update all installed module

### Usage:
```ps
psmod update
```

## new:
Create a new empty package for you

### Syntax:
```
psmod new <Package name>
```

### Usage:
```ps
psmod new MyPackage
```

After you publish your repo on github.com anyone can include your package with the `psmod require MyUser/Mypackage` command.

# Core Commands
The core package is included with the main loader. See it's [README.md here](https://github.com/ps-mod/ps-mod/tree/main/Core).
