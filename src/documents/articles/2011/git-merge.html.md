--- yaml
layout: 'article'
title: 'Git:merge'
author: 'Changwoo Park'
date: '2011-12-10'
tags: ['git', 'merge']
---

커밋 히스토리는 굉장히 잘 관리해야 한다. 이 글은 merge를 잘해서 히스토리를 잘 관리하는 방법을 설명한다.

git의 최고의 장점은 모든 것을 나중으로 미룰 수 있다는 것이다. 이 말의 의미는 언제나 히스토리를 원하는 데로 편집할 수 있다는 것을 의미한다. 기존의 커밋 여러 개를 하나로 합치거나 커밋 하나를 여러 개로 쪼갤 수 있다. 이미 커밋된 개체에 들어 있는 committer나 author 정보를 수정할 수도 있다. 이런 git의 막강한 기능을 이용해서 모든 참여자가 쉽게 이해할 수 있고 쉽게 관리할 수 있는 히스토리를 만들어 나아가야 한다. 히스토리를 단장하는 방법도 굉장히 흥미로운 주제지만 내용이 많아서 이 글에서 다루지 않는다. 나중에 다시 다루기로 하겠다.

히스토리를 단장하기 위해 다음과 같은 몇 가지 사항을 꼭 기억해야 한다.

 * Fast-forward merge와 merge 커밋을 구분해야 한다.
 * merge, rebase, cherry pick을 이해해야 한다.

![힘내](/articles/2011/git-merge/thousand_sunny_ship.jpg)

싸우전드 써니 호는 밀짚모자 해적단의 안전한 항해를 책임진다. 그러니 잘 관리해야 한다.

보통 master, develop, pu(proposed updates), next 등으로 이름 짓는 브랜치가 긴 호흡 브랜치(long-runing branch)이다. 이 브랜치는 굉장히 오랫동안 유지하고 사실 거의 저장소에 항상 존재한다. 필요에 따라 삭제하기도 하지만 바로 다시 만들어야 하기 때문에 항상 필요하다. 각 브랜치는 브랜치 고유의 목적이 있다. 여기서 각 브랜치의 의미를 설명하지 않는다.

이 글에서는 긴 호흡 브랜치로 ship 브랜치를 사용한다.

## merge, rebase, cherry-pick

먼저 merge, rebase, cherry-pick이 어떻게 다른지 알아보자. 각 명령어가 어떻게 다른지는 [Visual git guide][]에 잘 설명돼 있다.

merge, rebase, cherry-pick을 선택하기 전에 고려해야 하는 것 중의 하나로 해당 커밋을 공유하고 있는지가 중요하다. 이미 다른 사람과 공유한 커밋이라면 조심해야 한다. rebase, cherry-pick, squash는 내용이 같더라도 커밋 개체를 새로 만들어 버리기 때문에 조심해야 한다.

이미 공유하는 커밋이라면 기존의 커밋 개체를 바꾸면 안 되고 반드시 동료와 논의해야 한다. 그래야 동료가 혼란스러워하지 않는다.

### merge

긴 호흡 브랜치에 merge하는 것이 아니라면(토픽 브랜치에 merge하는 것이라면) 편한 방법으로 merge해도 된다. 토픽 브랜치는 보통 저장소에 올려 다른 사람과 공유하지 않기 때문에 커밋을 어떻게 작성하든 문제가 되지 않는다. 히스토리를 정돈하는 일은 저장소에 올려 다른 사람과 공유하기 전까지 미뤄도 괜찮다.

merge하기 전에 뭐가 다른지 확인해보는 것이 좋다. feature/sample이라는 토픽 브랜치를 ship 브랜치에 merge하는 경우에 다음과 같이 뭐가 다른지 살펴보자.

    git log ship..feature/sample

이 명령은 ship에는 없고 feature/sample에만 있는 커밋을 모두 보여준다. 그리고 나서 `git show` 명령으로 해당 커밋에서 도데체 무엇이 변경됐는지 확인할 수 있다.

#### 'git merge --no-commit --squash'

이 명령은 토픽 브랜치를 긴 호흡 브랜치에 merge할 때 유용하다.

예를 들어 토픽 브랜치에서 작업한 것을 긴 호흡 브랜치에 merge할 때는 토픽 브랜치에 있는 커밋을 하나의 의미로 묶어서 merge하는 것이 좋다. 토픽 브랜치는 보통 하나의 이슈를 구현하기 때문에 하나의 의미가 있을 확률이 높다. 보통 개발하다 보면 동료와 의논하거나 백업하는 등 여러 가지 이유로 여러 번 커밋을 하는 경우가 많다. 그대로 긴 호흡 브랜치에 merge하지 말고 의미 단위로 합쳐서 merge한다.

ship 브랜치 히스토리가 다음과 같다고 하자:

    :::text
    * 23a973a - (ship) Add feature/sample
    * 1934594 - Add ship

이 상태에서 '프랑키'는 feature/guns 브랜치를 만들어 대포를 두 번에 나눠서 달았다. 배를 고친 후 feature/guns 브랜치는 다음과 같다:

    :::text
    * f296244 - (feature/guns) Add gun2
    * 084ebfa - Add new A gun
    * 23a973a - (ship) Add feature/sample
    * 1934594 - Add ship

이것을 ship 브랜치에 merge하면 feature/guns는 ship을 base로 하고 있기 때문에 Fast-forward된다. ship 브랜치의 히스토리는 다음과 같아진다:

    * f296244 - (ship, feature/guns) Add gun2
    * 084ebfa - Add new A gun
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

사실 대포를 두 번에 나눠서 달았지만, ship 브랜치 히스토리에는 그냥 대포를 추가했다고 남기고 싶다. 대포를 나눠서 추가했든 한 번에 추가했든 그게 의미 있는 게 아니라 대포를 추가했다는 사실만 중요하기 때문에 하나로 합치는 것이 좋다.

`git merge --no-commit --squash` 명령으로 두 커밋을 합쳐서 merge하면 다음과 같아진다:

    :::text
    * 99f108e - (ship) Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

`--no-commit` 옵션을 주면 말 그대로 merge한 후 commit하지 않는다. `--no--commit` 옵션이 없더라도 커밋 여러 개를 합친 것이기(squash) 때문에 merge만하고 자동으로 커밋해주지 않는다. 수동으로 커밋 메시지를 수정하고 커밋한다.

### rebase

'프랑키'가 대포를 추가하는 사이에 '나미'는 'feature/tangerine' 브랜치를 만들고 귤 나무를 하나 심었다:

    :::text
    * 945381e - (feature/tangerine) Plant new tangerine
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

'나미'는 자신의 결과물을 push하기 위해서 먼저 pull한다. 그럼 ‘나미’의 ship 브랜치는 다음과 같다:

    :::text
    * 99f108e - (ship) Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

merge하기 전에 여기서도 두 브랜치에 어떤 차이가 있는 지 확인한다. 이때는 `git log --left-right ship...feature/tangerine` 명령으로 두 브랜치 사이에 뭐가 다른지 확인한다. `...`은 서로 다른 커밋을 모두 보여준다.

    :::text
    > 945381e - (feature/tangerine) Plant new tangerine
    < 99f108e - (ship) Add new guns

`>`는 파라미터로 넘긴 오른쪽 브랜치에만 있는 커밋이고 `<`는 왼쪽 브랜치에만 있는 커밋이다. 여기서 feature/tangerine를 merge하면 ship 브랜치는 다음과 같아진다:

    :::text
    *   2cc0cb8 - (dev) Merge branch 'feature/tangerine' into dev
    |\
    | * 945381e - (feature/tangerine) Plant new tangerine
    * | 99f108e - Add new guns
    |/
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

ship 브랜치에 merge 커밋이 들어갔기 때문에 히스토리가 선형적이지 않다. 곧 사라질 브랜치인 'feature/tangerine' 브랜치의 잔재가 커밋 히스토리에 남는다. 이럴 때는 rebase가 필요하다. 다음과 같이 feature/tangerine 브랜치를 checkout하고 rebase한다:

    $ git checkout feature/tangerine
    $ git rebase ship
    First, rewinding head to replay your work on top of it...
    Applying: Plant new tangerine

그럼 feature/tangerine의 히스토리는 다음과 같아진다:

    :::text
    * 0c8c128 - (feature/tangerine) Plant new tangerine
    * 99f108e - (ship) Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

feature/tangerine의 히스토리를 잘 보자. feature/tangerine 브랜치에서 추가한 커밋의 SHA 값이 '945381e'에서 '0c8c128'로 바뀌었다. rebase하면 ship 브랜치가 가리키는 커밋을 base로 해서 해당 커밋 개체를 다시 만든다. 그래서 저장소에 이미 push한 커밋에 대해서 rebase하면 다른 동료가 혼란스러워하고 히스토리를 다시 정리하기 위해 추가작업이 필요해진다

그리고 나서 ship 브랜치에 feature/tangerine을 merge한다. 이때 feature/tangerine 브랜치는 ship 브랜치를 base로 하기 때문에 Fast-forward된다. merge하면 ship 브랜치의 히스토리는 다음과 같아진다:

    :::text
    * 0c8c128 - (ship, feature/tangerine) Plant new tangerine
    * 99f108e - Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

### cherry-pick

'루피'는 고기와 과일을 가지고 돌아왔다. '루피'의 브랜치, feature/food는 다음과 같다:

    :::text
    * df19672 - (feature/food) Add fruits
    * 663ced1 - Add meats
    * 0c8c128 - (ship) Plant new tangerine
    * 99f108e - Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

그런데 배에 이미 과일이 많아서 고기만 배에 넣기로 했다. 두 커밋 'df19672', '663ced1' 중에서 '663ced1' 골라서 merge 시킬 수 있을까? 이럴 때 cherry-pick을 사용한다. cherry-pick은 기여자가 보내온 커밋 중에서 하나만 rebase하는 것이다. 커밋 하나만 rebase하는 것이기 때문에 커밋 개체도 새로 만들어진다.

ship 브랜치로 이동해서 `git cherry-pick 663ced1` 명령을 실행하면 ship 브랜치 히스토리는 다음과 같아진다:

    :::text
    * 271fa93 - (ship, feature/food) Add meats
    * 0c8c128 - Plant new tangerine
    * 99f108e - Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

## fast-forward merge와 merge 커밋

merge 커밋을 해야 하는 이유는 대게 커밋 하나로 정리할 수 없기 때문이다. 이슈를 하나로 정리해서 히스토리를 선형적으로 관리하는 것도 좋은 방법이지만 커밋 하나로 정리할 수 없는 이슈를 하나로 정리해 버리면 나중에 추적하기도 관리하기도 어려워진다.

### fast-forward merge

이슈를(토픽 브랜치를) 하나의 커밋으로 정리할 수 있다면 fast-forward merge가 낫다. 브랜치에 커밋이 하나면 그 커밋 메시지를 적절히 수정해서 merge하고 아니면 하나로 합쳐서 merge한다. 커밋이 하나인 브랜치를 merge할 때 merge 커밋을 히스토리에 남기면 브랜치 이름을 기록해 두는 것 이외에 아무런 이득이 없다.

fast-forward merge하는 방법을 살펴보자. '프랑키'는 feature/fix-ship 브랜치를 만들어 뱃머리와 닿을 수리했다:

    * 52f084e - (HEAD, feature/fix-ship) Fix anchor
    * eb1db0d - Fix sunny bow
    * 271fa93 - (ship) Add meats
    * 0c8c128 - Plant new tangerine
    * 99f108e - Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

이 브랜치를 ship 브랜치에 merge한다. 먼저, `...`으로 fast-forward merge될 수 있는지 확인한다.

    $ git log --left-right ship...feature/fix-ship
    > 52f084e - (feature/fix-ship) Fix anchor
    > eb1db0d - Fix sunny bow

feature/fix-ship 브랜치는 ship 브랜치를 base로 하기 때문에 fast-forward merge될 수 있다. `merge-base` 명령으로도 확인할 수 있다. 이 명령은 두 브랜치가 공통으로 하는 공통 커밋을 알려준다:

    $ git merge-base ship feature/fix-ship
    271fa933f42c7d6b0fa1e967c7d73801e83936b3

ship은 '271fa93'를 가리키고 있고 feature/fix-ship은 그 커밋을 base로 하고 있다.

`--no-ff` 옵션을 사용하지 않고 merge하면 fast-forward merge된다.

    $ git checkout ship
    $ git merge feature/fix-ship 
    Updating 271fa93..52f084e
    Fast-forward
     0 files changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 anchor
     create mode 100644 sunny

### merge 커밋

merge 커밋은 단순하게 말해서 커밋의 집합이라고 생각할 수 있다. merge 커밋을 만들어야 하는 때는 여러 커밋을 묶어서 관리하고자 할 때이다.

merge 커밋을 하면 여러 개의 커밋을 하나로 관리하고 어떤 브랜치에서 merge한 것인지 기록을 남길 수 있다. merge 커밋을 해보자.

위에서 merge 했던 것을 다시 원상태로 돌린다(revert):

    $ git reset --hard HEAD~2
    HEAD is now at 271fa93 Add meats

커밋이 두 개라서 feature 하나를 원복할 때 커밋 두 개를 모두 reset해야 한다.

이제 `--no-ff`을 주고 merge 커밋을 만든다.

    $ git checkout ship
    $ git merge --no-ff feature/fix-ship
    Merge made by recursive.
     0 files changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 anchor
     create mode 100644 sunny

이제 ship 브랜치의 히스토리를 살펴보자:

    *   65f14bd - (HEAD, ship) Merge branch 'feature/fix-ship' into ship
    |\  
    | * 52f084e - (feature/fix-ship) Fix anchor
    | * eb1db0d - Fix sunny bow
    |/ 
    * 271fa93 - (ship) Add meats
    * 0c8c128 - Plant new tangerine
    * 99f108e - Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

어떤 feature를 merge했고 그 feature에 해당하는 커밋이 무엇인지 히스토리에 남는다. 만약 이 merge를 취소하고 싶을 때는 다음과 같이 실행하면 된다.

    $ git reset --hard HEAD~1
    HEAD is now at 271fa93 Add meats

merge 커밋이 있기 때문에 'HEAD~1' 만으로도 feature/fix-ship에 해당하는 커밋이 모두 reset된다:

    * 271fa93 - (HEAD, ship) Add meats
    * 0c8c128 - Plant new tangerine
    * 99f108e - Add new guns
    * 23a973a - Add feature/sample
    * 1934594 - Add ship

## 결론

Vincent Driessen님은 [A successful Git branching model][git-flow-post]에서 --no-ff를 기본 옵션으로 해야 한다고 했지만, 꼭 그렇지 않다. 히스토리를 어떻게 관리할지에 따라 선택해야 하고 fast-forward merge해야 하는 경우도 매우 많다.

실제로 Driessen님이 저 글의 내용을 구현한 [git-flow][]에서도 feature 브랜치에 commit이 하나만 있으면 develop 브랜치에 fast-forward로 merge한다.

[progit]: http://dogfeet.github.com/articles/2011/progit.html
[git-flow-post]: http://dogfeet.github.com/articles/2011/a-successful-git-branching-model.html
[git-flow]: https://github.com/nvie/gitflow
[Visual git guide]: http://marklodato.github.com/visual-git-guide/index-ko.html

