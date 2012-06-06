--- yaml
layout: 'article'
title: 'Ladybucks: A Chrome extension for Starbucks WI-FI'
author: 'Changwoo Park'
date: '2012-2-9'
tags: ['Starbucks', 'Ladybucks', 'Backbone.js', 'Chrome Extension']
---

Ladybucks는 Chrome extension으로 스타벅스에서 WI-FI를 편하게 사용하기 위해 만들었다. 단순히 스타벅스에서 요구하는 정보를 저장했다가 해당 페이지가 뜨면 정해진 페이지 흐름대로 자동으로 입력하고 처리해준다.

이 프로그램은 실제로 한국 Starbucks 매장에서 사용할 수 있지만 JavaScript Example로 만들고 싶었다. 그래서 `Chrome Extension`에서 `BootStrap`과 `Backbone.js`를 사용하는 예제로 참고할 수 있도록 만들었다.

![logo](/articles/2012/ladybucks/intro.png)

Ladybucks는 원래 [@lethee][]가 Safari 버전으로 만들었고 [@lnyarl][]가 Chrome 버전으로 포팅하였다. 그걸 [@uniquenoun][]이 디자인하고 [@pismute][]가 다시 패키징했다.

## 설치하기

소스는 [저장소][ladybucks-repo]에서 확인할 수 있고 [ladybucks.cpk][]를 내려받는다.

패키지 파일을 Chrome에서 열면 설치할 수 있다.

### 20120606 업데이트

@lnyarl군이 웹 스토어에 등록함. [클릭](https://chrome.google.com/webstore/detail/fnpekdnicnempagdlmphknomnopaognh?hl=ko&gl=001)

## 사용하기

'tools/extensions' 메뉴를 클릭해서 extensions 페이지(`chrome://settings/extensions`)를 열고 Ladybucks Extension의 options을 클릭해서 option 페이지를 연다.

![extentions](/articles/2012/ladybucks/extensions.png)

이 페이지에서 Starbucks Wi-Fi 이용 시 사용할 신상정보(이름, 주민번호)를 입력한다.

![option](/articles/2012/ladybucks/option.png)

그리고 Starbucks에서 Wi-Fi 접속 페이지가 열리면 자동으로 신상정보를 입력하고 클릭해서 Wi-Fi에 연결해 준다.

![success](/articles/2012/ladybucks/success.png)

[@lethee]: https://twitter.com/#!/lethee
[@lnyarl]: https://twitter.com/#!/lnyarl
[@pismute]: https://twitter.com/#!/pismute
[@uniquenoun]: http://uniquenoun.tumblr.com

[ladybucks-repo]: https://github.com/pismute/ladybucks
[ladybucks.cpk]: https://pismute.github.com/ladybucks/ladybucks.cpk
