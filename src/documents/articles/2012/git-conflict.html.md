--- yaml
layout: 'article'
title: 'Git:conflict'
author: 'Changwoo Park'
date: '2012-01-01'
tags: ['git']
---

충돌을 해결하는 방법은 단순하다. 편집기로 충돌이 일어난 파일을 열어 적절히 편집하고 `git add` 명령으로 Staging Area에 추가하고 나서 `git commit`으로 commit하면 끝이다. 하지만, Git으로 좀 더 쉽게 하는 방법을 알아본다.

Git 명령어를 사용하다 보면 'ours', 'theirs'라는 옵션을 자주 보게 된다. 이 옵션은 충돌을 위해 만들어진 옵션이다. 이 글은 이 옵션에 대해 설명한다.

![creation of adam](/articles/2012/git-conflict/creation-of-adam.jpg)

새해 복 많이 받으세요!!

## Config

기본적으로 `git diff`와 같은 형식으로 보여주지만 충돌 결과를 보여주는 스타일을 변경할 수 있다:

    $ git config merge.conflictstyle diff3

## Checkout

Checkout 명령에 `--ours`와 `--theirs` 옵션이 있다. 이 옵션은 충돌 났을 때 사용한다. `ours` 브랜치에 conflict 파일은 다음과 같다고 하자:

    $ cat conflict
    ours

`theirs` 브랜치의 conflict 파일은 다음과 같다:

    $ cat conflict
    theirs

`theirs` 브랜치를 `ours` 브랜치에 Merge하면 충돌 난다:

    $ git merge theirs
    Auto-merging conflict
    CONFLICT (content): Merge conflict in conflict
    Automatic merge failed; fix conflicts and then commit the result.

diff 명령으로 어디서 충돌 났는지 확인한다:

    $ git diff
    diff --cc conflict
    index 1b9074b,f853c8d..0000000
    --- a/conflict
    +++ b/conflict
    @@@ -1,1 -1,1 +1,5 @@@
    ++<<<<<<< HEAD
     +ours
    ++=======
    + theirs
    ++>>>>>>> theirs

편집기로 conflict 파일을 손으로 수정해도 되지만 그냥 ours에 있는 파일을 사용할 수 있다:

    $ git checkout --ours -- conflict

theirs의 파일을 선택할 수도 있다:

    $ git checkout --theirs -- conflict

충돌을 해결했으면 `git add`로 추가하고 커밋한다.

## Diff

`git diff` 명령에도 `--ours`, `--theirs` 옵션이 있다. 이 옵션을 주면 `git diff` 명령은 다른 색으로 표시해준다. 예를 들어 다음과 같이 실행한다.

    $ git diff --ours --color=auto

그러면 ours 브랜치의 내용만 다른 색으로 표시해준다. `--theirs`도 같은 방법으로 확인할 수 있다.

diff 명령은 `--base` 옵션이 있어서 이 옵션을 주면 두 브랜치의 base 커밋에 있는 내용도 같이 보여준다:

    # git diff --base

## Merge

Merge할 때 아예 어느 것을 선택할지 정해줄 수 있다. ours 브랜치의 것을 선택하는 merge를 해보자.

    $ git merge -s ours theirs
    Merge made by ours.

그리고 파일 내용을 보면 ours 브랜치의 파일로 Merge 돼 있다.

    $ cat conflict
    ours

theirs를 선택하면 충돌 내지 않고 theirs 브랜치의 파일로 Merge된다.

## Attribute

Attribute로 Blob 패턴마다 ours를 사용할지 their를 사용할지 설정할 수 있다.

Git Attribute는 Blob 패턴마다 다른 설정을 하는 것을 말하며 `.gitattributes` 파일을 만들고 거기에 작성하면 된다. 

이 설정은 브랜치의 목적이 환경일 때 유용하다. 예를 들어 prod, test, dev라는 브랜치를 만들어 사용한다고 가정하자. prod는 실제 운영환경을 목적으로 설정돼 있고 test는 CI 등 테스트 자동화를 위해 만들었고, dev는 로컬 개발 환경을 위한 설정을 담고 있다고 하자. 그리고 환경정보는 `src/main/resources/env.properties`에 기술한다고 가정하자. 실제로 프로젝트를 해본 결과 prod, test, dev 프로파일을 만들고 개발하는 것이 `Maven + Spring` 환경에서는 꽤 유용했다. 분명히 환경을 위한 브랜치가 필요할 때가 올 것이다. 

`.gitattributes` 파일을 프로젝트 루트 디렉토리에 다음과 같이 만들고:

    src/main/resoruces/env.properties merge=ours

`git merge` 명령을 실행하면 이 파일은 항상 ours의 파일로 Merge한다. 그래서 환경 설정이 Merge될 걱정 없이 사용할 수 있다.
