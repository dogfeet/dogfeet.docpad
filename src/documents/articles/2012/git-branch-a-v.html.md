--- yaml
layout: 'article'
title: 'Git:branch-a-v'
author: 'Changwoo Park'
date: '2012-01-14'
tags: ['Git', 'Todo', 'Remote Tracking Branch', 'Branch']
---

Git을 사용하면서 규모가 작은 프로젝트를 많이 만들게 됐다. 예제를 만들거나, 간단한 도구를 만들거나 버전관리가 필요하면 언제든지 Git 저장소를 만들어 사용한다. 몇 일만 잊었다가 다시 돌아오면 어디까지 작업했는지 헷갈린다. 이 때 `git branch -a -v` 명령은 현 저장소 상태를 알아 보는데 좋다.

![todo.ly](/articles/2012/git-todo/todoly.png)

(todo.ly은 본 글과 아무 상관없다.)

## git branch -a -v

Git을 사용하면서 가장 많이 사용하는 명령어 중 하나가 `git branch -a -v`이다. Fetch한 원격 브랜치를 포함해서 모든 브랜치 목록을 볼 수 있을 뿐만 아니라 각 브랜치의 마지막 커밋 정보도 보여준다. 그뿐만 아니라 해당 브랜치가 Remote Tracking 브랜치이면 Tracking 브랜치에서 얼마나 멀어졌는지도 보여준다.

merge를 설명할 때 사용했던 ship 저장소를 다시 살펴보자. 이 저장소를 clone하고 `git branch -a -v`를 실행한다:

	$ git branch -a -v
	ship                             3f129b5 Fix anchor
	remotes/origin/ship              3f129b5 Fix anchor

`-a`의 는 원격 브랜치를 포함한 모든 브랜치를 보여준다. 그리고 `-v`는 해당 브랜치의 마지막 커밋을 보여준다.

'origin/ship'을 Tracking하는 'feature/kitchen'라는 브랜치를 만들고 싱크대를 추가한다:

	$ git co -b feature/kitchen origin/ship
	$ touch sink_unit
	$ git add sink_unit
	$ git commit
	[feature/kitchen e054c7e] Add sink unit
	 0 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 sink_unit

그리고 누군가 ship 브랜치에 커밋을 추가했다. 그래서 다시 Fetch를 하고 나서 `git branch -a -v`를 실행한다:

	feature/kitchen                  e054c7e [ahead 1, behind 1] Add sink unit
	ship                             3f129b5 [behind 1] Fix anchor
	remotes/origin/ship              3f129b5 Fix anchor

'feature/kitchen' 의 커밋 메시지에 'ahead 1'를 주목하자. 'ahead 1'은 이 브랜치가 Tracking하는 브랜치에서 커밋 1개만큼 멀어져 있다는 것을 보여준다. 'feature/kitchen'은 `git co -b feature/kitchen origin/ship` 명령으로 만들었다. 이렇게 만들면 'feature/kitchen'가 'origin/ship'을 Tracking하게 된다.

마찬가지로 'behind 1'은 'origin/sink' 브랜치가 'feature/kitchen' 브랜치보다 커밋을 하나 더 가졌다는 것이다. `git log feature/kitchen...origin/ship --left-right`을 실행하면 다음과 같다:

	$ git lg feature/kitchen...origin/ship --left-right
	> 2d45d4c - (origin/ship) Add test
	< e054c7e - (feature/kitchen) Add sink unit

`git branch`의 `-v` 옵션은 Remote Tracking 브랜치의 경우 두 브랜치 사이가 얼마나 멀어졌는지도 함께 보여준다.

## Remote Tracking 브랜치

Remote Tracking 브랜치의 경우 '[ahead 1, behind 1]' 처럼 얼마나 멀어졌는지 알려준다고 했는데 Remote Tracking 브랜치는 대체 뭐야?

Remote Tracking 브랜치는 브랜치가 특정 Remote 브랜치와 연결된 것을 말한다. 그 연결 정보가 있으면 명령어를 실행할때 정보를 생략할 수 있다. 그리고 주로 push/pull 명령과 관련돼 있다.

이 글에서는 push/pull과 관련된 방법을 알아보지 않을 거다. 난 자동으로 해주는 것보다 확인하고 Merge하는 것을 더 선호하기에 pull 명령 자체를 잘 쓰지 않는다. 그리고 push는 항상 명시적인 것이 좋다.

### 무엇이 Remote Tracking 브랜치일까?

이 정보는 config 파일에 저장하며(보통 .git/config에) 다음과 같이 생겼다.

	branch.feature/kitchen.remote=origin
	branch.feature/kitchen.merge=refs/heads/ship

'feature/kitchen'이 'origin/ship' 브랜치를 Tracking한다는 의미다.

그래서 `git config -l`로도 확인할 수 있지만, 별도의 명령이 있다. `git branch --track` 명령으로 Remote Tracking 브랜치가 무엇인지 확인할 수 있다.

	$ git branch --track
	feature/kitchen
	ship

### Remote Tracking 브랜치를 만들기

Remote Tracking 브랜치를 만드는 것은 간단하다. `git branch [new] [old]` 명령이나 `git co -b [new] [old]` 명령으로 만들 수 있다. 단 `[old]` 브랜치에 Remote 브랜치를 넣으면 된다.

이미 만든 브랜치를 Remote Tracking 브랜치로 만들 수도 있다. 기본적으로 설정을 '.git/config' 파일에 저장하기 때문에 'git config' 명령으로 지정해 줄 수 있다. 하지만, 전용 명령어가 있다:

	git branch --set-upstream [local] [remote]

### 어디에 좋나?

사실 잘 모르겠다. 잘 안 쓴다. Remote Tracking 브랜치를 만들긴 하지만 의도하고 만들어 본적 없다. 굳이 평하자면 'branch -a -v'에 좋다:)

#### git pull

`git pull`명령은 Remote Tracking 브랜치에만 사용할 수 있다. `git pull [remote] [branch]` 명령을 실행하면 [remote]/[branch]를 Fetch하고 자동으로 Merge한다.

`[remote]`와 `[branch]`를 생략할 수도 있는데 생략하면 현 브랜치의 정보를 사용한다.

## todo

나는 해당 프로젝트의 'todo' 목록을 별도로 관리하지 않고 그냥 토픽 브랜치로 만든다. 그리고 `git branch -a -v` 명령으로 관리한다. 나는 편의를 위해서 `todo`라는 alias를 만들어 사용한다:

	git config --global alias.todo "branch -a -v"

## 결론

`git branch -a -v` 명령은 하던 일을 뭔지 기억하는데 도움이 된다. 간단하게만 관리할 수 있다면 일을 하는 것과 계획을 관리하는 것을 한 몸으로 할 수 있다.

그리고 커밋 메시지가 정말 중요하다. 시간이 지나서 좀 잊어버리게 된다고 해도 다시 보면 바로 알 수 있어야 한다.

좀 더 개선된 형태가 필요하다. 왜 꼭 Remote 브랜치만 Tracking해야 하는 걸까? 사실 Local 브랜치를 Tracking하게 하고 싶다. 관련 브랜치도 함께 보여줄 수 없을까? 다른 색으로 보여줄 수는 없을까? 좀 더 인식하기 쉬운 형태였으면 좋겠다. 틈틈이 Git 플러그인을 만들자!

