--- yaml
layout: 'article'
title: 'GitHub로 남의 프로젝트에 감놓고 배놓기'
author: 'Sean Lee'
date: '2012-4-1'
tags: ['Git', 'Github', 'Pull Request', '깃헙', '오픈소스', 'OpenSource']
---

[GitHub][]를 사용하여 오픈소스 프로젝트에 어떻게 참여할 수 있는 방법을 정리한다. GitHub에 계정이 있어야 하고 [Git][]을 어느정도 써 본 사람이어야 한다. 

_원문은 [Rich Jones][rich]의 [How to GitHub: Fork, Branch, Track, Squash and Pull Request][source] 이다._

![gun.io](/articles/2012/how-to-github/banner_ul2.png)

[Git]: http://git-scm.org/
[GitHub]: http://github.com/
[source]: http://gun.io/blog/how-to-github-fork-branch-and-pull-request/
[rich]: http://gun.io/

## 저자 공지사항

[GitHub][]에서 활동하는 개발자 중 저자의 [구인구직 사이트](http://gun.io/contracts/new/)에 등록하면 구직하는 사람과 연결해준다고 한다. 관심있는 사람은 둘러보시길!

## 자 시작!

[GitHub][]에서 저장소를 새로 하나 만들면 아래와 같은 설명을 보여준다.

![GitHub](/articles/2012/how-to-github/LiEI3.png)

GitHub은 새로운 프로젝트와 새로운 저장소를 만들었을 경우에 대한 설명은 친절하게 해주고 있다. 하지만 다른 프로젝트를 개선하고 참여하는 방법에 대해서는 그다지 좋은 설명을 해주고 있지 않다. 이 글은 그러한 점에서 도움이 될 것이다.

우선 시작하기 전에 고쳐보고 싶은 프로젝트를 하나 골라보자. GitHub에서 프로젝트를 찾아서 코드도 둘러보고 익숙한 개발방식을 갖고 있는지 확인도 해보고 커밋 로그도 살펴보고 참여하는 사람이 어떤 사람인지도 살펴들 보자.

## 네트워크

![GitHub Network](/articles/2012/how-to-github/naZ6I.png)

네트워크 그림이다. 'mobile' 이라는 브랜치에서 누군가 열심히 작업을 하고 있기 때문에 'mobile'에 대한 일을 하는 수고는 하지 않는것이 좋을듯 하다.

우선 해야할 일은 프로젝트의 네트워크를 확인해보는 것이다. 네트워크를 확인함으로서 누가 어떤일을 하고 있는지를 살펴볼 수 있다. 네트워크를 한참 들여다보면 고쳐보고자 하던 부분도 이미 다른이가 하고 있는지 알수도 있다. 프로젝트 활동상황도 알 수 있으며 고친 부분이 어떻게 프로젝트에 Merge되는지도 알 수 있다.

## 이슈 등록

![GitHub Issue](/articles/2012/how-to-github/oksQI.png)
_이슈가 왔어요!_

프로젝트 화면에서 이슈메뉴로 가 봅시다. 얼마나 많은 이슈가 있는지 그리고 내가 고쳐보고픈 부분이 이미 이슈로 등록이 되어있는지 알 수 있다.

많은 사람들이 잊기 쉬운 이 과정이 왜 중요하냐면 고친점을 보내는 사람들은 보통 프로젝트의 관리자 즉 메인테이너가 같은 문제로 고민중이라는 점을 전혀 고려하지 않기 때문이다.

고쳐볼 부분이 아직 이슈로 등록이 안되어있다면 새로 하나 등록하자. 이슈를 등록할때는 메인테이너에게 공손히 프로젝트에 감사하다는 마음을 갖고 고쳐보고자 하는 버그나 개선사항을 적는거다.

메인테이너가 만들어진 이슈에 대한 댓글로 도움이 될 만한 점을 달아줄지도 모른다.

## Fork로 저장소 분리

![Hardcore Fork](/articles/2012/how-to-github/VWFCB.png)

'Fork' 버튼을 누르는 희열!! 복제된 저장소가 내 가슴속으로 들어왔다. 나의 복제된 저장소 페이지로 가보라! Clone해서 내려받을 수 있는 주소가 적혀있을 것이다. 바로 그냥 내려받는거다.

	git clone **your ssh/git url**

## Fork로 만든 저장소와 원본 저장소 연결

![Fork](/articles/2012/how-to-github/bbNRs.png)
_Fork가 이거냥!_

이 과정이 꼭 필요한건 아니다. 하지만 단 한번만 이 프로젝트에 참여할 것이 아니라면 이 과정을 해두면 정말 쓸모있다. 아래 명령을 실행하여 원래 프로젝트 저장소를 'upstream'으로 등록해두면 원래 프로젝트의 변경사항을 계속 받아볼 수 있다. 'upstreamname'과 'projectname' 부분을 실제 프로젝트에 맞게 적당히 바꿔서 명령을 실행한다.

	git remote add --track master upstream git://github.com/upstreamname/projectname.git

자 이렇게 하면 `upstream` 이라는 리모트로 등록이 된다.

	git fetch upstream

이렇게 하면 원래 프로젝트의 최신 내용을 받아오고

	git merge upstream/master

이렇게 하면 최신 내용을 현재 작업하고 있는 브랜치에 Merge하게 된다. 짜잔!

## 개발용 브랜치

![Old Internet](/articles/2012/how-to-github/fI9qT.gif)
_그 옛날의 인터넷이 생각나지 않나요들?_

자 이제 고쳐야 할 부분에 집중하기 위해 `master` 브랜치에서 새로운 브랜치로 `checkout`할 때가 왔다. Pull Request는 Branch 단위로 하기 때문에 브랜치를 잘 만들어두는게 중요하다. 고쳐야 할 이슈가 여럿이라면 브랜치도 여러개 이어야 겠다. 아래처럼 해서 브랜치를 만들자:

	git branch newfeature

해당 브랜치로 바꾸려면 즉 `checkout` 하려면:

	git checkout newfeature

새로 만든 브랜치로 변경했다. 현재 위치한 브랜치를 확인하려면 `git branch`를 실행해보라.

## Hack!

이제 실제 고치는 작업을 하자. 계획했던 고칠점이 맘에 들 때 까지 될대로 코드를 고쳐보고 테스트해보고 행복의 경지에 이르러보자. 음하하하~

## 커밋 하나로 합치기

![Squash](/articles/2012/how-to-github/FgOPu.png)
_이게 '스쿼시'냥!_

여러분도 나처럼 엄청나게 커밋을 해댄다면 커밋 메시지는 안봐도 거지같을게('동작함!', '안돌아감', '열여덟', '후아~', 등등) 뻔하다. 사실 이런 습관은 좋지 않지만 고치고 싶은 생각도 없고 이런 습관을 가진 사람도 많이 봤다.

Pull Request를 보내기 전에 여러 커밋을 하나 혹은 몇 개의 커밋으로 모아서 정리하고 싶을 수도 있다. 하여 `git rebase` 명령을 써 볼 것이다. 우선 `git log`로 커밋 메시지를 확인해보고 어떻게 정리할 지 생각해둔다. 마지막 3개의 커밋을 하나로 합치려면 아래와 같은 명령을 실행한다:

	git rebase -i HEAD~3

명령을 실행하면 Git은 기본 편집기를 불러내서 아래같은 내용을 보여준다.

	pick df94881 Allow install to SD 
	pick a7323e5 README Junkyism 
	pick 3ead26f rm classpath from git 

각 줄이 각 커밋에 해당하는데 하나로 합치려면 아래와 같이 내용을 수정한다.

	pick df94881 Allow install to SD 
	squash a7323e5 README Junkyism 
	squash 3ead26f rm classpath from git 

내용을 저장하고 편집기를 종료하면, 새로운 내용으로 편집기가 다시 뜰텐데 그때는 새로 하나로 만들어진 커밋 메시지를 입력하는 것이다. 거지같은 커밋이 깔끔하게 정리된 새 커밋으로 재탄생했다. 만쉐이~ 이제 Pull Request를 해도 부끄럽지 않겠다.

## Pull Request 보내기

단장하고 커밋해놓은 브랜치를 서버 저장소로 아래와 같은 명령으로 보낸다:

	git push origin newfeature

그리고 GitHub 사이트로 가서 새로 만든 브랜치로 이동한다. 보통 기본으로 master 브랜치로 되어있을 것이다.

![Pull Request](/articles/2012/how-to-github/aAd2v.png)
_Pull Request를 보내자_

브랜치로 이동한 것을 확인하고 'Pull Request' 버튼을 누르자. 다음과 같은 화면이 나오는데 브랜치에서 변경한 내용에 대한 설명을 적어주고 'Submit Pull Request' 버튼을 눌러준다.

![Pull Request](/articles/2012/how-to-github/5Euiy.png)
_Pull Request 설명 달기_

룰루랄라~ 끝났다. 사실 완전히 다 끝난건 아니다. 'Pull Request' 보낸 커밋에 고칠점이 있다면 메인테이너는 'Pull Request'를 바로 받아주지 않고 해당사항을 고쳐달라고 할 것이다. 메인테이너가 'Pull Request'를 닫지(Clone) 않는 한 해당 브랜치로 커밋을 Push하면 다행히도 'Pull Request' 속으로 들어간다.

## Pull Request 받아서 Merge하기

보너스! Pull Request를 받았을 때에는 어떻게 Merge하면 되는가! 그냥 버튼 하나만 누르면 된다. 쉽네. GitHub이 버튼 한 번만 누르면 모든게 자동으로 되도록 잘 만들어놨다. 간혹, 자동으로 되지 않을때가 있는데 그때는 직접 명령어를 써서 Merge해야 한다.

	git checkout master
	git remote add contributor git://github.com/contributor/project
	git fetch contributor
	git merge contributor/newfeature
	git push origin master

이렇게 하면 다른사람이 수정한 내용을 메인 master 브랜치로 merge하게 된다.

## Pull Request를 받아주지 않는 이유

이 부분은 [원본 페이지][source]를 확인하시라!
