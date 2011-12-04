# Requires
DocpadPlugin = require "docpad/lib/plugin.coffee"

# Define Plugin
class AuthorsPlugin extends DocpadPlugin
	# Plugin name
	name: 'authurs'

	renderBefore: ({documents, templateData, logger},next) =>
		try
			templateData[ 'authors' ]  = authors = {}

			for document in documents
				if 0 is document.url.indexOf '/authors'
					authors[ document.name ] = document

			next()
		catch err
			return next(err)

# Export Plugin
module.exports = AuthorsPlugin
