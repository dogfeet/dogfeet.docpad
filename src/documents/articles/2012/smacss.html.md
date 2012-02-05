--- yaml
layout: 'article'
title: 'SMACSS: Brief Notes - Part 1'
author: 'Changwoo Park, Sean Lee'
date: '2012-2-4'
tags: ['CSS', 'SMACSS', 'Jonathan Snook', 'Review']
---

[SMACSS][]('smacks', 아마도 '스맥스'로 읽는다)에는 '[Jonathan Snook][snook]'의 오랜 경험과 통찰이 담겨 있다. SMACSS는 프레임워크라기 보다는 스타일 가이드에 가까워서 만드는 사이트에 따라 그때그때 유연하게 사용할 수 있다.

_Back-End 출신이라 CSS를 사용할 때마다 '이 많은 스타일은 어떻게 관리해야 할까?'라는 궁금증을 늘 가지고 있었다. 이 책은 그 궁금증을 해결해 준다._

이 책은 두 번으로 나눠서 정리할 것인데 Part 1은 CSS Rule에 대하여, Part 2는 SMACSS의 나머지 부분을 다룰 예정이다.

![SMACSS](/articles/2012/smacss/smacss.png)

## Introduction

저자인 Snook가 경험했던 Best Practice를 SMACSS라는 책으로 정리했다. 이 방법은 규모에 상관없이 효과적이라서 프로젝트 초반부터 성장하는 내내 유용하다고 설명한다.

Snook도 말하고 있지만 SMACSS는 프레임워크가 아니라 스타일 가이드다. 그래서 어떤 라이브러리나 도구도 제공하지 않는다. SMACSS는 CSS를 어떻게 구성하고 사용해야 하는가를 설명한다.

SMACSS은 다음과 같은 주제를 다룬다:

 * Four Types of CSS Rules - SMACSS의 핵심, CSS를 네 가지로 분류하고 어떻게 구분해 사용하는지 설명
 * Themes and Typography - Theme와 Font에 대해 설명
 * Depth of Applicability - Selector를 길게 만드는 것이 좋은지 짧게 만드는 것이 좋은지 설명. 즉, tradeoff에 대한 설명.
 * Selector Performance - 브라우저가 Selector를 어떻게 찾는지 설명
 * State Representation - 상태에 대한 표현 기법
 * HTML5 and SMACSS - HTML5와 함께 사용하는 법
 * Prototyping - 만들어놓은 CSS를 실제 사용하기 전에 테스트해 보는 과정
 * Formatting Code - CSS 코드 형식을 정리하는 법

이 중 `Four Types of CSS Rules`이 핵심인데 이 규칙은 다음과 같다:

 * Base Rule
 * Layout Rule
 * Module Rule
 * State Rule

[SMACSS Review][smacss-review]를 작성한 'Jonathan Christopher'는 몇 시간이면 다 읽는다고 했는데 난 며칠 걸렸다. 영어인데다가 분명히 흥미로운 내용인데도 이상하게 읽어도 읽어도 머릿속에 잘 들어오지 않았다.

이 책은 CSS를 관리하는 법에 대해서 설명한다. 표현에 대해서 다루는 CSS 책은 무수히 많지만 이런 책은 드물다.

SMACSS는 유료 컨텐츠도 있지만, 기본적으로 무료다. 만약 ebook 포멧으로 읽거나 숨겨진 컨텐츠를 읽고 싶으면 결제해야 하지만 책의 내용 대부분을 웹에서 무료로 읽을 수 있다. 하지만, 구매하길 바란다. 무료로도 읽을 수 있지만 그만한 가치가 있다. 지금 유료 컨텐츠는 'The Icon Module', 'Screencast: Applying the Principles' 둘뿐이지만 저자는 계속 추가한다고 한다.

[smacss-review]: http://mondaybynoon.com/20120109/book-review-smacss/
[SMACSS]: http://smacss.com/
[snook]: http://snook.ca/

다음은 공부한 내용을 정리한 것이다. 읽고 해석한 대로 정리한 것이니 원문과 다를 수도 있다. 

## Four Types of CSS Rules

SMACSS는 CSS Rule을 네 가지로 나눈다.

 * Base - 기본 스타일
 * Layout - 엘리먼트를 나열하는 것과 관련된 스타일
 * Module - 재사용 위해 하나로 묶는 스타일
 * State - Hidden/Expand나 Active/Inactive 같은 스타일

그 외 Theme와 Font Rule에 대해서 거론하지만, 특별히 분류하지는 않았다. 대신 위 네 가지 Rule을 이용해서 Theme와 Font Rule을 만든다.

### Base

Base Rule을 쉽게 말하자면 id, class가 없는 스타일들을 말한다. 다음과 같은 것들이 Base Rule이다:

	html, body, form { margin: 0; padding: 0; }
	input[type=text] { boarder: 1px solid #999; }
	a { color: #039; }
	a:hover { color: #03C; }

Base Rule은 직접 이름 지을 수 없는 element, attribute, psedo 셀렉터 등으로만 만든다.

#### CSS Reset

기본 margin, padding 등의 것을 규정하는 Base Rule을 CSS Reset이라고 부른다. 사실 Base Rule을 사용할 만한 데가 CSS Reset밖에 없어 보인다. SMACSS는 element 셀렉터를 권장하지 않아서 element 셀렉터를 사용해도 된다고 허용하는 부분은 Base Rule로 CSS Reset을 만들 때와 `.mod > input`처럼 child 셀렉터를 함께 쓸 때뿐이다.

### Module

Module 스타일이 필요한 이유는 스타일을 Module 단위로 묶어서 재사용하기 위함이다. 사이드바나 제품 목록 등의 반복적으로 재사용하는 것들이 이에 해당된다. 

Module 스타일 이름은 3자로 제한해 사용한다. 하지만, 스타일 가이드이니까 4자도 되고 글자제한이 없어도 된다:

	/* Example Module */
	.exm { }
	
	/* Callout Module */
	.cli { }
	
	/* Form field module */
	.fld { }

Exmaple Module에서 하위 스타일을 하나 만든다면 다음과 같이 하면 된다:

	.exm-caption { }

Module은 재사용할 수 있어야 하기 때문에 id 셀렉터를 사용하지 않는다. 그리고 element 셀렉터도 사용하지 않는다. 다음과 같은 스타일과 html을 보자:

	<div class="fld">
		<span>Folder Name</span>
	</div>

	.fld > span {
		padding-left: 20px;
		background: url(icon.png);
	}

이렇게 사용해도 무방하지만, 프로젝트 규모가 커질수록 다른 element로 바꿔야 할 수도 있고 element 본연의 특징을 유지하기 어려울 수 있다. `span`을 제거하고 다음과 같이 변경한다:

	<div class="fld">
		<span class="fld-name">Folder Name</span>
	</div>

	.fld > .fld-name {
		padding-left: 20px;
		background: url(icon.png);
	}

그래도 element 셀렉터를 꼭 사용해야겠다면 `.fld > span`처럼 child 셀렉터를 꼭 함께 사용하라.

### Layout

Layout Rule이 엘리먼트를 어떻게 나열하는지 결정한다. 로그인 폼, 내비게이터 등부터 header, footer 같은 부분을 구분하는 것이 모두 Layout Rule이다.

`.l-fixed` 유무에 따라 가변 폭으로 할지 고정 폭으로 할지 결정하는 Layout은 다음과 같이 만든다:

	#article {
		width: 80%;
		float: left;
	}

	#sidebar {
		width: 20%;
		float: right;
	}

	.l-fixed #article {
		width: 600px;
	}

	.l-fixed #sidebar {
		width: 200px;
	}

id 셀렉터에는 'l'을 붙이지 않고 class 셀렉터에만 'l'을 붙인다. 전체 Layout처럼 큼직큼직한 Layout은 id 셀렉터로 스타일을 만들고 로그인 폼 같이 작은 부분의 스타일은 class 셀렉터로 만든다.

성능 등을 이유로 class 셀럭터 없이 전부 id 셀렉터로 만들어도 되지만 꼭 그래야 할 이유는 없다. CSS에서는 id 셀렉터와 class 셀렉터 이 둘의 성능은 거의 같다. id 셀렉터가 Javascript에서 빠를지 모르겠지만, CSS는 아니다. 

그리고 Layout Rule만 id 셀렉터를 사용한다. 다른 스타일은 id 셀렉터 사용하지 않는다.

id 셀렉터에 tag 셀렉터와 함께 사용하지 않는다. 자식이면 child 셀렉터(>)를 꼭 사용한다.

### State

상태와 관련된 스타일을 말하고 이름을 지을 때 's'를 붙인다. 예를 들면 이런 거다:

	.s-hidden { display: none; }

`!important`를 사용해도 되는 Rule은 State Rule뿐이다. 다른 Rule에는 `!important`를 사용해서는 절대 안된다. 하지만, State Rule에서도 권장하지 않는다. 되도록 안 쓰는 것이 좋다. 뭥미:) 그냥 사용하지 말자.

