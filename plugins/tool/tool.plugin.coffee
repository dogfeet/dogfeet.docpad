# Requires
DocpadPlugin = require 'docpad/lib/plugin.coffee'
moment = require 'moment'

# Define Plugin
class ToolPlugin extends DocpadPlugin
	# Plugin Name
	name: 'tool'

	# Ammend our Template Data
	renderBefore: ({documents, templateData}, next) ->
		templateData[ 'tool' ] = tool =
			moment: moment
			summary: (contentRendered) ->
				splited = contentRendered.split(/<h[123456]>/)
				splited[0]

		# Continue onto the next plugin
		next()

# Export Plugin
module.exports = ToolPlugin
