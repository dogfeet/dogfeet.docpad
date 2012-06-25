--- yaml
layout: 'default'
title: 'Archive'
---

moment=@tool.moment
layout=@layout

style rel: 'stylesheet', media: 'screen, projection', scoped: 'scoped', ->
  """
  .article_footer {
    margin-left: 10px;
  }
  """

h1 "Archive"

section ".archive", ->
  @getCollection('documents').forEach (document) ->
    if document.get('encoding') != 'binary' and 0 is document.get('url').indexOf '/article'
      dateWrapper = moment document.get('date')
      tagLinks = layout 'tag-links', document.get('tags')
      authorLinks = layout 'author-links', document.get('author')
      
      div '.row-fluid', ->
        div '.span2', dateWrapper.format('YYYY MMM DD')
        div '.span10.archive-item', ->
          a href: document.get('url'), property: 'dc:title', ->
            strong "#{document.get('title')}"
          div '.article_footer .modern-font .small-font', -> 
            text " posted in #{tagLinks} by #{authorLinks}"

