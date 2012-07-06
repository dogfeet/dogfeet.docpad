--- yaml
layout: 'article'
title: 'sbt: Getting Started Guide: Hellow, World'
author: 'Changwoo Park'
date: '2012-7-8'
tags: ['sbt']
---

이 글은 [Getting Started sbt][orig-getting-started]을 번역한 것이다.

![sbt](/articles/2012/sbt/sbt.png)

## 소스 코드에 프로젝트 디렉토리 만들기

어떤 디렉토리에 소스 파일이 하나라도 있으면 그 디렉토리는 sbt 프로젝트라고 할 수 있다. `hello` 디렉토리를 만들고 그 안에 다음과 같은 `hw.scala` 파일을 만들어 넣는다:

    object Hi {
        def main(args: Array[String]) = println("Hi!")
    }

`hello` 디렉토리에서 sbt를 실행하고 sbt 콘솔에서 `run`을 실행한다. Linux와 OS X에서는 다음과 같이 실행한다:

    $ mkdir hello
    $ cd hello
    $ echo 'object Hi { def main(args: Array[String]) = println("Hi!") }' > hw.scala
    $ sbt
    ...
    > run
    ...
    Hi!

sbt는 관례에 따라 동작하는 것인데 다음과 같은 것을 찾는다.

 - Base 디렉토리에 있는 소스
 - `src/main/scala` 또는 `src/main/java`에 있는 소스
 - `src/test/scala` 또는 `src/test/java`에 있는 테스트
 - `src/main/resources` 또는 src/test/resources`에 있는 데이터 파일
 - `lib`에 있는 jar 파일

sbt는 sbt를 실행하는 데 사용한 Scala 버전으로 프로젝트를 빌드한다.

`sbt run`으로 프로젝트를 실행하거나 `sbt console` 명령으로 [Scala REPL](http://www.scala-lang.org/node/2097)을 연다. `sbt console`은 프로젝트의 클래스패스에서 실행하는 것이라서 프로젝트 소스를 이용한 Scala 코드를 라이브로 실행 수 있다.

## 빌드 정의하기

프로젝트들은 보통 손으로 설정해줘야 한다. 프로젝트 Base 디렉토리에 `build.sbt` 파일을 만들고 기본 설정을 한다.

예를 들어, 프로젝트 Base 디렉토리가 `hello`라면 `hello/build.sbt` 파일에 다음과 같이 만든다:

    name := "hello"

    version := "1.0"

    scalaVersion := "2.9.1"

각 아이템 사이에 빈 줄이 있는데 그냥 보기 좋으라고 넣은 것이 아니다. 아이템 사이에는 꼭 빈 줄을 넣어줘야 한다. [.sbt build definition][.sbt-build-definition]에서 `build.sbt` 파일을 작성하는 방법을 자세히 배운다.

프로젝트를 jar 파일로 패키지할 거라면 `build.sbt` 파일에 버전과 이름 정도는 설정할 것이다.

## sbt 버전 설정하기

`hello/project/build.properteis` 파일에 어떤 버전의 sbt를 사용할지 명시할 수 있다. 다음과 같이 만든다:

    sbt.version=0.11.3

0.10 버전부터는 버전이 올라가도 99% 이상 잘 호환된다. 하지만 `project/build.properties`에 sbt 버전을 명시하면 혹시 모를 문제를 예방할 수 있다.

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
