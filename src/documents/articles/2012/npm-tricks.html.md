--- yaml
layout: 'article'
title: 'node: npm-tricks'
author: 'Changwoo Park'
date: '2012-2-25'
tags: ['node', 'npm', 'Guillermo Rauch']
---

*이 글은 Guillermo Rauch의 [NPM tricks](http://www.devthought.com/2012/02/17/npm-tricks/)을 번역한 것이다.*

![npm](/articles/2012/npm/npm.png)

나는 매일매일 NPM을 사용한다. 왠지 사람들이 잘 모를 것 같아서 쓸만한 NPM 팁을 정리했다.

## Dev dependencies

테스트 프레임워크같이 개발할 때만 필요한 '개발용' 모듈은 `devDependencies`에 넣는다:

    "devDependencies": {
        "module": "0.1.0"
    }

## Introspecting package.json

Node 0.6부터는 `require()`로 JSON 파일을 자동으로 읽어 준다. 그래서 쉽게 모듈의 package.json 파일을 이용할 수 있다:

    // considering the module lives in lib/module.js:
    exports.version = require('../package').version;

특정 모듈의 package.json을 읽어 오려면 다음과 같이 한다:

    require('my-module/package').name

## Linking

동시에 모듈을 여러 개 개발해야 할 때에는 보통 모듈들이 서로 의존하게 된다. 문제가 없는 모듈만 NPM에 Publish하기 때문에 이 때에는 다른 방법이 필요하다.

이때 `npm link`로 NPM에 올리지 않고도 의존성을 해결할 수 있다. 의존하는 모듈에서 `npm link <package>`를 실행하면 `global`에 있는 모듈을 끌어다 놓는다(link). 예를 들어, `moduleB`가 아직 개발 중인 `moduleA`에 의존하는 상황을 살펴보자:

You can leverage `npm link` to generate a global reference to a module, and then run `npm link <package>` to install it in other modules. Consider the following example, in which `moduleB` depends on the version of `moduleA` you’re currently developing, and `moduleB` specifies `"moduleA"` as a dependency in its `package.json`

    $ cd moduleA/
    $ npm link
    $ cd ../moduleB

    # moduleB의 package.json에는 
    # 아직 publish하지 않은 버전의 moduleA가 필요하다고 적혀 있기 때문에
    # 'npm install'은 실패한다.
    $ npm install

    # global에 있는 moduleA를 local에 설치한다.
    $ npm link moduleA

    # moduleA는 이미 설치했으니까 'npm install'이 무시한다:
    $ npm install

## Production flags

`npm install`할 때 `--production` 옵션을 주지 않으면 `devDependencies`에 있는 모듈을 설치해서 시간을 낭비하게 된다:

    $ npm install --production

설치하면서 발생하는 로그도 볼 수 있는데, 필요한 로그를 골라 볼 수 있다:

    $ npm install --loglevel warn

## Git dependencies

NPM에 Publish하는 대신 `package.json`에 버전 대신 URI를 넣을 수 있다. Private 모듈이든 Public 모듈이든 `git://`로 시작하는 URI를 명시할 수 있다:

    "dependencies": {
        "public": "git://github.com/user/repo.git#ref"
        , "private": "git+ssh://git@github.com:user/repo.git#ref"
    }

`#ref`는 생략할 수 있지만 `master`같은 브랜치, `0.0.1`같은 태그, SHA 값을(짧은 SHA도 됨) 넣을 수 있다. 태그로 사용하는 것이 좋은데, `npm install`이 항상 최신 버전을 사용하도록 하는 태그를 사용하는 것이 좋다.

## Local binaries

가끔은 의존하는 모듈의 `bin`을 가져다 써야 할 때가 있다. 이것은 테스트를 실행하거나 컴파일을 하려고 `Makefile` 만드는 것과 비슷하다.

다음과 같이 다른 곳에 설치된 프로그램을 사용하는 것이 아니라:

    test:
      mocha mytest.js

숨겨진 `node_mdoules/.bin` 디렉토리에 있는 local 모듈을 사용한다:

    test:
      node_modules/.bin/mocha mytest.js

여기서는 `"mocha"`를 사용하여 테스트한다. `mocha`를 `package.json`의 `devDependencies`에 넣는다. 그러면 `npm install`을 실행할 때 모듈이 설치된다.

Makefile을 따로 만들지 않을 거라면 `npm run-script` 명령어를 사용할 수 있다. `package.json`의 `scripts`에 다음과 같이 정의한다:

    "scripts": {
            "test": "mocha mytest.js"
              , "build": "uglify mycode.js
    }

그러면 다음과 같이 실행할 수 있다:

    $ npm run-script test
    $ npm run-script build
    $ npm test # shortcut for `run-script test`

게다가, 환경변수 `$PATH`에 `./node_modules/.bin/`를 추가하면 어디서나 스크립트를 직접 실행할 수 있다!

## Private repositories

개발 중인 모듈을 Publish하지 않을 때 `package.json`에 `private` 설정을 하면 실수로 Publish하는 일을 방지할 수 있다:

    "private": true

Private 저장소가 있으면 package.json에 registry로 등록할 수 있다:

    "publishConfig": { "registry": "https://yourregistry:1337/" }
