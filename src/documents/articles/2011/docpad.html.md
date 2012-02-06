---
layout: article
title: 'Docpad'
author: 'Changwoo Park'
date: '2011-11-25T16:06:05.000Z'
tags: ['Docpad', 'Prettify', 'Markdown', 'CoffeeKup']
---

Docpad는 CoffeeScript로 작성한 static page engine이다. 이 dogfeet 사이트는 docpad를 사용해 만들었다.

![Docpad](/articles/2011/docpad.png)

## Skeleton

docpad는 일종의 사이트 템플릿을 제공하는데 그걸 skeleton이라고 부른다. docpad에서 만든 skeleton은 다음의 세 개다.

 * [Kitchensink Skeleton][] - docpad 2부터 기본 skeleton. bootstrap ui로 된 예제
 * [Canvas Skeleton][] - 어제 배포된 따끈한 empty skeleton이다. 
 * [Balupton Skeleton][] - docpad 1때의 기본 skeleton balupton님의 blog 소스

[Canvas Skeleton]: https://github.com/balupton/canvas.docpad
[Kitchensink Skeleton]: https://github.com/balupton/kitchensink.docpad
[balupton Skeleton]: https://github.com/balupton/balupton.docpad

### Kitchensink Skeleton

balupton님이 docpad v2.0를 배포하면서 kitchensink.docpad라는 예제를 배포한다. 이 걸 띄우는 법은 간단하다.

일단 coffee script를 설치하고:

    $ npm install -g coffee-script 

docpad를 설치한다. -g는 global 영역에 설치하는 것으로 -g 옵션을 줘야 명령으로 실행할 수 있다:

    $ npm install -g docpad

`kitchensink.docpad`를 클론한다:

그리고 해당 디렉토리로 이동하고 나서 `docpad run`을 실행하고 브라우저로 들어간다. 다른 예제들은 사용법이 같으므로 생략한다.

## Custom Plugin

Docpad는 blog generator가 아니기 때문에 blog처럼 사용하려면 관련된 기능을 직접 만들어 사용해야 한다.

Plugin에서 require를 통해 underscore나 moment같은 다른 모듈을 사용하는 경우에는 package.json을 꼭 작성해야 한다. package.json의 dependencies 블럭에 의존 모듈을 추가하지 않으면 모듈을 매번 수동으로 설치해야 한다.  package.json이 있으면 docpad는 자동을 모듈을 설치한다.

### markdown-prettify Plugin

markdown에 첨부한 코드가 highlight되도록 plugin을 만들었다. 원래 markdown 규약상 다음과 같이 html로 변환된다:

    :::html
    <pre><code>...</code></pre>

이 것을 다음과 같이 변환한다:

    :::html
    <pre class="prittyprint"><code>...</code></pre>

google prettify는 특별히 언어를 명시하지 않아도 자동으로 찾는다. 완벽하지는 않지만 편리하다.

명시할 수도 있다. 코드 블럭 첫줄에 `:::java`라고 작성하면 `:::java`은 없애고 다음과 같이 렌더링한다:

    :::html
    <pre class="prittyprint"><code class="language-java">...</code></pre>

이 모습 낮설어 보여도 [w3c 권장사항][]이다. html5에서 syntax highlight는 이렇게 해야 한다. 지원하는 언어는 [prettify 페이지][]에서 확인한다.

':::'말고 쉘 스크립트들을 위해서 '#!'도 추가했다. `#!/usr/bin/env bash`을 첫줄로 시작하면 다음과 같이 랜더링한다. 이건 삭제하지 않는다:

    :::html
    <pre class="prittyprint"><code class="language-bsh">#!/usr/bin/env bash...</code></pre>

`#!/bin/bash`라고 써도 되고 `#!/usr/bin/bash`라고 써도 된다.

그리고 prettify하지 않은 코드를 위해 'text'와 'plain'도 추가했다. `:::text`나 `:::plain`을 첫줄에 넣어주면 다음과 같이 원래대로 렌더링한다.

    :::html
    <pre><code>...</code></pre>

### Tool Plugin

기본적으로 Template Engine이기 때문에 다양한 function을 사용할 수 없다. nodejs의 다양한 api들을 template에서 사용하고 싶은 것이다. 나는 CoffeeKup이외의 지식이 빈약하기 때문에 다른 Template Engine에 관한 예제는 올리지 않는다.

#### `@tool.moment`

CoffeeKup의 경우에 Tempate Data에 함수를 담아 넘기고 그 함수를 사용할 수 있다. Plugin으로 Template Data에 momentjs를 넘기고 그 것을 사용하는 예제를 보자.

다음은 ToolPlugin 소스다. 나는 docpad Plugin이 아닌 docpad site plugin으로 넣었다. 기본적으로 DocpadPlugin 클래스를 상속받아 사용한다는 점에서 구조는 똑같다. 다만 위치가 docpad site/plugins/ 밑에 들어가는 것만 다르다.

    # Requires
    DocpadPlugin = require 'docpad/lib/plugin.coffee'
    moment = require 'moment'

    # Define Plugin
    class ToolPlugin extends DocpadPlugin
      # Plugin Name
      name: 'totaldocuments'

      # Ammend our Template Data
      renderBefore: ({documents, templateData}, next) ->
        templateData[ 'tool' ] = tool =
          moment: moment

        # Continue onto the next plugin
        next()

    # Export Plugin
    module.exports = ToolPlugin

Template 페이지에서 이 것을 이용한 소스를 만들면 다음과 같다.

    dateWrapper = @tool.moment document.date
    dateWrapper.format 'MMM DD' #ex) JAN 01

#### `@tool.summary`

index 페이지에서는 글들의 summary만 보여주고 싶었다. docpad는 부가기능이 별로 없기 때문에 고민이 좀 됐는데 의외로 간단히 해결했다.

summary부터 정의해보자. 이 걸 생각해내는데 오래걸렸다. 좋은 아이디어가 없었는데 의외로 가까운데 있었다. 각 글의 첫 heading tag(/h[123456]/)까지가 summary로 사용된다. 그러니까 글을 쓸때 첫 heading tag가 summary이고 heading tag가 아예 존재하지 않으면 문서 전체를 summary로 사용한다:

    :::markdown
    
    Here is summary

    ## My heading

index 페이지에서 summary를 추출한다. 다음 예제는 CoffeeKup이다:

    :::coffee
    @tool.summary document.contentRendered

html을 잘라내는 것이기 때문에 content가 아니라 contentRendered 값을 가져다 사용해야 한다.

### authors Plugin

authors Plugin인 저자를 소개하는 페이지를 만들고 다른 문서의 author 프로퍼티에 저자 이름을 명시하면 자동으로 그 페이지로 링크해주는 것이다. `/src/documents/authors/`안에 소개 페이지를 다음과 같이 만든다.

    --- yaml
    name= 'ahmooge'
    ---

    blahblah

docpad는 이 문서를 처리해서 `{name:'ahmooge', url:'/authors/ahmooge.html', content: 'blahblah..', contentRendered: '<span>blahblah</span>'}`라는 객체로 만든다. 이 객체를 document 객체라고 하자(실제 코드에서도 document다). authors plugin은 `/src/documents/authors/`안에 잇는 파일을 모아서 template data의 `@authors.data` 객체에 담아준다. 'Kim'라는 document1와 'Park'라는 document2가 있으면 `@authors.data`에는 `{"Kim": document1, "Park":document2}`라는 객체가 들어가게 된다. 

그럼 CoffeeKup template에서 사용해보자:

     a href: @authors.data[ @document.author ].url

예외처리는 생략함.

CoffeeKup은 `with` 구문을 이용해서 scope variable을 확장할 수 있는 파라미터 locals와 hardcoded를 지원하지만 아직 docpad는 지원하지 않기 때문에 template data scope을 이용했다.

## TroubleShooting

### ENOENT

docpad를 실행했는데 다음과 같은 에러가 발생하면:

    Error: Command failed: npm ERR! error installing coffee-script@1.1.3 Error: ENOENT, no such file or directory '/Users/pismute/dogfeet/dogfeet.github.com/node_modules/coffee-script/package.json'

수동으로 패키지를 설치한다. 원래 docpad는 자동으로 설치하고 update해줄 수 있다고 하는데 뭔가 잘 안될 때가 있다:

    npm install docpad
    npm install coffee-script

이미 docpad랑 coffee-script 설치한 것 같은데 왜 또 설치해야하지? 라는 생각이 들 수 있다. 이유는 먼저 설치한 것은 npm global 영역에 설치한 것이고 이것은 local에서 설치하는 것이다. global 영역에 설치해야 command로 실행할 수 있다.

global 영역에서 설치한 버전을 local에서 사용하게 할 수도 있다. `npm link` 명령어를 살펴봐라. 

npm은 블로그를 이전하고 나서 파볼 계획이다. 

[prettify 페이지]: http://google-code-prettify.googlecode.com/svn/trunk/README.html
[w3c 권장사항]: http://dev.w3.org/html5/spec-author-view/the-code-element.html

