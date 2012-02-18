moment = require 'moment'
_ = require 'underscore'

# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class ToolPlugin extends BasePlugin
		# Plugin Name
		name: 'tool'

		# Ammend our Template Data
		renderBefore: ({documents, templateData}, next) ->
			templateData[ 'tool' ] = tool =
				moment: moment
				'_': _
				summary: (contentRendered) ->
					splited = contentRendered.split(/<h[123456]>/)
					splited[0]

			# Continue onto the next plugin
			next()

