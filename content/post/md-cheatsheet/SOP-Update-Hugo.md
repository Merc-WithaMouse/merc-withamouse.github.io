---
title: "Cheatsheet"
description: 
date: 2026-01-27T20:44:00+01:00
image: 
math: 
license: 
hidden: true
comments: false
draft: true

---

# **SOP: Updating Hugo & the Stack Theme**

A simple, repeatable procedure for safely updating Hugo and the Stack theme in this project.

---

## **1. Pre‑Update Checklist**

### **1.1 Check current versions**

Run:

```
hugo version
```

Confirm:
- Hugo version  
- That it is **extended**  
- Build date (helps spot outdated binaries)

### **1.2 Commit current state**

Before updating anything:

```
git add .
git commit -m "Pre-update snapshot"
```

This gives you a clean rollback point.

---

## **2. Update Hugo (Windows)**

Choose the method you use:

### **2.1 Scoop (recommended)**

```
scoop update hugo-extended
```

### **2.2 Chocolatey**

```
choco upgrade hugo-extended
```

### **2.3 Manual download**

1. Go to the Hugo releases page  
2. Download **hugo_extended_x.xx.x_windows-amd64.zip**  
3. Replace your existing `hugo.exe`  
4. Verify:

```
hugo version
```

---

## **3. Update the Stack Theme (Hugo Modules)**

### **3.1 Pull the latest theme version**

```
hugo mod get -u
```

### **3.2 Clean and tidy modules**

```
hugo mod tidy
hugo mod clean
```

This ensures your module cache matches the updated theme.

---

## **4. Run a Test Build**

```
hugo server
```

Check for:
- Deprecation warnings  
- Template errors  
- Missing functions (usually means Hugo too old)  
- Raw HTML warnings (optional to fix)

---

## **5. Apply Required Config Updates**

Hugo occasionally removes or renames config keys.  
Common fixes include:

### **5.1 Pagination (new syntax)**

Replace:

```
paginate = 5
```

with:

```
[pagination]
  pagerSize = 5
```

### **5.2 Allow raw HTML (optional)**

```
[markup.goldmark.renderer]
  unsafe = true
```

### **5.3 Silence raw HTML warnings (optional)**

```
ignoreLogs = ['warning-goldmark-raw-html']
```

Re‑run:

```
hugo server
```

---

## **6. Validate Content & Templates**

If you see:

```
ERROR error building site: logged 1 error(s)
```

Run:

```
hugo --verbose
```

Look for:
- Broken front matter  
- Old shortcodes  
- Custom templates in `layouts/` overriding the theme  
- Invalid dates or YAML formatting  

Fix the file(s) listed in the verbose output.

---

## **7. Final Verification**

1. Load the site locally  
2. Check homepage, posts, categories, tags, images  
3. Confirm no errors in the terminal  
4. Confirm no broken layouts or missing assets

---

## **8. Commit the Updated State**

Once everything works:

```
git add .
git commit -m "Updated Hugo + Stack theme"
```

Push if needed:

```
git push
```

---

## **9. Optional: Clear Hugo Cache**

If you see strange template errors:

```
hugo --cleanDestinationDir
hugo mod clean
```

Or manually delete:

```
%LOCALAPPDATA%\hugo_cache\
```

---

