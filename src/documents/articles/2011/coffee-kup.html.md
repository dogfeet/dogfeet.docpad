---
layout: 'article'
title: 'CoffeeKup &lt;☕/&gt;'
author: 'Changwoo Park'
date: '2011-11-21T16:06:05.000Z'
tags: ['CoffeeKup', 'CoffeeScript']
---

CoffeeKup은 HAML, Jade, Eco와 같은 Template Engine이다. [Docpad][]는 전부 지원하지만 [CoffeeKup][]을 기본 Template 엔진으로 고른 이유는 코드가 가장 예뻐서다.

![CoffeeScript](/articles/2011/coffeekup.png)

## CoffeeKup

CoffeeKup을 이해하기 위해서 먼저 준비해야 할 것은 JavaScript와 CoffeeScript이다. CoffeeKup은 CoffeeScript 문법과 거의 똑같다. Jade가 Haml과 유사하게 만들면서 JavaScript가 아닌 것이 돼버렸지만 CoffeeKup은 coffeescript 문법과 정말 똑같다.

먼저 JavaScript 공부하고 JavaScript에 익숙하다면 [CoffeeScript][]만 읽고 시작해도 된다.

이제 일주일밖에 되지 않았지만 내가 생각하는 장단점은 다음과 같다.

 * 장점: tag library 작성이 쉽다.
 * 장점: templateData에 함수를 넣을 수 있기 때문에 plugin을 통해서 기능 확장이 쉽다. 물론 templateData이외 context도 필요할 것 같다.
 * 단점: tag가 hierarchical하지 않은 dom구조를 작성하기 쉽지 않다. 물론 이렇게 작성하면 코드가 지저분해지기 때문에 안하는 것이 좋다.

## Hello World

우선 다음과 같이 coffeekup을 설치하고:

    :::bash
    $ npm install coffeekup -g

콘솔에 설치하는 것이 귀찮으면 그냥 [CoffeeKup][]에서 실행해보는 것도 좋고 [CoffeeScript][]을 공부했다면 어렵지 않다.

## 함수

CoffeeKup의 Markup은 단순히 함수를 호출하는 것이기 때문에 정의되지 않은 함수는 호출할 수 없다. 이미 대부분의 html tag는 정의돼 있는 것 같지만 그 외의 것을 사용하는 경우에는 에러가 난다. 예를 들어, 다음과 같이 코드를 만들면 say를 정의하지 않았다고 에러가 난다:

    :::coffee
    say 'Hello World'

say 함수를 만들면 더이상 에러가 나지 않는다:

    say = (args) ->
      tag 'say', args

    say 'Hello World'

여기서 `say 'Hello World'`은 `tag 'say', 'Hello World'`과 같다. tag는 정의되지 않은 xml tag가 필요할 때 사용할 수 있다. 예를 들어, `p 'Hello World'`과 똑같은 표현을 tag로 하면 `tag 'p', 'Hello World'`이다. 함수를 호출하는 것이라는 걸 기억해야 한다.

함수라는 것은 배웠고 이제 그럼 인자는 어떻게 매핑되는 거지?라는 것이 궁금하다. 다음 예제를 보자:

    say id: 'first', class: 'example', 'Hello World'

say 함수의 args[0]에는 `{id: 'first', class: 'example'}`라는 객체가 넘어가고 args[1]에는 'Hello World'가 넘어간다. 이를 이용해서 자신만의 함수를 작성해 사용할 수 있다.

### Tag body

Tag body는 두 가지 방법으로 정의할 수 있다. 먼저 `title 'Hello World'`은 다음과 같이 해석된다:

    <title>Hello World</title>

하지만 `title -> 'Hello World'`는 다음과 같이 해석된다:

    <title>
      Hello World
    </title>

이 두 가지는 구현이 조금 다르다. 문법에서 보이듯이 전자는 'Hello World'라는 스트링이 인자로 넘어가는 거고 후자는 'Hello World'라는 스트링을 반환하는 함수가 넘어간다. JavaScript로 표현하면 `function(){return 'Hello World';}`같은 함수가 넘어가는 것이다. CoffeeKup은 다르게 해석해 주기 때문에 필요에 따라 선택해 사용한다.

### `#id.class`

id와 class를 표현하는 방법은 두가지다 하나는 이미 설명대로 attribute를 기술하는 방법이 있고:

    title id: 'myid', class: 'myclass'

다른 하나는 css selector를 이용한 방법도 있다:

    title '#myid.myclass'

단, 이 css selector는 첫 argument로 넘겨야한다. 다른 attribute가 더 있으면 ',' 뒤에 위의 방법대로 계속 추가할 수 있다:

    title '#myid.myclass', lang: 'ko'

## Atom.xml

html5을 templating 예제는 [CoffeeKup][]페이지에도 나온다 xml 예제를 보자 

    homeUrl='http://dogfeet.github.com'

    anEntry = (document) ->
      tag 'entry', ->
        tag 'title', document.title
        tag 'link', href: "#{homeUrl}#{document.url}"
        tag 'updated', document.date.toString()
        tag 'id', "#{homeUrl}#{document.url}"
        tag 'content', type: 'html', -> document.contentRendered

    text '<?xml version="1.0" encoding="utf-8"?>\n'
    tag 'feed', xmlns: 'http://www.w3.org/2005/Atom', ->
      title 'dogfeet.github.com'
      tag 'link', href: "#{homeUrl}/atom.xml", rel: 'self'
      tag 'link', href: homeUrl
      tag 'updated', @site.date.toIsoDateString()
      tag 'id', homeUrl
      tag 'author', ->
        tag 'name', 'Changwoo Park'
        tag 'email', 'my@email'

      for document in @documents
        anEntry document if 0 is document.url.indexOf '/posts'

이 예제는 docpad에서 사용하기 위해 만든 CoffeeKup이다. Atom tag는 대부분 함수로 만들어지지 않아서 tag로 처리했다. `@`이 붙은 변수는 Template Data다. 어떤 의미인지 [CoffeeKup][] 페이지의 코드를 살펴보면 쉽게 이해할 수 있다.

[CoffeeKup]: http://coffeekup.org/
[CoffeeScript]: http://jashkenas.github.com/coffee-script/
[Docpad]: https://github.com/balupton/docpad

