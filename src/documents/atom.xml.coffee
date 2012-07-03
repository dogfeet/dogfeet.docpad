---
date: '2000-1-1'
---

renderContent = (doc, siteUrl) ->
  rendered = doc.get('contentRenderedWithoutLayouts')

  rendered = rendered.replace('src="/articles', "src=\"#{siteUrl}/articles")

  text '<![CDATA[\n'
  text rendered
  text ']]>\n'

anEntry = (document) ->
  tag 'entry', ->
    title '<![CDATA[ ' + document.get('title') + ' ]]>'
    tag 'link', href: "#{@site.url}#{document.get('url')}"
    tag 'updated', document.get('date').toISODateString()
    tag 'id', "#{@site.url}#{document.get('url')}"
    tag 'content', type: 'html', -> renderContent document, @site.url

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'feed', xmlns: 'http://www.w3.org/2005/Atom', ->
  title '<![CDATA[ ' + @site.title + ' ]]>'
  tag 'link', href: "#{@site.url}/atom.xml", rel: 'self'
  tag 'link', href: @site.url
  tag 'updated', @site.date.toISODateString()
  tag 'id', @site.url
  @getCollection('documents').forEach (document) ->
    if 0 is document.get('url').indexOf '/authors'
      tag 'author', ->
        tag 'name', document.get('name')
        tag 'email', document.get('email')

  i=0
  @getCollection('documents').forEach (document) ->
    if document.get('encoding') != 'binary' and 0 is document.get('url').indexOf '/articles'
      i++
      if i < 10 and document.get('contentRenderedWithoutLayouts')
        anEntry document

