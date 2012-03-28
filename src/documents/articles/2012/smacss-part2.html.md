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

Pseudo 클래스를 사용하면 JavaScript를 사용하지 않고도 상태 변경을 보여줄 수 있다. 하자만 보통 인접한 엘레먼트만 변경할 수 있는 제한이 있다.

**미디어 쿼리**

페이지가 보여지는 화면의 크기에 따라 스타일을 변경할 수 있다.

### 상태 변경 해보기

[SMACSS - Changing State](http://smacss.com/book/state) 사이트에서 저자는 상태를 변경하는 여러 코드를 직접 보여주고 있다. '클래스 이름으로 상태 변경하기', 'Pseudo 클래스로 상태 변경하기', '미디어 쿼리로 상태 변경하기' 등의 예제를 볼 수 있다.

## SMACSS를 쓰면...

이어지는 아래의 여러 내용은 SMACSS를 적용했을 때 기대할 수 있는 부분을 설명하고 있다.

## Depth of Applicability

Depth는 쉽게 말해서 CSS 셀렉터의 길이를 의미한다. CSS Depth 문제는 이미 만들어진 HTML 구조에 의존적이라는 것이고 HTML 구조를 그대로 CSS 셀렉터에 표현하면 너무 길어진다. 예를 들어 다음과 같은 CSS Rule이 있으면:

	#sidebar div, #footer div {
		border: 1px solid #333;
	}

	#sidebar div h3, #footer div h3 {
		margin-top: 5px;
	}

	#sidebar div ul, #footer div ul {
		margin-bottom: 5px;
	}

이런걸 다음과 같이 바꿀 수 있다.

	.pod {
		border: 1px solid #333;
	}

	.pod > h3 {
		margin-top: 5px;
	}

	.pod > ul {
		margin-bottom: 5px;
	}

element마다 class 셀렉터를 만들지 않고 `.pod` 하나만 만들었다. 여전히 문서 구조는 남아 있지만 만든 class 셀렉터는 하나다. 이런 점이 "tradeoff"다. 한쪽으로 치우치면 다른 한쪽이 아쉽다.

이렇게 낮은(Shallow) Depth의 CSS은 템플릿 엔진을 사용할 때 효과적이다. 이 CSS를 따르는 [Mushache][]의 템플릿 코드를 살펴보자:

	<div class="pod">
		<h3>{{heading}}</h3>
		<ul>
			{{#items}}
			<li>{{item}}</li>
			{{/items}}
		</ul>
	</div>

요는 관리성, 성능, 가독성을 잘 조화시켜야 한다. CSS 셀렉터 길이가 너무 길면 "classitis"는 낮출 수 있지만 관리성과 가독성을 포기해야 한다. 반대로 모든 element에 class 셀렉터를 새로 만들어 줄 수도 있다. 이 예제에서 h3, h1에 까지 class 셀렉터를 부여하는 것은 조금 불필요하다.

Container는 보통 Header, Body, Footer 영역으로 나눈다. 이 것은 일종의 디자인 패턴이라고 할 수 있다. 그래서 `.pod > ul`을 다음과 같은 CSS Rule을 만들고 HTML에 적용시면:

	.pod-body {
		margin-bottom: 5px;
	}

ul대신 ol이나 div같은 element도 사용할 수 있다.

이렇게 단일 셀렉터를 사용하면 결국 '어떤 CSS 셀렉터를 사용해야 할지?' 더는 고민하지 않아도 된다. 특별한 이유가 없으면 이렇게 단일 셀렉터를 사용하는게 장땡이다.

[Mushache]: http://mustache.github.com/

## 셀렉터 성능 고려

Perfomance를 위해 CSS Selector를 어떻게 적용할 지 몇가지 팁을 제시하고 있다. Perfomance를 위해 몇가지 도구를 사용한다고 언급했는데 [Google Page Speed][]같은 프로그램으로 한번 측정해보는 것이 적당할 것이다.

우선 스타일은 HTML의 element가 생성되는 시점에 적용이 된다. 브라우저는 HTML문서를 일종의 Stream으로 다룬다. 그러니까 먼저 들어온 element를 먼저 생성한다. 다음 예제를 보면:

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

`body, div#content, div.module.intro ...` 순으로 element를 생성하고 스타일을 evaluate한다는 말이다. 각 element를 evaluate할 때 Font는 뭐고, 컬러는 뭐고, 높이나 넓으는 얼마인지 브라우저는 정리한 스타일대로 적용하고 그린다. 그리고 하위 element의 크기가 바뀌면 브라우저는 body를 다시 그려야(Repaint)한다고 생각한다(저자는 다른 변수가 있는 사례가 있다고 의심하지만 확실한 것은 보통 width와 height값이 바뀌면 다시 그린다는 것이다).

HTML이 실제로 Render되는 영상을 소개하고 있다. http://youtu.be/ZTnIxIA5KGw 는 Firefox의 reflow/repaint 영상이다.

### Right to Left

CSS는 오른쪽 부터 evaluate한다. `#content > div > p` 같은 Selector가 있다면 p element가 그려질 때 마다 상위 div를 찾고 상위 #content를 찾는다. 스타일이 적용되기 위해 Selector가 찾아봐야 하는 Element의 갯수가 얼마나 될지 생각해봐야 한다.

### 그외 다른 규칙은?

Google Page Speed는 다음 네 가지 Selector Rule은 비효율적이라고 말한다.

 * `#content h3`와 같은 Descendant Selector
 * `#content > h3`와 같은 Child Selector
 * `div#content > h3`와 같이 불필요한 element까지 정의하는 Selector
 * `div#content:hover`와 같이 link element가 아닌 element에 :hover를 정의하는 Selector

자세한 내용은 [Google Page Speed의 조언][]을 참고하는 것이 좋다.

[Google Page Speed]: http://css-tricks.com/efficiently-rendering-css/
[Google Page Speed의 조언]: http://code.google.com/speed/page-speed/docs/rendering.html

[Efficiently Rendering CSS](http://css-tricks.com/efficiently-rendering-css/) 사이트를 참고해 보는 것도 좋다.

## HTML5와 SMACSS

## 프로토타입

## 마무리