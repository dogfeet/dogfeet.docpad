doctype 5
html lange: 'en', ->
  head ->
    comment 'Meta'
    meta charset: 'utf-8'
    meta 'http-equiv': 'X-UA-Compatible', content: 'IE=edge,chrome=1'
    meta 'http-equiv': 'content-type', content: 'text/html; charset=utf-8'
    meta name: 'viewport', content: 'width=device-width'
    title @site.title
    meta name: 'description', content: ''
    meta name: 'author', content: ''

    comment 'Icons'
    link rel: 'shortcut icon', href: 'images/favicon.ico'
    link rel: 'apple-touch-icon', href: 'images/apple-touch-icon.png'
    link rel: 'apple-touch-icon', sizes: '72x72', href: 'images/apple-touch-icon-72x72.png'
    link rel: 'apple-touch-icon', sizes: '114x114', href: 'images/apple-touch-icon-114x114.png'

    comment 'Shims: IE6-8 support of HTML5 elements'
    comment '[if lt IE 9]>\n        <script async src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>\n    <![endif]'
    comment 'Styles'
    link href: 'http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css', rel: 'stylesheet'
    link href: 'http://twitter.github.com/bootstrap/assets/css/docs.css', rel: 'stylesheet'
    link href: 'http://twitter.github.com/bootstrap/assets/js/google-code-prettify/prettify.css', rel: 'stylesheet'
    text @blocks.styles.join('')
    style type: 'text/css', ->
      '''
      pre > code {
        background-color: #FEFBF3;
      }
      .container-fluid > .sidebar, .container-fluid > .content{
        padding-top: 60px;
      }
      .container-fluid > .sidebar {
        left: auto;
        right: 20px;
      }
      .container-fluid > .content {
        left: 20px;
        margin-left: auto;
        margin-right: 240px;
      }
      footer {
        margin-top: 3px;
        padding-top: 3px;
        padding-bottom: 20px;
      }
      article.post {
        padding-top: 15px;
      }
      '''
    comment 'Scripts'
    script src: 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'
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
    script src: '/vendor/lang-vb.js'
    script src: '/vendor/lang-vhdl.js'
    script src: '/vendor/lang-wiki.js'
    script src: '/vendor/lang-xq.js'
    script src: '/vendor/lang-yaml.js'
    text @blocks.scripts.join('')
    script ->
      '''
      $(function () { prettyPrint() });
      /*
      $('ul.nav > li > a').click( function(){
        $(this).parent()
          .siblings()
            .removeClass('active')
          .end()
          .addClass('active')
      });
      */
      '''
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

    comment 'Markup'
    div '.container-fluid', ->
      div '#content.content', ->
        @content

      aside '.sidebar', ->
        div '.well', 'Hello World'

      footer ->
        p '&copy; Company 2011'
        p style: 'float:right;', ->
          text "This website was generated on #{@site.date.toIsoDateString()} and has #{@site.totalDocuments} documents"

