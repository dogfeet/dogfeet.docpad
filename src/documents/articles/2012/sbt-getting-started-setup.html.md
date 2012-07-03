--- yaml
layout: 'article'
title: 'sbt: Getting Started Guide: Setup'
author: 'Changwoo Park'
date: '2012-7-3'
tags: ['sbt']
---

이 글은 [orig-getting-started][]을 번역한 것이다. 

![sbt](/articles/2012/sbt/sbt.png)

## Overview

다음과 같은 과정을 거쳐서 sbt 프로젝트를 만든다:

 - sbt를 설치하고 실행할 스크립트를 만든다.
 - [hello-world][] 프로젝트를 만든다.
   - 프로젝트 디렉토리를 만들고 소스를 넣는다.
   - 어떻게 빌드할지 정의한다.
 - [running][]을 통해 sbt를 실행하는 법을 배운다.
 - [.sbt-build-definition][]에서 어떻게 빌드할지 정의하는 법을 배운다.

## sbt 설치

`sbt-launch.jar` 파일과 실행할 스크립트만 있으면 된다.

*Note: 다운로드는 [다운로드 페이지](http://www.scala-sbt.org/download.html)에서 할 수 있다.*

### Yum

[Typesafe Yum 레파지토리](http://rpm.typesafe.com)에 yum 패키지가 있다. [레파지토리 rpm 패키지](http://rpm.typesafe.com/typesafe-repo-2.0.0-1.noarch.rpm)를 설치하면 typesafe yum 레파지토리가 승인된 소스 목록에 추가된다. 그리고 다음과 같이 실행한다:

    yum install sbt

sbt의 최신 버전이 설치된다.

*Note: 이슈를 발견하면 [여기](https://github.com/sbt/sbt-launcher-package/issues)에 신고할 수 있다.*

## Apt

[Typesafe Debian 레파지토리](http://apt.typesafe.com)에 sbt Debian 패키지가 있다. [레파지토리 deb 패키지](http://apt.typesafe.com/repo-deb-build-0002.deb)를 설치하면 typesafe debian 레파지토리가 승인된 소스 목록에 추가된다. 그리고 다음과 같이 실행한다:

    apt-get install sbt

sbt의 최신 버전이 설치된다.

sbt 없으면 레파지토리에서 정보를 업데이트한다:

    apt-get update

*Note: 이슈를 발견하면 [여기](https://github.com/sbt/sbt-launcher-package/issues)에 신고할 수 있다.*

## Gentoo

공식 소스 안에는 sbt용 ebuild 스크립트가 없다. 하지만 https://github.com/whiter4bbit/overlays/tree/master/dev-java/sbt-bin에 sbt를 머지하는 ebuild 스크립트가 있다. 다음과 같이 ebuild 스크립트로 sbt를 머지한다:

    mkdir -p /usr/local/portage && cd /usr/local/portage
    git clone git://github.com/whiter4bbit/overlays.git
    echo "PORTDIR_OVERLAY=$PORTDIR_OVERLAY /usr/local/portage/overlay" >> /etc/make.conf
    emerge sbt-bin

## Mac

[MacPorts](http://macports.org/)로 설치한다:

    $ sudo port install sbt

[HomeBrew](http://mxcl.github.com/homebrew/)로 설치할 수 있다:

    $ brew install sbt

sbt-launch.jar를 직접 다운로드할 필요 없다:

## Windows

[msi](http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt-launcher/0.11.3/sbt.msi)를 다운로드한다:

*아니면*

`sbt.bat` 배치 파일을 만든다:

    set SCRIPT_DIR=%~dp0
    java -Xmx512M -jar "%SCRIPT_DIR%sbt-launch.jar" %*

그리고 그 디렉토리에 [sbt-launch.jar][] 파일을 넣는다. 커맨드 라인에서 'sbt'라고 실행하려면 PATH 환경 변수에 `sbt.bat`를 등록해준다.

## Unix

[sbt-launch.jar]를 다운로드해서 `~/bin` 디렉토리에 넣는다.

이 jar 파일을 실행하는 스크립트를 'sbt'라는 이름으로 만들고 `~/bin` 디렉토리에 넣는다:

    java -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M -jar `dirname $0`/sbt-launch.jar "$@"

그리고 스크립트를 실행할 수 있게 만든다:

    $ chmod u+x ~/bin/sbt

## 팁, 노트

문제가 생겨서 `sbt`가 실행이 안되면 [설치 노트][setup-note]를 확인하라. 터미널 엔코딩, HTTP 프록시, JVM 옵션 등에 대해 나와 있다.

꼼꼼하게 만들어진 쉘 스크립트있어서 이 스크립트로 sbt를 설치할 수 있다: https://github.com/paulp/sbt-extras(루트 디렉토리에 있는 sbt 파일). 이 스크립트로 설치하면 패키지로 설치하는 것처럼 원하는 버전의 sbt를 설치할 수 있다. 설치할 sbt의 버전을 선택한다든지 하는 유용한 커맨드 라인이 있다.

[setup-note]: https://github.com/harrah/xsbt/wiki/Setup-Notes

[orig-getting-started]: https://github.com/harrah/xsbt/wiki/Getting-Started-Welcome
[orig-setup]: https://github.com/harrah/xsbt/wiki/Getting-Started-Setup
[orig-hello-world]: https://github.com/harrah/xsbt/wiki/Getting-Started-Hello
[orig-directory-layout]: https://github.com/harrah/xsbt/wiki/Getting-Started-Directories
[orig-running]: https://github.com/harrah/xsbt/wiki/Getting-Started-Running
[orig-.sbt-build-definition]: https://github.com/harrah/xsbt/wiki/Getting-Started-Basic-Def
[orig-scopes]: https://github.com/harrah/xsbt/wiki/Getting-Started-Scopes
[orig-more-about-settings]: https://github.com/harrah/xsbt/wiki/Getting-Started-More-About-Settings
[orig-library-dependencies]: https://github.com/harrah/xsbt/wiki/Getting-Started-Library-Dependencies
[orig-.scala-build-definition]: https://github.com/harrah/xsbt/wiki/Getting-Started-Full-Def
[orig-using-plugins]: https://github.com/harrah/xsbt/wiki/Getting-Started-Using-Plugins
[orig-multi-project-builds]: https://github.com/harrah/xsbt/wiki/Getting-Started-Multi-Project
[orig-custom-settings-and-tasks]: https://github.com/harrah/xsbt/wiki/Getting-Started-Custom-Settings
[orig-summary]: https://github.com/harrah/xsbt/wiki/Getting-Started-Summary

[getting-started]: /articles/2012/sbt-getting-started.html
[setup]: /articles/2012/sbt-setup.html
[hello-world]: /articles/2012/sbt-hello-world.html
[directory-layout]: /articles/2012/sbt-directory-layout.html
[running]: /articles/2012/sbt-running.html
[.sbt-build-definition]: /articles/2012/sbt-sbt-build-definition.html
[scopes]: /articles/2012/sbt-scopes.html
[more-about-settings]: /articles/2012/sbt-more-about-settings.html
[library-dependencies]: /articles/2012/sbt-library-dependencies.html
[.scala-build-definition]: /articles/2012/sbt-scala-build-definition.html
[using-plugins]: /articles/2012/sbt-using-plugins.html
[multi-project-builds]: /articles/2012/sbt-multi-project-builds.html
[custom-settings-and-tasks]: /articles/2012/sbt-custom-settings-and-tasks.html
[summary]: /articles/2012/sbt-summary.html

