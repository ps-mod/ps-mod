# About PS-Mod
PS-Mod is a powershell script manager. You can pull in scripts from others or create and publish your own.
# Security
The project is in a VERY EARLY ALPHA STATE. 

PS-Mod **DOES NOT INCLUDE** any security features at the moment. To use PS-Mod, first you have to enable powershell script execution on your computer. _This is a security risk in itself_. 

> **NEVER** run scripts unknown to you.

Before installing/running any powershell script make sure you **know and understand** the content of the module.
# Commands
## require
Installs a PS-Mod module

### Syntax:
```ps
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
```ps
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
```ps
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
```ps
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
```ps
psmod new <Package name>
```

### Usage:
```ps
psmod new MyPackage
```

After you publish your repo on github.com anyone can include your package with the `psmod require MyUser/Mypackage` command.

# Core Commands
The core package is included with the main loader. See it's [README.md here]().