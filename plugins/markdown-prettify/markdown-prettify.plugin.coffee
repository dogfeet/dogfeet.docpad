# Requires
DocpadPlugin = require "docpad/lib/plugin.coffee"

# Define Plugin
class MarkdownPrettifyPlugin extends DocpadPlugin
	# Plugin name
	name: 'markdown-prettify'

	# Plugin priority: smaller than markdown(700)
	priority: 699

	# Normalize language name
	normal:
		javascript: 'js'
		coffeescript: 'coffee'
		bash: 'bsh'
		plain: 'text'

	normalize: (lang) =>
		lang = lang.toLowerCase()
		if @normal.hasOwnProperty lang
			return @normal[ lang ]
		else
			return lang

	# Detect language
	detects: [
			/^#!\/usr\/bin\/env\s+(\w+)\s*\n/
			/^#!\/usr\/bin\/(\w+)\s*\n/
			/^#!\/bin\/(\w+)\s*\n/
		]

	dels: [
			/^:::(\w+)\s*\n/
		]

	getLang: (code) =>
		lang = null
		for del in @dels
			result = del.exec code
			if result
				code = code.replace /^.*\n/, ''
				lang = @normalize result[1]

		for detect in @detects
			result = detect.exec code
			lang = @normalize result[1] if result

		lang: lang, code: code

	# Render some content
	render: ({inExtension,outExtension,templateData,file, logger}, next) =>
		try
			if inExtension in ['md','markdown'] and outExtension is 'html'
				#codes = file.content.split /<pre><code>\s*[<pre><code>]{0,1}/
				codes = file.content.split /<pre><code>/
				pretties = []
				for i in [0..codes.length]
					code = codes[i]
					continue if !code

					if i > 0
						{lang, code} = @getLang code
						if lang?
							pretties.push ['<pre class="prettyprint"><code class="language-', lang,'">'].join ''
						else if lang is 'text'
							pretties.push '<pre><code>'
						else
							pretties.push '<pre class="prettyprint"><code>'

					pretties.push code
				
				file.content = pretties.join ''

				next()
			else
				next()
		catch err
			return next(err)

# Export Plugin
module.exports = MarkdownPrettifyPlugin
