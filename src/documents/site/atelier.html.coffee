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
          authorAnchor = @helper.genAuthors @authors, authors

          text "#{year}. "
          a href: orig, title
          text '('
          a href: trans, state
          text ") by #{authorAnchor}"

      translateIt '2012', 'Meteor'
        , 'http://docs.meteor.com/'
        , 'http://docs-ko.meteor.com/'
        , 'Changwoo Park, Sean Lee, Yongjae Choi'
        , 'Ko-trans.'
      translateIt '2012', 'Learning J'
        , 'http://www.jsoftware.com/help/learning/contents.htm'
        , 'https://github.com/lnyarl/learning-j-ko'
        , 'Yongjae Choi'
        , 'Ko-trans.'
      translateIt '2011', 'Progit'
        , 'http://progit.org/'
        , 'http://dogfeet.github.com/articles/2012/progit.html'
        , 'Changwoo Park, Sean Lee'
        , 'Ko-trans.'
      translateIt '2011', 'JavaScript Garden'
        , 'http://bonsaiden.github.com/JavaScript-Garden/'
        , 'http://bonsaiden.github.com/JavaScript-Garden/ko/'
        , 'Changwoo Park'
        , 'Accepted'
      translateIt '2011', 'Visual Git Guide'
        , 'http://marklodato.github.com/visual-git-guide/index-en.html'
        , 'http://marklodato.github.com/visual-git-guide/index-ko.html'
        , 'Sean Lee'
        , 'Accepted'
      translateIt '2011', 'Why git is Better than X'
        , 'http://whygitisbetterthanx.com/'
        , 'http://pismute.github.com/whygitisbetter/'
        , 'Changwoo Park'
        , 'Ko-trans.'
      translateIt '2011', "Felix's Node.js Guide"
        , 'http://nodeguide.com/'
        , 'http://pismute.github.com/nodeguide.com/'
        , 'Changwoo Park'
        , 'Ko-trans.'
      translateIt '2008', 'Grails User Guide v1.0'
        , 'http://grails.org/doc/1.0/'
        , 'http://dogfeet.github.com/grails-doc/guide/'
        , 'Changwoo Park, Sean Lee, Yongjae Choi'
        , 'Ko-trans.'

