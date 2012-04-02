--- yaml
layout: 'article'
title: 'Git: git-svn'
author: 'Changwoo Park'
date: '2012-4-29'
tags: ['git', 'svn']
---

Progit 8장에 설명된 'git-svn'에서 쓸만한 명령어를 정리했다. svn server + git client 같이 오묘한 조합은 사용하고 싶지 않았는데, 너무 불편해서 못살겠다.

![et](/articles/2012/git-svn/et.jpg)

GitHub는 [git server + hg client][hg-git], [git server + svn client][svn-git] 조합도 만들었는데 쓰는 사람이 있을까?

## 주요 명령어 정리

SVN 처럼 로그를 보거나 등등의 기능이 많지만, 어차피 안 쓸 것 같아서 정리하지 않는다. SVN을 Git으로 마이그레이션할 때 필요한 명령어도 정리하지 않았다.

### clone:

    git svn clone url -s

-s는 표준레이아웃인 `trunk, branches, tags`를 사용한다는 의미다. 표준레이아웃을 사용하지 않으면 `-T trunk -b branches -t tags`라고 직접 알려주면 된다.

trunk, branches, tags는 모두 Git 브랜치로 만들어진다. trunk와 branches는 같은 이름으로 만들어지지만, tags는 앞에 `tags/`라고 붙는다.

progit 책에 나오는 `http://progit-example.googlecode.com/svn/`을 적용해보면 다음과 같이 만들어진다:

    └─▪ git br -av
    * master                        5925d95 Support HP C++ on Tru64.
      remotes/my-calc-branch        a52ad75 created a branch
      remotes/tags/2.0.2            fd8e73e Tag release 2.0.2.
      remotes/tags/release-2.0.1    60feb5c Tag the 2.0.1 release.
      remotes/tags/release-2.0.2    85bac46 Set version to 2.0.2 in release branch.
      remotes/tags/release-2.0.2rc1 168051e Update version number in 2.0.2rc1 release branch.
      remotes/trunk                 5925d95 Support HP C++ on Tru64

SVN 브랜치는 당연히 Git 브랜치로 만들어지지만 SVN의 tag도 Git의 브랜치로 만들어진다.

### fetch:

`git fetch`에 대응되는 명령어:

    git svn fetch

trunk가 master로 자동으로 Fast-Forward Merge 됐으면 좋겠다. 

`git-svn` 프로젝트이면 trunk를 master로 Fast-Forware Merge하도록 [git-ff][]를 수정했다. 이 브랜치만 Merge한다. svn에서 브랜치를 쓰고 싶지 않다.

### push:

`git push`에 대응하는 명령어:

    git svn dcommit

svn은 히스토리가 평평하니까 이것만 주의하면 된다.

### annotate:

어떤 놈이 잘못 고쳤는지 찾아보는 명령어:

    git svn blame [FILE] 

### .gitignore:

`.gitignore`를 만들어 넣으면 svn 서버에 Push된다. 다른 사람 몰래 혼자 쓰고 싶으면 `.git/info/exclude`에 만들면된다. `.gitignore`랑 똑같고 해당 저장소에만 적용되며 Push할 수 없다:

    git svn show-ignore > .git/info/exclude

## Merge

SVN의 히스토리는 항상 일직선이기 때문에 SVN에 Push할 브랜치는 항상 Fast-Forward로 Merge해야 한다. 그렇지 않으면 알아서 펴주기 때문에 히스토리 모양이 원하는 모양이랑 다를 수 있다.

## 브랜치

SVN의 히스토리는 항상 평평하다. 브랜치 별로 히스토리가 다르게 관리하는 것이 아니라 한 히스토리에서 trunk. branches, tags를 모두 관리한다. 이점을 꼭 기억해야 한다.

SVN 브랜치는 항상 Long-Running 브랜치로 사용한다. Topic 브랜치는 git-svn이 아니라 그냥 git을 사용할 때와 다를 바 없다. 단지 SVN 브랜치를 Tracking하는 Long-Running 브랜치에 Merge할 때 쫙 펴주기만 하면 된다.

문제는 SVN 브랜치를 Git에서 서로 Merge하는 데 있다. 그냥 Fetch해서 평평한 히스토리를 유지하면서 Push하는 것이 아니라 SVN 브랜치를 Git에서 Merge하면 어떨까? 이제 이걸 알아보자.

### 일단 SVN 저장소를 하나 준비하고

일단 SVN 저장소를 하나 준비하고:

![svn-repository.png](/articles/2012/git-svn/svn-repository.png)

Git으로 클론한다. 클론하고 나서 `git branch -av`를 하면 다음과 같다:

    * master             92a713a from trunk
      remotes/dogfeet    e5334ef Add from dogfeet
      remotes/tags/1.0.0 2ec86a0 tag 1.0.0
      remotes/trunk      92a713a from trunk

master는 remotes/trunk를 트랙킹하고 SVN 브랜치인 'dogfeet'과 SVN 태그인 '1.0.0'이 Git에서는 모두 브랜치로 만들어진다. 그리고 원래 리모트 트래킹 브랜치는 `remotes/origin/master` 같은 패턴으로 이름 지어지는데 리모트 없이 `remotes/trunk` 형식으로 이름 지어진다.

SVN 히스토리:

![history.png](/articles/2012/git-svn/history.png)

master 히스토리:

    * 92a713a - (HEAD, trunk, master) from trunk (2 hours ago)
    * 12bf5f1 - Initial structure. (2 hours ago)

dogfeet 히스토리:

    * e5334ef - (dogfeet) Add from dogfeet (2 hours ago)
    * 86cdd49 - branch dogfeet (2 hours ago)
    * 92a713a - (HEAD, trunk, master) from trunk (2 hours ago)
    * 12bf5f1 - Initial structure. (2 hours ago)

### 이제 Git에서 커밋을 하나씩하고

master에 커밋을 하나 하고:

    * 4c549fb - (master) Add from_git_master (4 minutes ago)
    * 92a713a - (trunk) from trunk (23 hours ago)
    * 12bf5f1 - Initial structure. (23 hours ago)

dogfeet에도 커밋을 하나 하고:

    * 904a4c0 - (HEAD, local_dogfeet) Add from_git_dogfeet (70 seconds ago)
    * e5334ef - (dogfeet) Add from dogfeet (23 hours ago)
    * 86cdd49 - branch dogfeet (23 hours ago)
    * 92a713a - (trunk) from trunk (23 hours ago)
    * 12bf5f1 - Initial structure. (23 hours ago)

dogfeet을 master에 Merge한다:

    *   8365b59 - (HEAD, master) Merge branch 'local_dogfeet' (2 seconds ago)
    |\  
    | * 904a4c0 - (local_dogfeet) Add from_git_dogfeet (2 minutes ago)
    | * e5334ef - (dogfeet) Add from dogfeet (23 hours ago)
    | * 86cdd49 - branch dogfeet (23 hours ago)
    * | 4c549fb - Add from_git_master (5 minutes ago)
    |/  
    * 92a713a - (trunk) from trunk (23 hours ago)
    * 12bf5f1 - Initial structure. (23 hours ago)

이걸 SVN에 Push하면 SVN 히스토리는 다음과 같아진다:

![history-after-merge.png](/articles/2012/git-svn/history-after-merge.png)

그러니까 이렇게 Merge 커밋이 있는 히스토리를 SVN에 Push하면 히스토리가 순서가 보장되지 않는다. 히스토리 순서를 보장하려면 Fast-Forward Merge로 펴놓고 Push해야 한다.

그렇다고 Rebase를 해서 Fast-Forward Merge를 하면 같은 커밋이 두 번 들어가게 될 수도 있으니 절대로 SVN에 올라간 커밋은 Rebase하면 안된다. 그러니까 SVN에 Push한 커밋을 Rebase할 바엔 그냥 Merge Commit을 남기는 게 낫다고 볼 수 있다.

### 브랜치 결론.

SVN 세상에서는 히스트리가 항상 평평하고 브랜치도 디렉토리로 관리한다. 그러니까 이점을 명확히 이해하고 있어야 혼란스럽지 않다.

SVN의 브랜치를 Git에서 Merge하는 것은 사실 조금 위험하다. Merge Commit 있는 Git 히스토리를 SVN에 Push하면 커밋 순서는 보장되지 않을 것이고 그렇다고 SVN에 이미 커밋된 것을 Rebase할 수도 없다. 하지만 Topic 브랜치를 만들어 작업하고 히스토리를 평평하게 펴서 SVN에 Push하면 쓸만하다.

그리고 SVN 히스토리가 망가질 수 있다는 단점은 지나친 기우일 수 있다. 오픈 소스 프로젝트라면 히스토리를 더럽히는 것이 당연히 부끄럽겠지만, 원래 커밋 메시지도 없는 히스토리라면 그냥 커밋 몇 개 더 만들어도 괜찮지 않을까? 취미로 하는 프로젝트를 빼고 난 아직 한번도 히스토리에 정성을 쏳는(이라고 쓰고 커밋 메시지를 잘 남기는 이라고 읽는다) 프로젝트를 해보지 못했다.

[git-ff]: https://github.com/pismute/git-tles
[hg-git]: http://hg-git.github.com/
[svn-git]: https://github.com/blog/966-improved-subversion-client-support

