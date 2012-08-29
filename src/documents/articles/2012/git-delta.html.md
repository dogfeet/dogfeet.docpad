--- yaml
layout: 'article'
title: 'Git: 델타와 스냅샷'
author: 'Changwoo Park'
date: '2012-8-25'
tags: ['git', 'delta', 'diff', 'patch']
---

우리가 커밋을 하면 그 시점의 스냅샷을 저장하는 것이고 두 시점의 스냅샷을 비교하면 델타를 얻을 수 있다. VCS는 스냅샷이나 델타를 저장하고 누가, 언제, 왜 저장했는지 등을 추적하고 관리하는 시스템이다. 실제로 저장할 때도 스냅샷을 저장하는 시스템도 있고(SVN, git) 델타를 저장하는 시스템도 있다(git, hg). 이 글은 델타 관점으로 git을 설명하고자 작성했다. 특정 시점을 의미하는 델타와 스냅샷을 두고 git이 어떻게 저장하는지 살펴보고, 델타를 구해서 적용하는 것으로 Merge/Rebase 명령어를 설명해보고자 한다.

![](/articles/2012/git-delta/crime-and-sin.jpeg)


## 델타

옛날 옛적에 리눅스 커널을 직접 빌드해야 했던 시절, 돈이 없어 샀던 싸구려 하드웨어 덕에 patch 파일을 받아서 직접 패치해야 했었다. diff와 patch 의 의미, 사용하는 이유 등을 이해한 것은 나중이었지만 내가 처음 접한 것은 그때였다.

과거에는 오픈소스 프로젝트를 [diff와 patch][diff-patch]로 개발했다. 코드를 수정하고 diff 프로그램으로 델타를 만들어서 메일로 보내면 관리자는 그 델타를 받아서 patch 프로그램으로 메인 코드에 적용했다. 비교할 수는 없지만, 선구자들은 우리가 git과 github을 통해서 하는 일들을 [diff와 patch][diff-patch], 메일, 웹, ftp 같은 것으로 해냈다.

리누스 토발즈는 오랫동안 그렇게 일해 왔고 그 경험을 살려 Git을 만들었다. 이제는 Git(Mercurial, SVN, 등등) 덕에 많은 것이 자동화됐다.

코드를 수정해서 github나 어딘가에 올리고 알려주면 그대로 가져가 적용할 수 있다. 메일로 보내는 방법도 아직 유효하고 git-am 같이 mailbox를 이용하는 Command가 내장돼 있어 더욱 편리하다.

다음 그림은 [Visual Git Guide][1]의 그림으로 `git diff` 명령을 설명하는 그림이다. VCS 없이 델타를 구할 생각을 하면 정말 끔찍하다. VCS 없이 코드를 공유했던 사람들은 정말 존경스럽다.

![git-diff](/articles/2012/git-delta/git-diff.png)[1][]

## Git의 저장 방식

히스토리는 개념적으로 스냅샷의 연속이자 델타의 연속이기도 하다. Git은 각 시점의 스냅샷을 저장하기도 하지만 그 스냅샷 사이의 델타를 저장하기도 한다.

커밋을 하면 그 시점의 스냅샷이 저장되는 것이고 그 커밋과 부모의 커밋을 비교(diff)하면 델타를 얻을 수 있다. 커밋은 영구적으로 저장하는 것이기 때문에 언제든지 Checkout해서 그 시점의 스냅샷을 얻을 수 있고 비교해서(diff) 델타를 얻을 수도 있다.

우리가 커밋을 하면 Git은 기본적으로 스냅샷을 저장한다. 이 말의 뜻은 snapshot.txt 파일을 처음 커밋하면 rev1에 snapshot.txt 파일이 저장된다. 그리고 그 파일을 수정해서 다시 커밋하면 rev2가 저장된다. 이때 rev2에 수정한 파일이 통째로 저장된다. `.git` 저장소에 rev1 때의 snapshot.txt 파일과 rev2 때의 snapshot.txt 파일이 통째로 저장된다.

이것을 그림으로 표현하면 다음과 같다:

![git-snapshot](/articles/2012/git-delta/git-snapshot.png)

이 방식으로 저장하면 1k 짜리를 한 글자씩 고쳐서 10번 수정하면 10k가 된다. Git은 처음에는 성능과 편리성을 위해 이 방식으로 저장하고 적절한 시점에 GC(Garbage Collection)가 실행되면 다음과 같이 저장한다:

![git-delta](/articles/2012/git-delta/git-delta.png)

마지막 버전의 파일 하나만 통째로 저장하고 이전 버전들은 델타(diff 파일)를 저장한다. 이 그림에서 rev6를 요구하면 rev6의 파일을 그대로 반환한다. 하지만, rev4를 요구하면 rev6 파일에 rev5, rev4의 델타를 적용해서 반환한다.

마지막 버전의 파일이 스냅샷인 이유는 우리가 질의하는 파일은 대부분 마지막 버전의 파일이기 때문이다. 평소에는 델타를 적용할 필요가 없어서 빠르다. Git을 정말 꼼꼼하게 설계했음을 보여주는 대목이다.

이렇게 저장하기 때문에 1k 짜리를 한 글자씩 10번 수정해서 커밋해도 거의 1k이다. GC가 수행되면 이렇게 델타로 저장할 뿐만 아니라 gzip으로 압축하기 때문에 실제로 저장하는 용량은 더욱 적다. Git은 이런 기법을 통해서 '[저장소 크기가 가장 작다](http://pismute.github.com/whygitisbetter)'라고 주장한다.

우리가 종종 Git과 비교하는 Mercurial도 델타로 저장한다. 다음 그림은 Mercurial이 저장하는 방식이다:

![mercurial-delta](/articles/2012/git-delta/mercurial-delta.png)

Mercurial은 처음에 스냅샷을 저장하고 그다음 버전부터는 델타를 저장한다. 그래서 최신 버전의 파일이 요구하면 첫 스냅샷 파일과 최근까지의 델타를 적용해서 반환한다[2][].

## 델타의 적용: Merge, Rebase, Cherry-pick, ...

Git의 그 수 많은 명령어는 우리가 과거에 수동으로 했던 diff & patch 작업을 자동/반자동으로 해주는 것이라고 이해할 수 있다.

**Merge**:

Branch를 만들면 Merge Base를 자동으로 기록했다가 나중에 Merge를 하면 두 스냅샷을 기준으로 diff 프로그램을 이용해서 델타를 만들고 한쪽 브랜치에 patch 프로그램으로 적용하는 것과 같다. Merge는 이런 과정이고 Git의 Merge는 그동안 수동으로 했었어야 했던 일을 자동으로 해준다.

![git-merge](/articles/2012/git-delta/git-merge.png)[1][]

SVN의 Merge도 결국 이런 것인데 SVN의 경우는 Merge Base를 자동으로 기록해주지 않아서 사람이 수동으로 메모했다가 Merge해야 하고 2-way Merge와 3-way Merge의 차이도 있다.

**Rebase**:

Rebase는 Merge와 비슷하다. 델타를 만들어 적용하는 것은 같지만 히스토리를 구성하는 게 다르다. Merge 커밋을 만드는 것이 아니라 한쪽 브랜치를 `base`로 만든다. 커밋 순서를 배열한다고 생각하면 된다.

![git-rebase](/articles/2012/git-delta/git-rebase.png)[1][]

**Cherry-pick**:

Cherry-pick은 특정 커밋과 그 커밋의 부모와의 델타를 구해서(그러니까 해당 커밋의 델타만) 현 브랜치에 적용하는 것이다. 고른 커밋 하나에 대해서만 Rebase하는 것이다:

![git-cherry-pick](/articles/2012/git-delta/git-cherry-pick.png)[1][]


[1]: http://marklodato.github.com/visual-git-guide/index-ko.html
[2]: http://pycon-hg-git.heroku.com/
[diff-patch]: http://kldp.org/node/28938
