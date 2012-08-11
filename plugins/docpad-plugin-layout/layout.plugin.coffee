_ = require 'underscore'
ck = require 'coffeecup'

# Export Plugin
module.exports = (BasePlugin) ->
    # Define Plugin
    class LayoutPlugin extends BasePlugin
        # Plugin Name
        name: 'layout'

        # Ammend our Template Data
        renderBefore: ({collection, templateData}, next) =>

            logger = @docpad.getLogger()
            _coffeeConfig =
                coffeekup:
                    format: true

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

            @docpad.getCollection('layouts').forEach (layout) ->
                layoutId=layout.get('id').replace('.html.coffee','')
                logger.log 'debug', "compiling '#{layoutId}' layout for @layout"
                _templates[ layoutId ] = ck.compile layout.get('content')

            # Continue onto the next plugin
            next()

