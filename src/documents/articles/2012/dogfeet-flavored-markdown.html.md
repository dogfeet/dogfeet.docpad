--- yaml
layout: 'article'
title: 'Dogfeet Flavored Markdown'
author: 'Changwoo Park'
date: '2012-3-8'
tags: ['Markdown', 'Docpad', 'Github']
---

'Dogfeet-Flavored-Markdown'은 Markdown에서 Twitter처럼 `@mention`, `#hash`와 같은 표현을 사용하고 싶어서 만들었다. 이 모듈은 아직 실험중이다. 현재는 Prototype이고 좀 더 다듬에 dogfeet에 적용하겠다.

'Dogfeet-Flavored-Markdown'의 구현을 요약하자면 다음과 같다:

 * '[Dogfeet-Flavored-Markdown][dogfeet-flavored-markdown]'은 Issac의 '[GitHub-Flavored-Markdown][github-flavored-markdown]'을 포크해서 만들었다.
 * [Issac의 'GitHub-Flavored-Markdown'][isaacs-flavored-markdown]은 [GitHub의 'GitHub-Flavored-Markdown'][github-flavored-markdown]을 node 모듈로 만든 것이다.
 * [GitHub의 'GitHub-Flavored-Markdown'][github-flavored-markdown]은 ShowDown에 몇 가지 문법을 추가한 것이다.

그래서 먼저 [GitHub의 GitHub-Flavored-Markdown 설명서][github-flavored-markdown-help]를 숙지하고 읽어 보는 것이 좋다.

## Github-Flavored-Markdown

Github-Flavored-Markdown(이하 GitHub-Flavored)은 다음과 같은 표현을 지원한다.

    * SHA: be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User@SHA ref: mojombo@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * #Num: #1
    * User/#Num: mojombo#1
    * User/Project#Num: mojombo/god#1

하지만 실제로 작동하는 것은 '사용자/저장소' 패턴이 명시된 다음의 두 경우 뿐이다:

 * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * User/Project#Num: mojombo/god#1

나머지 패턴도 동작하게 하려면 '사용자/저장소' 정보가 필요하다. GitHub-Flavored의 용법은 다음과 같은데 인자로 '사용자/저장소'를 넘겨줄 수 있다:

    var ghm = require("github-flavored-markdown")
    ghm.parse("I **love** GHM.\n\n#2", "isaacs/npm")
    // returns:
    // '<p>I <strong>love</strong> GHM.  '+
    // '<a href=\'http://github.com/isaacs/npm/issues/#issue/2\'>#2</a></p>'

그러면 나머지 패턴도 해당 저장소에 대한 GitHub 링크가 생성된다:

 * SHA: be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * User@SHA ref: mojombo@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * #Num: #1
 * User/#Num: mojombo#1

## Dogfeet-Flavored-Markdown

Dogfeet-Flavored-Markdown(이하 DogFeet-Flavored)은 GitHub-Flavored에서 '사용자/저장소' 정보가 필요한 나머지 패턴은 삭제했다. 그래서 다음과 같은 패턴만 사용할 수 있다:

 * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * User/Project#Num: mojombo/god#1

대신 `@mention`과 `#hash`를 추가 했다. 정확한 패턴은 다음과 같다:

 * mention - `(^|[ \t]+)@([ㄱ-ㅎ가-힣a-zA-Z0-9]+)`
 * hash - `(^|[ \t]+)#([ㄱ-ㅎ가-힣a-zA-Z0-9]+)`

다시 말해서 줄 처음에 시작하는 `@mention`이나 앞에 공백(space, tab)문자가 있는 것만 인식한다.

그리고 `<code>` 블럭에 있는 것은 무시한다. 간단히 말하면 `@mention`과 @mention의 차이다.

### 예제

이 것은 코드 블럭이 아니라 잘 된다:

 * User@SHA ref: mojombo@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * #Num: #1
 * User/#Num: mojombo#1
 * User/Project#Num: mojombo/god#1, `mojombo/god#1`
 * @pismute
 * #EveryoneIsBeautiful `, #EveryoneIsBeautiful,#EveryoneIsBeautiful`
 * #한글 `, #한글,#한글`

(이글에서는 `#hash`는 Twitter가 아니라 이 블로그의 tagmap 페이지로 연결된다.)

다음은 코드 블럭이라 DogFeet-Flavored은 동작하지 않는다. 하지만 GitHub-Flavored의 된다. 다시 말하지만 GitHub-Flavored의 것은 코드 블럭에서도 링크를 생성 하지만 Dogfeet에서 추가한 `@mention`과  `#hash`는 코드 블럭에서는 링크를 생성하지 않는다:

    * SHA: be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User@SHA ref: mojombo@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * #Num: #1
    * User/#Num: mojombo#1
    * User/Project#Num: mojombo/god#1, `mojombo/god#1`
    * @pismute
    * #EveryoneIsBeautiful `, #EveryoneIsBeautiful,#EveryoneIsBeautiful`
    * #한글 `, #한글,#한글`

### 설치

아직 패키지하지 않았다. `npm link`로 설치해야 한다.

    $ git clone https://github.com/pismute/github-flavored-markdown.git
    $ npm link

이젝 global에 설치했으니 해당 프로젝트에서 `npm link`를 실행해 local에 설치한다.

    $ cd myproject
    $ npm link

### Coding

기본적으로 내장된 템플릿은 twitter로 연결된다. 그래서 `@mention`과 `#hash`를 클릭하면 twitter로 연결된다. 하지만 바꿀 수 있다.

    var templates={
      '@': function(key){ return ['@@', key].join(''); }
      , '#': function(key){ return ['##', key].join(''); }
    }
    var dhm = require("dogfeet-flavored-markdown");
    ghm.parse("I **love** @DHM. #DHM", {templates:templates});
    // returns:
    // '<p>I <strong>love</strong> @@GHM. ##DHM'

## 기타

그외 규칙들을 정리한다.

### 순서

이 모듈은 세단계로 Markdown을 처리한다.

 * 먼저 원래 코드인 [showdown][showdown] 엔진이 먼저 처리한다.
 * 그리고 그 결과를 [Github-Flavored-Markdown][isaacs-flavored-markdown] 이 처리한다.
 * 마지막으로 [Dogfeet-Flavored-Markdown][dogfeet-flavored-markdown] 이 처리한다.

이 규칙이 중요할 때가 있는데, Heading을 표현하는 Markdown에서 중요하다. 줄 맨앞에서 `#Heading`이라고 표현하면 Dogfeet-Flavored가 처리하는 것이 아니라 showdown 엔진이 처리하기 때문에 링크가 생성되지 않고 `<h1>Heading</h1>`이라고 해석된다.

[showdown]: http://www.showdown.im/
[dogfeet-flavored-markdown]: https://github.com/pismute/github-flavored-markdown
[github-flavored-markdown-help]: http://github.github.com/github-flavored-markdown/
[isaacs-flavored-markdown]: https://github.com/isaacs/github-flavored-markdown
[github-flavored-markdown]: https://github.com/github/github-flavored-markdown


