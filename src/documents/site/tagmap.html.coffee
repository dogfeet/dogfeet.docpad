---
layout: 'default'
title: 'Tagmap'
---

rowmap = (row, orig) ->
  ret = []

  tagnames = []
  for own tag of orig
    tagnames.push tag
  tagnames.sort()

  for tag, i in tagnames
    ret.push(cur = []) if i % row is 0
    cur.push tag

  ret

cellular = rowmap 3, @tags.store()

style rel: 'stylesheet', media: 'screen, projection', scoped: 'scoped', ->
  """
  #tagmap {
    margin-left: 10px;
  }
  .row > [class*="span"] {
    margin-left: 10px;
  }
  """

h1 'Tagmap'

section ".tagmap", ->
  for row in cellular
    div '#tagmap.row', ->
      for cell in row
        tag = @tags.store( cell )
        div "##{cell}.span4", ->
          h4 tag.name
          ul ->
            tag.documents.forEach (document)->
              li -> a href: "#{document.url}", "#{document.title}"

