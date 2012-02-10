--- yaml
layout: 'article'
title: 'Git: Global Ignore'
author: 'Changwoo Park'
date: '2012-2-10'
tags: ['Git', 'gitignore']
---

GitHub에서 관리하는 `.gitignore` 패턴 템플릿이 있어 소개한다.

![무시로](/articles/2012/git-global-ignore/ignorelo.png)

## gitignore

파일을 무시하는 패턴을 설정하는 방법은 세 가지이다:

 1. `.git/info/exclude`는 해당 저장소에만 적용되고 전송되지 않는다. 그러니까 Clone되지 않고 Push할 수 없다.
 2. `.gitignore`는 해당 저장소에만 적용되지만 전송된다.
 3. `core.exlcudesfile` 설정

파일 형식은 모두 같고, 세 파일은 있는 대로 동시에 적용될 수 있다. 우선순위는 나열한 순서대로다.

`core.exlcudesfile` 설정은 다음과 같다:

    $ git config --global core.excludesfile ~/.global_ignore

## gitignore 프로젝트

Github는 친절하게도 '언어 및 환경'마다 권장 gitignore 파일 템플릿을 모아 두었다. GitHub의 [gitignore 저장소][gitignore-repo]에 가서 Clone하고 필요한 템플릿을 사용해보자.

저장소에는 루트 디렉토리에 있는 것과 `Global/` 디렉토리에 있는 것으로 나누어져 있는데 Global/ 디렉토리에 있는 것은 'OS-specific, editor-specific'인 것이다.

예를 들어 자바라면 다음과 같이 한다:

    $ cat Maven.gitignore >> ~/.global_ignore
    $ cat Java.gitignore >> ~/.global_ignore
    $ cat Global/Eclipse.gitignore >> ~/.global_ignore
    $ cat Global/vim.gitignore >> ~/.global_ignore
    $ cat Global/OSX.gitignore >> ~/.global_ignore
    $ git config --global core.excludesfile ~/.global_ignore

[gitignore-repo]: https://github.com/github/gitignore
