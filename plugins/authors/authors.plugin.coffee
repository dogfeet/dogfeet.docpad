# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class AuthorsPlugin extends BasePlugin
		# Plugin name
		name: 'authurs'

		renderBefore: ({documents, templateData, logger},next) =>
			try
				templateData[ 'authors' ]  = authors = {}

				for document in documents
					if 0 is document.url.indexOf '/authors'
						authors[ document.name ] = document

				authors.toTwitter = (names) ->
					ret = []
					names = names.split ','

					for name in names
						name = name.trim()

						ret.push '@' + authors[ name ].twitter

					ret.join ' '

				next()
			catch err
				return next(err)

