--- yaml
layout: 'article'
title: 'SMACSS:The Icon Module'
author: 'Changwoo Park'
date: '2012-3-8'
tags: ['CSS', 'SMACSS', 'Icon', 'CSS Sprite']
---

이글은 [The Icon Module][]을 정리한 것이다. [SMACSS][]를 읽고 SMACSS의 철학이 실제로 어떻게 적용되는지 알아보기에 좋다. 이글은 'CSS Sprite' 기법을 사용하는 엉성한 Icon Module을 SMACSS의 방법으로 단단한 Icon Module로 리팩토링하는 것을 보여준다.

![smacss](/articles/2012/smacss/smacss.png)

이 글은 무료로 공개돼 있지 않다.

## SMACSS

[SMACSS][]는 좋은 책이다. CSS '관리'에 초점을 맞추고 이렇게 일목요연하게 정리된 자료는 일찍이 보지 못했다. 이 글을 읽고 도움이 됐다면 [SMACSS][]를 꼭 사길 바란다. $30 짜리 workshop 계정을 사면 저자인 [Jonathan Snook][]가 지속적으로 업데이트하는 유로 컨텐츠를 계속 이용할 수 있다.

[The Icon Module]: https://smacss.com/book/icon-module
[SMACSS]: https://smacss.com/
[Jonathan Snook]: http://snook.ca/

## The Icon Module

Asset(Image)을 한 파일로 모으면 HTTP 요청 수도 줄고 이미 모든 Asset을 내려받았기 때문에 나중에 필요할 때 바로 사용할 수 있다. 이것을 `CSS Sprite`라고 부른다.

다음 그림을 보면 이 말이 무슨 뜻인지 알 수 있다:

![icon-menu](/articles/2012/smacss/icon-menu.png)

Menu HTML:

	<ul class="menu">
	    <li class="menu-inbox">Inbox</li>
	    <li class="menu-drafts">Drafts</li>
	</ul>

Menu CSS:

	.menu li {
	    background: url(/img/sprite.png) no-repeat 0 0;
	    padding-left: 20px;
	}

	.menu .menu-inbox {
	    background-position: 0 -20px;
	}

	.menu .menu-drafts {
	    background-position: 0 -40px;
	}

모든 Icon은 Sprite 파일 하나에 다 들어 있고 아이템마다 필요한 Icon이 있는 위치를 보여준다.

이걸로도 되긴 되지만 좀 더 작업을 다듬을 수 있다:

 * list 아이템이라는 특정 DOM에만 사용할 수 있다.
 * 모듈마다 Sprite를 항상 다시 만들어야 한다.
 * 위치가 취약하다: 폰트 크기를 늘리면 다른 부분이 살짝 보일 수 있다.
 * x가 항상 0이기 때문에 수평적으로 처리하기 까다롭다.

이 이슈만 해결되면 소위 Icon Module이라 칭할 수 있다.

Icon Module을 사용하도록 HTML을 바꾼다:

	<li><i class="ico ico-16 ico-inbox"></i> Inbox</li>

`<i>` 태그는 간단하고 시맨틱과는 거리가 먼 태그다. Icon은 다른 텍스트를 부연 설명하는 거니까 시멘틱이 없는 태그라고 볼 수 있다. Icon이 혼자 쓰일 때는 꼭 title 속성을 넣어줘서 Screen Reader나 tooltip에서 읽을 수 있도록 해주는 것이 좋다. `<i>` 태그가 싫다면 `<span>` 태그가 적당하다.

`<i>`는 HTML 속 어디에 넣어도 되니까 HTML 구조의 의존성은 사라졌다고 볼 수 있다.

그리고 "ico ico-16 ico-inbox" 클래스는 각각 역할이 다르다. 게다가 `<img>` 태그와 잘 섞어 사용할 수 있다.

Icon Module CSS:

	.ico {
	    display: inline-block;
	    background: url(/img/sprite.png) no-repeat;
	    line-height: 0;
	    vertical-align: bottom;
	}

	.ico-16 {
	    height: 16px;
	    width: 16px;
	}

	.ico-inbox {
	    background-position: 20px 20px;
	}

	.ico-drafts {
	    background-position: 20px 40px;
	}

`ico` 클래스는 모듈의 기본적인 토대를 다지는 클래스다. `<img>`처럼 inline-block 엘리멘트로 만들고 `vertical-align`으로 Icon이 텍스트와 잘 어우러지도록 해준다. IE는 `inline-block`을 `block` 엘리먼트로 취급하기 때문에 IE에서는 `{ zoom:1; display:inline; }`로 해야 한다.

`ico-16`은 크기 정해주기 위함이다. ico 클래스에 같이 넣어줘도 되지만 Icon마다 크기가 다를 수도 있어서 이렇게 하는 거다.

`icon-inbox`는 Sprite 이미지에서의 Inbox용 Icon의 위치를 정의하는 것이다.

촘촘히 우겨넣은 이미지:

![icon-menu2](/articles/2012/smacss/icon-menu2.png)

잘 우겨넣으면 압축 효율이 좋아진다. 그리고 파일 크기도 더 작아지므로 사이트 성능도 향상된다. 아직 [Smush.it][]이나 [ImageOptim][]을 사용해보지 않았으면 한번 사용해보는 것이 좋다.

[Smush.it]: http://www.smushit.com/ysmush.it/
[ImageOptim]: http://imageoptim.pornel.net/
