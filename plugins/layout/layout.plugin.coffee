# Requires
DocpadPlugin = require 'docpad/lib/plugin.coffee'
_ = require 'underscore'
ck = require 'coffeekup'

# Define Plugin
class LayoutPlugin extends DocpadPlugin
	# Plugin Name
	name: 'tool'

	# Ammend our Template Data
	renderBefore: ({documents, templateData, logger}, next) ->
		templateData[ 'layout' ] = layout = (name, moreTemplateData) ->
			template = _templates[ name ]
			if template?
				template _.extend {}, _templateDataForCk, moreTemplateData
			else
				'layout not found'

		_templateDataForCk = _.extend {}, templateData,
			format: true

		_templates={}

		for own name, layout of @docpad.layouts
			_templates[ name ] = ck.compile layout.content

		# Continue onto the next plugin
		next()

# Export Plugin
module.exports = LayoutPlugin
