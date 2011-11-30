# Requires
DocpadPlugin = require "docpad/lib/plugin.coffee"

# Define Plugin
class AuthorPlugin extends DocpadPlugin
	# Plugin name
	name: 'authurs'

	renderBefore: ({documents, templateData},next) =>
		try
			templateData[ 'authors' ]  = authors =
				data : {}
				render : (name) ->
					return '' if not name?

					rendered = []

					names = name.split(',')
					for n in names
						n = n.trim()
						author = @data[ n ]
						if author
							rendered.push """<a href="#{author.url}">#{author.name}</a>"""
						else
							rendered.push n

					rendered.join(', ')

			for document in documents
				if 0 is document.url.indexOf '/authors'
					authors.data[ document.name ] = document

			next()
		catch err
			return next(err)

# Export Plugin
module.exports = AuthorPlugin
