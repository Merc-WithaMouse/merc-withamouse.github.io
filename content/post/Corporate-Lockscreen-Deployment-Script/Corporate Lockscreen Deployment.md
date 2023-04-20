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

At the MSP where I work, we configure a fair amount of Windows computers (like many other in the industry).  

I have already created a configuration script that does most of the heavy lifting. This script is due a massive overhaul but this can wait. For now, I need to create a function that sets the background and lockscreen images for all users.

Previously when I have looked into this, I have come across _'Personalization CSP'_ in Microsoft documentation but hit a roadblock when i found that this was restricted to Education and Enterprise SKUs only.

I recently saw in a post on Reddit (I dont remember what post but if i find it i will link here) that this is no longer the case. Looking at the documentation here [Microsoft - Personalisation CSP](https://learn.microsoft.com/en-us/windows/client-management/mdm/personalization-csp) the post was correct.


##### Lets get started then...


