--- yaml
layout: 'default'
title: 'Atelier'
---

h1 'Atelier'

section ".atelier", ->
  div '.row', ->
    div '.span12', ->
      h2 '#open-works', 'Open Works'

  div '.row', ->
    div '.span3', ->
      h3 '#translation', 'Translation'
    div '.span8', ->

      translateIt = (year, title, orig, trans, authors, state)->
        p ->
          origAnchor = yield -> a href: orig, title

          switch state
            when 'accepted'
              transAnchor = yield -> a href: trans, 'Accepted'
            when 'in-progress'
              transAnchor = yield -> a href: trans, 'In progress'
            else
              transAnchor = yield -> a href: trans, 'Ko-trans.'

          authorAnchor = @layout 'author-links', authors

          span "#{year}. #{origAnchor}(#{transAnchor}) by #{authorAnchor}"

      ###
      translateIt '', ''
        , ''
        , ''
        , ''
      ###
      translateIt '2011', 'Progit'
        , 'http://progit.org/'
        , 'http://dogfeet.github.com/articles/2012/progit.html'
        , 'Changwoo Park, Sean Lee'
      translateIt '2011', 'JavaScript Garden'
        , 'http://bonsaiden.github.com/JavaScript-Garden/'
        , 'http://bonsaiden.github.com/JavaScript-Garden/ko/'
        , 'Changwoo Park', 'accepted'
      translateIt '2011', 'Visual Git Guide'
        , 'http://marklodato.github.com/visual-git-guide/index-en.html'
        , 'http://marklodato.github.com/visual-git-guide/index-ko.html'
        , 'Sean Lee', 'accepted'
      translateIt '2011', 'Why git is Better than X'
        , 'http://whygitisbetterthanx.com/'
        , 'http://pismute.github.com/whygitisbetter/'
        , 'Changwoo Park'
      translateIt '2011', "Felix's Node.js Guide"
        , 'http://nodeguide.com/'
        , 'http://pismute.github.com/nodeguide.com/'
        , 'Changwoo Park'
      translateIt '2008', 'Grails User Guide v1.0'
        , 'http://grails.org/doc/1.0/'
        , 'http://dogfeet.github.com/grails-doc/guide/'
        , 'Changwoo Park, Sean Lee, Yongjae Choi'

