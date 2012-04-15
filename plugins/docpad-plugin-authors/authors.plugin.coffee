# Export Plugin
module.exports = (BasePlugin) ->
	_ = require('underscore');

	# Define Plugin
	class AuthorsPlugin extends BasePlugin
		# Plugin name
		name: 'authors'

		renderBefore: ({documents, templateData},next) =>
			try
				templateData[ 'authors' ]  = authors = {}

				documents.forEach (document) ->
					if 0 is document.get('url').indexOf '/authors'
						authors[ document.get('name') ] = document

				authors.toTwitter = (names) ->
					ret = []
					names = names.split ','

					for name in names
						name = name.trim()

						if authors.hasOwnProperty name
							ret.push '@' + authors[ name ].get('twitter')

					ret.join ' '

				next()
			catch err
				return next(err)

