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
    tag 'updated', document.get('date').toISOString()
    tag 'id', "#{@site.url}#{document.get('url')}"
    tag 'content', type: 'html', -> renderContent document, @site.url

text '<?xml version="1.0" encoding="utf-8"?>\n'
tag 'feed', xmlns: 'http://www.w3.org/2005/Atom', ->
  title '<![CDATA[ ' + @site.title + ' ]]>'
  tag 'link', href: "#{@site.url}/atom.xml", rel: 'self'
  tag 'link', href: @site.url
  tag 'updated', @site.date.toISOString()
  tag 'id', @site.url
  for name of @authors
    author = @authors[ name ]
    tag 'author', ->
      tag 'name', author.name
      tag 'email', author.email

  i=0
  @getCollection('articles').forEach (document) ->
    i++
    if i < 10 and document.get('contentRenderedWithoutLayouts')
      anEntry document

