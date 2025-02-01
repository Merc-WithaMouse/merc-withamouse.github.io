---
title: "Quick Dive: Managing Applications With Winget"
description: 
date: 2023-08-19T6:45:00+01:00
image: "/post/Getting-To-Know-Winget/Winget-Help.PNG"
toc: false
math: false
license: false
hidden: false
comments: true
draft: false
authors:
    - ["Rob"]
categories:
    - Quick Look
tags:
    - Winget
    - Windows Package Manager
    - Command line Tool
    - PowerShell
    - Application Management

links:
  - title: Microsoft Learn
    description: Use the winget tool to install and manage applications
    website: https://learn.microsoft.com/en-us/windows/package-manager/winget
    image: https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RWCZER?ver=1433&q=90&m=6&h=120&w=120&b=%23FFFFFFFF&l=f&o=t&aim=true
---

<!-- Microsofts Guide -->
<!-- https://learn.microsoft.com/en-us/windows/package-manager/winget/ -->

Happy Saturday! Welcome back to another blog post. In this edition, we'll be taking a short break from OneDrive to have a quick dive into managing applications using the command line tool [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) - Microsoft's _"Client Interface to the Windows Package Manager service"_.

If you're looking for another way to install, update, and uninstall software on Windows, you're in the right place. Let's get started!

## Checking if Winget is Installed

Winget is supported on __*Windows 10 1709 (build 16299) or later*__.  Before we jump in, let's make sure it's installed in your environment. You can easily check by opening your command prompt or PowerShell and typing the following:

```powershell
winget --help
```
or
```powershell
winget -?
```

If Winget is installed, you'll see a helpful command summary along with various options and commands that you can use.

**An important note from Microsoft on this:** _The winget tool will not be available until you have logged into Windows as a user for the first time, triggering Microsoft Store to register Windows Package Manager as part of an asynchronous process. If you have recently logged in as a user for the first time and find that winget is not yet available, you can open PowerShell and enter the following command to request this winget registration:_ `Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe`

## Installing the Latest Version of Winget

If you're missing Winget or want to ensure you have the latest version, you can install it using the following command from Microsoft:

```powershell
$progressPreference = 'silentlyContinue'
Write-Information "Downloading WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
```

You could also install "App Installer" through the [Microsoft Store](https://www.microsoft.com/p/app-installer/9nblggh4nns1#activetab=pivot:overviewtab) to get to the same outcome.

## Navigating Available Command Line Options

Winget offers an array of powerful command-line options that enable you to perform various tasks. To explore them in detail, you can use the following command:

```powershell
winget -?
```
This will provide you with a handy list of commands, Each with their own context relevant options:

![Winget Help Output - Available Commands](content/post/Getting-To-Know-Winget/WingetSwitches.PNG)

<!--
```powershell
    usage: winget  [<command>] [<options>]

The following commands are available:
  install    Installs the given package
  show       Shows information about a package
  source     Manage sources of packages
  search     Find and show basic info of packages
  list       Display installed packages
  upgrade    Shows and performs available upgrades
  uninstall  Uninstalls the given package
  hash       Helper to hash installer files
  validate   Validates a manifest file
  settings   Open settings or set administrator settings
  features   Shows the status of experimental features
  export     Exports a list of the installed packages
  import     Installs all the packages in a file
  pin        Manage package pins
```
-->

To get more details on any specific commands available options, pass them the help argument. `[-?]`

for example, `winget install -?` would return the relevant options realating to installation. Some of these that are going to be relevant to us shortly are: 

| Install Option     | Description          |
| -------- | -------------- |
| --id  | Filter results by id |
| --name  | Filter results by name |
| -h,--silent    | Request silent installation |
| --accept-package-agreements    | Accept all licenseagreements for packages |
| --disable-interactivity   | Disable interactive prompts |


## Searching for Packages

Finding packages with Winget is simple. If you're looking for, let's say, Google Chrome, you can use the following command:

```powershell
winget search Chrome
```

This will present you with a list of matching packages, along with their IDs, versions, and sources.

## Getting Package Information

Curious about the details of a specific package? You can use the `show` command to retrieve comprehensive information. For instance, to get details about Google Chrome, you can use:

```powershell
winget show --id Google.Chrome
```

It's a good idea to use the 'Show' command to verify the package you are interacting with, is what you think it is.  

## Silently Installing a Package

Sometimes you might want to install packages without any prompts. To do so, use the `--silent` flag. For example:

```powershell
winget install --id Google.Chrome --silent
```

## Silently Upgrading All Packages

To keep your applications up to date without manual intervention, use the `upgrade` command with the following options:

```powershell
winget upgrade --all --uninstall-previous --force --accept-package-agreements --accept-source-agreements --silent --disable-interactivity
```

## Scripting winget

Microsoft provides an [Example Bash script](https://learn.microsoft.com/en-us/windows/package-manager/winget/#scripting-winget) that can install packages one after another using Winget. 

```powershell
@echo off  
Echo Install Powertoys and Terminal  
REM Powertoys  
winget install Microsoft.Powertoys  
if %ERRORLEVEL% EQU 0 Echo Powertoys installed successfully.  
REM Terminal  
winget install Microsoft.WindowsTerminal  
if %ERRORLEVEL% EQU 0 Echo Terminal installed successfully.   %ERRORLEVEL%
```

**An important note from Microsoft on this:** _When scripted, winget will launch the applications in the specified order. When an installer returns success or failure, winget will launch the next installer. If an installer launches another process, it is possible that it will return to winget prematurely. This will cause winget to install the next installer before the previous installer has completed._

## Silently Installing Multiple Specific Packages (One Liner)

If you want to automate the installation of a specific set of packages, you can use a script like this:

```powershell
winget install --id "7zip.7zip" "Adobe.Acrobat.Reader.64-bit" "Zoom.Zoom" "Notepad++.Notepad++" "Google.Chrome" "Mozilla.Firefox" "VideoLAN.VLC" "Egnyte.EgnyteDesktopApp" --silent --disable-interactivity --accept-source-agreements --accept-package-agreements
```

# Listing Installed Packages

You can get a list of installed packages using the command: 
```powershell
winget list
```

This command will output a table of installed packages and properties such as `Name, Id, Version` & `Available Source`.

Interestingly, this command will even display packages that were not originally installed through Windows Package Manager. 

## Silently Uninstalling a Package

Removing packages silently is just as easy. For example, to silently uninstall Google Chrome:

```powershell
winget uninstall --id Google.Chrome --silent
```

With these Winget commands and techniques, you have the power to manage your applications using Microsofts own package manager.

That's it for today! I hope this quick dive into managing applications with Winget proves helpful. Until next time, happy coding and exploring! 🚀

### _Automate and script away - Happy Shellcode Saturday!_