anEntry = (document) ->
  tag 'entry', ->
    tag 'title', document.title
    tag 'link', href: "#{@site.url}#{document.url}"
    tag 'updated', document.date.toString()
    tag 'id', "#{@site.url}#{document.url}"
    if document.firstRendered
      tag 'content', type: 'html', -> document.firstRendered
    else
      tag 'content', type: 'html', -> document.contentRendered

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'feed', xmlns: 'http://www.w3.org/2005/Atom', ->
  title @site.title
  tag 'link', href: "#{@site.url}/atom.xml", rel: 'self'
  tag 'link', href: @site.url
  tag 'updated', @site.date.toIsoDateString()
  tag 'id', @site.url
  tag 'author', ->
    tag 'name', 'Changwoo Park'
    tag 'email', 'pismute@gmail.com'
  tag 'author', ->
    tag 'name', 'Sean Lee'
    tag 'email', 'lethee@gmail.com'
  tag 'author', ->
    tag 'name', 'Yongjae Choi'
    tag 'email', 'lnyarl@gmail.com'

  for document in @documents
    anEntry document if 0 is document.url.indexOf '/article'

