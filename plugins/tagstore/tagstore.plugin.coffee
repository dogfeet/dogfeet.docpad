# Requires
DocpadPlugin = require "docpad/lib/plugin.coffee"
_ = require 'underscore'

# Define Plugin
class TagstorePlugin extends DocpadPlugin
	# Plugin name
	name: 'tagstore'

	getTags: (obj) ->
		tags = [obj] if _.isString obj
		tags = @getTags obj() if _.isFunction obj
		tags = obj if _.isArray obj

		tags

	renderBefore: ({documents, templateData},next) ->
		try
			tagHolder = {}
			templateData[ 'tagstore' ] = tagstore = (tagname, obj) ->
				if tagname
					key = tagname.toLowerCase()
					if obj
						#set
						if tagHolder[ key ]
							tagHolder[ key ].documents.push obj
						else
							tagHolder[ key ] =
								name : tagname
								documents : [obj]

						tagstore

					else if tagname
						#get
						tagHolder[ key ]
				else
					tagHolder

			for document in documents
				tags = @getTags document[ 'tags' ]
				for tag in tags
					tagstore tag, document

			next()
		catch err
			return next(err)

# Export Plugin
module.exports = TagstorePlugin
