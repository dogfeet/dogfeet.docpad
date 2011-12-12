anEntry = (document) ->
  tag 'entry', ->
    tag 'title', document.title
    tag 'link', href: "#{@site.url}#{document.url}"
    tag 'updated', document.date.toString()
    tag 'id', "#{@site.url}#{document.url}"
    if document.firstRendered
      tag 'content', type: 'html', -> document.firstRendered.replace('src="/articles', "src=\"#{@site.url}/articles")
    else
      tag 'content', type: 'html', -> document.contentRendered.replace('src="/articles', "src=\"#{@site.url}/articles")

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'feed', xmlns: 'http://www.w3.org/2005/Atom', ->
  title @site.title
  tag 'link', href: "#{@site.url}/atom.xml", rel: 'self'
  tag 'link', href: @site.url
  tag 'updated', @site.date.toIsoDateString()
  tag 'id', @site.url
  for document in @documents
    if 0 is document.url.indexOf '/authors'
      tag 'author', ->
        tag 'name', document.name
        tag 'email', document.email

  for document in @documents
    anEntry document if 0 is document.url.indexOf '/articles'

