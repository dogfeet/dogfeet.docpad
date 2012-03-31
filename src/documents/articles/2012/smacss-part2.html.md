--- yaml
layout: 'article'
title: 'SMACSS: Brief Notes - Part 2'
author: 'Changwoo Park, Sean Lee'
date: '2012-4-1'
tags: ['CSS', 'SMACSS', 'Jonathan Snook', 'Review']
---

[SMACSS][]('smacks', 아마도 '스맥스'로 읽는다)에는 '[Jonathan Snook][snook]'의 오랜 경험과 통찰이 담겨 있다. SMACSS는 프레임워크라기 보다는 스타일 가이드에 가까워서 만드는 사이트에 따라 그때그때 유연하게 사용할 수 있다.

_Back-End 출신이라 CSS를 사용할 때마다 '이 많은 스타일은 어떻게 관리해야 할까?'라는 궁금증을 늘 가지고 있었다. 이 책은 그 궁금증을 해결해 준다._

[Part 1][]은 CSS Rule에 대하여 다루었고, Part 2는 SMACSS의 나머지 부분을 다룬다. [Part 1][]에서 SMACSS는 4가지 중요한 Rule이 있다고 했는데 여기 하나가 더 추가되었다.

 * Base - 기본 스타일
 * Layout - 엘리먼트를 나열하는 것과 관련된 스타일
 * Module - 재사용 위해 하나로 묶는 스타일
 * State - Hidden/Expand나 Active/Inactive 같은 상태를 스타일
 * **Theme - 사이트 전체가 보이는 느낌에 대한 스타일**

![SMACSS](/articles/2012/smacss/smacss.png)

[smacss-review]: http://mondaybynoon.com/20120109/book-review-smacss/
[SMACSS]: http://smacss.com/
[snook]: http://snook.ca/
[Part 1]: /articles/2012/smacss.html

## 테마 Rule

우리가 [Part 1][]을 쓸 당시 저자는 사실 이 부분을 SMACSS Rule에 넣기에는 부족하지만 어쨌든 한번은 다루어야 겠다는 생각을 했다고 언급했다. 결국은 SMACSS Rule에 들아갔다.

테마는 웹사이트에 따라 사용할수도 사용하지 않을수도 있다. 테마를 지원하는 사이트를 살펴보면 Google 메일이나 Yahoo 메일 같은 사이트가 있다. 비록 그대가 지금 만들고 있는 웹사이트가 테마를 지원하지 않더라도 알아둘 필요가 있다고 생각한다.

### 테마

딱히 설명이 필요 없지만 굳이 정의하자면 테마라는 것은 색상 및 이미지를 사용하여 사이트의 전체적인 Look and Feel을 결정한다. 테마와 관련된 부분을 따로 하나의 CSS로 분리해두면 나중에 새로운 테마를 만들거나 테마를 서로 바꿀 때 아주 적절하게 사용할 수 있다.

테마는 모든 스타일을 재정의 할 수 있다. 예를 들어 링크의 색상을 바꾼다거나 사이트 전체의 레이아웃을 변경할 수도 있다. 테마와 스타일을 분리하기 위해 클래스 이름을 쓰는 방법도 있지만 대개 테마를 하나의 파일로 분리하여 사용하면 될 것이다.

### 타이포그러피

마지막으로 중요한 것이 타이포그러피(역주: 활자라 부르고 싶다)이다. 종종 사이트의 타이포그러피를 전체적으로 변경해야 할 상황이 있다. 또한 예를 들어 여러 나라의 언어를 지원할 때 만약 한국어나 중국어의 글자는 크기가 작으면 읽기가 매우 힘들다. 이러한 경우에도 전반적인 글자 크기 조정이 필요하다.

타이포그러피는 Base, Module, State Rule에 영향을 미치지만 Layout에는 영향을 주지 않는다. 글자의 크기를 조절할 때 약 3가지 정도의 다른 크기를 정해서 사용하는 것이 좋다. 만약 여러 단계의 글자 크기가 있다면 사용자는 구별하기 힘들어 할 것이다.

## 상태 변경

사이트를 만들 때 어떤 부분은 처음부터 보이는 부분이 있고 어떤 부분은 어떤 상태가 변경이 되어야만 보이는 부분이 있다. 상태라는 것을 무엇으로 나타내고 어떻게 변경할 수 있을까?

**클래스 이름**

마우스를 움직이거나 키보드를 누르거나하는 이벤트가 발생하면 JavaScript를 사용하여 클래스 이름을 변경할 수 있다. 클래스 이름이 변경되면 스타일이 변경되고 그에 따라 보여지는 모습도 바뀔 것이다.

**Pseudo 클래스**

Pseudo 클래스를 사용하면 JavaScript를 사용하지 않고도 상태 변경을 보여줄 수 있다. 하자만 보통 인접한 엘리먼트만 변경할 수 있는 제한이 있다.

**미디어 쿼리**

페이지가 보여지는 화면의 크기에 따라 스타일을 변경할 수 있다.

### 상태 변경 해보기

[SMACSS - Changing State](http://smacss.com/book/state) 사이트에서 저자는 상태를 변경하는 여러 코드를 직접 보여주고 있다. '클래스 이름으로 상태 변경하기', 'Pseudo 클래스로 상태 변경하기', '미디어 쿼리로 상태 변경하기' 등의 예제를 볼 수 있다.

## SMACSS를 쓰면...

이어지는 아래의 여러 내용은 SMACSS를 적용했을 때 기대할 수 있는 부분을 설명하고 있다.

## 적용도(Depth of Applicability)

깊이는 쉽게 말해 CSS 셀렉터의 길이를 의미한다. CSS 깊이 문제는 이미 만들어놓은 HTML 구조에 관련있는 것이고 HTML 구조를 그대로 CSS 셀렉터에 표현하면 너무 길어진다. 예를 들어 다음과 같은 CSS Rule이 있으면:

	#sidebar div, #footer div {
		border: 1px solid #333;
	}

	#sidebar div h3, #footer div h3 {
		margin-top: 5px;
	}

	#sidebar div ul, #footer div ul {
		margin-bottom: 5px;
	}

div 엘레멘트를 기본으로 하여 다음과 같이 바꿀 수 있다.

	.pod {
		border: 1px solid #333;
	}

	.pod > h3 {
		margin-top: 5px;
	}

	.pod > ul {
		margin-bottom: 5px;
	}

엘리먼트 마다 Class 셀렉터를 만들지 않고 `.pod` 하나만 만들었다. 깊이도 간단해졌고 문서 구조에 따라 의도하지 않은 CSS 적용도 피할 수 있다. 문서 구조는 변하지 않았지만 대신 적용해야 하는 부분마다 `.pod` 클래스를 지정해줘야 한다 이런 점이 고민할 부분이다. 한 쪽으로 치우치면 다른 한 쪽이 아쉬워진다.

이렇게 얕은 깊이의 CSS은 템플릿 엔진을 사용할 때 효과적이다. 이 CSS를 따르는 [Mushache][]의 템플릿 코드를 살펴보자:

	<div class="pod">
		<h3>{{heading}}</h3>
		<ul>
			{{#items}}
			<li>{{item}}</li>
			{{/items}}
		</ul>
	</div>

중요한 점은 관리성, 성능, 가독성을 잘 조화시켜야 한다. CSS 셀렉터 길이가 너무 길면 HTML 여기저기 클래스 속성이 남발하는 것을 낮출 수 있지만 관리성과 가독성을 포기해야 한다. 반대로 모든 엘리먼트에 Class 셀렉터를 새로 만들어 줄 수도 있다. 이 예제에서 h3, h1에 까지 class 셀렉터를 부여하는 것은 불필요하다.

Container는 보통 Header, Body, Footer 영역으로 나눈다. 이 것은 일종의 디자인 패턴이라고 할 수 있다. 그래서 `.pod > ul`을 다음과 같은 CSS Rule을 만들고 HTML에 적용시면:

	.pod-body {
		margin-bottom: 5px;
	}

Container 안에서 ul, ol, div에서 클래스 지정만으로 같은 효과를 사용할 수 있다.

이렇게 단일 셀렉터를 사용하면 결국 '어떤 CSS 셀렉터를 사용해야 할지?' 더는 고민하지 않아도 된다. 특별한 이유가 없으면 이렇게 단일 셀렉터를 사용하는게 장땡이다.

[Mushache]: http://mustache.github.com/

## 셀렉터 성능 고려

성능을 위해 CSS 셀렉터를 어떻게 적용할 지 몇가지 팁을 제시하고 있다. 성능 측정을 위해 몇 가지 도구를 사용한다고 말하는데 [Google Page Speed][]같은 프로그램으로 한번 측정해보는 것이 적당할 것이다.

우선 스타일은 HTML의 엘리먼트가가 생성되는 시점에 적용이 된다. 브라우저는 HTML문서를 일종의 Stream으로 다룬다. 그러니까 먼저 들어온 엘리먼트를 먼저 생성한다. 다음 예제를 보면:

	<body>
		<div id="content">
			<div class="module intro">
				<p>Lorem Ipsum</p>
			</div>
			<div class="module">
				<p>Lorem Ipsum</p>
				<p>Lorem Ipsum</p>
				<p>Lorem Ipsum <span>Test-</span></p>
			</div>
		</div>
	</body>

`body, div#content, div.module.intro ...` 순으로 엘리먼트를 생성하고 스타일을 evaluate한다는 말이다. 각 엘리먼트를 Evaluate할 때 Font는 뭐고, 컬러는 뭐고, 높이나 넓으는 얼마인지 브라우저는 정리한 스타일대로 적용하고 그린다. 그리고 하위 엘리먼트의 크기가 바뀌면 브라우저는 Body를 다시 그려야(Repaint)한다고 생각한다(저자는 다른 변수가 있는 사례가 있다고 의심하지만 확실한 것은 보통 width와 height값이 바뀌면 다시 그린다는 것이다).

HTML이 실제로 Render되는 영상을 소개하고 있다. http://youtu.be/ZTnIxIA5KGw 는 Firefox의 reflow/repaint 영상이다.

### Right to Left

CSS는 오른쪽 부터 Evaluate한다. `#content > div > p` 같은 셀렉터가 있다면 `p` 엘리먼트가 그려질 때 마다 상위 `div`를 찾고 상위 `#content`를 찾는다. 스타일이 적용되기 위해 셀렉터가 찾아봐야 하는 엘리먼트의 갯수가 얼마나 될지 생각해봐야 한다.

### 그외 다른 규칙은?

Google Page Speed는 다음 네 가지 셀렉터 Rule은 비효율적이라고 말한다.

 * `#content h3`와 같은 Descendant Selector
 * `#content > h3`와 같은 Child Selector
 * `div#content > h3`와 같이 불필요한 엘리먼트까지 정의하는 Selector
 * `div#content:hover`와 같이 link 엘리먼트가 아닌 엘리먼트에 :hover를 정의하는 Selector

자세한 내용은 [Google Page Speed의 조언][]을 참고하는 것이 좋다.

[Google Page Speed]: http://css-tricks.com/efficiently-rendering-css/
[Google Page Speed의 조언]: http://code.google.com/speed/page-speed/docs/rendering.html

[Efficiently Rendering CSS](http://css-tricks.com/efficiently-rendering-css/) 사이트를 참고해 보는 것도 좋다.

## HTML5와 SMACSS

[SMACSS][]는 당근 HTML5에 잘 들어맞는다. 사실 HTML4에도 잘 들어맞는다. [SMACSS][]는 다음 두 가지 목표를 위해 노력하기 때문이다.

1. 증가: HTML과 Content에서 Section의 의미
2. 감소: 특정 구조로 HTML을 만들거라는 기대

특히 HTML5에서 새로 추가된 의미 태그는 1번 항목을 도와준다. 하지만 HTML5라고 해서 충분히 모든 의미를 포함할수는 없다. 클래스 속성을 통해서 아주 구체적인 의미를 밝힐 수 있다. 아래의 두 `<nav>` 엘리먼트는 클래스로 그 의미를 밝혀두고 있다. 클래스 속성에 따라 `nav-primary` 클래스는 가로 메뉴로, `nav-secondary` 세로메뉴로 만들수도 있다.

	<nav class="nav-primary">
	    <h1>Primary Navigation</h1>
	    <ul>…</ul>
	</nav>

	<nav class="nav-secondary">
	    <h1>External Links</h1>
	    <ul>…</ul>
	</nav>

### 2단계 메뉴 목록

SMACSS의 목표는 최대한 얕은 깊이의 셀렉터를 사용하는 것이다. 만약 아래와 같은 마크업이 있을 때 2단계를 어떻게 다르게 처리할 수 있을까.

	<nav class="nav-primary">
	    <h1>Primary Navigation</h1>
	    <ul>
	        <li>About Us
	            <ul>
	                <li>Team</li>
	                <li>Location</li>
	            </ul>
	        </li>
	    </ul>
	</nav>

CSS 셀렉터를 중첩해서 쓰면 아래와 같다:

	nav.nav-primary li { 
	    display: inline-block; 
	}

	nav.nav-secondary li,
	nav.nav-primary li li {
	    display: block;
	}

자 여기서 엘리먼트를 제한하는 `nav`를 제거하고 셀렉터의 깊이도 더 얕게 만들어보면:

	.l-inline > * { 
	    display: inline-block;
	}

	.l-stacked > * {
	    display: block;
	}

요렇게 만들어볼 수 있다. 마크업은 아래와 같이 수정되어야 한다.

	<nav class="l-inline">
	    <h1>Primary Navigation</h1>
	    <ul>
	        <li>About Us
	            <ul class="l-stacked">
	                <li>Team</li>
	                <li>Location</li>
	            </ul>
	        </li>
	    </ul>
	</nav>

## 프로토타입

좋은 프로그래머는 패턴을 좋아해~ 좋은 디자이너도 패턴을 좋아해~

패턴으로서 재사용성을 높일 수 있다. SMACSS는 코드에서도 디자인에서도 패턴을 찾아내려 애쓴다. 프로토타입을 써서 전체적인 혹은 빌딩 블록 각 부분의 코드와 디자인이 제대로 되었는가를 확인할 수 있다. 잘 만든 디자인과 코드는 재사용하기가 매우매우 좋다. [Bootstrap](http://twitter.github.com/bootstrap/) 과 [960.gs](http://960.gs/)를 보라.

### 프로토타입

프로토타입을 통해 다음 사항을 확인해볼 수 있다.

**상태**

프로토타입에서는 정의해 둔 모든 상태에 대해서 테스트해 볼 수 있어야 한다. 데이터를 필요로 한다면 JSON이든 실제 서버든 간에 만들어서 테스트해보아야 한다.

**지역화**

사이트가 여러 언어를 지원하면 프로토타입을 통해 지역화를 지원하는지, 지역화를 통해 레이아웃이 손상되지 않는지 테스트 해볼 수 있다.

**의존관계**

프로토타입을 통해 각 모듈이 잘 보여지기 위한 최소의 필요조건을 테스트해볼 수 있다. 사이트가 커질수록 불필요한 부분을 줄이는것이 중요하다.

### 퍼즐 맞추기

야후처럼 아주 큰 사이트의 경우 프로토타입을 만들기 위한 시스템을 구축하여 부분적인 또한 전체적인 스타일을 테스트 해볼 수 있다. 운영하는 사이트가 규모가 작다면 이런 시스템은 오히려 배보다 배꼽이 더 클수도 있다. 사이트에 적당한 프로토타입을 정하는것이 중요하다.

좋은 모듈을 만들고 패턴을 재사용하기 좋게 만드는 것이 추구해야할 목적이다. [MailChimp의 디자인 패턴 깜지](http://www.flickr.com/photos/aarronwalter/5579386649/)처럼 한눈에 보기쉽게 정리해두면 좋을 것이다.

패턴은 락(樂)이다. 패턴을 코드로 만듦도 락(樂)이다. 패턴을 리뷰하고 테스트 하는 프로세스를 만듦은 극락(極樂)이다.
