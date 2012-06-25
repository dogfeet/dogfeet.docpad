moment = require 'moment'
_ = require 'underscore'

# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class ToolPlugin extends BasePlugin
		# Plugin Name
		name: 'tool'

		# Ammend our Template Data
		renderBefore: ({collection, templateData}, next) ->
			templateData[ 'tool' ] = tool =
				moment: moment
				'_': _
				summary: (contentRendered) ->
					splited = contentRendered.split(/<h[123456]>/)
					splited[0]

			collection.comparator = (model) ->
				-model.get('date').getTime()
			collection.sort()

			# Continue onto the next plugin
			next()

