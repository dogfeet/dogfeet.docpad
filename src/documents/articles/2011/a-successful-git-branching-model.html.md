--- yaml
layout: 'article'
title: 'A successful git branching model'
author: 'Changwoo Park'
date: '2011-12-06'
tags: ['git', 'git-flow']
---

_
[Vincent Driessen]님은 2010년 1월에 [A successful Git branching model][original]을 썼는데 매우 훌륭한 글입니다. Driessen님은 이 글에서 설명한 내용을 '[git-flow][]'로 구현해 놓았습니다. 번역하도록 허락해주신 Driessen님께 감사드립니다.
_

[original]: http://nvie.com/posts/a-successful-git-branching-model/
[git-flow]: https://github.com/nvie/gitflow
[Vincent Driessen]: https://github.com/nvie

내가 지난 일 년간 프로젝트를 할 때 사용한 개발 모델을 소개하고자 한다. 나는 이 모델을 업무에서도 사용했고 개인 프로젝트에서도 사용했다. 결과는 매우 성공적이었다. 진작부터 이 글을 쓰려고 벼르고 있었지만, 시간이 부족해 완성할 수 없었다. 나는 프로젝트를 진행하는 데 필요한 것을 하나하나 설명하기보다 순수하게 branching 전략과 배포 관리에 대해서 설명하고자 한다. 

![Git은 버전 관리용](/articles/2011/a-successful-git-branching-model/git-branching-model.png)

이 그림은 [Git][]으로 버전 관리하는 것을 한눈에 보여준다.

[Git]: http://git-scm.com/

### 왜 Git인가?

다른 중앙집중식 버전 관리 시스템과 Git을 비교해보고 싶으면 [웹에서][compare-1] 찾아라. [거기는][compare-2] 지금 [전쟁][compare-3] 중이다. 나는 개발자이고 다른 것보다 Git을 선호한다. Git은 merging/branching에 대해 신세계를 열어 줬다. 예전에는 CSV/Subversion을 썼었는데 항상 merging/branching이 두려웠고("주의: merge conficts라는 미친개가 물을 수도 있어요!") 사실 잘 사용하지 않았다.

[compare-1]: http://whygitisbetterthanx.com/
[compare-2]: http://www.looble.com/git-vs-svn-which-is-better/
[compare-3]: http://git.or.cz/gitwiki/GitSvnComparsion

그런데 Git에서는 merging/branching이 매우 간단하다. merging/branching은 매일 한다. CVS/Subversoin [책][svnbook]에서는 merging/branching과 관련된 내용이 마지막 장에 있어서 고급 사용자들이나 읽지만, [Git][git community book] [책][Pragmatic Version Control Using Git]은 [모두][progit] 3장 이전에 다룬다.

Git에서 merging/branching은 단순하고 자주 쓰기 때문에 더는 쫄지 않아도 된다. 버전 관리도구는 무엇보다 merging/branching이 쉬워야 한다.

도구에 대한 얘긴 그만 접고 개발 모델에 대한 얘기를 시작하자. 내가 여기서 말하고자 하는 모델은 단순히 소프트웨어 개발 프로세스를 관리하려고 팀원 모두가 따라야 하는 치짐일 뿐이다.

[svnbook]: http://svnbook.red-bean.com/
[Pragmatic Version Control Using Git]: http://pragprog.com/book/tsgit/pragmatic-version-control-using-git
[git community book]: http://book.git-scm.com/
[progit]: http://progit.org

### 분산이지만 중앙집중식처럼

이 브랜치 모델에는 중앙 저장소가 하나 필요하다. 사람들이 중앙에 두고 공유하는, 의미상으로 "진짜" 중앙 저장소 말이다. Git은 DVCS라서 본질적으로 모든 저장소가 같다. 중앙 저장소라고 해서 금칠 돼 있는 것이 아니다. 이 중앙 저장소를 origin으로 추가한다. Git을 사용하는 사람에게는 origin이라는 이름이 매우 친근하다.

![Decentralized but centralized](/articles/2011/a-successful-git-branching-model/centr-decentr.png)

개발자 모두 origin에 push/pull할 수 있지만, 중앙집중식에서는 모든 개발자가 다른 모듈 팀에서 수정한 것까지도 pull해야 한다. 예를 들어 혼자 하기 어려운 기능은 둘, 셋이서 함께 개발하고 나서 origin에 push해야 한다. 개발 중인 것을 origin에 push하지 않는다. 이 그림에서 Alice와 Bob, Alice와 David, Clair와 David은 각각 팀을 만들었다:

이것을 Git 언어로 풀어보면 Alice는 자신의 저장소에 Bob의 저장소를 bob이라는 이름으로 추가한다는 것을 말한다. 나머지 팀원과 팀도 모두 똑같이 한다.

### 주요 브랜치

![branches](/articles/2011/a-successful-git-branching-model/main-branches.png)

이 개발 모델은 전혀 새롭지 않다. 핵심은 기존에 있던 개념들이다. 주요 브랜치 두 개는 중앙 저장소에 영원히 유지한다:

 * master
 * develop

Git 사용자라면 누구나 익숙한 master 브랜치와 develop 브랜치를 병행으로 유지한다.

먼저 배포했거나 곧 배포할(production-ready) 코드는 origin/master에 두고 관리한다.

그리고 다음에 배포할 것을 개발하는 코드는 origin/develop에 두고 관리한다. 혹자는 이 브랜치를 "통합 브랜치(integration branch)"라고 부르기도 하는데, 이 브랜치를 자동으로 매일 빌드하는데 사용한다.

develop branch의 코드가 안정되고 배포할 준비가 되면 곧 master로 merge하고 배포 버전으로 태그를 단다. 이것을 어떻게 하는지 이 글에서 자세히 설명한다.

즉, 정의한 대로 master로 merge하는 것은 새 버전을 배포하는 것을 의미한다. 우리는 이것을 매우 엄격하게 지킬 것이다. 그래서 master 브랜치에 커밋될 때마다 Git hook 스크립트로 자동으로 빌드하고 말아서 운영 서버로 배포할 수 있다.

### 보조 브랜치

master와 develop 브랜치말고 다른 브랜치도 필요하다. 기능을 구현하고, 배포를 준비하고, 이미 배포한 제품이나 서비스의 버그를 빠르게 해결해야 한다. 이 모든 것을 동시에 진행해야 하기 때문에 다양한 브랜치가 필요하다.

우리가 사용할 브랜치의 종류는 다음과 같다:

 * feature 브랜치
 * release 브랜치
 * hotfix 브랜치

각 브랜치마다 만든 목적이 있고 어떤 브랜치에서 갈라져 나왔는지, 어떤 브랜치에 merge할 지에 따라 꼭 지켜야 규칙도 있다. 이제 이 얘기를 하려고 한다.

이 분류는 어떻게 사용할지에 따라 나누었다. 하지만 기술적으로는(technically) 모두 같은 브랜치다. Git의 다른 브랜치와도 똑같다.

#### feature 브랜치

    갈라져 나온 브랜치: develop
    다시 merge할 브랜치: develop
    브랜치 이름 규칙: master, develop, release-*, hotfix-*를 제외한 것

feature 브랜치(토픽 브랜치라고도 부른다)는 다음, 아니면 다다음, 어쨌든 조만간에 배포할 기능을 개발하는 브랜치다. 기능을 개발하기 시작할 때에는 사실 언제 배포할 수 있는지 알 수 없다. feature 브랜치는 그 기능을 다 완성할 때까지 유지하고 다 완성되면 develop 브랜치로 merge한다. 다음 배포에 확실히 넣을 거라고 판단될 때 merge하고 결과가 실망스러우면 아예 버린다.

feature 브랜치는 보통 개발자 저장소에만 있는 브랜치고 origin에는 push하지 않는다.

##### feature 브랜치 만들기

feature 브랜치를 develop 브랜치에서(base) 새로 만든다.

    $ git checkout -b myfeature develop
    Switched to a new branch "myfeature"

##### 완성된 기능을 develop에 합치기

어떤 기능이 다 완성돼 다음 배포에 넣기로 했다면 develop 브랜치에 merge한다:

    $ git checkout develop
    Switched to branch 'develop'
    $ git merge --no-ff myfeature
    Updating ea1b82a..05e9557
    (Summary of changes)
    $ git branch -d myfeature
    Deleted branch myfeature (was 05e9557).
    $ git push origin develop

'--no-ff' 옵션을 주면 항상 merge 커밋을 만들어 merge한다. fast-forward로 merge할 수 있어도 fast-forward하지 않는다. 그러면 feature 브랜치에 추가된 모든 커밋이 merge되고 feature 브랜치에서 merge했다는 기록이 커밋 히스토리에 남는다. 그 둘을 비교해보자:

![branches](/articles/2011/a-successful-git-branching-model/merge-without-ff.png)

후자처럼 fast-forward merge하면 나중에 커밋 히스토리를 다시 확인할 때 어떤 커밋이 어떤 기능(feature)을 구현한 것인지 확인하기 어렵다. 그래서 히스토리에 있는 커밋 메시지를 하나하나 눈으로 찾아야 한다. 추가한 feature를 되돌려야(revert) 할 때 feature와 관련된 모든 커밋을 되돌려야 하는데 merge 커밋이 없으면 욕이 절로 나올 것이다. --no-ff 옵션을 주고 merge했다면 되돌리기 쉽다.

물론 아무것도 없는 텅 빈 커밋 개체가 하나 추가로 만들어지긴 하지만 이득이 더 많다.

나는 --no-ff 옵션을 기본 옵션으로 설정하는 방법을 찾지 못했다. 나는 꼭 기본 옵션이 돼야 한다고 생각한다.

#### release 브랜치

    갈라져 나온 브랜치: develop
    다시 merge할 브랜치: develop, master
    브랜치 이름 규칙: release-*

release 브랜치는 제품 배포를 준비하는 브랜치이다. 이 브랜치가 화룡이 승천할 수 있도록 점정하는 곳이다. 배포하는 데 필요한 버전 넘버, 빌드 일정 등의 메타데이터를 준비하고 사소한 버그도 잡는다. 이런 일을 release 브랜치에서 함으로써 develop 브랜치는 다음에 배포할 때 추가할 기능에 집중할 수 있다.

develop 브랜치가 배포할 수 있는 상태에 다다랐을 때 release 브랜치를 만드는 것이 중요하다. 이때, 배포해야 하는 기능이 모두 develop 브랜치에 merge돼 있어야 하고 이번에 배포하지 않을 기능은 release 브랜치를 만들 때까지 기다려야 한다.

release 브랜치를 만든다는 것은 이제 배포 버전을 부여하겠다는 것을 의미한다. 그때까지 develop 브랜치가 다음 배포가 어떤 모습일지 보여주지만, 아직 깨끗하게 정리된 상태가 아니다. 최종적으로 release 브랜치를 만들어 '0.1', '0.3' 같은 버전 넘버 붙을 때까지는 "진짜" 배포라고 할 수 없다. 그러니까 release 브랜치를 만들기로 하는 것이 버전 넘버를 새로 부여하기로 하는 것을 의미한다. 이것은 규칙이다.

##### release 브랜치 만들기

release 브랜치는 develop 브랜치에서 만든다. 예를 들어 배포할 수 있을 정도로 develop 브랜치가 준비돼 이제 곧 새 버전을 배포할 것이라고 하자. 그리고 현재 배포된 버전이 '1.1.5'이고 새 버전은 '1.1.6'이나 '2.0'이 아니라 '1.2' 버전으로 배포하기로 했다. 그럼 다음과 같은 이름으로 release 브랜치를 만든다:

    $ git checkout -b release-1.2 develop
    Switched to a new branch "release-1.2"
    $ ./bump-version.sh 1.2
    Files modified successfully, version bumped to 1.2.
    $ git commit -a -m "Bumped version number to 1.2"
    [release-1.2 74d9424] Bumped version number to 1.2
    1 files changed, 1 insertions(+), 1 deletions(-)

브랜치를 새로 만들고 버전 넘버를 생성했다. `bump-version.sh`는 버전 넘버가 들어 있는 파일을 전부 수정하는 가상의 쉘 스크립트다. 손으로 직접 수정해도 된다. 중요한 것은 이 시점에 파일을 수정한다는 점이다. 그리고 수정한 파일을 커밋한다.

새로 만든 release 브랜치는 잘 말아서 진짜로 배포할 때까지 유지한다. 그동안 발견한 버그는 develop 브랜치가 아니라 이 브랜치에서 해결하고 새 기능은 이 브랜치에 추가하지 않는다. 그런 기능은 develop 브랜치에 merge하고 다음 배포로 미뤄야 한다.

##### release 브랜치 마치기

release 브랜치가 진짜 배포할 상태가 되면 배포한다. master 브랜치에 있는 것을 배포하는 것으로 정의했으므로 먼저 release 브랜치를 master로 merge한다. 그리고 나중에 이 버전을 찾기 쉽도록 태그를 만들어 지금 master가 가리키는 커밋을 가리키게 한다. 그리고 release 브랜치를 develop 브랜치에 merge하고 다음에 배포할 때 release 브랜치에서 해결한 버그가 적용되도록 한다.

먼저 처음 두 단계, master에 merge하고 tag를 단다:

    $ git checkout master
    Switched to branch 'master'
    $ git merge --no-ff release-1.2
    Merge made by recursive.
    (Summary of changes)
    $ git tag -a 1.2

release 브랜치로 해야 할 일을 끝냈고 미래를 위해 tag도 달았다. tag를 달 때 `-s`나 `-u` 옵션을 주고 암호화 알고리즘을 이용해서 서명할 수도 있다.

그리고 develop 브랜치에 다시 merge해서 release 브랜치에서 수정한 것이 앞으로도 계속 유지되게 한다:

    $ git checkout develop
    Switched to branch 'develop'
    $ git merge --no-ff release-1.2
    Merge made by recursive.
    (Summary of changes)

버전 넘버를 수정했기 때문에 여기서 merge할 때에는 충돌이 날 확률이 높다. 충돌이 나면 수정해서 커밋한다.

이제 진짜로 배포했기 때문에 release 브랜치는 더는 필요 없다. 삭제한다:

    $ git branch -d release-1.2
    Deleted branch release-1.2 (was ff452fe).

#### hotfix 브랜치

    갈라져 나온 브랜치: master
    다시 merge할 브랜치: develop, master
    브랜치 이름 규칙: hotfix-*

![hotfix branches](/articles/2011/a-successful-git-branching-model/hotfix-branches.png)

미리 계획을 세워두지 않는다는 점만 빼면 hotfix 브랜치도 새로운 배포를 준비하는 것이기 때문에 release 브랜치와 비슷하다. 이것은 이미 배포한 운영 버전에 생긴 문제를 해결하기 위해 만든다. 운영 버전에 생긴 치명적인 버그는 즉시 해결해야 하기 때문에 문제가 생기면 master 브랜치에 만들어 둔 tag로부터 hotfix 브랜치를 만든다.

그리고 버그를 잡는 사람이 일하는 동안에도 다른 사람들은 develop 브랜치에서 하던 일을 계속 할 수 있다.

##### hotfix 브랜치 만들기

hotfix 브랜치는 master 브랜치에서 만든다. 예를 들어 현재 운영 버전이 1.2이고 심각한 버그가 발견됐다. develop 브랜치는 아직 불안정하기 때문에 hotfix 브랜치를 만들고 거기서 버그를 잡는다:

    $ git checkout -b hotfix-1.2.1 master
    Switched to a new branch "hotfix-1.2.1"
    $ ./bump-version.sh 1.2.1
    Files modified successfully, version bumped to 1.2.1.
    $ git commit -a -m "Bumped version number to 1.2.1"
    [hotfix-1.2.1 41e61bb] Bumped version number to 1.2.1
    1 files changed, 1 insertions(+), 1 deletions(-)

브랜치를 만들고 버전 넘버를 바꾸는 것을 잊으면 안 된다!

버그를 해결하고 나서 커밋한다. 한두 개의 커밋으로 해결한다:

    $ git commit -m "Fixed severe production problem"
    [hotfix-1.2.1 abbe5d6] Fixed severe production problem
    5 files changed, 32 insertions(+), 17 deletions(-)

##### hotfix 브랜치 마치기

버그를 잡았으면 다시 master에 merge하고 다시 develop 브랜치에도 merge해야 한다. 그래야 다음에 배포할 때도 포함된다. release 브랜치를 마치는 방법과 같다.

먼저 master에 merge하고 tag를 단다:

    $ git checkout master
    Switched to branch 'master'
    $ git merge --no-ff hotfix-1.2.1
    Merge made by recursive.
    (Summary of changes)
    $ git tag -a 1.2.1

이때에도 `-s`나 `-u` 옵션으로 tag에 서명할 수 있다.

그리고 develop에도 merge한다:

    $ git checkout develop
    Switched to branch 'develop'
    $ git merge --no-ff hotfix-1.2.1
    erge made by recursive.
    (Summary of changes)

만약 아직 release 브랜치가 삭제되지 않고 있다면 develop 브랜치가 아니라 release 브랜치에 merge한다. release 브랜치가 완료되면 결국 develop 브랜치에 merge될 것이다. 그런데 develop 브랜치도 즉시 해결해야 하면 release 브랜치가 끝날 때까지 기다리지 말고 develop 브랜치에 즉시 merge한다. 문제가 생기지 않도록 조심스럽게 merge한다. 

이제 이 임시 브랜치를 삭제한다:

    $ git branch -d hotfix-1.2.1
    Deleted branch hotfix-1.2.1 (was abbe5d6).

## 결론

이 모델은 전혀 새로운 게 아니다. 이 모델이 제시하는 그림은 내가 프로젝트를 할 때 정말 유용했다. 팀원 모두 머릿속에 같은 그림을 그리고 일할 수 있다. 이 모델은 팀이 브랜치와 배포 프로세스를 이해하고 공유 개발할 수 있도록 도와준다.

[고품질 PDF 버전][Git-branching-model.pdf]도 올려 두었으니 언제든지 볼 수 있도록 벽에 붙여두면 좋다. 

다이어그램 이미지 파일의 [Apple Keynote][gitflow-model.src.key] 파일도 요청하는 사람이 많아서 올렸다.

[gitflow-model.src.key]: http://github.com/downloads/nvie/gitflow/Git-branching-model-src.key.zip
[Git-branching-model.pdf]: http://github.com/downloads/nvie/gitflow/Git-branching-model.pdf
