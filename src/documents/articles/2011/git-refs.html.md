--- yaml
layout: 'article'
title: 'Git:refs'
author: 'Changwoo Park'
date: '2011-12-02'
tags: ['git']
---

이 글은 git에서 커밋을 가리키는 방법에 대해 정리한 것이다.

![heading images](/articles/2011/git.png)

git은 항상 Snapshot단위로 저장한다. 커밋하면 Snapshot을 저장하는 것이고 이 때 SHA 키가 발급된다. SHA가 Snapshot을 식별하는 유일한 식별자다. branch나 태그처럼 Snapshot을 식별하는 방법은 결국 SHA 값을 이용하는 것이다. Branch나 태그는 단순히 SHA 값을 가리키는 것 뿐이다.

SHA값은 40자나 되고 이런 암호를 인간이 인식하고 식별하기란 어렵다. git은 인간이 인식할 수 있도록 몇가지 방법 제공한다. 이 글은 각 Snapshot을 식별하는 방법을 설명한다. 아직 git에 대한 공부를 시작하지 않았다면 당장 [progit][]를 읽기 시작하라

이 글에서는 SHA값을 가리키는 방법 그리고 이 방법들로 어떤 일들을 할 수 있는지 살펴본다.

## Single Commit

먼저 하나의 커밋을 표현하는 방법들을 알아보자. 커밋 하나를 질의하는 것인지 커밋 여러개를 질의하는 것인지는 명령어마다 다르다. 먼저 커밋 하나를 질의하는 방법을 살펴보자.

커밋하나를 질의하는 명령어로 `git show` 명령을 사용한다.

### full SHA

`1c3618887afb5fbcbea25b7c013f4e2114448b8d`, 생성된 SHA 값은 이렇게 생겼다. 이 값이 기본이고 다른 refs는 모두 이 SHA 값을 가리키는 것 뿐이다.

### short SHA

기본적으로 7자가 사용된다. 위 SHA 값에 적용하면 `1c36188`이다:

    git show 1c3618887afb5fbcbea25b7c013f4e2114448b8d

라고 해도 되지만:

    git show 1c36188

이렇게 해도 결과는 같다. short SHA는 저장소에서 식별할 수 있는 만큼 사용되며 거대한 리눅스 커널 프로젝트도 겨우 12자를 사용한다.

### Branch

Branch도 결국 특정 커밋을 가리키는 것이다. master Branch가 `1c36188` 커밋을 가리키고 있다면 `git show master`와 `git show 1c36188`는 똑 같다.

### HEAD

HEAD도 마찬가지다. `git show HEAD`하면 HEAD가 가리키는 snapshot 정보를 볼 수 있다.

### Tag

이미 만들어진 tag는 다음과 같이 확인할 수 있다.

    $ git tag
    v0.1
    v1.3

이름으로 검색하려면 다음과 같이 확인할 수 있다.

    $ git tag -l 'v1.4.2.*'
    v1.4.2.1
    v1.4.2.2
    v1.4.2.3
    v1.4.2.4

#### Lightweight Tag

Lightweight Tag는 순수하게 특정 커밋을 가리키는 것 뿐이다. `git tag mytag`이라고 실행하면 현재 HEAD가 가리키는 커밋을 가리키는 mytag라는 Tag가 만들어진다. `git show mytag`명령으로 언제 어디서든지 mytag가 가리키는 커밋 정보를 확인할 수 있다.

#### Annotated Tag

Lightweight Tag처럼 특정 커밋을 가리키는 데다가 추가 정보를 더해 저장하는 것이다. Tag를 만든 사람의 이름과 email, Tag를 만든 날짜, Tag 메시지 그리고 GPG 서명도 할 수 있다. tag를 만들 때 `-a, -s, -m`을 사용하여 만드는데 여기서는 생략한다.

### 계통

특정 커밋을 기준으로 계통관계를 표시할 수 있다.

커밋 히스토리가 다음과 같을 때:

    :::text
    *   4f2b862 - (HEAD, dev) Merge branch 'issue2' into dev
    |\
    | * 3a6714f - (issue2) It sucks again
    |/
    * 41947a1 - It sucks
    *   3b0b17d - Merge branch 'issue1' into dev
    |\
    | * 3b1bfc5 - (issue1) Add issue1
    |/
    * 40b4870 - (master) Initial Commit

#### '~'

HEAD를 기준으로 이전 커밋을 보려면 `HEAD~`를 사용한다. 예를 들어 `git show HEAD~`라고 실행하면 `41947a1`에 대한 정보를 보여준다.

`~1`이나 `~2`처럼 숫자를 명시하여 이전 커밋이나 이전의 이전 커밋을 나타낼 수 있다. 예를 들어 `git show HEAD~2`는 `3b0b17d`에 대한 정보를 보여준다. `git show HEAD~1`은 `git show HEAD~`의 결과와 똑같다.

HEAD에만 사용할 수 있는 것이 아니다. git은 기본적으로 SHA값을 인식하는 것이지 Branch 이름이나 HEAD같은 포인터를 다루는 것이 아니다. 이 예제에서 HEAD와 dev가 같은 커밋을 가리키기 때문에 `HEAD~`와 `dev~`의 결과는 같고 심지어 `4f2b862~`의 결과도 같다. 

#### '^'

계통을 표시하는 다른 방법으로 `^`도 있다. 이 것은 `~`과 다르게 수평적 조상을 표현하는 방법이다. 사실 `HEAD~`와 `HEAD^`의 결과는 같다. 수직적 조상을 표현하는 `~`와 수평적 조상을 표시하는 `^`는 똑같이 이전 커밋을 나타낸다.

하지만 `HEAD~2`과 `HEAD^2`는 다르다. `HEAD~2`는 `3b0b17d`를 나타내지만 `HEAD^2`는 `3a6714f`를 가리킨다. `^`는 이전 커밋이 두 개 이상인 merge 커밋에만 사용하는 것이 좋다.

`~`과 `^`을 조합하여 복잡한 표현도 가능하다. 이 예제에서 `HEAD~^`는 `HEAD~2`가 가리키는 `3b0b17d`를 가리킨다. 이와 같은 방법으로 `HEAD~2^2`는 `3b1bfc5`를 가리킨다.

`^`는 이전 커밋이 두 개 이상일 때에만 의미있기 때문에 merge 커밋에만 사용한다.

### reflog

reflog로그는 일반적인 커밋 히스토리와 다르다. reflog는 로컬에만 남는 log이고 push해서 다른 사람과 공유할 수 없다. 즉, 이제 막 클론한 저장소라면 현재 HEAD가 가리키고 있는 단 하나의 reflog만 존재할 것이기 때문에 reflog는 클론하고 시간이 흐른 경우에만 유용하다.

reflog는 단순히 HEAD가 가리켰던 히스토리이다. 위에서 사용한 히스토리에서 `git reflog`를 실행하면 다음과 같이 나온다:

    4f2b862 HEAD@{0}: merge issue2: Merge made by recursive.
    41947a1 HEAD@{1}: checkout: moving from issue2 to dev
    3a6714f HEAD@{2}: commit: It sucks again
    41947a1 HEAD@{3}: checkout: moving from dev to issue2
    41947a1 HEAD@{4}: commit: It sucks
    3b0b17d HEAD@{5}: merge issue1: Merge made by recursive.
    40b4870 HEAD@{6}: checkout: moving from master to dev
    40b4870 HEAD@{7}: checkout: moving from issue1 to master
    3b1bfc5 HEAD@{8}: commit: Add issue1
    40b4870 HEAD@{9}: checkout: moving from master to issue1
    40b4870 HEAD@{10}: commit (initial): Initial Commit

reflog는 HEAD나 브랜치가 가리키는 커밋이 바뀔때마다 기록된다. 특정 커밋을 Checkout하면 HEAD가 가리키는 커밋이 바뀌기 때문에 reflog가 남는다. 

`git show HEAD@{4}`는 `41947a1`에 대한 정보를 보여준다. HEAD뿐만 아니라 Branch에도 사용할 수 있다. `git reflog --all` 명령을 실행하면 같은 형식으로 branch 기준으로 보여준다:

    4f2b862 refs/heads/dev@{0}: merge issue2: Merge made by recursive.
    3a6714f refs/heads/issue2@{0}: commit: It sucks again
    41947a1 refs/heads/dev@{1}: commit: It sucks
    3b0b17d refs/heads/dev@{2}: merge issue1: Merge made by recursive.
    3b1bfc5 refs/heads/issue1@{0}: commit: Add issue1
    40b4870 refs/heads/dev@{3}: branch: Created from HEAD

HEAD와 마찬가지로 `git show master@{0}` 명령을 사용할 수 있다.

만약 `git reset --hard HEAD~1`라고 명령을 실행해서 브랜치가 HEAD~1을 가리키도록 했다. 그럼 다음과 같이 reflog가 남는다:

    3a6714f refs/heads/issue2@{0}: commit: It sucks again
    41947a1 refs/heads/dev@{0}: HEAD~1: updating HEAD
    4f2b862 refs/heads/dev@{1}: merge issue2: Merge made by recursive.
    41947a1 refs/heads/dev@{2}: commit: It sucks
    3b0b17d refs/heads/dev@{3}: merge issue1: Merge made by recursive.
    3b1bfc5 refs/heads/issue1@{0}: commit: Add issue1
    40b4870 refs/heads/dev@{4}: branch: Created from HEAD

이전 커밋으로 reset했기 때문에 `4f2b862`에 서 수정한 내용은 없어진다. 이 예제에서는 merge한 것이 취소된다. 그런데 잘못한 행동이라고 깨달았다. SHA 값을 어디 적어두고 다니는 것도 아니고 다시 돌릴 방법이 없다. 이 예제는 merge를 돌린 것이라 다시 merge해도 되지만 수정사항이 담긴 커밋이면 잃어 버리게 된다. 

이 때 `git reflog --all` 명령을 실행시켜서 dev 브랜치가 이전에 가르키던 SHA 값을 찾아서 다시 `git reset --hard 4f2b862`라고 실행해서 복원할 수 있다.

즉, reflog는 로컬 저장소에서 무슨 짓을 했는지 추적해서 문제를 해결하는데 도움이 된다. `git log`는 커밋 히스트로를 보여주지만 `git reflog`는 각 포인터들이 가리켰던 커밋들을 보여준다.

reflog가 특이한점은 SHA 값을 인식하는 것이 아니라는 것이다. 그래서 `git show ca53436@{0}`은 에러가 난다. 꼭 HEAD와 branch 이름만 사용할 수 있다.

`HEAD@{yesterday}` 식으로 순서가 아니라 시간을 명시할 수도 있는데 시간에 관한 용법은 나중에 추가하겠다.

## Range

`git show` 명령처럼 인자로 넘긴 커밋을 single 커밋으로 취급하는 명령어들도 있지만 `git log`처럼 집합으로 취급하는 명령어들도 있다. `git log master`와 같이 명령어를 실행하면 master 브랜치와 그 히스토리를 순서대로 모두 보여준다. 하지면 `git show`는 해당 커밋에 대한 정보만 보여준다.

`git log` 명령이 인식하는 것도 결국 SHA 값이라는 것을 기억해야 한다. master, HEAD, tag등의 포인터를 인자로 넘겨도 결국 git이 인식하는 것은 그 포인터가 가리키는 SHA 값이다. 그래서 SHA값을 직접 사용해도 된다.

![예제](http://progit.org/figures/ch6/18333fig0601-tn.png 예제)
progit의 예제

### Double Dot

'Double Dot'은 브랜치의 히스토리 차이를 비교할 때 사용한다. `master..experiment`는 master에는 없고 experiment에만 있는 것을 의미한다. 반대로 `experiment..master`는 experiment에는 없고 master에만 있는 것을 의미한다. 이 것은 주로 merge하기 전에 차이를 확인해볼 때 주로 사용한다:

    $ git log master..experiment
    D
    C

    $ git log experiment..master
    F
    E

한쪽을 생략하면 HEAD가 사용된다. 즉, `master..`는 `master..HEAD`와 같다.

### Tripple Dot

Tripple Dot은 서로 다른 커밋만을 보여준다. 다음 예제를 보자:

    $ git log master...experiment
    F
    E
    D
    C

`--left-right` 옵션을 추가하면 어느쪽에 속하는 것인지도 보여준다.

    $ git log --left-right master...experiment
    <F
    <E
    >D
    >C

### -not or `^`

이 옵션은 세 개 이상의 브랜치를 서로 비교해볼 때 유용하다. `git log refA refB -not refC`는 `git log refA refB ^refC`와 같고 refA와 refB에는 있지만 refC에는 없는 커밋들을 보여준다.
 
## 참고

 - [progit][]

[progit]: /articles/2011/progit.html

