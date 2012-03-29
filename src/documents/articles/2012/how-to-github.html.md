--- yaml
layout: 'article'
title: 'GitHub로 남의 프로젝트에 감놔라 배놔라: Fork, Branch, Track, Squash, Pull Request'
author: 'Sean Lee'
date: '2012-4-1'
tags: ['Git', 'Github', 'Fork', 'Branch', 'Pull Request', '깃헙', '기여', '프로젝트', '오픈소스', 'OpenSource']
---

[GitHub][]를 사용하여 오픈소스 프로젝트에 어떻게 참여할 수 있는 방법을 정리한다. GitHub에 계정이 있어야 하고 [Git][]을 어느정도 써 본 사람이어야 한다. 

_원문은 [Rich Jones][rich]의 [How to GitHub: Fork, Branch, Track, Squash and Pull Request][source] 이다._

[Git]: http://git-scm.org/
[GitHub]: http://github.com/
[source]: http://gun.io/blog/how-to-github-fork-branch-and-pull-request/
[rich]: http://gun.io/

## 저자 공지사항

[GitHub][]에서 활동하는 개발자 중 저자의 [구인구직 사이트](http://gun.io/contracts/new/)에 등록하면 구직하는 사람과 연결해준다고 한다. 관심있는 사람은 둘러보시길!

## 자 시작!

[GitHub][]에서 저장소를 새로 하나 만들면 아래와 같은 설명을 보여준다.

(그림)

GitHub은 새로운 프로젝트와 새로운 저장소를 만들었을 경우에 대한 설명은 친절하게 해주고 있다. 하지만 다른 프로젝트를 개선하고 참여하는 방법에 대해서는 그다지 좋은 설명을 해주고 있지 않다. 이 글은 그러한 점에서 도움이 될 것이다.

우선 시작하기 전에 고쳐보고 싶은 프로젝트를 하나 골라보자. GitHub에서 프로젝트를 찾아서 코드도 둘러보고 익숙한 개발방식을 갖고 있는지 확인도 해보고 커밋 로그도 살펴보고 참여하는 사람이 어떤 사람인지도 살펴들 보자.

## 네트워크

(그림)

네트워크 그림이다. 'mobile' 이라는 브랜치에서 누군가 열심히 작업을 하고 있기 때문에 'mobile'에 대한 일을 하는 수고는 하지 않는것이 좋을듯 하다.

우선 해야할 일은 프로젝트의 네트워크를 확인해보는 것이다. 네트워크를 확인함으로서 누가 어떤일을 하고 있는지를 살펴볼 수 있다. 네트워크를 한참 들여다보면 고쳐보고자 하던 부분도 이미 다른이가 하고 있는지 알수도 있다. 프로젝트 활동상황도 알 수 있으며 고친 부분이 어떻게 프로젝트에 Merge되는지도 알 수 있다.

## 이슈 등록

(그림)

이슈가 있네!

프로젝트 화면에서 이슈메뉴로 가 봅시다. 얼마나 많은 이슈가 있는지 그리고 내가 고쳐보고픈 부분이 이미 이슈로 등록이 되어있는지 알 수 있다.

This is an important step that many people forget about, and they just submit major pull requests to maintainers without considering that the maintainers might not have the same intentions with the software as they do. This is especially true if a new feature requires user interface/design changes, as often, that's the aspect of programs that people are the most protective of.

TODO: (다시 읽고 개선) 많은 사람들이 잊기 쉬운 이 과정이 왜 중요하냐면 고친점을 보내는 사람들은 보통 프로젝트의 관리자 즉 메인테이너가 같은 문제로 고민중이라는 점을 전혀 고려하지 않기 때문이다.

고쳐볼 부분이 아직 이슈로 등록이 안되어있다면 새로 하나 등록하자. 이슈를 등록할때는 메인테이너에게 공손히 프로젝트에 감사하다는 마음을 갖고 고쳐보고자 하는 버그나 개선사항을 적는거다.

메인테이너가 만들어진 이슈에 대한 댓글로 도움이 될 만한 점을 달아줄지도 모른다.

## Fork로 저장소 분리

'Fork' 버튼을 누르는 희열!! 복제된 저장소가 내 가슴속으로 들어왔다. 나의 복제된 저장소 페이지로 가보라! Clone해서 내려받을 수 있는 주소가 적혀있을 것이다. 바로 그냥 내려받는거다.

	git clone **your ssh/git url**

## Fork로 만든 저장소와 원본 저장소 연결

(그림)

Fork가 이거냥!

이 과정이 꼭 필요한건 아니다. 하지만 단 한번만 이 프로젝트에 참여할 것이 아니라면 이 과정을 해두면 정말 쓸모있다. 아래 명령을 실행하여 원래 프로젝트 저장소를 'upstream'으로 등록해두면 원래 프로젝트의 변경사항을 계속 받아볼 수 있다. 'upstreamname'과 'projectname' 부분을 실제 프로젝트에 맞게 적당히 바꿔서 명령을 실행한다.

	git remote add --track master upstream git://github.com/upstreamname/projectname.git

자 이렇게 하면 `upstream` 이라는 리모트로 등록이 된다.

	git fetch upstream

이렇게 하면 원래 프로젝트의 최신 내용을 받아오고

	git merge upstream/master

이렇게 하면 최신 내용을 현재 작업하고 있는 브랜치에 Merge하게 된다. 짜잔!

## 개발용 브랜치

## Hack!

## 커밋 하나로 합치기

## Pull Request 보내기

## Pull Request 받아서 Merge하기

## Pull Request를 받아주지 않는 이유

## 정리