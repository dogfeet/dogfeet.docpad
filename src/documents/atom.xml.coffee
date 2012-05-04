---
date: '2000-1-1'
---

renderContent = (doc, siteUrl) ->
  rendered = doc.contentRenderedWithoutLayouts

  rendered = rendered.replace('src="/articles', "src=\"#{siteUrl}/articles")

  text '<![CDATA[\n'
  text rendered
  text ']]>\n'

anEntry = (document) ->
  tag 'entry', ->
    title '<![CDATA[ ' + document.title + ' ]]>'
    tag 'link', href: "#{@site.url}#{document.url}"
    tag 'updated', document.date.toIsoDateString()
    tag 'id', "#{@site.url}#{document.url}"
    tag 'content', type: 'html', -> renderContent document, @site.url

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'feed', xmlns: 'http://www.w3.org/2005/Atom', ->
  title '<![CDATA[ ' + @site.title + ' ]]>'
  tag 'link', href: "#{@site.url}/atom.xml", rel: 'self'
  tag 'link', href: @site.url
  tag 'updated', @site.date.toIsoDateString()
  tag 'id', @site.url
  @documents.forEach (document) ->
    if 0 is document.url.indexOf '/authors'
      tag 'author', ->
        tag 'name', document.name
        tag 'email', document.email

  i=0
  @documents.forEach (document) ->
    if document.encoding != 'binary' and 0 is document.url.indexOf '/articles'
      i++
      if i < 10 and document.contentRenderedWithoutLayouts
        anEntry document

