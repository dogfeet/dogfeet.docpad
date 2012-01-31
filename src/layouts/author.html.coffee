---
layout: default
---

#generate for meta[name=description]
if !@document.description
  desc = @content.trim()
  #strip html tag
  desc = desc.replace(/(<([^>]+)>)/ig,'')

  len = desc.indexOf '\n'
  if len > 0
    desc = desc.substring 0, len

  @document.description = desc

#generate for meta[name=keywords]
if !@document.keywords and @document.tags
  @document.keywords = @document.tags.join ','

#not defined title
if @document.filename.indexOf @document.title == 0
  @document.title = @document.name

#generate for meta[name=author]
if !@document.author
  @document.author = @document.name

article "#post.#{@document.class}", typeof: 'sioc:post', about: "#{@document.url}", lang: 'ko-kr', ->
  header '.row', ->
    div '.span2', ->
      img src: "http://www.gravatar.com/avatar/#{@document.gravata}"
    div '.span10', ->
      h1 property: 'dcterms:title', "#{@document.title}"
      if @document.twitter?
        div ->
          span -> strong 'twitter:'
          a href: "http://twitter.com/#!/#{@document.twitter}", "@#{@document.twitter}"
      if @document.links?
        div ->
          div -> strong 'Links ->'
          blockquote -> @document.links.join ', '

  footer '.row', ->
    p ' '
    div '.span4', ->
      if @document.github?
        iframe src:"http://githubbadge.appspot.com/badge/#{@document.github}?a=0", style: 'border: 0;height: 150px;width: 200px;overflow: hidden;'
  div property: 'sioc:content', -> "#{@content}"

