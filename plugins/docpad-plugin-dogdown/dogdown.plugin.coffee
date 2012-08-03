# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class DogdownPlugin extends BasePlugin
		# Plugin name
		name: 'dogdown'

		# Plugin priority
		priority: 700

		templates:
			'@': ( key ) ->
				['<a href="https://twitter.com/', key, '">@', key, '</a>'].join('')
				#['<a href="https://github.com/', key, '">@', key, '</a>'].join('')
			'#': ( key ) ->
				['<a href="/site/tagmap.html#', key, '">#', key, '</a>'].join('')

		# Render some content
		render: (opts,next) ->
			# Prepare
			{inExtension,outExtension,templateData,content} = opts

			# Check our extensions
			if inExtension in ['md','markdown'] and outExtension is 'html'
				# Requires
				markdown = require('dogfeet-flavored-markdown')

				# Render
				opts.content = markdown.parse( content, { templates:@templates } )
	
			# Done, return back to DocPad
			return next()

