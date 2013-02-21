doctype 5
html lang: 'en', ->
  head ->
    comment 'Meta'
    meta charset: 'utf-8'
    meta 'http-equiv': 'X-UA-Compatible', content: 'IE=edge,chrome=1'
    meta 'http-equiv': 'content-type', content: 'text/html; charset=utf-8'
    meta name: 'viewport', content: 'width=device-width, initial-scale=1'

    if @document.meta.layout is 'article' or @document.meta.layout is 'author'
      #document has own title, articles or authors
      title "#dogfeet - #{@document.meta.title}"
      meta name: 'description', content: @document.meta.description or ''
      meta name: 'keywords', content: @document.meta.keywords or ''
      meta name: 'author', content: @document.meta.author or ''
    else
      #document has not own title, not articles or authors
      title "#dogfeet - #{@site.title}"
      meta name: 'description', content: @site.description or ''
      meta name: 'keywords', content: @site.keywords or ''
      authors = @tool._.keys(@authors).join(', ')
      meta name: 'author', content: authors

    comment 'Icons'
    link rel: 'shortcut icon', href: 'images/favicon.ico'
    link rel: 'apple-touch-icon', href: 'images/apple-touch-icon.png'
    link rel: 'apple-touch-icon', sizes: '72x72', href: 'images/apple-touch-icon-72x72.png'
    link rel: 'apple-touch-icon', sizes: '114x114', href: 'images/apple-touch-icon-114x114.png'

    link rel: 'alternate', type: 'application/atom+xml', title: "#{@site.title} &raquo; Feed", href: 'http://feeds.feedburner.com/github/dogfeet'

    comment 'Shims: IE6-8 support of HTML5 elements'
    comment '[if lt IE 9]>\n        <script async src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>\n    <![endif]'
    comment 'Styles'
    link rel: 'stylesheet', href: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.0/css/bootstrap-combined.min.css', media: 'screen, projection'
    link rel: 'stylesheet', href: '/css/highlight/github.css', media: 'screen, projection'
    link rel: 'stylesheet', href: '/styles/style.css', media: 'screen, projection'
    link rel: 'stylesheet', href: '/styles/markdown.css', media: 'screen, projection'
    #link rel: 'stylesheet', href: '/styles/print.css', media: 'print'

    #text @blocks.styles.join('')

    comment 'Scripts'

    script src: 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'
    script src: 'http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.0.6/modernizr.min.js'
    script src: "http://connect.facebook.net/en_US/all.js#xfbml=1"
    script src: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.0/js/bootstrap.min.js'
    script src: 'http://twitter.github.com/bootstrap/assets/js/bootstrap-collapse.js'
    script src: '/scripts/script.js'

    #text @blocks.scripts.join('')

  body ->
    comment 'Topbar'
    div '.navbar.navbar-static-top', ->
      div '.navbar-inner', ->
        div '.container', ->
          a '.btn.btn-navbar.pull-right', 'data-toggle':'collapse', 'data-target':'.nav-collapse', ->
              span '.icon-bar', ''
              span '.icon-bar', ''
              span '.icon-bar', ''

          a '.brand', href: '/', 'dogfeet'
          div '.nav-collapse.collapse', ->
            ul '.nav', ->
              li -> a href: '/site/tagmap.html', 'Tagmap'
              li -> a href: '/site/archive.html', 'Archive'
              li -> a href: '/site/atelier.html', 'Atelier'
              li -> a href: 'http://feeds.feedburner.com/github/dogfeet', ->
                img src: 'http://forum.tattersite.com/ko/style/Textcube/feed-icon.png'
            form '#search-form.pull-right.navbar-search', action: 'http://google.com/search', method: 'get', ->
              input type: 'hidden', name: 'q', value: 'site:dogfeet.github.com'
              input 'search-query', type: 'text', name: 'q', results: '0', placeholder: 'Search'

    comment 'Markup'
    div '.container', ->
      div ->
        @content

      footer '.footer', ->
        p 'Copyright &copy; 2008-2012 Dogfeet from coding to pixels, powered by <a href="https://github.com/balupton/docpad">Docpad</a>'

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
