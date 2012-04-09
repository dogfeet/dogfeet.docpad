# Export Plugin
module.exports = (BasePlugin) ->
	_ = require('underscore');

	# Define Plugin
	class AuthorsPlugin extends BasePlugin
		# Plugin name
		name: 'authurs'

		renderBefore: ({documents, templateData},next) =>
			try
				templateData[ 'authors' ]  = authors = {}

				documents.forEach (document) ->
					if 0 is document.url.indexOf '/authors'
						authors[ document.name ] = document

				authors.toTwitter = (names) ->
					ret = []
					names = names.split ','

					for name in names
						name = name.trim()

						if authors.hasOwnProperty name
							ret.push '@' + authors[ name ].twitter

					ret.join ' '

				next()
			catch err
				return next(err)

