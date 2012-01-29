--- yaml
layout: 'article'
title: 'Git: Remote Tracking Branch vs Tracking Branch'
author: 'Changwoo Park'
date: '2012-3-3'
tags: ['Git', 'Tracking Branch', 'Remote Tracking Branch']
---

Tracking 브랜치와 Remote Tracking 브랜치는 조금 애매하다. `Tracking 브랜치` 개념은 잘 이용하지 않기 때문에 돌아서면 잊어버린다. 그래서 정리했다. 구분하고 있지 않아도 Git을 사용하는데 불편할 거라고는 생각하지 않지만, 그래도 궁금하다.

![stalker](/articles/2012/git-tracking-vs-remote-tracking/sensei.jpeg)

(절망선생)

## Remote Tracking 브랜치

Remote Tracking 브랜치는 `origin/master`와 같은 브랜치를 말한다. 이 브랜치는 origin 저장소에 있는 master 브랜치가 가리키는 커밋을 그대로 가리키는 브랜치이다. 리모트 저장소의 브랜치를 Fetch해 오면 이 브랜치가 업데이트된다.

Remote Tracking 브랜치는 다음과 같은 특징이 있다.

 * 이 브랜치는 사용자가 임의로 수정할 수 없다.
 * `git fetch`, `git pull` 명령으로만 업데이트할 수 있다.

## Tracking 브랜치

Tracking 브랜치는 Remote Tracking 브랜치(이하 리모트 브랜치)보다 복잡하지만 그렇다고 어려운 것도 아니다.

Tracking 브랜치는 로컬 브랜치이다. 로컬 브랜치 중에서 리모트 브랜치를 Tracking하는 브랜치다.

Tracking 특징 다음과 같다:

 * 이 브랜치는 사용자가 임의로 수정할 수 있다.
 * `git fetch`로 정보가 업데이트되지 않는다. `git fetch`는 단지 리모트 저장소의 브랜치를 Tracking하는 Remote Tracking 브랜치만 만든다.

Tracking 브랜치는 도우미 같은 것으로 생각하면 된다. 몰라도 크게 불편하지 않다.

### Tracking 브랜치 확인

`git clone` 명령은 리모트 저장소를 Fetch하고 나서 master 브랜치를 만들고 Checkout 해준다. 이때 master 브랜치를 origin/master 브랜치를 Tracking하도록 만든다.

`git clone` 명령으로 저장소를 만들고 `git config -l` 명령을 실행하면 다음과 같은 설정이 들어가 있다:

	branch.master.remote=origin
	branch.master.merge=refs/heads/master

### Tracking 브랜치 만들기

Tracking 브랜치는 설정에 이런 정보를 가지고 있다. Tracking 브랜치는 만드는 게 간단하다. 리모트 브랜치에서 브랜치를 만들면 된다.

	git br tracking origin/master
	git co -b tracking origin/master

하지만, 로컬 브랜치에서 만들면 Tracking 브랜치가 되지 않는다:

	git br tracking master
	git co -b tracking master

이미 만든 브랜치를 Tracking 브랜치로 만들 수도 있다:

	git branch --set-upstream master origin/master

### 쓰임새

Tracking 브랜치 정보는 로컬 브랜치와 리모트 브랜치 사이의 연결 정보이고 설정에 저장된다. Git은 이 정보를 이용해서 몇 가지 정보를 제공한다.

#### git branch -v

Tracking 브랜치의 경우 리모트 브랜치와 거리가 얼마나 되는지(다른 커밋 개수를) 보여준다:

	$ git branch -v
	feature/kitchen e054c7e [ahead 1, behind 1] Add sink unit
	* ship            2d45d4c Add test

`[ahead 1]`은 feature/kitchen은 origin/feature/kitchen에 없는 커밋이 하나 있다는 것이고 [behind 1]은 feature/kitchen은 origin/feature/kitchen에 있는 커밋 하나가 없다는 것이다.

#### git checkout

`git checkout`도 브랜치가 Tracking 브랜치이면 얼마나 다른지 보여준다.

	$ git checkout feature/kitchen 
	Switched to branch 'feature/kitchen'
	Your branch and 'origin/ship' have diverged,
	and have 1 and 1 different commit(s) each, respectively.

#### git pull

Tracking 브랜치를 Checkout한 상태에서 `git pull` 명령을 실행하면 현재 Checkout과 연결된 리모트 저장소와 브랜치를 설정에서 찾아서 Fetch하고 현 브랜치에 Merge한다.

Tracking 브랜치가 아니면 `git pull`을 할 수 없다. 그러니까 `git pull`을 하려면 Tracking 브랜치를 Checkout하고 있어야 한다.

#### git push

`git push`라고 실행하면 Checkout한 브랜치와 상관없이 Tracking 브랜치를 모두 Push한다. `git push origin master`는 Tracking 브랜치와 상관없이 master 브랜치를 origin/master로 Push한다.

## 끝으로...

자동으로 Merge하는 방식은 아름다운 히스토리를 해칠 수 있다. 히스토리는 가능한 평평하게 펴줘야 하고 여러 커밋을 묶어서 관리할 필요가 있을 때만 Merge 커밋을 히스토리에 남기는 것이 좋다.

물론 `git pull` 명령도 --rebase, --ff, --no-ff, --ff-only와 같은 옵션이 있고 의도대로 Merge하지 못해도 복구할 수 있지만, Fetch하고 확인하고서 Merge하는 것이 아직 마음이 더 편하다.

`git pull` 명령은 어떨 때 유용한 걸까?

저장소와 모든 브랜치를 동기화하는 기능이 필요하긴 하다. 복잡하게 Tracking 브랜치에 따른 것이 아니라 걍 이름으로 했으면 좋겠는데..

