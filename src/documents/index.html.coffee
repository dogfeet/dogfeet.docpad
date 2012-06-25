--- 
layout: 'default'
date: '2000-1-1'
---

i = 0
@getCollection('documents').forEach (document) ->
  if document.get('encoding') != 'binary' and 0 is document.get('url').indexOf '/articles'
    i++
    if i < 10
      article '.post', ->
        header ->
          a href: document.get('url'), ->
            h1 document.get('title')

        footer '.modern-font .small-font', ->
          text @layout 'article-footer', document

        if document.get('contentRenderedWithoutLayouts')
          text @tool.summary document.get('contentRenderedWithoutLayouts')

        p -> a '.btn', href: document.get('url'), 'Read more &raquo;'

p -> a '.btn.info.right', href: '/site/archive.html', 'go to Archive &raquo;'

