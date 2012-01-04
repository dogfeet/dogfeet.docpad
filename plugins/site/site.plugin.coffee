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
			title: '개발새발'
			description: '정통 개발 주간 블로그입니다. 주 관심사는 학습과 WEB입니다.'
			keywords: '학습,Learning,HTML5,Mobile,Web,iPhone,Android,Git,개발새발,dogfeet'
			url: 'http://dogfeet.github.com'
			disqusShortName: 'dogfeet-github'

		#totalDocuments
		totalDocuments = 0
		for document in documents
			totalDocuments++ if 0 is document.url.indexOf '/articles'
		site.totalDocuments = totalDocuments

		# Continue onto the next plugin
		next()

# Export Plugin
module.exports = SitePlugin
