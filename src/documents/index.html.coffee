--- 
layout: 'default'
date: '2000-1-1'
---

i = 0
for document in @documents
  if 0 is document.url.indexOf '/articles'
    i++
    if i < 10
      article '.post', ->
        header ->
          a href: document.url, ->
            h1 document.title

        footer ->
          text @layout 'article-footer', document

        text @tool.summary document.contentRenderedWithoutLayouts

        p -> a '.btn', href: document.url, 'Read more &raquo;'

p -> a '.btn.info.right', href: '/site/archive.html', 'go to Archive &raquo;'

