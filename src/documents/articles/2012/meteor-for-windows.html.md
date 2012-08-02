--- yaml
layout: 'article'
title: 'Meteor: Windows에 설치하기'
author: 'Changwoo Park'
date: '2012-8-3'
tags: ['meteor', 'node']
---

Rod Johnson에 Meteor에 합류했다기에 자료를 좀 찾아봤다.

![](/articles/2012/meteor/meteor.jpg)

## Meteor

Meteor가 무엇인지는 @rkjun님의 '[자바스크립트기반 웹플랫폼 Meteor.js 란 무엇인가](http://rkjun.wordpress.com/2012/06/04/meteor-js-preview-0-3-6-intro/)'읽어보면 좋다.

현재는 PREVIEW이고 펀딩도 받았으니 곧 좀 더 정리된 버전을 내놓으리라 기대된다.

driver만 구현하면(driver라는 건 mongo API다 mongo API로 질의할 수 있도록 만들어 주면 된다) mongoDB말고 다른 것도 사용할 수 있다고 하고 있고 hanldebar말고 다른 템플릿 엔진도 사용할 수 있다고 하는데 아직 직접 통합해서 써야 한다. 특히 RDB를 사용하려면 기다려야 한다.

[docpad](https://github.com/bevry/docpad)의 @balupton은 JavaScript 컬랙션에 대해서 Mongo API처럼 질의하는 [query-engine](https://github.com/bevry/query-engine) 만들어서 사용한다. mongo API가 데이터를 질의하는데 꽤 편리한 방법인듯 하다.

node는 CRUD 웹 앱에 취약하다라고 생각했는데, meteor를 보면 CRUD 웹 앱 분야에서도 node가 빛을 발할 수 있다는 것을 보여준다. 현재 구조로도 'Single Page 웹 앱'에 대해서는 어느 플랫폼 보다 나은 생산성을 보여줄 것 같다.

## Windows 용 Meteor

아직 Meteor가 공식 지원하는 플랫폼은 Linux와 Mac뿐이다. Installer를 열어보면 Linux에서는 해당 패키지로 설치하니 Debian 계열에서만 도드라지는 결벽증에도 안심이다.

다음 글을 보면 아직 완전하진 않은 것 같지만, 비공식적으로 Window 용 Meteor를 배포하고 있다:

[Windows support for Meteor](https://github.com/meteor/meteor/pull/162)

[meteor.msi][] 다운 로드해서 설치하고 path만 걸어 주면 된다. node도 들어 있기 때문에 기존에 사용하던 node와 엉키지 않도록 Path를 잘 걸어준다. 'c:\Meteor'에 설치했으면 다음과 같이 설정한다:

	set PATH=c:\Meteor;c:\Meteor\bin;%PATH%

`c:\Meteor\bin`에 node, npm이 들어 있으니 이 디렉토리도 추가한다.

현재 이 패키지에 들어 있는 node 버전은 `v0.6.19`이고 meteor 버전은 `v0.3.7`이다. node의 최신 버전은 `v0.8.4`이고 meteor의 최신 버전은 `v0.3.8`인 걸 가만할 때 쓸만한 것 같다. meteor에서 직접 신경 쓰는 것 같으니, 앞으로도 너무 버전이 벌어지지 않게끔 해줄 것 같다.

meteor/docs 앱을 실행하면 다음과 같이 실행된다:

![](/articles/2012/meteor/meteor-run.jpg)

출력메시지는 최신 버전이 아니니 update하라는 얘기인데 `meteor update`할 수 없다. 그 외에는 잘 동작하는 것 같다. 아마 msi 파일을 다시 배포할 것이라고 생각한다. 

[meteor.msi]: https://dl.dropbox.com/s/8g6o0edqhqmzly1/Meteor.msi?dl=1
[Continuation-passing style]: http://dogfeet.github.com/articles/2012/by-example-continuation-passing-style-in-javascript.html

