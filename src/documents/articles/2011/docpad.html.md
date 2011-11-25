---
layout: article
title: 'Docpad'
author: 'Changwoo Park'
date: '2011-11-24T16:06:05.000Z'
tags: ['Docpad', 'Prettify', 'Markdown', 'CoffeeKup']
---

Docpad는 coffeescript로 작성한 static page engine이다.

## Skeleton

docpad는 일종의 사이트 템플릿을 제공하는데 그걸 skeleton이라고 부른다. docpad에서 만든 skeleton은 다음의 두 개다.

 * [Kitchensink Skeleton][] - docpad 2부터 기본 skeleton
 * [Balupton Skeleton][] - docpad 1때의 기본 skeleton balupton님의 blog 소스

[Kitchensink Skeleton]: https://github.com/balupton/kitchensink.docpad
[balupton Skeleton]: https://github.com/balupton/balupton.docpad

### Kitchensink Skeleton

balupton님이 docpad v2.0를 배포하면서 kitchensink.docpad라는 예제를 배포한다. 이 걸 띄우는 법은 간단하다.

일단 coffee script를 설치하고:

    $ npm install -g coffee-script 

docpad를 설치한다. -g는 global 영역에 설치하는 것으로 -g 옵션을 줘야 명령으로 실행할 수 있다:

    $ npm install -g docpad

`kitchensink.docpad`를 클론한다:

그리고 해당 디렉토리로 이동하고 나서 `docpad run`을 실행하고 브라우저로 들어간다.

## markdown-prettify Plugin

markdown에 첨부한 코드가 highlight되도록 plugin을 만들었다. 원래 markdown 규약상 다음과 같이 html로 변환된다:

    <pre><code>...</pre></code>

이 것을 다음과 같이 변환한다:

    <pre class="prittyprint"><code>...</pre></code>

google prettify는 특별히 언어를 명시하지 않아도 자동으로 찾는다. 완벽하지는 않지만 편리하다.

명시할 수도 있다. 코드 블럭 첫줄에 `:::java`라고 작성하면 `:::java`은 없애고 다음과 같이 렌더링한다:

    <pre class="prittyprint"><code class="language-java">...</pre></code>

이 모습 낮설어 보여도 [w3c 권장사항][]이다. html5에서 syntax highlight는 이렇게 해야 한다. 지원하는 언어는 [prettify 페이지][]에서 확인한다.

':::'말고 쉘 스크립트들을 위해서 '#!'도 추가했다. `#!/usr/bin/env bash`을 첫줄로 시작하면 다음과 같이 랜더링한다. 이건 삭제하지 않는다:

    <pre class="prittyprint"><code class="language-bsh">#!/usr/bin/env bash...</pre></code>

`#!/bin/bash`라고 써도 되고 `#!/usr/bin/bash`라고 써도 된다.

[prettify 페이지]: http://google-code-prettify.googlecode.com/svn/trunk/README.html
[w3c 권장사항]: http://dev.w3.org/html5/spec-author-view/the-code-element.html

