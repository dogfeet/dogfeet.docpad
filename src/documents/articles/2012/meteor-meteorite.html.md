--- yaml
layout: 'article'
title: 'Meteor: 스마트 패키지 매니저 "Meteorite"'
author: 'Changwoo Park'
date: '2012-9-21'
tags: ['meteor', 'meteorite', 'package']
---

[Meteorite][meteorite]로 할 수 있는 일은 두 가지이다. 하나는 스마트 패키지를 관리하는 일이고 하나는 Meteor 앱을 관리하는 일이다. 이 글은 Meteor 앱을 관리하는 방법을 설명한다. 스마트 패키지를 관리하는 일은 다음에 정리하겠다.

[Meteorite][meteorite]는 [Meteor][meteor] 매니저이자 스마트 패키지 매니저다. meteor 명령을 감싸는 형태로 구현했기 때문에 [Meteorite][meteorite]로도 Meteor 앱을 관리할 수 있다. 그리고 meteor 명령은 지원하지 않는 스마트 패키지를 설치/관리할 수도 있다. 게다가 스마트 패키지를 만들고 관리할 수도 있다. [gem][], [bundler][], [rvm][]을 보고 만들었다고 한다.

![meteorite](/articles/2012/meteor/meteorite.png)

[Meteorite][meteorite]를 사용하면 사용할 meteor 버전을 명시할 수도 있고 스마트 패키지 의존성을 관리할 수 있다.

## 설치하기

```bash
npm install -g meteorite
```

## mrt 명령어

[Meteorite][meteorite]의 명령어는 `mrt`이다. 'meteor create myapp'으로도 스케폴드 앱을 만들 수 있지만 `mrt` 명령으로도 앱을 만들 수 있다:

```bash
mrt create myapp
```

`meteor` 명령으로 생성한 것과 거의 같지만 `mrt` 명령은 meteor 저장소의 master 브랜치를 기준으로 myapp으로 생성한다. 그리고 스마트 패키지 정보파일인 smart.json 파일에 그 정보를 기록한다:

```javascript
{
  "meteor": {
    "git": "https://github.com/meteor/meteor.git",
    "branch": "master"
  },
  "packages": {}
}
```

`mrt create` 명령에는 `--branch`, `--tag`, `--ref` 옵션이 있어서 원하는 meteor 버전을 명시할 수 있다. 

그리고 다음과 같이 실행한다. 아무 옵션없이 `mrt`를 실행하면 `mrt run`를 실행한 것과 같고 기본포트는 `meteor` 명령처럼 3000이다:

```bash
mrt run --port 2222
```

## smart.json

`smart.json`은 npm의 `package.json` 처럼 스마트 패키지 정보를 기술하는 파일이다. 

```javascript
{
  //meteor는 생략할 수 있다.
  //생략할 경우 Meteor의 공식 저장소와 master 브랜치가 사용된다.
  //meteor.branch와 meteor.git 설정은 다른 브랜치를 사용할 때 쓴다.
  "meteor": { 
    "branch": "devel"
  },
  //packages에 명시한 패키지는 기본적으로 중앙저장소(atmosphere)에서
  //다운로드한다. 여기서는 moment와 fork-me를 다운로드한다.
  "packages": {
    "moment": "1.7.0",
    "fork-me": {
      "version": "0.0.1"
    },
    "cool-tool": {
      //atmosphere가 아니라 git 저장소에서 패키지를 가져온다.
      "git": "https://github.com/possibilities/cool-tool.git",
      //해당 태그의 버전을 가져온다.
      "tag": "v0.0.2"
      //branch도 된다.
      "branch": "master"
      //ref도 된다.
      "ref": "a137a5eee5"
    },
    "another-tool": {
      //atmosphere가 아니라 git 저장소에서 패키지를 가져온다.
      "git": "https://github.com/possibilities/another-tool.git"
    },
    "test-package": {
      //로컬 디스크에 있는 패키지를 가져온다.
      "path": "/path/to/local/package"
    }
  }
}
```

* smart.json 파일에는 저장소 이외에 다른 정보는 기입하지 않아도 된다. mrt는 저장소에 있는 package.js 파일을 찾고 해당 Meteor 버전에 맞는 패키지를 다운로드해서 설치한다.

* 명시한 스마트 패키지들에 서로 의존관계가 있으면 `mrt`가 적당히 정렬해서 설치한다. 상호 의존성이 있어도 잘 설치한다.

* `mrt`가 처음 실행되면 smart.lock 파일이 생성된다. 이 파일에는 사용하는 패키지 버전이 들어간다. 다음에 실행할 때 참고하기 때문에 매우 유용하다. smart.lock 파일을 저장소에 커밋해 두면 그 저장소를 클론한 다른 개발자도 원 개발자가 사용하는 버전이 무었인지 알 수 있다. 그리고 smart.json 파일이 수정되면 자동으로 새 버전으로 업데이트 한다. 다음은 smart.lock 샘플이다:

```javascript
{
  "meteor": {
    "git": "https://github.com/meteor/meteor.git",
    "branch": "devel",
    "commit": "de413efe500174999211eff318ad65eb34794d74"
  },
  "dependencies": {
    "basePackages": {
      "moment": {},
      "groups": {}
    },
    "packages": {
      "moment": {
        "git": "https://github.com/possibilities/meteor-moment.git",
        "tag": "v1.7.0",
        "commit": "c64b6ec0e714b9556f4b6643d430b868ba69d3d7"
      },
      "groups": {
        "git": "https://github.com/possibilities/meteor-groups.git",
        "tag": "v0.0.6",
        "commit": "ee45c3fbdb84313f6f0124ed30e02e101d3829cb"
      }
    }
  }
}
```

`mrt install`이라고 실행하면 Meteor는 실행하지 않고 패키지만 설치한다.

`smart.lock` 파일을 날려버리고서 `mrt update` 명령을 실행하면 패키지를 전부 업데이트할 수 있다. `mrt update PACKAGE_NAME` 처럼 패키지 이름을 입력하면 그 패키지만 업데이트된다.

## Atmosphere

[Meteorite][meteorite]는 스마트 패키지용 중앙 저장소를 사용하는데 이 저장소가 [Atmosphere][atmosphere]이다. 

다음과 같이 [Atmosphere][atmosphere]에 있는 패키지는 설치한다:

```
mrt add moment --version 1.6.2
```

'버전은 생략할 수 있다.'라고 메뉴얼에서 설명하는데 저 옵션은 제대로 동작하는 것인지 모르겠다. 생략도 가능하다. `mrt help add` 명령을 실행했을 때 나오는 설명도 없고 아직 먼가 부실하다.

`mrt list` 명령을 실행하면 현재 사용할 수 있는 패키지를 보여준다. `meteor list`과 기본적으로 같지만 mrt 명령으로 설치한 스마트 패키지도 보여진다. 아직 설치하지 않은 [Atmosphere][atmosphere]에 있는 패키지도 조회할 수 있으면 좋을 것 같은데 아직 그런 명령어는 없다. 현재 사용하고 있는 패키지는 smart.json을 봐야한다. `mrt list` 명령의 결과는 다음과 같다:

```
absolute-url      DEPRECATED: Generate absolute URLs pointing to the application
amplify           Cross browser API for Persistant Storage, PubSub and Request.
autopublish       Automatically publish all data in the database to every client
backbone          A minimalist client-side MVC framework
bootstrap         UX/UI framework from Twitter
code-prettify     Syntax highlighting of code, from Google
coffeescript      Javascript dialect with fewer braces and semicolons
email             Send email messages
force-ssl         Require this application always use transport layer encryption
groups            Simple system for groups
handlebars        Simple semantic templating language
htmljs            Easy macros for generating DOM elements in Javascript
http              Make HTTP calls to remote servers
jquery            Manipulate the DOM using CSS selectors
jquery-history    pushState module from the jQuery project
jquery-layout     Easily create arbitrary multicolumn layouts
jquery-waypoints  Execute a function when the user scrolls past an element
less              The dynamic stylesheet language.
madewith          Made With Meteor badge
moment            Moment.js packaged for Meteor
sass              Sassy CSS pre-processor.
showdown          Markdown-to-HTML processor
spiderable        Makes the application crawlable to web spiders.
stylus            Expressive, dynamic, robust CSS.
underscore        Collection of small helper functions (map, each, bind, ...)
```

`mrt remote moment`라고 실행하면 moment 패키지가 삭제된다. mrt 명령 사용방법은 `mrt help`를 실행하면 볼 수 있다. 세부 명령어 사용법은 `mrt help [command]`라고 실행하면 볼 수 있다.

지금까지 mrt 명령으로 앱을 관리하는 방법을 살펴보았다. 다음에는 스마트 패키지를 만드는 법을 살펴보겠다. 기대하시라.

[meteorite]: https://github.com/oortcloud/meteorite
[atmosphere]: https://atmosphere.meteor.com/wtf/package
[meteor]: http://meteor.com/
[npm]: https://npmjs.org/
[nvm]: https://github.com/creationix/nvm
[gem]: http://rubygems.org/
[rvm]: https://rvm.io/
[bundler]: http://gembundler.com/

