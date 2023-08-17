---
title: "Deconstructed: Convert OneDrive Files to Online-Only"
description: "Discover a useful little PowerShell script to effortlessly transform your OneDrive files into online-only mode, freeing up disk space by uploading files."
date: 2023-08-12T23:45:00+01:00
image: "/post/Convert-OneDrive-Files-Online-Only/OneDriveBanner-White.png"
toc: false
hidden: false
comments: true
draft: false
authors:
    - ["Rob"]
categories:
    - PowerShell Scripting
    - OneDrive
    - Deconstructed
tags:
    - OneDrive
    - PowerShell
    - File Attributes
    - Files On Demand
    - Online-Only
    - Scripting
---


# Manage OneDrive: Converting Files to Online-Only with PowerShell

Hello there, another quick one to finish off the day. Let's dive into a quick breakdown of a useful little PowerShell script we stumbled upon in _[Tristan Tyson's tech blog](https://tech.tristantyson.com/setonedrivefodstatespowershell)_ whilst looking into _[Getting OneDrive File States with PowerShell](/content/post/Get-OneDrive-Sync-Status-Script\Get-OneDrive-Sync-Status-Script.md)_. This small but handy script is all about converting your OneDrive _(Commercial)_ files into online-only mode. This can be scoped for OneDrive _(Personal)_ files as well.

 Let's break it down step by step.

## The Script: Streamlining Online-Only Conversion

The script focuses on using PowerShell to set your OneDrive _(Commercial)_ files as online-only, saving local storage. You can check out the original post _[here](https://tech.tristantyson.com/setonedrivefodstatespowershell)_, courtesy of Tristan Tyson.

Here's the script laid out for you:

```powershell
get-childitem $ENV:OneDriveCommercial -Force -File -Recurse -ErrorAction SilentlyContinue |
Where-Object { $_.Attributes -match 'ReparsePoint' -or $_.Attributes -eq '525344' } |
ForEach-Object {
    attrib.exe $_.fullname +U -P /s
}
```

## The Breakdown: What Each Part Does

1. **Gathering OneDrive Files:** We start by using `Get-ChildItem` to get the OneDrive directory contents _(recursively)_. The `-File` switch ensures we focus on files, and `-Recurse` dives into subdirectories.

2. **Choosing the Right Ones:** With `Where-Object`, we pick files with specific attributes. Those with 'ReparsePoint' or '525344' attributes are targeted as these attributes relate to locally availabile files _(See my previous post: [Getting OneDrive File States with PowerShell](/content/post/Get-OneDrive-Sync-Status-Script\Get-OneDrive-Sync-Status-Script.md))_.

3. **Making the Change:** For each chosen file, we employ `attrib.exe` to do the magic. The `+U -P /s` commands shift the file to online-only mode.

## Embrace Streamlined OneDrive Management

And there you have it, folks! A straightforward dive into Tristan Tyson's script for transforming OneDrive files into online-only mode. With a few lines of PowerShell, you can streamline your file management, making the most of online storage.

Feel free to use this script to optimize your OneDrive experience. Here's to more efficient digital spaces and simplified file management!

---

With this script in your toolkit, you've got the power to make your OneDrive files online-only and keep things tidy. Stay tuned for more useful script breakdowns and tips!


#### **Next time**: We will look at creating a dashboard alert and automated remediation task for use with RMM software. This will likely utilise elements of or even combine this small script we haev created today and our previous script to _[Get OneDrive File Sync Status]("content/post/Get-OneDrive-Sync-Status-Script/Get-OneDrive-Sync-Status-Script.md)_

### Automate and script away - Happy Shellcode Saturday!