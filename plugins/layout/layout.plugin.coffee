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
		templateData[ 'layout' ] = layout = (name, args...) ->
			template = _templates[ name ]
			if template?
				realTemplateData = _.extend {format:true}, templateData, {args}
				logger.log 'debug', "include '#{name}' layout for @layout"
				logger.log 'debug', "real template data's keys is #{_.keys realTemplateData}"
				template realTemplateData
			else
				'layout not found'

		_templates={}

		for own name, layout of @docpad.layouts
			logger.log 'debug', "compiling '#{name}' layout for @layout"
			_templates[ name ] = ck.compile layout.content

		# Continue onto the next plugin
		next()

# Export Plugin
module.exports = LayoutPlugin
