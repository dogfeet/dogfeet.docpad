--- yaml
layout: 'default'
title: 'Archive'
---

style rel: 'stylesheet', media: 'screen, projection', scoped: 'scoped', ->
  """
  .article_footer {
    margin-left: 10px;
  }
  """

h1 "Archive"

section ".archive", ->
  for document in @documents
    if 0 is document.url.indexOf '/article'
      dateWrapper = @tool.moment document.date
      tagLinks = @layout 'tag-links', document.tags
      authorLinks = @layout 'author-links', document.author
      
      div '.row-fluid', ->
        div '.span2', dateWrapper.format('YYYY MMM DD')
        div '.span10.archive-item', ->
          a href: document.url, property: 'dc:title', ->
            strong "#{document.title}"
          div '.article_footer .modern-font .small-font', -> 
            text " posted in #{tagLinks} by #{authorLinks}"

