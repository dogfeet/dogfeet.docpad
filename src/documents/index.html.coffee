--- 
layout: 'default'
date: '2009-05-21T16:06:05.000Z'
---

for document in @documents
  if 0 is document.url.indexOf '/articles'
    article '.post', ->
      header ->
        a href: document.url, ->
          h1 document.title

      footer ->
        span ->
          author = @authors[ document.author ]
          text 'by '
          if author
            a href: "#{author.url}", "#{author.name}"
          else
            text "#{document.author}"
        text ' | '
        span property: 'dc:created', "#{document.date.toShortDateString()}"
        text ' | '
        for tag in document.tags
          text ', ' if tag isnt document.tags[0]
          a href: "/site/tagmap.html##{tag.toLowerCase()}", tag
        text ' | '
        span '18 comments'

      if document.firstRendered is undefined
        text @tool.summary document.contentRendered
      else
        text @tool.summary document.firstRendered
      
      p -> a '.btn', href: document.url, 'View Detail &raquo;'
