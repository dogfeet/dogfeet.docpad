--- yaml
layout: 'article'
title: 'Optimize browser rendering'
author: 'Changwoo Park'
date: '2012-01-27'
tags: ['CSS', 'Selector', 'Performance', 'Google Page Speed']
---

이글은 [Google Page Speed][]에 있는 [Optimize browser rendering][]를 정리한 것이다. 이 글과 이 글에 주렁주렁 달린 글을 모두 독파하면 '한 브라우저 렌더링'한다고 말할 수 있을 것 같다.

브라우저의 특징을 잘 살려서 코딩하면 성능이 빨라진다. 이 글은 다음과 같은 주제에 대해 설명한다:

 * 효율적인 CSS 셀렉터
 * CSS Expression 안 쓰기
 * CSS는 Document head에 넣기
 * 이미지 크기 명시하기
 * Charset 명시하기

![google-page-speed](/articles/2012/optimize-browser-rendering/google-page-speed.png)

## 효율적인 CSS 셀렉터

찾아볼 엘리먼트가 많은 셀렉터만 사용치 않아도 렌더링 성능이 대폭 향상된다.

브라우저는 HTML을 파싱하는 대로 화면에 표시할 엘리먼트를 모두 생성하면서 내부에 도큐먼트 트리를 만든다. 브라우저의 CSS 엔진은 정해진 규칙에 따라 엘리먼트마다 맞는 스타일이 있는지 찾는다. 그 규칙은 표준 CSS cascade, 상속, 정열 규칙에 따른다. "셀렉터"는 어떤 엘리먼트에 스타일을 적용할지를 나타내는 것인데 CSS 엔진은 제일 오른쪽에 있는 셀렉터부터 찾는다. 가장 오른쪽에 있는 셀렉터를 "Key 셀렉터"라고 부르고 필요한 스타일을 찾거나 못 찾을 때까지 계속 Evaluate한다.

이런 시스템이라서 Rule이 적을수록 성능이 좋다. 그러니까 [사용하지 않는 CSS][removing unused CSS]를 삭제하는 것만으로도 성능이 대폭 향상된다. 일단 안 쓰는 CSS를 모두 삭제하고 나서 엘리먼트나 CSS Rule이 많은 페이지를 최적화한다. CSS Rule을 손보는 것만으로도 성능을 향상시킬 수 있다. Rule을 가능한 정확하게 만들고 불필요한 군더더기를 제거하는 게 최적화의 핵심이다. 그래서 스타일 엔진이 사용하지도 않을 Rule까지도 일일이 검사하지 않게끔 해야 한다.

[removing unused CSS]: http://code.google.com/speed/page-speed/docs/payload.html#RemoveUnusedCSS

#### Descendant 셀렉터

	ul li a {...}

Descendant 셀렉터는 비효율적이다. 브라우저는 Key를 찾고 나서 정확히 일치하는 것을 찾거나 더는 찾을 수 없을 때까지 그 상위 DOM 트리를 전부 뒤진다. Key가 덜 구체적일수록 Evaluate해 봐야 하는 엘리먼트의 수는 많아진다.

#### Child 셀렉터

	ul > li > a {...}

Child 셀렉터도 비효율적이다. 브라우저가 엘리먼트를 Evaluate할 때마다 노드를 하나 더 Evaluate해야 한다. 다시 말해서 Child 셀렉터를 사용한 Rule은 비용이 두 배 더 든다. 게다가 Key 셀렉터가 가리키는 엘리먼트가 많을수록 더 많은 엘리먼트를 Evaluate해야 한다. 비효율적이지만 Descendant 셀렉터 보다는 훨씬 빨라서 꽤 사용되는 편이다.

#### 쓸데없이 셀렉터를 더 사용할 때

	ul#top_blue_nav {...}

정의에 따르면 ID 셀렉터는 중복될 수 없다. 그래서 class나 tag 셀렉터와 함께 사용하면 필요 없는 Evaluate을 추가로 하게 만든다. 노파심을 달래줄 뿐 하지 않아도 될 Evaluate만 더 하는 것이다.

#### Pseudo 셀렉터 `:hover`를 링크가 아닌 엘리먼트에 사용할 때

	.foo:hover {...}

`:hover` 셀렉터를 Non-anchor 엘리먼트에 사용하면 [IE7, IE8는 느려질 때가 있다][ie78-bug-report]고 알려졌다. Strict Doctype을 사용하지 않을 때 IE7, IE8은 Non-Anchor 엘리먼트에 사용된 `:hover`를 무시한다. 하지만, Strict Doctype이 사용할 때 Non-Anchor 엘리먼트에 `:hover`를 사용하면 성능을 저하된다.

[ie78-bug-report]: http://connect.microsoft.com/IE/feedback/ViewFeedback.aspx?FeedbackID=391387

### 기억할 것.

 * Universal 셀렉터를 Key로 사용하지 말 것.
   * 여러 가지 엘리먼트에 적용해야 할 때는 Class 셀렉터를 사용하자.

 * 가능한 구체적으로 사용하라.
   * Tag 셀렉터 보다는 ID나 Class 셀렉터를 사용하라.

 * Redundant Qualifier를 제거할 것.
   * ID 셀렉터와 Tag, Class 셀렉터를 사용하지 말 것.
   * Class 셀렉터에 추가로 Tag 셀렉터를 사용하지 말 것.

 * Descendant 셀렉터를 사용하지 말 것 - 특히 Redundant 때문에 Ancestor를 명시하지 말 것.
   * `body ul li a` 같은 Rule에서 body는 Redundant 때문에 사용한 것인데 아무 의미 없다.

 * Descendant 셀렉터 대신 Class 셀렉터를 사용하라.
   * `ul li {color: blue;}` 이런 스타일은 `.unordered-list-item {color: blue;}`으로 바꾼다.
   * `ol li {color: red;}` 이런 스타일은 `.ordered-list-item {color: red;}`으로 바꾼다.

 * Descendant 셀렉터를 사용할 바에는 Child 셀렉터를 사용해라.
   * 여러 단계를 다 Evaluate하는 것보다 한 단계만 더 Evaluate하는 게 낫다.

 * IE를 위해 `:hover`를 Non-Anchor(non-link) 엘리먼트에 사용하지 말 것.
   * Non-Anchor 엘리먼트에 `:hover`를 사용하면 IE7, IE8에서 꼭 해당 페이지를 테스트해야 한다. `:hover` 때문에 성능에 문제가 생기면 IE에서는 JavaScript의 onmouseover 이벤트 핸들러를 사용하라.

## CSS expression 안 쓰기.

CSS expression은 렌더링 성능을 떨어트린다. CSS expression은 IE5, IE6, IE7만 지원하는 것이고 IE 8부터는 deprecated 됐다. 게다가 다른 브라우저는 아예 지원하지 않는다. 정리하지 않음.

## CSS는 document head에 두기

브라우저는 `<link>` 엘리먼트의 CSS 파일을 모두 내려받을 때까지 웹 페이지를 렌더링하지 않기 때문에 `<link>` 엘리먼트를 도큐먼트 헤드에 넣어서 무엇보다 CSS 파일을 먼저 내려받을 수 있도록 해줘야 한다.

브라우저는 도큐먼트를 스트림처럼 다루기 때문에 내려받은 만큼 먼저 렌더링한다. 렌더링하고 나서 스타일이 바뀌면 다시 해야 하기 때문에 인라인 스타일 블럭(`<style>` 엘리먼트)도 도큐먼트 헤드에 넣어줘야 한다.

### 기억할 것

 * `<link>` 엘리먼트는 항상 `<head>`에 넣어라.
 * [`@import`는 사용하지 마라][dont-use-import]
 * `<style>` 블럭도 `<head>`에 넣어라.

[dont-use-import]: http://www.clearboth.org/css-link-vs-import/

## 이미지 크기 명시하기

이미지 크기를 명시하면 이미지 파일을 다 내려받고 나서 다시 그리지(reflow와 repaint) 않는다. 크기를 명시하지 않았거나 명시한 크기가 실제 이미지 크기와 다르면 브라우저는 내려받고서 다시 그린다.

### 기억할 것

 * 실제 이미지 크기로 명시하라.
 * img 엘리먼트나 그 부모 중에서 block 엘리먼트에 크기를 명시해야 한다. block 엘리먼트가 아니면 명시한 크기 값은 무시된다.

## Charset 명시하기

HTML 문서의 HTTP Response 헤더에 캐릭터 셋을 항상 넣어주면 브라우저는 바로 HTML 파싱하고 스크립트를 실행한다. 

Charset을 명시하지 않으면 브라우저는 일정 크기만큼 버퍼링하고 그 버퍼에서 charset 정보를 찾는다. 

브라우저마다 버퍼링하는 바이트 수와 Charset을 명시하지 않았을 때 사용하는 기본 Encoding이 다르다. 하지만, 일단 버퍼링하면 바로 렌더링한다. 그리고 만약 기본 Encoding과 버퍼링하고 나서 찾아낸 Charset이 서로 다르면 다시 파싱하고 페이지를 다시 그린다.

### 기억할 것

 * Content Type을 빠트리지 마라. - HTTP 헤더나 HTML meta tag 두 곳에 모두 적어 준다. 브라우저는 Content Type을 "sniff"하는데 알고리즘이 여러 가지 사용된다. 그래서 추가적인 Delay도 생기고 보안에 구멍도 생긴다. 'text/html'이라고 할지라도 반드시 적어준다.
 * 제대로 된 Charset을 명시한다.  - HTTP 헤더와 HTML meta tag 두 곳에 모두 명시한다.

HTTP 헤더에 명시하는 예제:

	Content-Type: text/html; charset=utf-8

HTML meta tag에 명시하는 예제:

	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />

## 결론

[Google Page Speed][]를 한번 돌려보자. 굉장히 잘 만들었다. 문제가 무엇인지 알려주고 어떻게 해결해야 하는지도 알려준다.

[Google Page Speed]: http://code.google.com/speed/page-speed/
[Optimize browser rendering]: http://code.google.com/speed/page-speed/docs/rendering.html
