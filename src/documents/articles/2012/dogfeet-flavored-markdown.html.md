--- yaml
layout: 'article'
title: 'dogfeet-flavored-markdown'
author: 'Changwoo Park'
date: '2012-12-8'
tags: ['Nodejs', 'Markdown', 'Docpad', 'Github', 'Dogfeet']
---

'dogfeet-flavored-markdown'은 Markdown에서 Twitter처럼 `@mention`, `#hash`와 같은 표현을 사용하고 싶어서 'github-flavored-markdown'을 수정했다.

아이디어를 정리하고 자료 조사를 끝낸건 3개월 전인데 게으름이 봄바람을 타고와 늦어 졌다.

![keyboard](/articles/2012/dogfeet-flavored-markdown/keyboard.png)

이 글을 읽기 전에 [GitHub의 GitHub-Flavored-Markdown 설명서][github-flavored-markdown-help]를 읽어 보는 것이 좋다.

## github-flavored-markdown

github-flavored-markdown은 다음과 같은 표현을 지원한다.

    * SHA: be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User@SHA ref: mojombo@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * #Num: #1
    * User/#Num: mojombo#1
    * User/Project#Num: mojombo/god#1

하지만 실제로 작동하는 것은 '사용자/저장소' 패턴이 명시된 다음의 두 경우 뿐이다:

 * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * User/Project#Num: mojombo/god#1

나머지 패턴도 동작하게 하려면 '사용자/저장소' 정보가 필요하다. github-flavored-markdown의 용법은 다음과 같은데 인자로 '사용자/저장소'를 넘겨줄 수 있다:

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

하지만 custom 하게 수정이 필요하고, 특히 [Docpad][]의 Markdown 을 수정해서 하드코딩하거나 이 정보를 설정할 수 있도록 수정해야 한다.

## dogfeet-flavored-markdown

dogfeet-flavored-markdown(이하 DFM)은 DFM에서 '사용자/저장소' 정보가 필요한 나머지 패턴은 삭제했다. 그래서 다음과 같은 패턴만 사용할 수 있다:

 * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
 * User/Project#Num: mojombo/god#1

대신 `@mention`과 `#hash`를 추가 했다. 정확한 패턴은 다음과 같다:

 * mention - `(^|[ \t]+)@([a-zA-Z0-9]+)`
 * hash - `(^|[ \t]+)#([ㄱ-ㅎ가-힣a-zA-Z0-9]+)`

다시 말해서 줄 처음에 시작하는 `@mention`이나 앞에 공백(space, tab)문자가 있는 것만 인식한다.

이 규칙이 중요할 때가 있는데, `#`으로 Heading을 표현하는 Markdown에서 중요하다. 줄 맨앞에서 `#Heading`이라고 표현하면 DFM가 처리하는 것이 아니라 showdown 엔진이 처리하기 때문에 링크가 생성되지 않고 `<h1>Heading</h1>`이라고 해석된다. 이 것은 해석하는 순서의 문제다.

그리고 `<code>` 블럭과 `<a>` 블럭에 있는 것은 무시한다. 간단히 말하면 `@mention`과 @mention의 차이이고 [@twitter](http://twitter.com)와 @twitter 의 차이다. 원문은 다음과 같다:

    그리고 `<code>` 블럭과 `<a>` 블럭에 있는 것은 무시한다. 간단히 말하면 `@mention`과 @mention의 차이이고 [@twitter](http://twitter.com)와 @twitter 의 차이다. 원문은 다음과 같다:

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

다음은 코드 블럭이라 DFM은 동작하지 않는다. 하지만 GFM의 것은 코드 블럭의 것도 처리한다. 다시 말하지만 GFM의 것은 코드 블럭에서도 링크를 생성 하지만 Dogfeet에서 추가한 `@mention`과  `#hash`는 코드 블럭에서는 링크를 생성하지 않는다:

    * SHA: be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User@SHA ref: mojombo@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
    * #Num: #1
    * User/#Num: mojombo#1
    * User/Project#Num: mojombo/god#1, `mojombo/god#1`
    * @pismute
    * #EveryoneIsBeautiful `, #EveryoneIsBeautiful,#EveryoneIsBeautiful`
    * #한글 `, #한글,#한글`

### Coding

기본적으로 내장된 템플릿은 twitter로 연결된다. 그래서 `@mention`과 `#hash`를 클릭하면 twitter로 연결된다. 하지만 바꿀 수 있다.

    var templates={
      '@': function(key){ return ['@@', key].join(''); }
      , '#': function(key){ return ['##', key].join(''); }
    }
    var dfm = require("dogfeet-flavored-markdown");
    gfm.parse("I **love** @DFM. #DFM", {templates:templates});
    // returns:
    // '<p>I <strong>love</strong> @@DFM. ##DFM'


### 설치

이 모듈은 npmjs.org에 올릴 계획이 없다. 그러니 다음과 같이 설치해야 한다.

    npm install git://github.com/dogfeet/dogfeet-flavored-markdown.git#master

## Docpad Plugin

Docpad Plugin을 만들어서 이 블로그에 했다. 다음은 Docpad Plugin이다:

    # Export Plugin
    module.exports = (BasePlugin) ->
        # Define Plugin
        class DogdownPlugin extends BasePlugin
            # Plugin name
            name: 'dogdown'

            # Plugin priority
            priority: 700 

            templates:
                '@': ( key ) ->
                    ['<a href="https://twitter.com/#!/', key, '">@', key, '</a>'].join('')
                    #['<a href="https://github.com/', key, '">@', key, '</a>'].join('')
                '#': ( key ) ->
                    ['<a href="/site/tagmap.html#', key, '">#', key, '</a>'].join('')

            # Render some content
            render: (opts,next) ->
                # Prepare
                {inExtension,outExtension,templateData,content} = opts

                # Check our extensions
                if inExtension in ['md','markdown'] and outExtension is 'html'
                    # Requires
                    markdown = require('dogfeet-flavored-markdown')

                    # Render
                    opts.content = markdown.parse( content, { templates:@templates } ) 

                # Done, return back to DocPad
                return next()

templates을 수정해서 단순히 링크를 생성하는 것외에 통계나 문서의 메타 정보도 구할 수 있지만 그리하진 않았다.

## 마치며

 이 모듈의 [저장소][dogfeet-flavored-markdown]에 올려 두었다.

[showdown]: http://www.showdown.im/
[dogfeet-flavored-markdown]: https://github.com/dogfeet/dogfeet-flavored-markdown
[github-flavored-markdown-help]: http://github.github.com/github-flavored-markdown/
[isaacs-flavored-markdown]: https://github.com/isaacs/github-flavored-markdown
[github-flavored-markdown]: https://github.com/github/github-flavored-markdown

