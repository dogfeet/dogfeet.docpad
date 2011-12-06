---
layout: default
---

article "#post.#{@document.class}", typeof: 'sioc:post', about: "#{@document.url}", lang: 'ko-kr', ->
  header ->
    h1 property: 'dcterms:title', "#{@document.title}"
  footer '.row', ->
    p ' '
    img '.span2', src: "http://www.gravatar.com/avatar/#{@document.gravata}"
    div '.span10', ->
      if @document.twitter?
        div ->
          span -> strong 'twitter:'
          a href: "http://twitter.com/#!/#{@document.twitter}", "@#{@document.twitter}"
      if @document.github?
        div ->
          span -> strong 'github:'
          a href: "https://github.com/#{@document.github}", "#{@document.github}"
      if @document.links?
        div ->
          div -> strong 'Links ->'
          blockquote -> @document.links.join ', '

  div property: 'sioc:content', -> "#{@content}"

