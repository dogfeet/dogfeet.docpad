--- yaml
layout: 'article'
title: 'Git: Rebase는 언제 어떻게 해야 할까?'
author: 'Changwoo Park'
date: '2012-08-12'
tags: ['Git', 'Rebase']
---

처음에는 Rebase를 왜 해야 하고 언제 어떻게 해야 하는지 좀 헷갈린다. 헷갈리는 이유는 정답이 없고 미묘함이 있어서인데 그래도 대략적인 가이드가 있으면 좋겠다 싶어서 정리해보았다.

![git-](/articles/2012/git-merge-rebase/git-rebase.jpeg)

## Social Coding Platform

svn이나 다른 VCS 도구 말고 git을 사용해야 하는 이유는 커뮤니케이션이다. 개발이라는 작업은 혼자 하는 게 아니라서 코드를 공유하고, 리뷰하고, 피드백을 받아야 하는데 Git으로 하면 일이 좀 쉬워진다(Git이 쉽다는 것은 아니다).

git과 github의 인기는 VCS 본연의 기능뿐만 아니라 커뮤니케이션을 원활하게 할 수 있는 플랫폼이 함께 필요하다는 것을 보여준다. git은 소스관리에도 뛰어난 도구지만 그게 Git만의 장점은 아니다.

git은 단순히 VCS가 아니다. 소스관리뿐만 아니라 커뮤니케이션에 필요한 모든 것이 들어 있다. 특히 코드를 공유하는 것은 정말 끝내 준다. Git 이외에 필요한 도구가 별로 없다. 나는 히스토리를 엉망으로 관리하는 프로젝트을 살펴보고자 gitx를 가끔 사용하고 차이를 살펴보고자 diffmerge를 아주 가끔 사용한다. 정말 아주 가끔이다. 한 달에 한 번도 실행하지 않는다.

그 외에는 항상 콘솔에서 작업한다. git은 아직도 발전 중이고 코드를 쉽게 공유하는 방법이 계속 통합될 것으로 생각한다. git에는 정말 필요한 모든 것이 통합되고 있어서 언젠가 git으로 문자 메시지로 코드를 보낼 수 있는 날이 올지도 모른다는 상상을 하고 있다.

## 배려

동료는 그녀와 같다. 배려 없이 초대에 응하는 그녀는 없다. 최대한 친절을 베풀어야 그녀를 내 저장소로 초대할 수 있다. 공포를 조장하거나 무턱대고 돈만 살포해서는 진심을 이끌어 낼 수 없다. 스스로 응할 때까지 배려하고 인내해야 한다.

코드는 당연히 잘 짜야 한다. 버그는 없을수록 좋고, 주석은 간략하고 명확해야 하고, 변수나 함수이름, 파일이나 디렉토리 구조나 이름 등등…. 중요하지 않은 것이 없다. 좋은 글에는 좋은 문장도 많은 법이다.

git도 마찬가지다. 변수 이름을 잘 짓듯이 브랜치 이름도 잘 지어야 한다. 커밋 메시지도 표준 포멧에 따라 잘 지어야 한다. 그리고 히스토리도 예쁘게 만들어야 한다.

## Merge vs Rebase

Rebase는 히스토리를 단장하는 데 필요하다. 나 혼자 쓰는 저장소에서도 Rebase가 없으면 지저분해서 히스토리를 읽을 수가 없다.

잘 정리한 히스토리를 엿보고 싶다면 [npm 저장소](https://github.com/isaacs/npm/)를 구경해보는 것이 좋다. @izs님은 완전 git타쿠:

![npm-history](/articles/2012/git-merge-rebase/npm-history.png)

히스토리가 정말 보기 좋다. github의 'pull request'도 사용하지 않고 죄다 손으로 Merge하는 것 같다.

### 커밋 vs Merge 커밋

Merge와 Rebase를 살펴보기 전에 커밋부터 다시 살펴보자.

커밋은 의미의 단위다. 지금 하는 일을 적당하게 한 조각으로 나눠서 커밋한다. 10줄, 100줄처럼 정량적인 단위가 아니다. 고기를 사듯이 '커밋 한 근 주세요.'라고 말할 수 없다. **커밋 하나는 의미 하나다**.

커밋 하나하나에도 의미가 있지만 어떤 모듈을 개발한다면 여러 개를 하나로 묶어서 처리할 필요도 있다. 그러니까 여러 개의 커밋을 묶음으로 표현할 수 있는 커밋이 필요하다. 그게 Merge 커밋이다. **Merge 커밋은 일종의 커밋 묶음이다**

npm 저장소에 @izs님이 만들어 놓은 Merge 커밋을 보자:

![npm-gyp-history](/articles/2012/git-merge-rebase/npm-gyp-history.png)

`1ecd0eb`는 gyp를 구현한 커밋들을 묶어 놓은 Merge 커밋이다. gyp 브랜치를 만들어 gyp를 구현하고 master 브랜치로 Merge했다.


Merge 커밋은 사실 커밋 묶음 나타내는 것이 아니다. 보통 커밋은 Parent가 하나인데 Merge 커밋은 Parent가 여러 개다. 하지만, Parent가 여러 개인 점을 이용해서 커밋 묶음으로 다룰 수 있다:

![git-merge](/articles/2012/git-merge-rebase/git-merge.png)

C6는 Merge 커밋으로 Parent가 두 개다. 

Merge 커밋을 Reset하면 관련 커밋이 전부 Reset된다:

![git-reset](/articles/2012/git-merge-rebase/git-reset.png)

`C3`와 `C5`가 같이 Reset되기 때문에 master 입장에서는 커밋 묶음이 Reset된 것이다.

npm 저장소에서 master 브랜치가 Merge 커밋인 `1ecd0eb`를 가리키는 상태에서 'HEAD~1'으로 Reset하면 gyp 브랜치가 통째로 Reset된다. 그래서 master는 `c4eb2fd`를 가리킨다.

## Merge vs Rebase

다음과 같은 브랜치를 Merge, Rebase해보고 그 결과를 비교해보자:

![orig](/articles/2012/git-merge-rebase/orig.png)

`git merge iss1` 명령으로 iss1를 Merge한다. 노란색인 C1은 Merge Base이다:

![merge1](/articles/2012/git-merge-rebase/merge1.png)

`git merge iss2` 명령으로 iss2를 Merge한다:

![merge2](/articles/2012/git-merge-rebase/merge2.png)

`git merge iss3` 명령으로 iss3를 Merge한다:

![merge3](/articles/2012/git-merge-rebase/merge3.png)

iss1, iss2, iss3를 Merge 했다. C9, C10, C11은 Merge 커밋이다. 이 그림에서는 히스토리가 복잡하지 않다고 생각할 수 있지만, 이정도 되는 내용도 콘솔에서 보면 헷갈린다. 한눈에 들어오지 않는다. 이제 Rebase 후 Merge해보자.

헷갈릴 수 있으니 원본 브랜치를 다시 한번 보고:

![orig](/articles/2012/git-merge-rebase/orig.png)

`git checkout iss1`과 `git rebase master`를 차례대로 실행해서 Rebase한다 그러면 Merge Base가 `C1`이 아니라 `C4`가 된다:

![rebase1](/articles/2012/git-merge-rebase/rebase1.png)

`git checkout master`과 `git merge iss1`를 차례대로 실행해서 Merge한다. Rebase를 하면 항상 Fast-Forward Merge가 가능해진다. 하지만, 무턱대고 Fast-Forward Merge를 하는 것이 아니라 앞서 얘기했듯이 커밋을 묶음으로 관리하고 싶지 않을 때만 Fast-Forward Merge한다. 이 경우는 커밋이 하나이므로 그냥 Fast-Forward Merge한다:

![rebase1-merge](/articles/2012/git-merge-rebase/rebase1-merge.png)

`git checkout iss2`과 `git rebase master`를 차례대로 실행해서 Rebase한다 그러면 Merge Base가 `C3`가 아니라 `C2'`가 된다:

![rebase2](/articles/2012/git-merge-rebase/rebase2.png)

`git checkout master`과 `git merge --no-ff iss2`를 차례대로 실행해서 Merge한다. `--no-ff` 옵션은 강제로 Merge 커밋을 남기려고 주는 것이다. iss2 브랜치는 커밋이 두 개고 이 커밋은 iss2를 처리한 결과이므로 커밋 묶음으로 처리하는 것이 낫다(물론, 내용상 --no-ff 옵션을 주는 게 틀릴 수도 있다.):

![rebase2-merge](/articles/2012/git-merge-rebase/rebase2-merge.png)

`git checkout iss3`과 `git rebase master`를 차례대로 실행해서 Rebase한다 그러면 Merge Base가 `C3`에서 `C9`이 된다:

![rebase3](/articles/2012/git-merge-rebase/rebase3.png)

`git checkout master`과 `git merge --no-ff iss3`를 차례대로 실행해서 Merge한다:

![rebase3-merge](/articles/2012/git-merge-rebase/rebase3-merge.png)

다음 그림은 위에서 Rebase 없이 Merge한 결과다. 한번 비교해보자:

![merge3](/articles/2012/git-merge-rebase/merge3.png)

Rebase를 하고 나서 Merge한 것이 훨씬 보기 좋다. 아무리 복잡한 과정을 거쳤어도 한눈에 들어오게 할 수 있다.

## 마치며

Git처럼 히스토리를 다중으로 관리하는 시스템에서 Rebase는 필수다. Mercurial도 Git의 영향을 받아 Rebase를 지원한다. 이글에서는 Rebase가 왜 필요하고 언제 어떻게 해야 하는지 알아봤다.

## UPDATE: 20121122

Merge Commit은 Commit을 묶음으로 관리하는데도 유용하지만 Release Note에 넣을 만한 것을 미리 Merge Commit으로 만들어 놓으면 편리할 것 같다. 배포할 때 Merge Commit만 추려볼 수 있으니 Release Note를 따로 작성하지 않아도 된다.

