---
title: "Corporate Lockscreen Deployment"
description: 
date: 2023-04-20T10:03:47+01:00
image: MicrosoftLogo.PNG
math: 
license: 
hidden: false
comments: true
draft: true
---

#### So, lets start checking off some of the goals outlined in my previous post...  

At the MSP where I work, we configure a fair amount of Windows computers _(like many others in the industry)_.  

I have already created a configuration script that does most of the heavy lifting. This script is due a massive overhaul but this can wait. For now, I need to create a function that sets the background and lockscreen images for all users.

Previously when I have looked into this, I have come across _'Personalization CSP'_ in Microsoft documentation but hit a roadblock when i found that this was restricted to Education and Enterprise SKUs only.

I recently saw in a post on Reddit _(I dont remember what post but if i find it i will link here)_ that this is no longer the case. Looking at the documentation here: [Microsoft - Personalisation CSP](https://learn.microsoft.com/en-us/windows/client-management/mdm/personalization-csp), the post was correct.


#### Lets get started then...

Unfortunately, this documentation does not include any reference on application via Registry but luckily, a quick Google search tells me what keys and values will be needed so thats half the battle done.

First off, we need to create the following registry key:
_"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"_

``` powershell
# Create PersonalizationCSP Registry Key
New-Item HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP -Force
```  

Next, we'll need to declare some variables to contain the Registry Key path and image files.  

``` powershell
# Declare Variables
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$BackgroundImage = "C:\Images\Background.png"
$LockScreenImage = "C:\Images\Background.png"
```

Now, we can start to set the registry key values. We'll start with the lockscreen values.

``` powershell
# Set Lockscreen Registry Keys
New-ItemProperty -Path $RegPath -Name LockScreenImagePath -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageUrl -Value $LockScreenImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name LockScreenImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null
```

Finally, the desktop background image values.

``` powershell
#Background Wallpaper Registry Keys
New-ItemProperty -Path $RegPath -Name DesktopImagePath -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageUrl -Value $Backgroundimage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name DesktopImageStatus -Value 1 -PropertyType DWORD -Force | Out-Null
```
Now, we can bundle all these components together to form a simple function to implement in the configuration script mentioned earlier.

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

Running this function in a test environment and then restarting the endpoint, I can see the specified images have been applied as the background wallpaper & lockscreen as desired.  

This does prevent standard users from changing their background and lockscreens, so i may look for a less restrictive way to achieve this but for now, this'll do.