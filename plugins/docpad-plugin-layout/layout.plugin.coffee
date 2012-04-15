_ = require 'underscore'
ck = require 'coffeekup'

# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class LayoutPlugin extends BasePlugin
		# Plugin Name
		name: 'layout'

		# Ammend our Template Data
		renderBefore: ({documents, templateData, logger}, next) =>

			logger = @logger
			_coffeeConfig = @config.docpad.config.plugins.coffee or {}

			templateData[ 'layout' ] = layout = (name, args...) ->
				template = _templates[ name ]
				if template?
					realTemplateData = _.extend {}, templateData, _coffeeConfig.coffeekup, {args}
					logger.log 'debug', "include '#{name}' layout for @layout"
					logger.log 'debug', "real template data's keys is #{_.keys realTemplateData}"
					template realTemplateData
				else
					'layout not found'

			_templates={}

			@docpad.layouts.forEach (layout) ->
				layoutId=layout.get('id')
				logger.log 'debug', "compiling '#{layoutId}' layout for @layout"
				_templates[ layoutId ] = ck.compile layout.get('content')

			# Continue onto the next plugin
			next()

