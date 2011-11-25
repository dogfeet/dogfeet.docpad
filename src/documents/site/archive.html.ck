--- yaml
layout: 'default'
title: 'Home'
date: '2009-05-21T16:06:05.000Z'
---

section class: 'posts', ->
  h2 'Posts'
  nav class: 'linklist', typeof: 'dc:collection', ->
    for document in @documents
      if 0 is document.url.indexOf '/article'
        li typeof: 'sioc:Post', about: document.url, ->
          span property: 'dc:created', "#{document.date.toShortDateString()}"
          a href: document.url, property: 'dc:title', "#{document.title}"

