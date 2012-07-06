--- yaml
layout: 'article'
title: 'sbt: Getting Started Guide: Directory Layout'
author: 'Changwoo Park'
date: '2012-7-16'
tags: ['sbt']
---

이 글은 [Getting Started sbt][orig-getting-started]을 번역한 것이다. 

![sbt](/articles/2012/sbt/sbt.png)

### Base directory

sbt에서 "base 디렉토리"는 프로젝트가 들어 있는 디렉토리를 말한다. [Hello, World][hello-world] 에서 만든 `hello` 프로젝트에는 `hello/build.sbt`와 `hello/hw.scala` 파일이 있는데 여기서 `hello` 디렉토리가 base 디렉토리이다.

## Source code

소스는 `hello/hw.scala`처럼 프로젝트 base 디렉토리에 넣으면 된다. 하지만 보통은 그냥 넣으면 너무 지저분하기 때문에 정리해서 넣는 규칙이 있다.

sbt는 기본적으로 [Maven]과 같은 디렉토리 레이아웃을 사용한다(모든 경로는 base 디렉토리를 기준으로 하는 상대 경로다):

    src/
      main/
        resources/
           <files to include in main jar here>
        scala/
           <main Scala sources>
        java/
           <main Java sources>
      test/
        resources
           <files to include in test jar here>
        scala/
           <test Scala sources>
        java/
           <test Java sources>

`src/` 안에 있는 다른 디렉토리와 숨겨진 디렉토리는 무시된다.

## sbt build definition files

`build.sbt` 파일은 base 디렉토리에 넣지만 다른 sbt 파일은 `project` 디렉토리를 만들어 넣는다.

`project` 디렉토리에는 `.scala` 파일을 넣을 수 있고 이 `.scala` 파일은 `.sbt` 파일과 함께 빌드를 정의하는데 쓴다. 자세한건 [.scala Build Definition][.scala-build-definition]를 봐라.

    build.sbt
    project/
      Build.scala

`project/` 디렉토리 안쪽에도 `.sbt` 파일을 넣을 수 있지만 base 디렉토리에 있는 `.sbt` 파일과 다르다. 이점은 몇 가지 사전지식이 필요하기 때문에 [나중에][.scala-build-definition]에서 설명한다.

## Build products

기본적으로 `target` 디렉토리에 파일을(컴파일한 클래스, 패키지한 jar 파일, managed 파일, 캐시, 문서) 생성한다.

## Configuring version control

`.gitignore` 파일에 `target/` 디렉토리를 추가한다. 다른 버전관리 시스템도 git처럼 `target/` 디렉토리를 추가해야 한다:

    target/

이름이 `/`로 끝났다. `/` 끝나는 이름은 디렉토리만 매치하겠다는 의미다. 그리고 `/`로 시작하지 않았기 때문에 base 디렉토리에 있는 `target/` 뿐만 아니라 `project/target`처럼 하위 디렉토리 안에 있는 디렉토리도 매치된다.

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

[Maven]: http://maven.apache.org/

