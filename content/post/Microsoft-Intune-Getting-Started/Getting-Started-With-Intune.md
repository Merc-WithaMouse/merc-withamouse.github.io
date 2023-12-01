---
title: "Getting Started With Intune"
description: ""
date: 2023-08-12T23:45:00+01:00
image: "/post/Convert-OneDrive-Files-Online-Only/OneDriveBanner-White.png"
toc: false
hidden: true
comments: true
draft: true
authors:
    - ["Rob"]
categories:
    - Deconstructed
tags:
    - OneDrive
    - PowerShell
    - File Attributes
    - Files On Demand
    - Online-Only
    - Scripting
---

# Intune Quick Start Guide
<!--[https://jannikreinhard.com/2023/01/08/intune-quick-start-guide/]-->

## How to create a Configuration Profile?
- Open https://endpoint.microsoft.com in your Browser
- Select Devices in the left start menu and select Configuration Profiles
- Click + Create profile
- Select the Platform in our case Windows 10 and select Settings catalog
- Click Create

- Enter a Name (Hint: It is recommended to have a naming convention)
- Click Next
- Click + Add settings
- Select and configure the settings you want to take
- Click Next -> Next

- Create a assignment. In my case I select all Devices. (It is recommended to use custom groups instead of all users and devices)
- Click Next
- Review the settings and click Create

# How to enroll a device into Intune?
[Windows 10/11](https://jannikreinhard.com/2021/07/17/setup-a-windows-autopilot-test-lab/)
[MacOS](https://jannikreinhard.com/2022/06/18/getting-started-with-mac-management-in-microsoft-intune/)

# Setup Autopilot Test Lab
## Enable the Intune auto-enrollment for all users. 
- Select in the MEM (Microsoft Endpoint Manager) portal, Devices > Enroll devices > Automatics Enrollment.
- select All for “MDM user scope” and “MAM user scope”.
- Click save.

## Add Company Branding
- Open Azure Active Directory. 
- Company branding and Configure.
- Configure the company branding per requirement.

## Create dynamic device group
- Open MEM portal (https://intune.microsoft.com/)
- Select Groups from the left menu bar
- Click New grou
- Name Policies&Apps
- Select Security as Group type,
- Enter a group name and select Dynamic Device as Membership type
- Click on Add dynamic query
- Click Edit and enter the following filter
```(device.devicePhysicalIds -any _ -eq "[OrderID]:AutoPilotTest1")```
- Click Create

- Create a new group as type Assigned
-- Click No members selected
-- Add the previously created group (DynamicDevice) with the autopilot objects 

- Create a new group called all users & set as type Dynamic
- Specify the following as filters (Edit Syntax)
```	(user.surname -ne " 0")```
- Save & click create

- To add a license go to Licenses > Assignments
- Select the Microsoft 365 E5 Developer license and click Save

##  Create AutoPilot deployment profile
- Go to the MEM (Intune) portal.
- Go to Devices > Enrol Devices > Windows Enrollment > Deployment Profiles.
- Click Create Profile > Windows PC.
- Enter a name.
- The OOBE (out-of-the-box experience) settings can be left at the default values.
- Click Next
-- If you want to set a custom hostename, enable 'Apply Device Name Template'. You can use the variables %SERIAL% or %RAND:x% (x = number of characters)
- Click Add groups and select the dynamic user group created in the earlier step.
- Click Select and Next.
- Click Create
- Deployment profile created. 

## Configure the Enrollment Status Page
*Enrollment Status Page (ESP) shows the progress of the deployment*
- Select Devices > Enroll devices > Enrollment Status Page in the MEM (Intune) portal.
_By default there is already an entry. Now we want to configure it according to our needs_
- Click on All users and all devices
- Click properties
- Click on Edit next to the Settings heading
- Select Yes for “Show app and profile configuration progress“.
- Select No for “Show custom message when time limit error occurs” or insert a custom message for a time out
- Select Yes for “Allow users to reset device if installation error occurs“.
- Click Review + Save > Save.

# Register a device in intune (VM / Non OEM method) 
- Start the machine and type “Shift + F10” on the keyboard.
- Type into the CMD window PowerShell
Type in the following commands:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
Install-Script -Name Get-WindowsAutoPilotInfo
```
- Type the following command and Authenticate with an Intune Admin account:
```powershell
Get-WindowsAutoPilotInfo.ps1 -GroupTag AutoPilotTest1 -online
```
_Confirm all queries with [Y] Yes or [A] Yes to all_
- Type the following command and Authenticate with an Intune Admin account:
```powershell
Get-WindowsAutoPilotInfo.ps1 -GroupTag AutoPilotTest1 -online
```
- Sign in with Intune Admin. 
- Accept the required rights.
- Check in Intune if the hash is there and if the group tag is set
-- Check via MEM (Intune Portal) > Devices > Enrol Devices

# How to add and deploy a new Application?
[Win23 App](https://jannikreinhard.com/2021/07/24/deploy-an-win32-app-with-intune-cmtrace/)
[Windows Store App](https://jannikreinhard.com/2022/12/11/deploy-windows-store-apps-via-intune/)
_W32 applications must always be uploaded as .intunewin package. It is not possible to simply upload an .exe file. See how to create an .intunewin package below._

### Prepare installation sources
- Download the CMtrace installation file from the following link: [System Center 2012 R2 Configuration Manager Toolkit](https://www.microsoft.com/en-us/evalcenter/download-microsoft-endpoint-configuration-manager)
- Install the MSI. After running the MSI you can find the sources in `C:\Program Files (x86)\ConfigMgr 2012 Toolkit R2\.`
- Copy the CMTrace tool from the ClientTools folder into a temp folder e.g. C:\temp\cmtrace\soureces

### Install the  Microsoft Intune Win32 App Packaging Tool
- Download the tool from the following Github repo: [microsoft/Microsoft-Win32-Content-Prep-Tool](https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool)
- Extract the folder and copy the IntuneWinAppUtil.exe to the temp folder.

### Creating the installation and uninstallation script
- Create two text files with the name install.bat and deinstall.bat
- Add the following content to the scripts:
*install.bat*
```batch
mkdir c:\windows\_Tools
Xcopy cmtrace.exe c:\windows\_Tools /e /i
```
*deinstall.bat*
```batch
del c:\windows\_Tools\cmtrace.exe
```
_Hint: The path can be chosen as you like_

### Creating the Intunewin file
- Open PowerShell as administrator and navigate to the temp folder.
- Enter the following command:
```powershell
Set-ExecutionPolicy Bypass
```
- Confirm prompt with [Y] Yes
- Enter the following Command:
```powershell
.\IntuneWinAppUtil -c C:\temp\cmtrace\sources\ -s C:\temp\cmtrace\sources\install.bat -o C:\temp\cmtrace
```
_Switches_
-- -c = Folder of the setup files
-- -s = Setupfile
-- -o = Output folder for the .intunewin file
- Now the intunewin installation file is created

#### Creating the Win32 App in intune
- Navigate to Apps -> Windows
- Click Add
- Select Windows app (Win32) as App type
- Click Select app package file
- Click upload und select the .intunewin file
- Click OK
- Give the application a name and customize the app information.
- Click Next
- Enter the install.bat and deinstall.bat as install/unistall command
- Change the Device restart behavior to No specific action
- Click Next
_Hint: If you use an powershell script insert the following command:_
```powershell
%windir%\system32\windowspowershell\v1.0\powershell.exe -executionpolicy bypass -windowstyle hidden -file "File.ps1"
```
- Select 32-bit and 64-bit as Operation system architecture
- Select a minimum OS Version
_Hints: If you want to specify further requirements, such as minimum free disk space, you can do this in this step.
It is also possible to specify a file, a registry value or a script as a requirement._

- Select Manually configure detection rules as Rules format
- Click Add
- Select File as Rule type
- Enter your file path and the file name. The detection method is File or folder exists
- Click Next
- We can skip the depentencies and supersedence step click next.
- Add an assignment. Add a group a required, the app will be installed automatically. If you select availale the app will only be offered in the Company Portal for installation.
- When you click on one of the hyperlinks behind the group you still have possibilities to make some aditional configurations. E.g. the download type for delivery optimization (Foreground or Backround) or you can also hide the installations notifications.
- Click Next > Create


