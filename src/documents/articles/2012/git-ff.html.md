--- yaml
layout: 'article'
title: 'Git: git-ff'
author: 'Changwoo Park'
date: '2012-3-25'
tags: ['git', ‘git-tles’]
---

리모트 저장소와 내 저장소를 자주 동기화하고 싶은데 좋은 방법이 없을까? 'git pull'은 별로 맘에 들지 않는다. 전 쓴 '[Git: Remote Tracking Branch vs Tracking Branch][tracking-branch]'에서도 말했지만, Tracking 브랜치는 불편하다.

그래서 'git pull' 대신 사용할 수 있는 '[git ff][git-ff]'를 만들었다.

![git-ff-result](/articles/2011/git.png)

## git-ff 특징

### Dirty 체크

Working Directory의 상태가 Dirty가 아닐 때만 동작한다.

### 'git fetch --prune'

Fetch시 --prune 옵션을 주기 때문에 리모트에서 삭제된 브랜치가 있으면 로컬의 Remote Tracking Branch도 삭제한다.

### 이름으로 매칭하기.

원격 브랜치와 로컬 브랜치를 시스템이 연결해주는 것이 Tracking 브랜치인 건데, 이게 유용한 때도 있겠다. 아직은 모르겠지만….

그냥 이름으로 하는 게 알아보기도 쉽고 기억하기도 쉽다. 그래서 `origin/master`에 대응되는 로컬 브랜치는 `master`라고 간주한다.

### Fast-Foward Merge

리모트 저장소를 Fetch하고 로컬 브랜치가 있는지 확인한 다음에 Fast-Forward Merge가 가능한 브랜치가 있으면 자동으로 Merge한다.

### Rebase

리모트 브랜치가 수정됐지만, 로컬 브랜치도 수정됐다면 얘기가 달라진다. 그냥 Merge 하면 Merge Commit이 생긴다. 그래서 Rebase하고 나서 Fast-Forward Merge를 해야 한

이 기능도 넣고서 1달 정도 사용해봤는데, 큰 문제는 없었지만 영 찜찜해서 빼버렸다.

이 기능을 넣으려면 마음의 두려움부터 극복해야겠다.

## git-ff 사용법

'git ff'라고 실행하면 origin에서 Fetch한다:

    git ff [remote]

하지만, origin이 아니라 다른 저장소로도 작업해야 할 때도 왕왕 있다. 특히 origin이 메인 저장소가 아닐 때가 그렇다. 'git ff managers'라고 실행하면 managers 저장소에서 Fetch한다.

실행결과는 다음과 같다:

![git-ff-result](/articles/2012/git-ff/git-ff-result.png)

Fast-Forward Merge도 하지만 해당 저장소랑 Delta가 얼마나 되는지 한눈에 알 수 있다.

[git-ff]: https://github.com/dogfeet/git-tles/blob/master/git-ff
[tracking-branch]: http://dogfeet.github.com/articles/2012/git-tracking-vs-remote-tracking.html


