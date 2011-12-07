doctype 5
html lang: 'en', ->
  head ->
    comment 'Meta'
    meta charset: 'utf-8'
    meta 'http-equiv': 'X-UA-Compatible', content: 'IE=edge,chrome=1'
    meta 'http-equiv': 'content-type', content: 'text/html; charset=utf-8'
    meta name: 'viewport', content: 'width=device-width, initial-scale=1'

    if 0 is @document.filename.indexOf @document.title
      #document has not own title, not articles or authors
      title @site.title
      meta name: 'description', content: @site.description or ''
      authorNames=[]
      for document in @documents
        if 0 is document.url.indexOf '/authors'
          authorNames.push document.name

      authors = if authorNames.length > 0 then authorNames.join(', ') else ''
      meta name: 'author', content: authors
    else 
      #document has own title, articles or authors
      title @document.title
      meta name: 'description', content: @document.description or ''
      meta name: 'author', content: @document.author or ''

    comment 'Icons'
    link rel: 'shortcut icon', href: 'images/favicon.ico'
    link rel: 'apple-touch-icon', href: 'images/apple-touch-icon.png'
    link rel: 'apple-touch-icon', sizes: '72x72', href: 'images/apple-touch-icon-72x72.png'
    link rel: 'apple-touch-icon', sizes: '114x114', href: 'images/apple-touch-icon-114x114.png'

    comment 'Shims: IE6-8 support of HTML5 elements'
    comment '[if lt IE 9]>\n        <script async src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>\n    <![endif]'
    comment 'Styles'
    link rel: 'stylesheet', href: 'http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css', media: 'screen, projection'
    link rel: 'stylesheet', href: 'http://twitter.github.com/bootstrap/assets/js/google-code-prettify/prettify.css', media: 'screen, projection'
    link rel: 'stylesheet', href: '/styles/style.css', media: 'screen, projection'
    #link rel: 'stylesheet', href: '/styles/print.css', media: 'print'

    text @blocks.styles.join('')

    comment 'Scripts'

    script src: 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'
    script src: 'http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.0.6/modernizr.min.js'
    script src: '/vendor/prettify.js'
    script src: '/vendor/lang-apollo.js'
    script src: '/vendor/lang-clj.js'
    script src: '/vendor/lang-css.js'
    script src: '/vendor/lang-go.js'
    script src: '/vendor/lang-hs.js'
    script src: '/vendor/lang-lisp.js'
    script src: '/vendor/lang-lua.js'
    script src: '/vendor/lang-ml.js'
    script src: '/vendor/lang-n.js'
    script src: '/vendor/lang-proto.js'
    script src: '/vendor/lang-scala.js'
    script src: '/vendor/lang-sql.js'
    script src: '/vendor/lang-tex.js'
    #script src: '/vendor/lang-vb.js'
    script src: '/vendor/lang-vhdl.js'
    script src: '/vendor/lang-wiki.js'
    script src: '/vendor/lang-xq.js'
    script src: '/vendor/lang-yaml.js'
    script src: '/scripts/script.js'

    text @blocks.scripts.join('')

  body ->
    comment 'Topbar'
    div '.topbar', ->
      div '.topbar-inner', ->
        div '.container-fluid', ->
          a '.brand', href: '/', 'dogfeet'

          ul '.nav', ->
            #li -> a href: '/site/about.html', 'About'
            li -> a href: '/site/tagmap.html', 'Tagmap'
            li -> a href: '/site/archive.html', 'Archive'
            li -> a href: '/site/atelier.html', 'Atelier'
            li -> a href: '/atom.xml', -> 
              img src: 'http://forum.tattersite.com/ko/style/Textcube/feed-icon.png'

          form '.pull-right', action: 'http://google.com/search', method: 'get', ->
            input type: 'hidden', name: 'q', value: 'site:dogfeet.github.com'
            input type: 'text', name: 'q', results: '0', placeholder: 'Search'

    comment 'Markup'
    div '.container-fluid', ->
      section '.content', ->
        @content

      aside '.sidebar', ->
        @layout 'aside'

      footer ->
        p '&copy; Company 2011'
        p style: 'float:right;', ->
          text "This website was generated on #{@site.date.toIsoDateString()} and has #{@site.totalDocuments} documents"

    comment 'DISQUS'
    script ->
      """
      var disqus_shortname = '#{@site.disqusShortName}';
      (function () {
          var s = document.createElement('script'); s.async = true;
          s.type = 'text/javascript';
          s.src = 'http://' + disqus_shortname + '.disqus.com/count.js';
          (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
      }());
      """


    comment 'GA'
    script ->
      """
      if( '#{@site.url}' === 'http://' + window.location.hostname ) {
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-27493298-1']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      }
      """
