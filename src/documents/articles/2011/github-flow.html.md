--- yaml
layout: 'article'
title: 'GitHub Flow'
author: 'Changwoo Park'
date: '2011-12-22'
tags: ['git', 'github', 'scott chacon']
---

_이 글은 GitHub의 CIO인 [Scott Chacon][]님의 [github-flow][]를 정리한 글입니다. Chacon님은 [git-flow][]가 정리한 것처럼 github를 개발하는 데 사용하는 flow를 정했습니다._

Chacon님은 git-flow도 좋지만 Github는 명확히 Release라고 부를 만한 시점이 없어서 git-flow를 사용하지 않는다고 한다. 그 외 세세한 차이점도 거론하긴 했지만 생략한다. Release가 분명하지 않은 경우엔 확실히 git-flow를 적용하기 어렵다.

![love github](/articles/2011/github-flow/contact-github.png)

이 글은 그냥 요약한 것이다. 그림이 첨부된 자세한 설명은 [원문][github-flow]를 참고하라.

## GitHub Flow

이 Flow는 간단하지만, 꽤 큰 규모의 팀(Github 직원이 35명, 그중 15-20 명이 같은 프로젝트를 진행함)에서도 굉장히 좋다.

### master 브랜치에만 정해진 규칙이 있다.

반드시 규칙을 지켜야 하는 브랜치는 master뿐이다. 다른 브랜치는 임기응변식으로 운영하는 것 같다. 

master 브랜치에 Merge하면 이미 deploy했거나 곧 deploy된다는 의미다.

master 브랜치는 안정 버전을 의미하므로 Merge하기 전에 충분히 테스트해야 한다.

테스트는 로컬에서 하는 것이 아니라 브랜치를 Push하고 Jenkins로 테스트한다.

deployed 같은 브랜치를 만들어 deploy한 커밋을 관리할 수도 있지만 GitHub는 해당 SHA 값을 직접 관리하고(webapp이나 curl로) 나중에 비교할 때 사용한다.

### 브랜치는 항상 master 브랜치에서 만든다.

`git checkout -b mine master` 처럼 master 브랜치에서 만든다. 

### 이름을 잘 짓는다.

이름은 무슨 브랜치인지 나타나도록 브랜치 이름을 잘 짓는다(예) new-oauth2-scopes, redis2-transition). 그래서 브랜치 목록만 보더라도 곧 어떤 feature가 추가될지 알 수 있다.

### named 브랜치는 자주 Push한다.

git-flow의 feature 브랜치 쯤 되는 거라고 보면 된다. 위에서 얘기했듯이 브랜치 이름을 잘 짓고 자주 Push한다.

자주 Push해야 하는 이유는 자신이 무엇을 하고 있는지 동료들과 공유하는 것이고 누군가 `git fetch`를 실행하면 백업도 된다.

### 언제든지 Pull Request한다.

Merge할 때만 하는 것이 아니라 도움이나 피드백이 필요할 때에도 Pull Request를 사용한다. 제목에 '도움이 필요해요', '검토 좀 해주세요.', '머지해도 됩니다'라고 구분한다.

`@metion`으로 쉽게 다른 사람에게 검토를 요청할 수도 있다. 특히 Pull Request는 브랜치를 두고 토론하는 것으로 브랜치 히스토리가 업데이트되면 그 최신정보도 자동으로 포함된다. 

나는 이 글을 읽기 전에 Pull Request로 피드백을 요청한다는 것은 상상도 못했다.

### Pull Request로 리뷰한 후에만 Merge한다.

사람들이 '좋다' 등으로 리뷰해주면 그때 가서 Merge한다. 물론 CI도 통과해야 한다. Push하면 자동으로 Pull Request가 닫힌다.

### 일단 `master`에 Merge하면 바로 deploy한다.

hubot으로 deploy한다. 

GitHub는 최근 Kenkins + Hubot + Github를 묶은 [Janky][]를 공개했다.

[Scott Chacon]: https://github.com/schacon
[github-flow]: http://scottchacon.com/2011/08/31/github-flow.html
[Janky]: https://github.com/blog/1013-janky
