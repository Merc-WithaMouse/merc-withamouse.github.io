---
title: "Cheatsheet"
description: 
date: 2023-04-22T20:25:48+01:00
image: 
math: 
license: 
hidden: true
comments: true
draft: true
---

# PNG Assets
`https://www.pngegg.com/`

# Hugo Commands
### Create a new Hugo MD post: 
`hugo new post/md-cheatsheet/cheatsheet.md`

### Preview Drafts, Scheduled and Expired Posts
`hugo Server --buildDrafts    # or -D`  
`hugo Server --buildExpired   # or -E`  
`hugo Server --buildFuture    # or -F`  


# Markdown Syntax
<!-- Headings -->
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

<!-- Italics -->
*This text* is italic

_This text_ is italic

<!-- Strong -->
**This text** is italic

__This text__ is italic

<!-- Strikethrough -->
~ Test  ~ <!-- Remove Spaces -->
~~This text~~ is strikethrough

<!-- Horizontal Rule -->

---
___

<!-- Blockquote -->
> This is a quote

<!-- Links -->
[Traversy Media](http://www.traversymedia.com)

[Traversy Media](http://www.traversymedia.com "Traversy Media")

<!-- UL -->
* Item 1
* Item 2
* Item 3
  * Nested Item 1
  * Nested Item 2

<!-- OL -->
1. Item 1
1. Item 2
1. Item 3

<!-- Inline Code Block -->
`<p>This is a paragraph</p>`

<!-- Images -->
![Markdown Logo](https://markdown-here.com/img/icon256.png)

<!-- Github Markdown -->

<!-- Code Blocks -->
```bash
  npm install

  npm start
```

```javascript
  function add(num1, num2) {
    return num1 + num2;
  }
```

```python
  def add(num1, num2):
    return num1 + num2
```

<!-- Tables -->
| Name     | Email          |
| -------- | -------------- |
| John Doe | john@gmail.com |
| Jane Doe | jane@gmail.com |

<!-- Task List -->
* [x] Task 1
* [x] Task 2
* [ ] Task 3
























# Images Sizes
[Reference](https://www.zerostatic.io/docs/hugo-advance/guides/image-sizes/)
## Hero Image
The fullscreen image that runs across the top of pages in the “hero” section.
![hero image example](/Content/post/md-cheatsheet/assets/hero-image.png)

- Aspect Ratio: 16/9
- Suggested Image Sizes:
  - 1920px (width) x 1080px (height)
    - Notes: May look blurry on larger screens as the image will stretch fullwidth. Increasing the image size will increase the page load significantly. Be aware of the tradeoffs.
Example Image: /static/images/gen/services/service-1-large.webp

## Thumbnail
Many pages have a thumbnail frontmatter field. Normally used in the services and projects “cards” for example see the cards on the services page. Also can be used for blog thumbnails.

![thumbnail example](/Content/post/md-cheatsheet/assets/thumbnail.png)

- Aspect Ratio: 16/9
- Suggested Image Sizes:
  - 640px (width) x 360px (height)
  - 1280px (width) x 720px (height)
- Example Image: /static/images/gen/services/service-1-thumbnail.webp
- Example Image: /static/images/gen/blog/blog-1-thumbnail.webp

## Image
Most pages have a image frontmatter field. Often used instead of a hero image. Used alot in basic pages, see the about us page for an example. Also used in blog posts.

![image example](/Content/post/md-cheatsheet/assets/image.png)

- Aspect Ratio: 16/9
- Suggested Image Sizes:
 - 1280px (width) x 720px (height)
- Example Image: /static/images/gen/content/content-6.webp
- Example Image: /static/images/gen/blog/blog-1.webp

## Images in content
Images inside the markdown content will be resized to a max width of 640px so we recommend using an image at least 640px wide for the best look. The height can be any size you want.

![content example](/Content/post/md-cheatsheet/assets/content.png)

- Aspect Ratio: none
- Suggested Image Sizes:
  - 640px (width) x any (height)
- Example Image: /static/images/gen/content/content-3.webp













### Add a new page to your site.
hugo new post/My-First-Post/my-first-post.md

### Preview Drafts
hugo server --buildDrafts


### When editing content, if you want your browser to automatically redirect to the page you last modified, run:
hugo server --navigateToChanged
hugo server --minify --buildDrafts --navigateToChanged
