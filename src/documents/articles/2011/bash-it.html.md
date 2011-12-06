---
layout: 'article'
title: 'Bash-it'
author: 'Changwoo Park'
date: '2011-12-01'
tags: ['Bash-it', 'NVM', 'git', 'git-flow']
---

이 글은 bash-it이 무엇인지 알아보고 각 주제별로 어떤 기능이 있는지 알아 본다. bash-it은 기능이 많으므로 틈틈히 하나씩 추가할 계획이다.

![bash-it](/articles/2011/bash-it.sean-shell.png)

## 요약

[bash-it][]은 말 그대로 bash helper다. 크게 shell completion, alias, theme, plugin, template 같은 기능을 지원하는데 각 기능은 다음과 같다. 

 * completion : tab 키를 눌렀을 때 completion되도록 하는 스크립트가 들어 있다. 명령어 파라미터까지 completion을 지원한다. 예를 들어 `git checkout <tab>`이라고 입력하면 선택할 수 있는 브랜치 목록이 출력한다.
 * alias : 사람들이 자주 사용하는 alias를 정리해 두었다.
 * plugin : bash 명령어를 확장해준다(그러니까 명령어에 해당하는 함수들이다).
 * theme : terminal 색, prompt 모양등이 테마 별로 정리 돼 있다.
 * template : .bash_profile 같은 파일을 생성하는 template이 들어 있다.

이 것은 다시 말해서 revans님이 정리하고 관리하는 convention이다. bash-it에 익숙해지면 꽤 편리하다.

[bash-it]: https://github.com/revans/bash-it

## nvm

creationix님의 [nvm][]이 .bash-it에 포함돼 있다. 그러니까 .bash-it만 설치하면 nvm을 별도로 설치할 필요 없다. 

게다가 추가된 기능도 있다. original nvm에는 없는 명령 sync가 추가됐고 마지막 안정버전과 개발버전을 가르키는 stable과 latest가 기본 alias로 추가됐다.

`nvm sync` 명령을 실행하면 nodejs.org의 디렉토리 목록을 가져와서 어떤 버전이 있는지 로컬에 목록을 만들고 각 0.5 같은 0.홀수 버전은 latest로 0.짝수 버전은 stable로 가르킨다. 그리고 `nvm ls`를 실행할 때마다 로컬에 캐시된 결과와 현재 상태를 보여준다. 

내 컴퓨터에서 실행한 `nvm ls`의 결과:

    v0.1.100  v0.1.16   v0.1.23   v0.1.30   v0.1.93   v0.2.0    v0.3.0    v0.3.7    v0.4.12   v0.4.8    v0.5.3    v0.6.0
    v0.1.101  v0.1.17   v0.1.24   v0.1.31   v0.1.94   v0.2.1    v0.3.1    v0.3.8    v0.4.2    v0.4.8-rc v0.5.4    v0.6.1
    v0.1.102  v0.1.18   v0.1.25   v0.1.32   v0.1.95   v0.2.2    v0.3.2    v0.4      v0.4.3    v0.4.9    v0.5.5
    v0.1.103  v0.1.19   v0.1.26   v0.1.33   v0.1.96   v0.2.3    v0.3.3    v0.4.0    v0.4.4    v0.5.0    v0.5.6
    v0.1.104  v0.1.20   v0.1.27   v0.1.90   v0.1.97   v0.2.4    v0.3.4    v0.4.1    v0.4.5    v0.5.1    v0.5.7
    v0.1.14   v0.1.21   v0.1.28   v0.1.91   v0.1.98   v0.2.5    v0.3.5    v0.4.10   v0.4.6    v0.5.10   v0.5.8
    v0.1.15   v0.1.22   v0.1.29   v0.1.92   v0.1.99   v0.2.6    v0.3.6    v0.4.11   v0.4.7    v0.5.2    v0.5.9
    stable:     v0.6.1
    latest:     v0.6.1
    current:    v0.6.1
    # use 'nvm sync' to update from nodejs.org

다른 건 nvm을 저장소에서 설치하는 것과 모두 같다.

[nvm]: https://github.com/creationix/nvm

## git

git에 대해서는 많은 것들이 추가돼있다.

### completion

git source에 들어 있는 bash_completion코드가 포함돼 있어서 별도로 추가설치할 필요가 없다.

### alias

설치한후 `git-help`라고 실행시키면 등록된 alias들을 보여준다. 아직 사용해보지 않았다.

### plugin

몇가지 명령어를 추가했다. 이 중에서 git_stats과 git_info가 가끔 쓸만할 것 같은데 사실 별로 쓸모는 없다. 참고하고 자신만의 것을 만들면 좋을 것 같다.

 * git_stats - 누가 얼마나 기여했는지 정리해준다.
 * git_info - 현 프로젝트 정보를 요약해준다.

### theme

여러가지 테마가 있는데 내가 사용하고 있는 `zork` 테마의 경우 다음과 같이 보여준다.

    [계정][시스템 이름][±][브랜치 ✓][현재 경로]
    $ git st ...

 * ±  - 이 것은 git을 나타내는 기호다. 왜 Git icon인지 mySysGit을 설치해보면 안다. HG는 `☿`, SVN은 `⑆`, 그 외는 `○`을 보여준다.
 *  ✓ - 현재 git 상태가 clean 상태라는 것을 의미한다. dirty 상태가 되면 `✗`를 보여준다.

