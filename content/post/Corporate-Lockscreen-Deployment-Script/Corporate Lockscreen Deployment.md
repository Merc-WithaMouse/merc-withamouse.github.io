---
title: "Corporate Lockscreen Deployment"
description: 
date: 2023-04-22T14:03:47+01:00
image: "/post/Corporate-Lockscreen-Deployment-Script/MicrosoftPowershell.PNG"
math: 
license: 
toc: false
hidden: false
comments: true
draft: false
categories:
    - Windows Configuration - PowerShell
tags:
    - Windows 10
    - Windows 10 Configuration
    - PowerShell
    - Scripting
    - Automation
---

#### So, lets start checking off some of the goals outlined in my previous post...  

At the MSP where I work, we configure a fair amount of Windows computers _(like many others in the industry)_.  

I have already created a configuration script that does most of the heavy lifting. This script is due a massive overhaul but this can wait. For now, I need to create a function that sets the background wallpaper and lockscreen images for all users.

Previously when I have looked into this, I have come across _'Personalization CSP'_ in Microsoft documentation but hit a roadblock when i found that this was restricted to Education and Enterprise SKUs only.

I recently saw in a post on Reddit _(I dont remember what post but if i find it i will link here)_ that this is no longer the case. Looking at the documentation here: [Microsoft - Personalisation CSP](https://learn.microsoft.com/en-us/windows/client-management/mdm/personalization-csp), the post was correct.


#### Lets get started then...

Unfortunately, this documentation does not include any reference on application via registry but luckily, a quick Google search tells me what keys and values will be needed. So thats half the battle done.

First off, we need to create the following registry key:
_"`HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP`"_

``` powershell
# Create PersonalizationCSP Registry Key
New-Item HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP -Force
```  


Next, we'll need to declare some variables to contain the registry key path and image files.  

``` powershell
# Declare Variables
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$BackgroundImage = "C:\Images\Background.png"
$LockScreenImage = "C:\Images\Background.png"
```


Now, we can set the registry key values. We'll start with the lockscreen values.

``` powershell
# Set Lockscreen Registry Keys
New-ItemProperty -Path $RegPath -Name LockScreenImagePath -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageUrl -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null
```


And finally, the desktop background image values.

``` powershell
#Background Wallpaper Registry Keys
New-ItemProperty -Path $RegPath -Name DesktopImagePath -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageUrl -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null
```

To finish this up, we can bundle all these components together to form a simple function to implement in the configuration script mentioned earlier.

``` powershell
# Create PersonalizationCSP Registry Key
New-Item HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP -Force  

# Declare Variables
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$BackgroundImage = "C:\Images\Background.png"
$LockScreenImage = "C:\Images\Background.png"

# Set Lockscreen Registry Keys
New-ItemProperty -Path $RegPath -Name LockScreenImagePath -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageUrl -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null

#Background Wallpaper Registry Keys
New-ItemProperty -Path $RegPath -Name DesktopImagePath -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageUrl -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null
```


Calling this function in a test environment and then restarting the endpoint, I can see the specified images have been applied as the background wallpaper & lockscreen as desired.  

This does prevent standard users from changing their background and lockscreens, so i may look for a less restrictive way to achieve this but for now, this'll do.



---



#### Easy enough, lets go for bonus points...

To save naming both the image files used by each individual client the same file name (which is not really feasible), It would be helpful to have the image file specified by the technician running the configuration script. Equally, having this achieved using a familiar "Browse" dialog to eliminate any cances of mistyping would be incredibly beneficial for the less experienced technicians.

Back to Google I go.

Again, after a short search I came across an article that appears to fit the bill: [4Sysops - How to create an open file dialog with PowerShell](https://4sysops.com/archives/how-to-create-an-open-file-folder-dialog-box-with-powershell/)

So according to the article, to start off, we will need to load the System.Windows.Forms assembly.

``` powershell
# Load the System.Windows.Forms assembly 
Add-Type -AssemblyName System.Windows.Forms
```


Next, we will create a Open File Dialog instance.

``` powershell
# Instantiate an OpenFileDialog object using New-Object.
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = "C:\" }
```

If we want, we can even restrict the file type that can be selected.

``` powershell
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'Documents (*.docx)|*.docx|SpreadSheet (*.xlsx)|*.xlsx'
}
```
 

Finally, we just need to display the dialog instance.

``` powershell
# Display the Browse dialog
$null = $FileBrowser.ShowDialog() 
```


We can then, yet again wrap this into a simple function which can be implemented into scripts as needed.

``` powershell
function Get-OpenFileDialog{

# Load the System.Windows.Forms assembly 
Add-Type -AssemblyName System.Windows.Forms

# Instantiate an OpenFileDialog object using New-Object.
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = "C:\" }

# Display the Browse dialog
$null = $FileBrowser.ShowDialog() 

$SelectedFile = ($FileBrowser.FileName)
}
```

And there we have it. When this is ran, the familiar browse or open dialog is produced. A file can then be selected, which will be stored in OpenFileDialog.

If we piece these two functions together, we have a working solution for deploying corporate lock screen and desktop images, which we can implement into our main Windows configuration script.

Something like this should do...

``` powershell
function Get-OpenFileDialog{
# Load the System.Windows.Forms assembly.
Add-Type -AssemblyName System.Windows.Forms
# Instantiate an OpenFileDialog object using New-Object.
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = "C:\" }
# Display the Browse dialog.
$null = $FileBrowser.ShowDialog()
$SelectedFile = ($FileBrowser.FileName)
$SelectedFile
}


function Set-CorporateLockScreen{
# Create PersonalizationCSP Registry Key.
New-Item HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP -Force | Out-Null
# Declare Variables.
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$BackgroundImage = (Get-OpenFileDialog)
$LockScreenImage = (Get-OpenFileDialog)
# Set Lockscreen Registry Keys
New-ItemProperty -Path $RegPath -Name LockScreenImagePath -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageUrl -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null
#Background Wallpaper Registry Keys
New-ItemProperty -Path $RegPath -Name DesktopImagePath -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageUrl -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null
}
```

After adding this to our main configuration script, we can call the function `Set-CorporateLockScreen` in the execution section of the script. We will then be prompted to select the files for the lockscreen and background and then the registry keys will be applied. 

Part of the standard configuration workflow _(when using the script I created some time ago) is already to restart the endpoint manualy upon script completion. As such, we do not need to consider this in these functions. If we were implementing these functions elsewhere, a system restart would need to be factored in.

### On to the next task...