hl = require('highlight.js')

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

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

###
    # -----------------------------
    # Helper Functions

    # Get the prepared site/document title
    # Often we would like to specify particular formatting to our page's title
    # we can apply that formatting here
    getPreparedTitle: ->
      # if we have a document title, then we should use that and suffix the site's title onto it
      if @document.title
        "#{@document.title} | #{@site.title}"
      # if our document does not have it's own title, then we should just use the site's title
      else
        @site.title

    # Get the prepared site/document description
    getPreparedDescription: ->
      # if we have a document description, then we should use that, otherwise use the site's description
      @document.description or @site.description

    # Get the prepared site/document keywords
    getPreparedKeywords: ->
      # Merge the document keywords with the site keywords
      @site.keywords.concat(@document.keywords or []).join(', ')

  # =================================
  # DocPad Events

  # Here we can define handlers for events that DocPad fires
  # You can find a full listing of events on the DocPad Wiki
  events:

    # Server Extend
    # Used to add our own custom routes to the server before the docpad routes are added
    serverExtend: (opts) ->
      # Extract the server from the options
      {server} = opts
      docpad = @docpad

      # As we are now running in an event,
      # ensure we are using the latest copy of the docpad configuraiton
      # and fetch our urls from it
      latestConfig = docpad.getConfig()
      oldUrls = latestConfig.templateData.site.oldUrls or []
      newUrl = latestConfig.templateData.site.url

      # Redirect any requests accessing one of our sites oldUrls to the new site url
      server.use (req,res,next) ->
        if req.headers.host in oldUrls
          res.redirect(newUrl+req.url, 301)
        else
          next()
###
}

# Export our DocPad Configuration
module.exports = docpadConfig
