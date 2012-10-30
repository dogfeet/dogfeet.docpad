--- 
layout: 'default'
date: '2000-1-1'
---
div style: 'display:none', -> h1 'dogfeet'

# Articles
section '.content.articles', ->
  div '.row', -> h2 '.offset2.span10', 'Articles'
  i = 0
  @getCollection('documents').forEach (document) ->
    if document.get('encoding') != 'binary' and 0 is document.get('url').indexOf '/articles'
      i++
      if i > 10
        return
      article '.articles-item', style: 'padding-bottom: 1em;', ->
        # Date & Title
        div '.row', ->
          div '.span2.muted.modern-font.small-font', ->
            span property: 'dc:created', ->
              @helper.formatDate( document.get('date') ) + ' &raquo;'
          div '.span10', ->
            a '.index-article-title', href: document.get('url'), -> document.get('title')
        # Author & Info
        div '.row', ->
          div '.offset2.span10.modern-font.small-font.muted', ->
            text @layout 'article-footer', document
        if i > 3
          return
        # First paragraph
        div '.row.hidden-phone', ->
          div '.offset2.span10', ->
            if document.get('contentRenderedWithoutLayouts')
              text '<br/>'
              text @tool.summary document.get('contentRenderedWithoutLayouts')
            p -> a '.btn', href: document.get('url'), 'Read more &raquo;'
  div '.row', -> p '.offset2.span10', -> a '.btn.info.right', href: '/site/archive.html', 'go to Archive &raquo;'

# Artifacts
artifactsIt = (title, link, date, authorNames) ->
  article '.articles-item', style: 'padding-bottom: 1em;', ->
    div '.row', ->
      div '.span2.muted.modern-font.small-font', ->
        span property: 'dc:created', ->
          "#{date} &raquo;"
      div '.span10', ->
        a '.index-article-title', href: link, -> 
          text title
    div '.row', ->
      div '.offset2.span10.modern-font.small-font.muted', ->
        div '.modern-font.small-font', ->
          text @helper.genAuthors authorNames
section '.content.articles', ->
  div '.row', -> h2 '.offset2.span10', 'Artifacts'
  artifactsIt '프로 안드로이드 4 실무 바이블 [번역, 책]'
    , 'http://www.gilbut.co.kr/book/bookView.aspx?bookcode=BN000463'
    , '2012 Oct 15'
    , 'Sean Lee, Changwoo Park'
  artifactsIt 'Meteor 문서 [번역]'
    , 'http://docs-ko.meteor.com/'
    , '2012'
    , 'Changwoo Park, Sean Lee, Yongjae Choi'
  artifactsIt 'Learning J [번역]'
    , 'http://www.gilbut.co.kr/book/bookView.aspx?bookcode=BN000463'
    , '2012'
    , 'Yongjae Choi'
  artifactsIt 'JavaScript Garden [번역]'
    , 'http://bonsaiden.github.com/JavaScript-Garden/ko/'
    , '2011'
    , 'Changwoo Park'
  artifactsIt 'Visual Git Guide [번역]'
    , 'http://marklodato.github.com/visual-git-guide/index-ko.html'
    , '2011'
    , 'Sean Lee'
  artifactsIt 'Why git is Better than X [번역]'
    , 'http://pismute.github.com/whygitisbetter/'
    , '2011'
    , 'Changwoo Park'
  artifactsIt 'Felix\'s Node.js Guide [번역]'
    , 'http://pismute.github.com/nodeguide.com/'
    , '2011'
    , 'Changwoo Park'
  artifactsIt 'Grails User Guide v1.0 [번역]'
    , 'http://dogfeet.github.com/grails-doc/guide/'
    , '2008'
    , 'Changwoo Park, Sean Lee, Yongjae Choi'

# Seminar & Meets
section '.content.articles', ->
  div '.row', -> h2 '.offset2.span10', 'Seminar &amp; Meets'
  @getCollection('documents').forEach (document) ->
    if document.meta.get('articleType') == 'seminar'
      article '.articles-item', style: 'padding-bottom: 1em;', ->
        div '.row', ->
          div '.span2.muted.modern-font.small-font', ->
            span property: 'dc:created', ->
              @helper.formatDate( document.get('date') ) + ' &raquo;'
          div '.span10', ->
            a '.index-article-title', href: document.get('url'), -> document.get('title')
        div '.row', ->
          div '.offset2.span10.modern-font.small-font.muted', ->
            text @layout 'article-footer', document