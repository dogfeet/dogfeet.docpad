# Requires
#DocpadPlugin = require "#{__dirname}/../../plugin.coffee"
DocpadPlugin = require 'docpad/lib/plugin.coffee'
markdown = require('dogfeet-flavored-markdown')

# Define Plugin
class MarkdownPlugin extends DocpadPlugin
	# Plugin name
	name: 'dogfeet-flavored-markdown'

	# Plugin priority
	priority: 700
	templates:
		'@': ( key ) ->
			['<a href="https://twitter.com/#!/', key, '">@', key, '</a>'].join('')
		'#': ( key ) ->
			['<a href="/site/tagmap.html#', key, '">#', key, '</a>'].join('')

	# Render some content
	render: ({inExtension,outExtension,templateData,file}, next) ->
		try
			if inExtension in ['md','markdown'] and outExtension is 'html'
				file.content = markdown.parse file.content, { templates:@templates }
				next()
			else
				next()
		catch err
			return next(err)

# Export Plugin
module.exports = MarkdownPlugin
