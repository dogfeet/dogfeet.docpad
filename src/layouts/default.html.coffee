doctype 5
html lange: 'en', ->
  head ->
    comment 'Meta'
    meta charset: 'utf-8'
    meta 'http-equiv': 'X-UA-Compatible', content: 'IE=edge,chrome=1'
    meta 'http-equiv': 'content-type', content: 'text/html; charset=utf-8'
    meta name: 'viewport', content: 'width=device-width, initial-scale=1'

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
            comment ''' li -> a href: '/site/about.html', 'about' '''
            li -> a href: '/site/tagmap.html', 'tagmap'
            li -> a href: '/site/archive.html', 'archive'
            li -> a href: '/site/atelier.html', 'atelier'
            li -> a href: '/atom.xml', -> 
              img src: 'http://forum.tattersite.com/ko/style/Textcube/feed-icon.png'

          form '.pull-right', action: '', ->
            input '.input-small', type: 'text', placeholder: 'Username'
            input '.input-small', type: 'password', placeholder: 'Password'
            button '.btn', type:'submit', 'Sign in'

    comment 'Markup'
    div '.container-fluid', ->
      section '.content', ->
        @content

      aside '.sidebar', ->
        div '.well', 'Hello World'

      footer ->
        p '&copy; Company 2011'
        p style: 'float:right;', ->
          text "This website was generated on #{@site.date.toIsoDateString()} and has #{@site.totalDocuments} documents"

    comment 'DISQUS'
    text '''
<script type="text/javascript">
    var disqus_shortname = 'dogfeet-github';
    (function () {
        var s = document.createElement('script'); s.async = true;
        s.type = 'text/javascript';
        s.src = 'http://' + disqus_shortname + '.disqus.com/count.js';
        (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
    }());
</script>
    '''
