# Requires
DocpadPlugin = require "docpad/lib/plugin.coffee"
_ = require 'underscore'

# Define Plugin
class TagmapPlugin extends DocpadPlugin
	# Plugin name
	name: 'tagmap'

	getTags: (obj) =>
		tags = [obj] if _.isString obj
		tags = @getTags obj() if _.isFunction obj
		tags = obj if _.isArray obj

		tags

	renderBefore: ({documents, templateData},next) =>
		try
			templateData[ 'tagmap' ]  = tagmap = {}
			for document in documents
				tags = @getTags document[ 'tags' ]
				for tag in tags
					tagdocs = tagmap[tag]
					tagdocs = tagmap[tag] = [] if !tagdocs
					tagdocs.push document

			next()
		catch err
			return next(err)

# Export Plugin
module.exports = TagmapPlugin
