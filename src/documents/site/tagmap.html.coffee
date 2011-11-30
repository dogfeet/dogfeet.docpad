---
layout: 'default'
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

cellular = rowmap 4, @tags.store()

h1 'Tagmap'
for row in cellular
  div '.row', ->
    for cell in row
      tag = @tags.store( cell )
      div "##{cell}.span3", ->
        h4 tag.name
        ul ->
          for document in tag.documents
            li -> a href: "#{document.url}", "#{document.title}"

