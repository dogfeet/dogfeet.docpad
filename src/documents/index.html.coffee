--- 
layout: 'default'
date: '2000-1-1'
---
div style: 'display:none', -> h1 'dogfeet'
section '.content.articles', ->
  div '.row', -> h2 '.offset2.span10', 'Articles'
  i = 0
  @getCollection('documents').forEach (document) ->
    if document.get('encoding') != 'binary' and 0 is document.get('url').indexOf '/articles'
      i++
      if i > 10
        return
      article '.articles-item', style: 'padding-bottom: 1em;', ->
        # Date & Title
        div '.row', ->
          div '.span2.muted.modern-font.small-font', ->
            span property: 'dc:created', ->
              @helper.formatDate( document.get('date') ) + ' &raquo;'
          div '.span10', ->
            a href: document.get('url'), -> document.get('title')
        # Author & Info
        div '.row', ->
          div '.offset2.span10.modern-font.small-font.muted', ->
            text @layout 'article-footer', document
        if i > 3
          return
        # First paragraph
        div '.row.hidden-phone', ->
          div '.offset2.span10', ->
            if document.get('contentRenderedWithoutLayouts')
              text '<br/>'
              text @tool.summary document.get('contentRenderedWithoutLayouts')
            p -> a '.btn', href: document.get('url'), 'Read more &raquo;'
p -> a '.btn.info.right', href: '/site/archive.html', 'go to Archive &raquo;'