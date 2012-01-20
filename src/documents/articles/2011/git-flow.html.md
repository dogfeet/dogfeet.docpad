--- yaml
layout: 'article'
title: 'Git:git-flow'
author: 'Changwoo Park'
date: '2011-12-09'
tags: ['git', 'git-flow', 'Workflow']
---

[git-flow][]를 설명하는 글, [A successful git branching model][git-flow-post]을 먼저 읽어 보는 게 좋다. 저 글에 설명된 것을 쉽게 할 수 있도록 구현한 게 git-flow다.

이 글에서는 git-flow 명령어가 어떤 것인지 살펴본다.

![그림](/articles/2011/git-flow/branching_flow.png)

git-flow의 branching flow를 요약한 그림.

support 브랜치는 git-flow에 추가된 브랜치다. 아직 실험중인(experimental) 기능이다. support 브랜치는 이 글 끝 부분에 설명한다.

## git flow

git-flow 설치하고 `git flow`라고 실행하면 어떤 명령어들이 있는지 볼 수 있다:

    $ git flow
    usage: git flow <subcommand>

    Available subcommands are:
       init      Initialize a new git repo with support for the branching model.
       feature   Manage your feature branches.
       release   Manage your release branches.
       hotfix    Manage your hotfix branches.
       support   Manage your support branches.
       version   Shows version information.

    Try 'git flow <subcommand> help' for details.

### git flow init

먼저 branch 이름 규칙을 설정한다. `git flow init` 명령어를 실행하고 묻는 말에 답하면 된다.

설정은 `.git/config` 파일에 다음과 같이 저장된다. `git config -l`로도 확인할 수 있다.

    gitflow.branch.master=master
    gitflow.branch.develop=develop
    gitflow.prefix.feature=feature/
    gitflow.prefix.release=release/
    gitflow.prefix.hotfix=hotfix/
    gitflow.prefix.support=support/
    gitflow.prefix.versiontag=0.1

'master', 'develop', 'feature', 'release', 'hotfix' 브랜치가 무엇인지 설명하지 않는다. 이 것은 [A successful git branching model][git-flow-post]에 잘 설명돼 있다.

### feature

feature 명령어는 다음과 같다.

    $ git flow feature start
    Missing argument <name>
    usage: git flow feature [list] [-v]
           git flow feature start [-F] <name> [<base>]
           git flow feature finish [-rFk] <name|nameprefix>
           git flow feature publish <name>
           git flow feature track <name>
           git flow feature diff [<name|nameprefix>]
           git flow feature rebase [-i] [<name|nameprefix>]
           git flow feature checkout [<name|nameprefix>]
           git flow feature pull <remote> [<name>]

각 명령어는 다음과 같은 shortcut이다

#### git flow feature list

`feature/*` 브랜치들을 보여준다.

#### git flow feature start [base]

[base]으로 부터 브랜치를 만든다. [base]를 생략하면 develop에서 만든다.

`git flow feature start my-feature`라고 실행하면 develop 브랜치를 base로 `feature/my-feature`라는 브랜치가 만들어 진다. 이 명령은 다음과 같은 명령의 shortcut 이다:

    git checkout -b feature/my-feature develop

실제로 코드를 열어보면 몇 가지 점검하는 코드가 더 들어 있지만 핵심은 이렇다.

#### git flow feature finish

`git flow feature finish my-feature`라고 실행하면 my-feature 브랜치가 develop 브랜치에 merge된다. 이 명령은 다음과 같은 명령이다:

    git checkout develop
    git merge --no-ff feature/my-feature
    git branch -d feature/my-feature

`--no-ff` 옵션이 빠지는 경우도 있다. my-feature 브랜치에 추가된 커밋이 하나고 develop 브랜치가 fast-forward merge할 수 있으면 fast-forward된다. 그래서 커밋 하나로 정리할 수 있는 feature라면 하나로 정리하고 `finish`하면 develop 브랜치에 fast-forward merge할 수 있다.

다른 경우엔 `--no-ff` 옵션으로 merge한다.

#### git flow feature publish

해당 브랜치를 push한다. `git flow feature publish my-feature`라고 실행하면 `origin/feature/my-feature`로 push하는 것이고 실행되는 git 명령을 풀어보면 다음과 같다:

    git push origin feature/my-feature
    
    # configure remote tracking
    git config branch.feature/my-feature.remote origin
    git config branch.feature/my-feature.merge refs/heads/feature/my-feature
    git checkout feature/my-feature

#### git flow feature track

remote tracking branch를 새로 만든다. `git flow feature track my-feature`라는 것은 다음과 같이 실행한 것과 같다:

    git checkout -b feature/my-feature origin/feature/my-feature

#### git flow feature diff

develop 브랜치와의 merge-base 커밋을 찾아 그 차이를 비교한다. `git flow feature diff my-feature`라는 건 다음의 명령을 실행한 것과 같다:

    git diff $(git merge-base develop feature/my-feature)..feature/my-feature

merge-base는 두 브랜치의 공통 조상을 찾아 준다. merge할 때 어떤 브랜치를 기준으로 merge할지 보여주는 것이다. 예를 들어 히스토리가 다음과 같다고 하자:

![그림](/articles/2011/git-flow/example_history.png)

`git merge-base develop feature/1` 명령을 실행하면 4ae3845 커밋을 찾아 준다. 그리고 그 커밋을 기준으로 diff한다. 그러니까 이 예제에서 `git flow feature diff 1`이라고 실행하면 결국 다음과 같은 명령이 실행되는 것이다.

    git diff 4ae3845..feature/1

#### git flow feature rebase

`git flow feature rebase my-feature`라는 명령은 다음과 같다:

    git checkout feature/my-feature
    git rebase develop

#### git flow feature checkout

`git flow feature checkout my-feature`는 다음과 같다:

    git checkout feature/my-feature

#### git flow feature pull

`git flow feature pull my-feature`는 다음과 같다:

    git pull feature/my-feature

### release, hotfix

release, hotfix 명령어들도 feature와 비슷하다. [A successful git bfanching model][git-flow-post]에 설명된 방법에 따라 명령어들이 실행된다.

#### versiontag

release, hotfix 브랜치를 최종적으로 master로 merge하고 나서 tag를 만드는데, versiontag는 그 tag 이름 prefix이다. versiontag가 `1.`이라고 가정해보자.

`git flow release start 2.0` 명령을 실행해서 release 브랜치를 하나 만들어 작업을 하고 브랜치를 닫는다. `git flow release finish 2.0` 명령을 실행해서 release 작업으로 마치면 자동으로 annotated tag를 생성하게 된다. 이때 생성되는 tag 이름은 `1.2.0`가 된다. `1.`은 vertiontag prefix값에 의해서 생성된 것이다.

hotfix 브랜치도 똑같이 적용된다. 이미 `1.2.0`이라는 tag로 부터 branch를 만든다. hotfix 작업은 결국 버전을 올리게 만들기 때문에 hotfix 브랜치를 만들 때 이점에 유의한다.

`git flow hotfix start 2.1`이라고 만들고 finish하고 나면 `1.2.1`이라는 tag가 생성된다.

### support

support 브랜치는 저자의 글에 설명돼지 않았다. support 브랜치는 [git-flow][]의 실험적인 기능이다. support 브랜치는 새 버전으로 업그레이드하지 고객을 위해 만드는 브랜치다. 이 브랜치로 예전 버전에서 생기는 문제를 해결한다. 보통 그런 고객은 돈이 많다.

master 브랜치에 만들어둔 이전 버전의 tag를 base로 브랜치를 만든다. 예전 버전을 지원하기 위한 브랜치라 해당 버전을 가리키는 tag로 만든다.

## 참고

 * [A successful git bfanching model][git-flow-post]
 * [git-flow][]
 * [Getting started git-flow][getting-started-git-flow]
 * [Setting up git flow remote][getting-started-git-flow]

[git-flow-post]: http://dogfeet.github.com/articles/2011/a-successful-git-branching-model.html
[git-flow]: https://github.com/nvie/gitflow
[setting-up-git-flow-remote]: http://www.scottw.com/setting-up-git-flow-remote
[getting-started-git-flow]: http://yakiloo.com/getting-started-git-flow/
