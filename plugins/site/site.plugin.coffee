# Requires
DocpadPlugin = require 'docpad/lib/plugin.coffee'
_ = require 'underscore'

# Define Plugin
class SitePlugin extends DocpadPlugin
	# Plugin Name
	name: 'totaldocuments'

	# Ammend our Template Data
	renderBefore: ({documents, templateData}, next) ->
		site = templateData.site
		_.extend site,
			title: 'function 개발새발(){...}'
			url: 'https://dogfeet.github.com'

		#totalDocuments
		totalDocuments = 0
		for document in documents
			totalDocuments++ if 0 is document.url.indexOf '/articles'
		site.totalDocuments = totalDocuments

		# Continue onto the next plugin
		next()

# Export Plugin
module.exports = SitePlugin
