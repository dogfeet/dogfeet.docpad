#parameters
#@authorLinks

author = @args[0]

if author? and typeof author is 'string'
  authorNames = author.split(',')

  rendered = []

  for name in authorNames
    name = name.trim()

    author = @authors[ name ]
    if author?
      rendered.push """<a href="#{author.url}">#{author.name}</a>"""
    else
      rendered.push name

  text "by #{rendered.join(', ')}"
