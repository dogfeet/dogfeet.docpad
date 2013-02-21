--- yaml
layout: 'article'
title: 'grunt: node-coffee 템플릿'
author: 'Changwoo Park'
date: '2013-2-21'
tags: ['grunt', 'node', 'node-coffee', 'template']
---

@Outsideris님의 [자바스크립트 빌드 도구 Grunt](http://blog.outsider.ne.kr/892)와 [Grunt에 사용자 템플릿 추가하기](http://blog.outsider.ne.kr/894)를 읽고 [node-coffee][] 템플릿을 만들었다. @docpad 덕에 coffeescript에 익숙해졌고 항상 Compile해서 실행하기만 하면 디버그도 할 수 있기 때문에 node를 사용할 때는 coffee를 사용하려고 하는 편이다. 그동안 make를 사용해서 좀 불편했었는데, grunt를 적용하니 정말 편하다. 좀 더 편하려고 Coffeescript에 Mocha를 기본으로 하는 템플릿을 하나 만들었다.

![](/articles/2013/grunt-init-node-coffee/gruntjs.png)

## grunt 0.4

갑자기 0.4 버전이 배포되는 바람에 @Outsideris님의 글이 내용이 틀리게 됐다. 하지만 정리가 잘돼 있어서 grunt를 이해하기에는 여전히 좋은 글이다.

@Outsideris님의 글을 읽고 0.3 버전용 [node-coffee][]를 만들었다가 나중에 글을 써야지 하고 있었는데, 0.4가 나와 버렸다. [upgrading-from-0.3-to-0.4](http://gruntjs.com/upgrading-from-0.3-to-0.4)을 잘 읽고 적용하는 게 좋다. 나는 길어서 대충 읽었다가 삽질을 좀 했다. 다 읽기 귀찮으면 새 템플릿으로 만든 코드를 좀 읽어보고 시작하는 것이 시간을 절약해줄 것 같다.

## node-coffee 템플릿

이 템플릿은 특징을 요약하면 아래와 같다:

* Coffeescript
  - Gruntfile.coffee
  - `/src/lib/**/*.coffee`를 `/out/lib/**/*.js`로 컴파일
  - `/src/test/**/*.coffee`를 `/out/test/**/*.js`로 컴파일
  - coffeelint
* Javascript
  - `/src/lib/**/*.js`를 `/out/lib/**/*.js`로 복사
  - `/src/test/**/*.js`를 `/out/test/**/*.js`로 복사
  - jshint 그대로 포함
* Mocha + Should로 변경

그 외는 [node](https://github.com/gruntjs/grunt-init-node) 템플릿을 수정한 것이기 때문에 node 템플릿과 같다.

### 사용법

다음과 같이 설치한다:

```
git clone git@github.com:pismute/grunt-init-node-coffee.git ~/.grunt-init/node-coffee
```

[grunt-init][]이 설치된 상태에서 다음과 같이 프로젝트를 만든다:

```
mkdir my-project
cd my-project
grunt-init node-coffee
```

[grunt-init]: https://github.com/gruntjs/grunt-init
[node-coffee]: https://github.com/pismute/grunt-init-node-coffee

