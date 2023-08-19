---
title: "Installing Apps With Winget"
description: 
date: 2023-08-20T03:45:00+01:00
image: 
toc: false
math: 
license: 
hidden: true
comments: true
draft: true
authors:
    - ["Rob"]
categories:
    - PowerShell
    - Application Management
    - CLI Tool
tags:
    - Winget
    - PowerShell
---

<!-- Microsofts Guide -->
<!-- 
https://learn.microsoft.com/en-us/windows/package-manager/winget/ -->

# Quick Dive: Managing Applications With Winget

Welcome back to another ShellCode Saturdays blog post! In this edition, we'll be taking a quick dive into managing applications using Microsoft's powerful package manager, Winget. If you're looking for a seamless way to install, update, and uninstall software on Windows, you're in for a treat. Let's get started!

## Checking if Winget is Installed

Before we jump into the magic of Winget, let's make sure it's installed on your system. You can easily check this by opening your command prompt or PowerShell and typing the following:

```powershell
winget -?
```

If Winget is installed, you'll see a helpful command summary along with various options and commands that you can use.

## Installing the Latest Version of Winget

If you're missing Winget or want to ensure you have the latest version, you can install it using the following command:

```powershell
winget install Microsoft.Winget
```

Or...

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


## Navigating Available Command Line Options

Winget offers an array of powerful command-line options that enable you to perform various tasks. To explore them in detail, you can use the following command:

```powershell
winget -?
```

This will provide you with a comprehensive list of options, allowing you to customize your installation process.

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

To get more details on any specific options own available , pass it the help argument. [-?]

for example, `winget install -?` would return the relevant options realating to installation. Some of these that are going to be relevant to us shortly are: 

| Install Option     | Description          |
| -------- | -------------- |
| --id  | Filter results by id |
| --name  | Filter results by name |
| -h,--silent    | Request silent installation |
| --accept-package-agreements    | Accept all licenseagreements for packages |
| --disable-interactivity   | Disable interactive prompts |


## Searching for Packages

Finding packages with Winget is a breeze. If you're looking for, let's say, Google Chrome, you can use the following command:

```powershell
winget search Chrome
```

This will present you with a list of matching packages, along with their IDs, versions, and sources.

## Getting Package Information

Curious about the details of a specific package? You can use the `show` command to retrieve comprehensive information. For instance, to get details about Google Chrome, you can use:

```powershell
winget show --id Google.Chrome
```

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

## Script for Silently Installing Specific Packages

If you want to automate the installation of a specific set of packages, you can use a script like this:

```powershell
winget install --id "7zip.7zip" "Adobe.Acrobat.Reader.64-bit" "Zoom.Zoom" "Notepad++.Notepad++" "Google.Chrome" "Mozilla.Firefox" "VideoLAN.VLC" "Egnyte.EgnyteDesktopApp" --silent --silent --disable-interactivity
```

## Silently Uninstalling a Package

Removing packages silently is just as easy. For example, to silently uninstall Google Chrome:

```powershell
winget uninstall --id Google.Chrome --silent
```

With these Winget commands and techniques, you have the power to effortlessly manage your applications, ensuring your system stays organized and up to date.

Remember, Winget is an incredibly versatile tool that can make your life easier. Explore its commands, experiment, and embrace the convenience it offers in managing your software ecosystem.

That's it for today's ShellCode Saturdays post! We hope this quick dive into managing applications with Winget proves helpful. Until next time, happy coding and exploring! 🚀