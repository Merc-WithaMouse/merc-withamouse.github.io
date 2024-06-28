if (Get-Command -Name winget -ErrorAction SilentlyContinue) {
    Write-Output "Chceking output."
    $WingetVersion = (winget.exe -v)
    Write-Output "Winget is installed. Version: $WingetVersion";
}
else {
    Write-Output "Winget is not installed."
    Write-Output "Installing Winget..."
    try {
        Invoke-WebRequest -Uri https://aka.ms/winget-cli -OutFile winget-cli.msixbundle
        Start-Sleep -Seconds 1
        Add-AppxPackage -Path .\winget-cli.msixbundle
    }
    catch {
        Write-Output "Winget Installation Failed."
    }
}



$progressPreference = 'silentlyContinue'
Write-Information "Downloading WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle






<#

Using what you already know about me, create a blog post for my ShellCode Saturdays blog on "Quick Dive: Managing Applications With Winget". I will provide my different aims for the post and then notes from the current outputs of some of the winget commands.


#### Post to include: 
- How to Check Winget is intalled. 
- How to Install the Latest Version of Wiinget.
- Overview of available winget switches (command line options). 
- How to search for packages via Winget.
- How to use the Show command to get package information. 
- How to silently install a package using Winget. 
- How to silently upgrage all packages using Winget.
- Script to silently install the following packages using Winget: 
  * --id "7zip.7zip"
  * --id "Adobe.Acrobat.Reader.64-bit"
  * --id "Zoom.Zoom"
  * --id "Notepad++.Notepad++"
  * --id "Google.Chrome"
  * --id "Mozilla.Firefox"
  * --id "VideoLAN.VLC"
  * --id "Egnyte.EgnyteDesktopApp"
- How to silently uninstall a package using Winget. 


------------------------------------------
# Notes to Create Post: 

### Check Winget Installed

### Help Command
```powershell
winget -?
```

#### Output
```powershell
The winget command line utility enables installing applications and other packages from the command line.

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

For more details on a specific command, pass it the help argument. [-?]

The following options are available:
  -v,--version              Display the version of the tool
  --info                    Display general info of the tool
  -?,--help                 Shows help about the selected command
  --wait                    Prompts the user to press any key before exiting
  --logs,--open-logs        Open the default logs location
  --verbose,--verbose-logs  Enables verbose logging for winget
  --disable-interactivity   Disable interactive prompts

More help can be found at: https://aka.ms/winget-command-help
```


### Search Command
```powershell
winget search Chrome
```

#### Output
```powershell

Name                                            Id                         Version        Match                 Source
-----------------------------------------------------------------------------------------------------------------------
DC Browser - Chrome and IE kernels              XP890QTFL1X0D0             Unknown                              msstore
DC Browser - Chrome and IE kernel               XP8BV7F2CT4LDK             Unknown                              msstore
Dichromate                                      Dichromate.Browser         110.0.5481.178 Command: chrome       winget
Google Chrome Dev                               Google.Chrome.Dev          117.0.5938.0   Command: chrome       winget
Google Chrome Beta                              Google.Chrome.Beta         117.0.5938.11  Command: chrome       winget
Chrome Remote Desktop Host                      Google.ChromeRemoteDesktop 112.0.5615.26  Tag: chrome           winget
Ginger Chrome                                   Saxo_Broko.GingerChrome    93.0.4529.0                          winget
ChromeCacheView                                 NirSoft.ChromeCacheView    2.45                                 winget
ICBCChromeExtension                             ICBC.ICBCChromeExtension   1.2.0.0                              winget
Google Chrome Canary                            Google.Chrome.Canary       117.0.5935.0                         winget
ChromeDriver for Chrome 111                     Chromium.ChromeDriver      114.0.5735.90                        winget
360 极速浏览器X                                 360.360Chrome.X            21.0.1216.0                          winget
360极速浏览器                                   360.360Chrome              13.5.2044.0                          winget
115浏览器                                       115.115Chrome              25.0.6.5                             winget
Google Chrome                                   Google.Chrome              116.0.5845.97                        winget
Vision Teacher for Chromebooks Machine-Wide In… Netop.VisionTeacher        1.7.6.0                              winget
Inssist                                         SlashedIo.Inssist          16.1.0         Tag: chrome-extension winget

```

### Show Command
```powershell
winget show --id Google.Chrome
```

#### Output
```powershell
Found Google Chrome [Google.Chrome]
Version: 116.0.5845.97
Publisher: Google LLC
Publisher Url: https://www.google.com
Publisher Support Url: https://support.google.com/?hl=en
Author: Google LLC
Description: A more simple, secure, and faster web browser than ever, with Google’s smarts built-in.
Homepage: https://www.google.com/intl/en_us/chrome
License: Freeware
License Url: https://www.google.com/intl/en_us/chrome/terms
Privacy Url: https://policies.google.com/privacy?hl=en
Copyright: Copyright 2023 Google LLC. All rights reserved.
Tags:
  browser
  chromium
  internet
  web
  webpage
Installer:
  Installer Type: msi
  Installer Url: https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi
  Installer SHA256: 0ba199118165a597ee91398312cee3f8444c249be649f3d40b2d0d8a48b9911f
  Release Date: 2023-08-15
```

### Install Help Command
```powershell
winget install -?
```

#### Output
```powershell

Installs the selected package, either found by searching a configured source or directly from a manifest. By default, the query must case-insensitively match the id, name, or moniker of the package. Other fields can be used by passing their appropriate option. By default, install command will check package installed status and try to perform an upgrade if applicable. Override with --force to perform a direct install.

usage: winget install [[-q] <query>...] [<options>]

The following command aliases are available:
  add

The following arguments are available:
  -q,--query                           The query used to search for a package

The following options are available:
  -m,--manifest                        The path to the manifest of the package
  --id                                 Filter results by id
  --name                               Filter results by name
  --moniker                            Filter results by moniker
  -v,--version                         Use the specified version; default is the latest version
  -s,--source                          Find package using the specified source
  --scope                              Select install scope (user or machine)
  -a,--architecture                    Select the architecture to install
  -e,--exact                           Find package using exact match
  -i,--interactive                     Request interactive installation; user input may be needed
  -h,--silent                          Request silent installation
  --locale                             Locale to use (BCP47 format)
  -o,--log                             Log location (if supported)
  --custom                             Arguments to be passed on to the installer in addition to the defaults
  --override                           Override arguments to be passed on to the installer
  -l,--location                        Location to install to (if supported)
  --ignore-security-hash               Ignore the installer hash check failure
  --ignore-local-archive-malware-scan  Ignore the malware scan performed as part of installing an archive type package from local manifest
  --dependency-source                  Find package dependencies using the specified source
  --accept-package-agreements          Accept all license agreements for packages
  --no-upgrade                         Skips upgrade if an installed version already exists
  --header                             Optional Windows-Package-Manager REST source HTTP header
  --accept-source-agreements           Accept all source agreements during source operations
  -r,--rename                          The value to rename the executable file (portable)
  --uninstall-previous                 Uninstall the previous version of the package during upgrade
  --force                              Direct run the command and continue with non security related issues
  -?,--help                            Shows help about the selected command
  --wait                               Prompts the user to press any key before exiting
  --logs,--open-logs                   Open the default logs location
  --verbose,--verbose-logs             Enables verbose logging for winget
  --disable-interactivity              Disable interactive prompts

More help can be found at: https://aka.ms/winget-command-install
```


### Upgrade All Command
```powershell

winget upgrade --all --uninstall-previous --force --accept-package-agreements --accept-source-agreements --silent  --disable-interactivity

--uninstall-previous
--force
--accept-package-agreements
--accept-source-agreements
--silent
--disable-interactivity

```


### App IDs
```powershell

--id "7zip.7zip"
--id "Adobe.Acrobat.Reader.64-bit"
--id "Zoom.Zoom"
--id "Notepad++.Notepad++"
--id "Google.Chrome"
--id "Mozilla.Firefox"
--id "VideoLAN.VLC"
--id "Egnyte.EgnyteDesktopApp"

# Ignore: "--id "Microsoft.OfficeDeploymentTool""

```

#>