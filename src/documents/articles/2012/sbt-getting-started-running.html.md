--- yaml
layout: 'article'
title: 'sbt: Getting Started Guide: Running'
author: 'Changwoo Park'
date: '2012-7-25'
tags: ['sbt']
---

이 글은 [Getting Started sbt][orig-getting-started]을 번역한 것이다.

![sbt](/articles/2012/sbt/sbt.png)

# Running

이 페이지는 이미 설정이 끝난 프로젝트에서 `sbt` 명령을 사용하는 법을 설명한다. [sbt를 설치][setup]했고 [Hello, World][hello-world]정도는 만들어 봤다고 간주한다.

## Interactive mode

프로젝트 디렉토리에서 아무런 아규먼트 없이 sbt를 실행한다:

    $ sbt

아규먼트 없이 sbt를 실행하면 인터랙티브 모드로 실행돼서 커맨드 프롬프트가 나온다. 이 커맨드 프롬프트는 탭 완성과 히스토리까지 지원한다!

예를 들어 sbt 프롬프트에서 `compile`이라고 실행하고:

    > compile

`compile`을 다시 실행할 때는, 위 방향키를 누르고 엔터를 친다.

`run`을 입력해서 프로그램을 실행한다.

Unix에서는 Ctrl+D 키를, Windows에서는 Ctrl+Z 키를 누르거나 `exit`라고 입력하면 인터랙티브 모드를 빠져나온다.

## Batch mode

sbt를 배치 모드로 실행할 수도 있다. 스페이스로 구분해서 목록을 죽 나열하고 sbt 아규먼트로 넘기면 된다. sbt의 아규먼트는 sbt 명령과 그 명령의 아규먼트를 의미한다. sbt 명령어와 해당 명령의 아규먼트는 따옴표(`"`)로 묶어서 아규먼트 하나로 만든다:

    $ sbt clean compile "test-only TestA TestB"

이 예제에서는 `test-only` 명령에 `TestA와 `TestB` 아규먼트를 넘기면 입력한 sbt 명령어 순으로 `clean`, `compile`, `test-only`가 실행된다.

## Continuous build and test

소스 파일이 수정될 때 자동으로 컴파일하고 테스트를 실행하게 할 수 있으니 수정-컴파일-테스트 과정에 드는 시간을 절약할 수 있다.

명령을 실행할 때 앞에 `~` 라고 적어주면 소스 파일이 변경될 때마다 명령어가 실행된다. 예를 들어, 인터랙티브 모드에서는 다음과 같이 실행한다:

    > ~ compile

    Press enter to stop watching for changes.

인터랙티브 모드 뿐만 아니라 배치 모드에서도 `~`를 사용할 수 있다.

자세한 내용은 [Triggered Execution](https://github.com/harrah/xsbt/wiki/Triggered-Execution)에서 있다.

## Common commands

다음은 자주 사용하는 sbt 명령어다. 나머지 sbt 명령어는 [Command Line Reference](https://github.com/harrah/xsbt/wiki/Command-Line-Reference)에서 설명한다.

* `clean`
  `target` 디렉토리에 생성한 파일을 모두 삭제한다.
* `compile`
  `src/main/scala`와 `src/main/java` 디렉토리에 있는 소스를 컴파일한다.
* `test`
  테스트를 전부 컴파일하고 실행한다.
* `console`
  컴파일한 소스와 모든 의존성을 자동으로 클래스패스에 포함시켜서 Scala 인터프리터를 실행한다. sbt 콘솔에서 `:quit`를 입력하거나 Ctrl+D(Unix) 키나 Ctrl+Z(Windows)를 누르면 빠져나온다.
* `run <argument>*`
  `sbt`가 실행되고 있는 가상 머신에서 해당 프로젝트의 메인 클래스를 실행한다.
* `package`
  `src/main/scala`와 `src/main/java`에 있는 소스 파일을 컴파일한 클래스와 `src/main/resources`에 있는 파일까지도 전부 포함하는 jar파일을 생성한다. 
* `help <command>`
  해당 명령어의 도움말을 보여준다. <command>를 생략하면 모든 명령어에 대한 요약 도움말을 보여준다.
* `reload`
  빌드 정의 파일인 `build.sbt`, `project/*.scala`, `project/*.sbt`을 다시 로드한다. 이 파일을 수정했을 때 필요하다.

## Tab completion

인터랙티브 모드에서는 탭 자동완성을 사용할 수 있다. 프롬프트에 입력한 게 없을 때에도 탭 자동완성을 사용할 수 있다. 탭 키를 한번 누르면 가능한 데까지 자동완성을 해주고 거기서 한 번더 누르면 그 다음에 선택할 수 있는 모든 명령어를 보여준다.

## History Commands

인터랙티브 모드에서는 히스토리가 저장되는데 sbt를 종료하거나 재시작할 때도 저장된다. 방향키로 히스토리를 조회할 수 있다. 다음은 히스토리와 관련된 명령이다:

 * `!`
  히스토리 명령어에 대한 도움말을 보여준다.
 * `!!`
  이전 명령어를 실행한다.
 * `!:`
  모든 이전 명령어를 보여준다.
 * `!:n`
  최근에 실행한 n번째 명령어를 보여준다.
 * `!n`
  최근에 실행한 n번째 명령어를 실행한다. `!:` 명령어는 과거 명령어를 순서에 따라 보여준다.
 * `!-n`
  최근에 실행한 n번째 명령어를 실행한다.
 * `!string`
  `string`으로 시작하는 가장 최근 명령어를 실행한다.
 * `!?string`
  `string`이 포함된 가장 최근 명령어를 실행한다.

[orig-getting-started]: https://github.com/harrah/xsbt/wiki/Getting-Started-Welcome
[getting-started]: /articles/2012/sbt-getting-started.html
[setup]: /articles/2012/sbt-getting-started-setup.html
[hello-world]: /articles/2012/sbt-getting-started-hello.html
[directory-layout]: /articles/2012/sbt-getting-started-directory-layout.html
[running]: /articles/2012/sbt-getting-started-running.html
[.sbt-build-definition]: /articles/2012/sbt-getting-started-sbt-build-definition.html
[scopes]: /articles/2012/sbt-getting-started-scopes.html
[more-about-settings]: /articles/2012/sbt-getting-started-more-about-settings.html
[library-dependencies]: /articles/2012/sbt-getting-started-library-dependencies.html
[.scala-build-definition]: /articles/2012/sbt-getting-started-scala-build-definition.html
[using-plugins]: /articles/2012/sbt-getting-started-using-plugins.html
[multi-project-builds]: /articles/2012/sbt-getting-started-multi-project-builds.html
[custom-settings-and-tasks]: /articles/2012/sbt-getting-started-custom-settings-and-tasks.html
[summary]: /articles/2012/sbt-getting-started-summary.html
