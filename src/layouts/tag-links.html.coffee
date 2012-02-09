tag = @args[0]
href = '/site/tagmap.html'

if tag? 
  if typeof tag is 'string'
    tagNames = tag.split ','
  else
    tagNames = tag

  rendered = []

  for name in tagNames
    name = name.trim()

    tag = @tags.store name
    if tag?
      rendered.push """<a href="#{href}##{name.toLowerCase()}" class="btn btn-tag btn-info">#{name}</a>"""
    else
      rendered.push name

  text "#{rendered.join ' '}"
