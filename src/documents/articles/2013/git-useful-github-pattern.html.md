--- yaml
layout: 'article'
title: 'git: Useful GitHub Patterns'
author: 'Changwoo Park, Yongjae Choi'
date: '2013-8-8'
tags: ['git', 'GitHub', 'Jake Benilov']
---

![너의 패턴은 파악되었다!](/articles/2013/git-useful-github-pattern/pattern.jpg)

Jake Benilov님이 쓴 [Useful Github Patterns][]를 번역한 글이다. Jake님은 글이라기보다 요약이나 정리에 가까운 형식으로 썼기 때문에 번역이 어려웠다. 같은 의미로 새로 쓴 게 많아서 오역이 첨가됐을 것 같다.

특히 `Pull Request`를 글로 정리하는 일은 쉽지 않았는데 Jake Benilov님이 잘 설명하신 것 같다.

## USEFUL GITHUB PATTERNS

내 [직업](http://blog.quickpeople.co.uk/2013/05/17/the-uk-government-pays-me-to-write-open-source-all-day/)이나 [오픈소스 활동](http://benilovj.github.io/dbfit/)을 하다보면 git과 GitHub 컨설팅도 하게된다. 그러면서 git과 GitHub을 일정한 패턴에 따라 사용하는 나를 발견했다.

(여기부터는, 'Pull Request'를 PR로 사용한다).

### 1. the peel-off PR

**언제 사용하나?:**

* feature 브랜치에서 뭔가 하고 있는 도중에
* 문제를 발견하자마자 바로 수정하고 싶은데, 현재 추가하는 기능하고 관련이 없는 것일 때( 작은 버그, 오타, 코딩 규칙 위반을 발견했을 때)

**어떻게 하나:**

* 하던 일을 저장(Commit하거나 Stash한다)
* checkout master
* 브랜치를 만든다.
* 문제를 수정하고 PR을 보낸다.
* 다시 원래의 Feature 브랜치로 돌아와 하던 일을 계속한다.
* 나중에 그 PR을 보냈던 브랜치가 merge된 후에 rebase한다.

전혀 다른 문제를 빨리 고치고 싶은 욕망과 Feature 브랜치를 정갈하게 해서 리뷰하기 쉽게 만들고 싶은 욕망을 모두 만족시킬 수 있다.

### 2. the optimistic branch

**언제 사용하나?:**

* 지금은 Merge할 수 없는 브랜치(branch-A)가 있는데(CI 빌드가 깨질 수도 있고, 리뷰어가 바쁠 수도 있다).
* 내가 당장  구현해야 하는 기능은 branch-A의 코드가 필요하다.

**어떻게 하나:**

* branch-A에서 branch-B 브랜치를 만든다.
* branch-A가 master에 머지되면, branch-B를 master에 대해 Rebase하고 충돌 나는게 있으면 해결한다.
* branch-A에 대한 버그픽스는 branch-B에 대해서 Rebase한다.

branch-A에서 코드를 많이 수정하면 충돌날 확률이 높다. 하지만 95% 정도는 잘 된다.

### 3. the heads-up PR

**언제 사용하나?:**

* 리뷰가 필요하지 않는 코드를 작성하고 있지만
* 동료가 알고 있으면 좋을 것 같을 때

**어떻게 하나:**

* 코드를 작성
* PR을 보낸다.
* 피드백을 기다리지 않고 PR을 직접 Merge한다.

GitHub은 PR에 대한 이메일을 동료에게 보낸다. 그래서 맘에 들지 않은 코드를 발견한 동료는 코멘트를 달거나 할 수 있다. 내가 할 일이 별로 없다.

### 4. the sneaky commit

**언제 사용하나?:**

* 코드를 리뷰하고 master에 Merge까지 한 다음에
* 수정할 것이 발견되었는데 너무 사소한 수정(버그픽스나 copy change같은 것)이라서 다른 사람이 알 가치도 없을 때

**어떻게 하나:**

* master 브랜치에 바로 커밋한다.

### 5. the roger roger comment

**언제 사용하나?:**

* 코드 리뷰 중에 바로 적용할만한 피드백을 받았을 때
* 그 피드백에 따라서 고쳤을 때

**어떻게 하나:**

* 고친 커밋의 Ref가 포함된 PR에 코멘트를 한다.
* Ref를 클릭하면 GitHub은 Diff로 다른 부분만 보여준다. 그래서 내 동료들은:
  - Email로 내가 수정했다는 것을 통보 받고
  - 클릭만 하면 간단하게 커밋 Diff를 볼 수 있고
  - 이런식으로 코드 리뷰를 할 수 있다는 것을 안다.

### 6. the creepin’ commit

**언제 사용하나?:**

* 내가 만든 사소한 포멧팅 버그를 발견했을 때(불필요한 공백이나 파일 끝에 한 줄 남기는 것을 빼먹었을 때)나
* 이전 커밋과 논리적으로 같은 커밋이 돼야 할 때
* (실패하는 테스트가 있거나 해서) 아직 커밋할 만한 코드가 아닌 상태에서 하나씩 실험해보고 다시 현재 코드로 되돌리거나 진행하고 싶을 때

**어떻게 하나:**

* 첫번째나 두번째는 그냥 이전 커밋을 수정한다(amend)
* 마지막은 일단 (creeping) 커밋을 하나 만들어 놓고 실험하면서 점진적으로 amend한다. 실험 결과가 안 좋으면 그냥 버린다. 커밋할만한 단계에 도달할 때까지 계속한다.

### 7. the forced branch

**언제 사용하나?:**

* 남이 Push한 Feature 브랜치를 Amend해야 할 때. 예를 들어, 커밋 메시지에 이유를 남기고 싶을 때

**어떻게 하나:**

* 로컬에서 커밋을 Amend한다.
* Feature 브랜치를 리모트 저장소에 강제로(-f 옵션을 주고) Push한다.

보통 리모트 브랜치에 강제로 푸시하는 것은 금단의 영역으로 취급된다. master 브랜치가 아니라면 내 경험상 별로 문제되지 않았다(역주 - Long-Running 브랜치가 아니면 별로 문제될 게 없다). GitHub은 PR 브랜치가 강제로 Push돼도 잘 처리한다. 이전 커밋에 있던 코멘트를 잃어버리거나 하지 않는다.

### 8. the reformat peel-off

**언제 사용하나?:**

* 코드를 수정하면서 코드 포멧도 수정할 계획이라면

**어떻게 하나:**

* 포멧을 수정한 커밋은 master 브랜치에 직접한다.
* 코드를 수정한 커밋이 들어 있는 브랜치는 master대해 Rebase한다.

이럴때 코드 리뷰하는 사람은 코드를 수정한 브랜치에 Diff하는것이 더 좋다. 코드 수정 커밋이 있는 브랜치에는 포멧 수정 커밋이 없기 때문에 Diff 결과가 더 깔끔하다.

### 9. the prototype PR

**언제 사용하나?:**

* 본격적으로 구현하기 전에 아이디어에 대해 피드백을 받고 싶을 때

**어떻게 하나:**

* 브랜치에 뭔가 수정을 한다.
* 아직 완성된 코드가 아니라고 해도 일단 PR을 하면 토론의 시작점이 된다.
* 다음 단계로 뭘 할지 합의가 이루어지면 PR을 닫고 브랜치도 삭제한다.
* 다시 브랜치를 만들고 제대로 구현해서 PR을 한다.

나는 PR이 코드를 다 완성하고 나서 하는 것이라고 생각했었다. 지금은 "Pull Request는 대화의 시작점"이라는 것을 깊히 공감한다. PR과 관련된 GitHub의 기능은(inline comment, reply, notification, diff) 매우 훌륭하다. 코드와 설계에 대해 토론을 많이 하게 해서 개발자가 너무 멀리 가거나 벼랑 끝으로 향하는 일을 미연에 방지해준다.

[Useful Github Patterns]: http://blog.quickpeople.co.uk/2013/07/10/useful-github-patterns/
