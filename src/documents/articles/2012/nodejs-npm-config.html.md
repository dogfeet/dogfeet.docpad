---
layout: 'article'
title: 'nodejs: npm config'
author: 'Changwoo Park'
date: '2012-5-5'
tags: ['nodejs', 'npm', 'config']
---

이글은 [npm config](http://npmjs.org/doc/config.html)를 정리한 글이다. npm이 설정을 관리하는 부분은 꽤 재미있다. npm 설정을 바꿀 일은 아직 없어서 몰랐는데 꽤 꼼꼼하게 설계했다.

![npm-config](/articles/2012/npm/npm-config.png)

## config

npm은 설정하는 방법이 여섯 가지나 있고 우선순위는 다음과 같다:

 * Command Line Flags
 * Environment Variables
 * Per-user config file
 * Global config file
 * Built-in config file
 * Default Configs

### Command Line Flags

CLI에서 `--foo bar`라고 사용하면 `foo`라는 변수에 값이 `"bar"`라고 설정된다. 그리고 `--`는 CLI 파서에게 flag 처리는 인제 그만 한다고 말하는 것이다. `--flag`처럼 단독으로 사용하는 파라미터는 명령어 끝에 사용하고 `true` 값이 할당된다.

### Environment Variables

`npm_config_`로 시작하는 환경변수도 npm 설정으로 사용된다. 예를 들어, `npm_config_foo=bar`라는 환경변수를 정의하면 npm에서 `foo` 설정의 값을 `bar`라고 설정하는 것과 같다. 환경변수에 값이 없으면 npm은 해당 설정의 값을 `true`라고 해석한다. 대소문자를 구분하지 않기 때문에 `NPM_CONFIG_FOO=bar`와 `npm_config_foo=bar`는 같다.

### Per-user config file

`$HOME/.npmrc`(파일의 위치는 `userconfig` 파라미터로 바꿀 수 있으며 위 방법(CLI 파라미터, 환경변수)으로 설정할 수 있다.)

이 파일은 ini 형식이라서 `key = value`라고 설정한다.

### Global config file

`$PREFIX/etc/npmrc`(파일의 위치는 `globalconfig` 파라미터로 바꿀 수 있고 위 방법(CLI 파라미터, 환경변수, userconfig)으로 설정한다.)

이 파일도 ini 형식이다.

### Built-in config file

`path/to/npm/itself/npmrc`

이 파일은 "빌트인"이라 수정할 수 없다. npm 스크립트에 들어 있는 `./configure` 스크립트로 값을 설정할 수 있다. 이 파일은 기본 값을 변경해야 하는 배포 관리자를 위한 것이고 표준과 일관성을 지키며 수정해야 한다.

그러니까 회사에서 회사에 맞는 설정(회사의 registry를 기본 registry로 한다든가 하는)을 직원에게 배포할 때 이 설정을 바꾼 npm을 만들어서 배포하면 되겠다.

### Default Configs

npm 내부에 박혀있는 것으로 파라미터가 어디에도 설정되지 않으면 사용하는 기본값이다. 이것은 그냥 하드코딩된 것으로 생각하면 된다.

## 명령어

config 명령어가 있는데 `git config`랑 비슷하다.

### set

    npm config set key value

key, value를 설정한다.

value를 생략하면 "true"로 설정된다.

### get

    npm config get key

stdout에 설정 값을 보여준다.

### list

    npm config list

npm 설정 목록을 보여준다.

### delete

    npm config delete key

모든 설정 파일에서 key를 삭제한다.

### edit

    npm config edit

설정을 편집기에서 수정하도록 편집기를 열어준다. `--global` flag를 주면 global 설정 파일이 열린다.

## 단축 파라미터

사용할 수 있는 단축 파라미터들:

* `-v`: `--version`
* `-h`, `-?`, `--help`, `-H`: `--usage`
* `-s`, `--silent`: `--loglevel silent`
* `-q`, `--quiet`: `--loglevel warn`
* `-d`: `--loglevel info`
* `-dd`, `--verbose`: `--loglevel verbose`
* `-ddd`: `--loglevel silly`
* `-g`: `--global`
* `-l`: `--long`
* `-m`: `--message`
* `-p`, `--porcelain`: `--parseable`
* `-reg`: `--registry`
* `-v`: `--version`
* `-f`: `--force`
* `-l`: `--long`
* `-desc`: `--description`
* `-S`: `--save`
* `-y`: `--yes`
* `-n`: `--yes false`
* `ll` and `la` commands: `ls --long`

파라미터를 입력하다 말아도 특정 파라미터로 판단할 수만 있으면(resolve unambiguously) 해당 파라미터로 사용한다:

    npm ls --par
    # same as:
    npm ls --parseable

단축 파라미터는 여러 개를 붙여 사용해도 된다. 예를 들어:

    npm ls -gpld
    # same as:
    npm ls --global --parseable --long --loglevel info

## Per-Package Config Settings

npm script를 사용할 때만 적용되는 설정도 할 수 있다. package.json의 "config" 설정은 "scripts" 설명을 이용할 때 적용된다. 다음과 같으면:

    { "name" : "foo"
    , "config" : { "port" : "8080" }
    , "scripts" : { "start" : "node server.js" } }

`npm start`를 실행시킬 때 config 설정이 적용된다. 하지만, 다른 곳에 설정할 수도 있다. `<name>[@<version>]:<key>`처럼 정의하면 된다. 이 pacakge.json을 사용하는 server.js가 다음과 같으면:

    http.createServer(...).listen(process.env.npm_package_config_port)

다음과 같이 바꿀 수 있다:

    npm config set foo:port 80
