--- yaml
layout: 'article'
title: 'Git:mergetool, difftool'
author: 'Changwoo Park'
date: '2011-12-17'
tags: ['git', 'diffmerge']
---

보통은 Git에 기본으로 들어 있는 도구로도 충분하다. 기본 도구는 빠르고 간결해서 좋다. 하지만 가끔씩 Visual 도구가 필요하다.

먼저 [본격 Diff 도구 리뷰][]를 보고 도구를 골라보자. 이 리뷰는 정말 훌륭하다. 나는 무료이고 Mac, Linux, Window를 지원하는 [DiffMerge][]를 골랐다. 이 글은 DiffMerge를 기준으로 설명한다. 

![diff](/articles/2011/git-mergediff/savage-chikens-catoon.jpg)

## mergetool

다음과 같이 설정한다:

    git config --global merge.tool diffmerge
    git config --global mergetool.diffmerge.cmd "/Applications/DiffMerge.app/Contents/MacOS/DiffMerge --merge --result=\$MERGED \$LOCAL \$BASE $REMOTE"
    git config --global mergetool.diffmerge.trustExitCode true

각 설정의 의미는 다음과 같다:

 * `merge.tool`은 Merge 도구를 새로 정의하는 것이다.
 * `mergetool.*.cmd`가 실제로 실행되는 명령어다.
 * `mergetool.*.trustExitCode`은 해당 Merge 도구의 Exit 코드가 Merge의 성공여부를 나타내면 true로 설정한다.

이렇게 설정된 `~/.gitconfig/` 파일내용은 다음과 같다:

    [merge]
        tool = diffmerge
    [mergetool "diffmerge"]
        cmd = /Applications/DiffMerge.app/Contents/MacOS/DiffMerge --merge --result=$MERGED $LOCAL $BASE $REMOTE
        trustExitCode = true

이제 `git mergetool` 명령을 실행하면 DiffMerge가 실행된다.

### mergetool.keepBackup

Git은 기본적으로 Merge한 후에 원래 파일을 백업한다. 이 백업을 생략하려면 다음과 같이 설정한다:

    git config --global mergetool.keepBackup false

## difftool

difftool은 다음과 같이 설정한다:

    git config --global diff.tool diffmerge
    git config --global difftool.diffmerge.cmd "/Applications/DiffMerge.app/Contents/MacOS/DiffMerge \$LOCAL \$REMOTE"

각 설정의 의미는 다음과 같다:

 * `diff.tool`은 diff 도구를 새로 정의하는 것이다.
 * `difftool.*.cmd`가 실제로 실행되는 명령어다.

    [diff]
        tool = diffmerge
    [difftool "diffmerge"]
        cmd = /Applications/DiffMerge.app/Contents/MacOS/DiffMerge $LOCAL $REMOTE

`git difftool` 명령을 실행하면 DiffMerge가 실행된다.

### diff.external

difftool을 설정했지만 `git diff` 명령은 여전히 Git에 들어 있는 diff 툴을 사용한다. 

`git diff` 명령을 실행할 때도 DiffMerge를 사용하고 싶으면 먼저 다음과 같이 wrapper를 만든다:

    #!/usr/bin/env bash
    [ $# -eq 7 ] && /Applications/DiffMerge.app/Contents/MacOS/DiffMerge "$2" "$5"

wrapper 스크립트로 념겨지는 인자는 모두 7개로 다음과 같은 순서로 넘어간다:

    path old-file old-hex old-mode new-file new-hex new-mode

이 중에서 인자 몇 개만 사용하고 싶으면 wrapper를 꼭 만들어야 한다.

그리고 이 파일을 실행경로에 넣고 실행권한도 부여한다. 그리고 이 것을 Git에 설정한다:

    git config --global diff.external mydiff

그러면 이제 `git diff` 명령을 실행할 때도 DiffMerge를 사용할 수 있다. 

하지만 나는 `difftool` 명령과 `diff` 명령을 구분해 두는 게 좋다. 터미널에서 밖에 작업할 수 없는 환경도 많다. 그래서 나는 diff.external 옵션은 사용하지 않는다.

## preset

Git에 이미 설정이 포함돼 있어서 cmd를 설정하지 않아도 되는 프로그램들이 있다. kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff는 cmd 설정이 필요 없고 merge.tool, diff.tool만 설정해서 Git한테 어떤 도구를 사용할지만 알려주면 된다. 예를 들어 vimdiff를 사용할 거라면 다음 옵션만 설정하고 vimdiff만 실행 경로에 넣으면 된다:

    git config --global merge.tool vimdiff

## 그외

 * diff 할때 공백 문자 어떻게 다룰지 설정할 수 있다. 
 * diff할 수 있도록 바이너리 파일에서 텍스트를 추출할 수 있으면 바이너리 파일도 diff할 수 있다.

## 참고

 * [DiffMerge][]
 * [본격 Diff 도구 리뷰][]
 * [How to setup git to use diffmerge][]
 * [progit][]

[progit]: http://progit.org
[How to setup git to use diffmerge]: http://adventuresincoding.com/2010/04/how-to-setup-git-to-use-diffmerge
[DiffMerge]: http://www.sourcegear.com/diffmerge/
[본격 Diff 도구 리뷰]: http://ljh131.tistory.com/143

