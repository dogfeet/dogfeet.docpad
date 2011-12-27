---
layout: default
---

article "#post.#{@document.class}", typeof: 'sioc:post', about: "#{@document.url}", lang: 'ko-kr', ->
  header ->
    h1 property: 'dcterms:title', "#{@document.title}"
  footer '.row', ->
    p ' '
    div '.span4', ->
      if @document.github?
        iframe src:"http://githubbadge.appspot.com/badge/#{@document.github}?a=0", style: 'border: 0;height: 150px;width: 200px;overflow: hidden;'
      else
        img src: "http://www.gravatar.com/avatar/#{@document.gravata}"
    div '.span8', ->
      if @document.twitter?
        div ->
          span -> strong 'twitter:'
          a href: "http://twitter.com/#!/#{@document.twitter}", "@#{@document.twitter}"
      if @document.links?
        div ->
          div -> strong 'Links ->'
          blockquote -> @document.links.join ', '

  div property: 'sioc:content', -> "#{@content}"

