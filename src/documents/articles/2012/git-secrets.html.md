--- yaml
layout: 'article'
title: 'Git: git secrets'
author: 'Changwoo Park'
date: '2012-12-19'
tags: ['Git', 'holman', 'Zach Holman', 'RedDotRubyConf']
---

이글은 @holman님이 싱가폴에서 열린 [RedDotRubyConf](http://reddotrubyconf.com/)에서 발표한 [Git and GitHub Secrets](http://zachholman.com/talk/git-github-secrets)에 설명을 달았다. 내용이 길어서 둘로 나눴는데 이 글은 `Git Secetets`부분을 정리한 글이다. [GitHub Secrets](/articles/2012/git-github-secrets.html)은 다른 글에 정리한다.

Git은 명령과 옵션이 굉장히 많은데, 그 중에서 @holman님이 추천하는 쓸만한 것이라고 생각하면 되겠다.

![holman](/articles/2012/git-secrets/holman.png)

## Git secret

### --allow-empty

파일없이 커밋할 수 있다:

```sh
$ git commit -m "LOOK AT ME TROLOLOL" --allow-empty
```

`git log`를 하면 아무내용없이 그냥 커밋 개체만 달랑 생긴다.

```sh
$ git log
commit 6eb28f645174fba20d819f40da4ca822c7c67b2a
Author: Changwoo Park <pismute@gmail.com>
Date:   Tue Nov 12 20:32:25 2012 +0900

    LOOK AT ME TROLOLOL
```

히스토리에 뭔가 표식을 남기고 싶을 때 유용하다.

### Staging Hunk

파일에서 한 부분? 덩어리?를 Hunk라고 부른다. `git add -p` 명령으로 파일을 통째로 Staging Area에 넣는게 아니라 일정 골라서 부분만(hunk만) 넣는다.

자세한 설명은 @semtlnori님의 [깔끔하게 커밋하기](http://npcode.com/blog/archives/449)를 보자.

### git show :/query

특정 질의가 들어간 커밋 중에서 가장 최근 커밋 하나를 찾아 준다. 로그를 분석할때 매우 유용하다. 커밋 메시지, 파일 이름, 파일 내용에서 찾는다.

`git log` 명령에도 있어서 `git log :/query`라고 실행해도 된다. `:/query` 만족하는 커밋을 골라서 보여준다.

### go back

`cd -`라고 실행하면 이전 디렉토리로 되돌아 간다. `cd`명령 처럼 `git checkout -`라고 하면 이전 브랜치를 checkout한다.

### merged branch

브랜치나 커밋이 다른 브랜치에 Merge됐는지 확인하는 명령들.

* `git branch --merged` : 이미 다른 브랜치에 머지된 것만 보여준다.
* `git branch --no-merged` : 아직 다른 브랜치에 머지되지 않는 것만 보여준다.
* `git branch --contains 838ad46` : 특정 커밋이 포함된 브랜치만 보여준다.

### Content Copy

브랜치를 변경하지 않고도 다른 브랜치에 들어 있는 파일을 복사해 올 수 있다:

```sh
$ git checkout BRANCH -- path/to/file.rb
```

`path/to/file.rb`에 파일이 복사된다.

Reset과 Checkout은 비슷해보여서 구분하기 쉽지 않다. Checkout은 데이터베이스에서 뭔가를 꺼낼때 사용하는 명령이다. 옵션도 스냅샷과 파일이름 등 그와 관련된 옵션으로 구성돼있다. 반대로 Reset은 워킹 디렉토리, Staging Area, 브랜치 등을 스냅샷으로 Reset하는 명령이다.

이렇게 구분하면 쉽다. 데이터베이스에서 뭔가를 꺼낼때는 Checkout을 사용하고 그외는 Reset을 사용한다.

### Reachable Commits

특정 브랜치에만 있는 커밋이 보고 싶을 때는 다음과 같이 한다:

`git log branchA ^branchB`

branchA에는 있고 branchB에는 없는 커밋을 보여준다.

### FINDING LOST COMMITS

어떤 브랜치에도 들어 있지 않은 커밋을 보여준다. git의 커밋은 개체는 실제로 전부 immutable이라서 커밋을 수정하면 새로운 커밋 개체가 등록된다. 잘 못 수정했으면 아래 명령으로 커밋을 찾아서 복구한다:

```sh
$ git fsck --lost-found
Checking object directories: 100% (256/256), done.
dangling commit 4a7f2e89a480d3af0ccfdf71f76f4149f25fb0fb
dangling commit d3ad9f17532109d12084646c306e9d7748c2f791
```

어떤 브랜치에도 속하지 않은 커밋이 두 개있다.

## DIFFSTATS

델타(diff)를 다 보여주는 게 기본인데 통계만 볼 수도 있다:

`git diff HEAD^ --stat`

![git-diff--stat](/articles/2012/git-secrets/git-diff--stat.png)

### BLAME

`git blame`은 기본적으로 어떤 라인을 누가 고쳤는지 확인하는 명령이다.

**blame이니까**

`git blame`은 기본적으로 어떤 라인을 **어떤 새끼**가 고쳤는지 확인하는 명령이다.

#### git blame -w

정말 내용을 수정한 **새끼**를 찾는다. 공백만 추가한 경우는 무시한다. `git diff HEAD~` 명령으로 공백이 어디에 추가됐는지 보자:

![git-blame-w-diff](/articles/2012/git-secrets/git-blame-w-diff.png)

히스토리를 보면 마지막에 "BBB"가 공백을 추가했다:

![git-blame-w-lg](/articles/2012/git-secrets/git-blame-w-lg.png)

다음은 `git blame -w`의 결과다:

![git-blame-w](/articles/2012/git-secrets/git-blame-w.png)

단순히 공백만 추가한 "BBB"는 무시된다. `-w`을 옵션을 빼고 `git blame`만 실행하면 공백만 추가한 "BBB"도 나온다.

![git-blame](/articles/2012/git-secrets/git-blame.png)

#### git blame -M

해당 라인을 실질적으로 마지막에 수정한 사람을 보여준다. 이 옵션을 주면 같은 파일 내에서 단순히 라인을 옮긴 사람이 아니라 마지막으로 내용을 수정한 사람이 표시된다:

텍스트를 옮긴 후에 `git blame` 명령을 실행하면 다음과 같이 나온다:

![git-blame](/articles/2012/git-secrets/git-blame-m-before.png)

`-M` 옵션을 추가하면 단순히 옮긴 사람이 아니라 원래 그 코드를 추가한 사람을 보여준다:

![git-blame](/articles/2012/git-secrets/git-blame-m.png)

원래 의도는 측근 `all.md` 파일에서 친구 끼리, 가족 끼리 모아서 `-M` 옵션을 설명할 계획이였다. Git이 정확히 어떤 알고리즘을 사용하는 건지 나중에 살펴봐야 겠다.

#### git blame -C

`-M`와 비슷하게 실제로 마지막에 수정한 사람을 보여준다. 한 파일 내에서의 이동만 감지하는 것이 아니라. 같은 커밋에서의 다른 파일간 이동도 감지한다.

`all.md`라는 파일에서 친구는 `friends.md`라는 파일로 옮기고 가족은 `family.md` 파일로 옮겼다. 아래는 `git blame -f family.md`의 결과다:

![git-blame](/articles/2012/git-secrets/git-blame-c-f.png)

`-f`는 원래 파일이름을 보여주는 옵션이다. `git blame -fC family.md`의 결과는 아래와 같다:

![git-blame](/articles/2012/git-secrets/git-blame-c-cf.png)

#### git blame -CC

`-C` 처럼 다른 파일에서 옮긴 것을 감지해주는데 해당 파일을 생성한 커밋내에서도 감지한다.

#### git blame -CCC

다른 파일에서 옮긴 것도 감지하는데 커밋을 가리지 않고 전체에서 찾는다.

#### MULTI-REMOTE FETCHES

원래는 하나씩 fetch해야 하지만 group을 만들어서 한번에 fetch할 수 있다.

```sh
$ git config remotes.mygroup 'remote1 remote2'
$ git fetch mygroup
```

#### A BETTER STATUS

status의 결과를 더 간략하게 볼 수 있다.

`git status`:

![git-status](/articles/2012/git-secrets/git-status.png)

`git status -sb`:

![git-status-sb](/articles/2012/git-secrets/git-status-sb.png)

#### WORD DIFFING

라인 단위로 비교하는 것이 아니라 단어 단위로 비교해서 볼 수 있다.

`git diff HEAD^`:

![diff-head-1](/articles/2012/git-secrets/git-diff-head-1.png)

`git diff HEAD^ --word-diff`:

![diff-head-1--word-diff](/articles/2012/git-secrets/git-diff-head-1--word-diff.png)

#### CONFIG: SPELLING

`git comit`이라고 실행하면 `commit`이라고 할려고 했냐? 라고 물어봐 주는 게 기본설정이다. 명령을 실행할 때 오타를 내면 자동으로 인식해서 실행하게 할 수 있다. 다음과 같이 설정하면 된다:

```sh
$ git config --global help.autocorrect 1
```

이 옵션이 설정되면 `git comit`이라고 실행하면 그냥 `git commit`이 실행된다:

#### CONFIG: GIT RERERE(REUSE RECORDED RESOLUTION)

[Git: rerere](/articles/2012/git-rerere.html)에서 확인한다.

#### CONFIG: COLOR!

다음과 같이 설정하면 결과가 칼라로 나온다.

```sh
$ git config --global color.ui 1
```

#### ALIAS: GIT-AMEND

아래와 같이 alias를 등록하면 `git amend`라고 실행해서 HEAD 커밋을 수정할 수 있다. `-C` 옵션이 있기 때문에 커밋 메시지는 수정하지 않는다. 항상 커밋 메시지를 확인하고 싶으면 `-C HEAD`를 빼면 된다.

```sh
$ git config --global alias.amend "commit --amend -C HEAD"
```

#### ALIAS: GIT-UNDO

가장 최근 커밋을 되돌린다. `--soft`이기 때문에 그 커밋의 개체는 Staged 상태로 남는다:

```sh
$ git config --global alias.undo "reset --soft HEAD^"
```

#### ALIAS: GIT-COUNT

누가 얼마나 커밋했는지 보여준다:

```sh
$ git config --global alias.count "shortlog -sn"
```

![git-shortlog-sn](/articles/2012/git-secrets/git-shortlog-sn.png)

#### SCRIPT: GIT-CREDIT

가장 마지막 커밋 author 정보를 바꿀일은 종종 생긴다. 실수일 수도 있고 아닐 수도 있지만 뭐 어찌됐건 최근 커밋의 author를 마음대로 바꾸고 싶을 때가 있다. 다음과 같이 config에 등록한다:

```sh
#!/bin/sh

git commit --amend --author "$1 <$2>" -C HEAD
```

`git credit "Zach Holman" zach@example.com`이라고 실행하면 최근 커밋의 author 정보가 변경된다.

@holman님은 @holman님의 [dotfile](https://github.com/holman/dotfiles/tree/master/bin) 프로젝트에 가면 @holman님이 사용하는 `git-credit` 스크립트가 있다.

#### Octocat

이 슬라이드로 옥토캣은 다리가 4개고 꼬리가 1개라는 비밀을 알게 됐다. 맨날 보는 그림이지만 문어니까 그냥 다리가 8개라고 생각했었다.

![octocat](/articles/2012/git-secrets/pusheencat.png)

