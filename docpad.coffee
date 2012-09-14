hl = require 'highlight.js'
moment = require 'moment'
_ = require 'underscore'

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
module.exports = 
  # =================================
  # Template Data
  # These are variables that will be accessible via our templates
  # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

  templateData:

    # Specify some site properties
    site:
      # The production url of our website
      url: "http://dogfeet.github.com"

      # The default title of our website
      title: "개발새발"

      # The website description (for SEO)
      description: """
        정통 개발 주간 블로그입니다. 주 관심사는 학습과 WEB입니다.
        """
      # The website keywords (for SEO) separated by commas
      keywords: """
        학습,Learning,HTML5,Mobile,Web,iPhone,Android,Git,JavaScript,Scala,개발새발,dogfeet
        """
      disqusShortName: "dogfeet-github"

    # helpers
    helper:
      formatDate: (date)->
        moment( date ).format('YYYY MMM DD')
      genTags: (tag)->
        return '' if !tag

        tags = tag
        tags = tag.split ',' if _.isString tag

        _.map(tags, (name)->
          name = name.trim()
          """<a href="/site/tagmap.html##{name.toLowerCase()}" class="tag">#{name}</a>"""
        ).join ' '
      genAuthors: (authors, name)->
        return '' if !name

        names = name
        names = name.split ',' if _.isString name

        _.map(names, (name)->
          name = name.trim()
          author = authors[ name ]
          """<a href="#{author.get('url')}">#{author.meta.get('name')}</a>"""
        ).join ' '

    # tools
    tool:
      '_': _
      summary: (contentRendered) ->
        splited = contentRendered.split(/<h[123456]>/)
        splited[0]

  # =================================
  # DocPad Plugin Config
  plugins:
    marked:
      markedOptions:
        highlight: (code, lang)->
          has = lang && hl.LANGUAGES.hasOwnProperty(lang.trim())
          return hl.highlight(lang, code).value if has
          return hl.highlightAuto(code).value
        inline: (src, hash, escape)->
          out = src

          #for people
          out = out.replace /(^|[ \t]+)@([a-zA-Z0-9]+)/g, (whole, m1, m2) ->
            hash m1 + '<a href="https://twitter.com/' + m2 + '">@' + m2 + '</a>'

          #for hash tag·
          out = out.replace /(^|[ \t]+)#([ㄱ-ㅎ가-힣a-zA-Z0-9]+)/g, (whole, m1, m2) ->
            hash m1 + '<a href="/site/tagmap.html#' + m2 + '">#' + m2 + '</a>'

          out

  # =================================
  # DocPad Events

  # Here we can define handlers for events that DocPad fires
  # You can find a full listing of events on the DocPad Wiki
  events:

    # Ammend our Template Data
    renderBefore: ({collection, templateData}, next) ->
      #sorting documents 
      collection.comparator = (model) ->
        -model.get('date').getTime()
      collection.sort()

      # Continue onto the next plugin
      next()

