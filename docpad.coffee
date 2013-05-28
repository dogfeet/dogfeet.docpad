hl = require 'highlight.js'
moment = require 'moment'
_ = require 'underscore'

to =
  value: (it) ->
    return it() if _.isFunction( it )
    it

## for locally access
    
authors =
  'Changwoo Park':
    name: 'Changwoo Park'
    email: 'pismute@gmail.com'
    github: 'pismute'
    twitter: 'pismute'
    gravata: '2694a5501ec37eab0c6d4bf98c30303a'
  'Sean Lee':
    name: 'Sean Lee'
    email: 'sean@weaveus.com'
    github: 'lethee'
    twitter: 'lethee'
    page: """<a href="http://kr.linkedin.com/in/seanseonghwanlee">Sean Lee</a>"""
    gravata: '2699699e90ed281807fc0631ec89bbe2'
  'Yongjae Choi':
    name: 'Yongjae Choi'
    email: 'mage@weaveus.com'
    github: 'lnyarl'
    twitter: 'lnyarl'
    gravata: '8232d82f449689642bb4c1f6bbc929bd'

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
module.exports = 
  # =================================
  # Template Data
  # These are variables that will be accessible via our templates
  # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

  templateData:
    authors: authors

    # Specify some site properties
    site:
      # The production url of our website
      url: "http://dogfeet.github.io"

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
      genAuthors: (name)->
        return '' if !name

        names = name
        names = name.split ',' if _.isString name

        _.map(names, (name)->
          name = name.trim()
          author = authors[ name ]
          return to.value(author.page) if author.hasOwnProperty( 'page' )
          """<a href="https://twitter.com/#{author.twitter}/">#{author.name}</a>"""
        ).join ', '
      genTwitter: (names) ->
        ret = []
        names = names.split ','

        for name in names
          name = name.trim()

          if authors.hasOwnProperty name
            ret.push '@' + authors[ name ].twitter

        ret.join ' '

    # tools
    tool:
      '_': _
      summary: (contentRendered) ->
        splited = contentRendered.split(/<h[123456]>/)
        splited[0]

  # =================================
  # DocPad Plugin Config
  plugins:
    robotskirt:
      highlight: (code,lang) ->
        has = lang && hl.LANGUAGES.hasOwnProperty(lang.trim())

        open = if has then '<pre><code class="lang-'+lang.trim()+'">' else '<pre><code>'
        body = if has then hl.highlight(lang, code).value else hl.highlightAuto(code).value
        close = '</code></pre>'

        open + body + close

      inline: (src, hash, houdini)->
        out = src

        #for people
        out = out.replace /(^|[ \t]+)@([a-zA-Z0-9]+)/g, (whole, m1, m2) ->
          hash m1 + '<a href="https://twitter.com/' + m2 + '">@' + m2 + '</a>'

        #for hash tag·
        out = out.replace /(^|[ \t]+)#([ㄱ-ㅎ가-힣a-zA-Z0-9]+)/g, (whole, m1, m2) ->
          hash m1 + '<a href="/site/tagmap.html#' + m2 + '">#' + m2 + '</a>'

        out

  # =================================
  # Collections
  # These are special collections that our website makes available to us

  collections:
    # For instance, this one will fetch in all documents that have pageOrder set within their meta data
    #pages: (database) ->
    #  database.findAllLive({pageOrder: $exists: true}, {pageOrder: 1})

    # This one, will fetch in all documents that have the tag "post" specified in their meta data
    articles: (database) ->
      config = @config
      database.findAllLive({fullPath: $startsWith: config.documentsPaths + '/articles'}, [date:-1])
    speach: (database) ->
      database.findAllLive({tags: $has: 'speach'}, [date:-1])

  # Environments
  # Allows us to set custom configuration for specific environments
  environments:
    w:  # for writing and debug
      ignoreCustomPatterns: /2008|2009|2010|2011|2012/

      # =================================
      # DocPad Events

      # Here we can define handlers for events that DocPad fires
      # You can find a full listing of events on the DocPad Wiki
      events:
        docpadReady: ({docpad}, next)->
          console.log(':docpadReady:')
          next()

        consoleSetup: ({consoleInterface, commander}, next)->
          console.log(':consoleSetup:')
          next()

        generateBefore: ({}, next)->
          console.log(':generateBefore:')
          next()

        generateAfter: ({}, next)->
          console.log(':generateAfter:')
          next()

        parseBefore: ({}, next)->
          console.log(':parseBefore:')
          next()

        parseAfter: ({}, next)->
          docpad = @docpad
          console.log(['total files=', docpad.database.length])

          console.log(':parseAfter:')
          next()

        renderBefore: ({collection, templateData}, next)->
          console.log(':renderBefore:')
          next()

        renderAfter: ({collection}, next)->
          console.log(':renderAfter:')
          next()
        ###
        render: ({inExtension, outExtension, templateData, file, content}, next)->
          console.log(':render:')
          next()

        renderDocument: ({extension, templateData, file, content}, next)->
          console.log(':renderDocument:')
          next()
        ###
        writeBefore: ({collection, templateData}, next)->
          console.log(':writeBefore:')
          next()

        writeAfter: ({collection}, next)->
          console.log(':writeAfter:')
          next()

        serverBefore: ({}, next)->
          console.log(':serverBefore:')
          next()

        serverAfter: ({server}, next)->
          console.log(':serverAfter:')
          next()

        serverExtend: ({server}, next)->
          console.log(':serverExtend:')
          next()

      ###
        # Ammend our Template Data
        renderBefore: ({collection, templateData}, next) ->
          #sorting documents 
          collection.comparator = (model) ->
            try
              -model.meta.get('date').getTime()
            catch error
              9007199254740992
          collection.sort()

          next()
      ###


