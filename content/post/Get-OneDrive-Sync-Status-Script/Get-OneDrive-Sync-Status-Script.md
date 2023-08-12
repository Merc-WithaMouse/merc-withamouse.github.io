---
title: "Getting OneDrive File States with PowerShell"
description: "Unlock the power of PowerShell to delve into the attributes of local OneDrive files and interpret their File On Demand states."
date: 2023-08-12T04:45:00+01:00
image: "/post/Get-OneDrive-Sync-Status-Script/OneDriveBanner.jpg"
toc: false
hidden: true
comments: true
draft: false
authors:
    - ["Rob"]
categories:
    - PowerShell Scripting
    - OneDrive Scripting
tags:
    - OneDrive
    - PowerShell
    - File Attributes
    - File On Demand
    - Scripting
---

# Navigating the World of OneDrive File Attributes

In our ever-connected digital landscape, OneDrive has emerged as a prominent player in the realm of cloud storage and collaboration. Managing files and syncing them across devices is effortless, but have you ever wondered about the nitty-gritty details of how OneDrive handles these files locally? Today, we'll unveil the magic of PowerShell and explore how to retrieve and interpret the attributes of local OneDrive files, specifically focusing on their File On Demand (FOD) states.

## Initiating the Quest

My journey began with a simple yet intriguing task: I wanted to create a script that could examine local OneDrive files and extract their attributes, particularly shedding light on their FOD states. After some exploration, I stumbled upon a reference script from [Tristan Tyson's tech blog](https://tech.tristantyson.com/setonedrivefodstatespowershell) that seemed promising.

The initial script was straightforward:

```powershell
get-childitem | 
ForEach-Object {
    write-host "$_ :" $_.Attributes
}
```

This script looped through files and displayed their attributes. However, to adapt it for my needs, I needed to focus on OneDrive's specific attributes.

## The Reference Table and Adjustments

The reference script came with a table that associated attribute values with file states:

| File State          | Attribute   |
|---------------------|-------------|
| Cloud-Only          | 5248544     |
| Always available   | 525344      |
| Locally Available | ReparsePoint|

However, during my testing phase, I realized that the provided values didn't align correctly with OneDrive's states on my machine. So, I rolled up my sleeves and manually tested different sync states to identify the correct attribute values and their corresponding human-readable states.

For my testing (and ultimately my end goal), I took the reference script and adjusted it to drill down to the current users Commercial OneDrive directory. This allowed me (with toggling sync states multiple times) to identify the different attributes assiociated with different states.

```powershell
get-childitem $ENV:OneDriveCommercial -Force -File -Recurse | 
ForEach-Object {
    write-host "$_ :" $_.Attributes
}
```

Armed with the information gathered in the testing phase, I then constructed my own reference table. 

| File State          | Attribute   |
|---------------------|-------------|
| Cloud-Only          | 5248544     |
| Always available    | 525344      |
| Downloading         | 4724256     |
| Uploading           | 1049632     |
| Locally Available   | Archive, ReparsePoint|
| Hidden System File  | 1572902     |

Now, translating the attribute values to human-readable states should be an easy enough task to accomplish. 

## Cracking the Code: The Finished Script

After traveling so far on this quest, the elements of my script emerged, ready to unveil the OneDrive attributes we sought. To that end, I focused on generating clear and comprehensible results into a table format, leveraging a switch statement and PSCustomObject to complete this final task. 

```powershell
$OneDrivePath = $ENV:OneDriveCommercial

$filesInfo = Get-ChildItem $OneDrivePath -Force -File -Recurse | ForEach-Object {
    $fileName = $_.Name
    $attributes = $_.Attributes

    $state = switch ($attributes) {
        5248544 { "Cloud-Only" }
        525344 { "Always Available" }
        4724256 { "Downloading" }
        1049632 { "Uploading" }
        1572902 { "Hidden System File" }
        "Archive, ReparsePoint" { "Locally Available" }
        default { "Unknown" }
    }

    [PSCustomObject]@{
        FileName = $fileName
        State    = $state
    }
}

$filesInfo | Format-Table -AutoSize -Wrap
```

The script was then tested for its efficiency at gathering the needed information.

With this final script, I was able to successfully list the OneDrive file attributes as desired. The script translates OneDrive file attribute values into human-readable states, making it easier than ever to understand the synchronization status of each file.

## Final Thoughts and Further Explorations

In this exhilarating journey, we ventured into the realm of PowerShell to reveal the attributes of local OneDrive files. Armed with a script that interprets File On Demand states, we've unlocked a deeper understanding of file synchronization. As we continue our IT expeditions, let's remain curious and ever-ready to explore the intricacies of our digital world. 


### Automate. Script. Conquer - Happy Saturday!
