---
layout: default
---

@document.firstRendered or= @content

article "#post.#{@document.class}", typeof: 'sioc:post', about: "#{@document.url}", lang: 'ko-kr', ->
  header ->
    h1 property: 'dcterms:title', "#{@document.title}"
  div property: 'sioc:content', -> "#{@content}"

