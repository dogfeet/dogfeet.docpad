---
layout: 'default'
---

for own tag, value of @tagmap
  section "##{tag.toLowerCase()}.tag", ->
    header ->
      h2 tag
    ul ->
      for document in value
        li -> a href: "#{document.url}", "#{document.title}"


