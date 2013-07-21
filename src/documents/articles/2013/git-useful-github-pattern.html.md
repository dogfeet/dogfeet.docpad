--- yaml
layout: 'article'
title: 'git: Useful GitHub Patterns'
author: 'Changwoo Park, Yongjae Choi'
date: '2013-7-20'
tags: ['git', 'GitHub', 'Jake Benilov']
---

Jake Benilov님이 쓴 [Useful Github Patterns][]를 번역한 글이다. Jake님은 글이라기보다 요약이나 정리에 가까운 형식으로 썼기 때문에 번역이 어려웠다. 같은 의미로 글을 새로 쓴 게 많아서 오역이 첨가됐을 것 같다.

특히 `Pull Request`를 글로 정리하는 일은 쉽지 않았는데 Jake님이 잘 설명하신 것 같다.

![너의 패턴은 파악되었다!](/articles/2013/git-useful-github-pattern/pattern.jpg)

## USEFUL GITHUB PATTERNS

내 [직업](http://blog.quickpeople.co.uk/2013/05/17/the-uk-government-pays-me-to-write-open-source-all-day/)이나 [오픈소스 활동](http://benilovj.github.io/dbfit/)을 하다 보면 git과 GitHub 컨설팅도 하게 된다. 그러면서 git과 GitHub을 일정한 패턴에 따라 사용하는 나를 발견했다.

(여기부터는, 'Pull Request'를 PR로 사용한다).

### 1. The peel-off PR

**언제 사용하나?:**

* Feature 브랜치에서 뭔가 하는 도중에
* 문제를 발견하자마자 바로 수정하고 싶은데, 현재 추가하는 기능과 관련이 없을 때( 작은 버그, 오타, 코딩 규칙 위반을 발견했을 때)

**어떻게 하나?:**

* 하던 일을 저장(Commit하거나 Stash한다)
* checkout master
* 브랜치를 만든다.
* 문제를 수정하고 PR을 보낸다.
* 다시 원래의 Feature 브랜치로 돌아와 하던 일을 계속한다.
* 나중에 그 PR을 보냈던 브랜치가 Merge된 후에 Rebase한다.

전혀 다른 문제를 빨리 고치고 싶은 욕망과 Feature 브랜치를 정갈하게 해서 리뷰하기 쉽게 만들고 싶은 욕망을 모두 만족하게 할 수 있다.

### 2. The optimistic branch

**언제 사용하나?:**

* 지금은 Merge할 수 없는 브랜치(branch-A)가 있는데(CI 빌드가 깨질 수도 있고, 리뷰어가 바쁠 수도 있다).
* 내가 당장 구현해야 하는 기능은 branch-A의 코드가 필요하다.

**어떻게 하나?:**

* branch-A에서 branch-B 브랜치를 만든다.
* branch-A가 master에 Merge되면, branch-B를 master에 대해 Rebase하고 충돌 나는 게 있으면 해결한다.
* branch-A에 대한 버그픽스 브랜치들은 branch-B에 대해서 Rebase한다.

branch-A에서 코드를 많이 수정하면 충돌 날 확률이 높아진다. 하지만, 95% 정도는 잘 된다.

### 3. The heads-up PR

**언제 사용하나?:**

* 리뷰가 필요하지 않은 코드를 작성하고 있지만
* 동료가 알고 있으면 좋을 것 같을 때

**어떻게 하나?:**

* 코드를 작성
* PR을 보낸다.
* 피드백을 기다리지 않고 PR을 직접 Merge한다.

GitHub은 PR에 대한 이메일을 동료에게 보낸다. 그래서 맘에 들지 않은 코드를 발견한 동료는 코멘트를 달거나 할 수 있다. 내가 할 일이 별로 없다.

### 4. The sneaky commit

**언제 사용하나?:**

* 코드를 리뷰하고 master에 Merge까지 한 다음에
* 수정할 것이 발견되었는데 너무 사소한 수정(버그픽스나 copy change같은 것)이라서 다른 사람이 알 가치도 없을 때

**어떻게 하나?:**

* master 브랜치에 바로 커밋한다.

### 5. The roger roger comment

> 역주: GitHub 이슈 넘버를 넣고 push하면 커밋 넘버에 대한 링크가 해당 이슈 코멘트에 댓글로 달리는 기능에 대해 말하는 것 같다. [Introducing Issue Mentions](https://github.com/blog/957-introducing-issue-mentions) 참고.

**언제 사용하나?:**

* 특정 브랜치에 대한 피드백을 받았는데 바로 적용하고 싶을 때
* 그 피드백에 따라서 고쳤을 때

**어떻게 하나?:**

* 고친 커밋의 Ref가 포함된 PR에 코멘트를 단다.
* GitHub은 똑똑해서 Ref를 클릭했을 때 이전 커밋과의 Diff 결과만 보여준다. 그래서 내 동료는:
  - Email로 내가 수정했다는 것을 통보받고
  - 클릭만 하면 간단하게 커밋 Diff를 볼 수 있고
  - 이런 식으로 코드 리뷰를 할 수 있다는 것을 안다.

> 역주: PR을 통해서 코드까지 포함된 피드백을 받든지, 단순히 이슈로 피드백을 받든지 간에 이슈와 코드를 함께 묶어서 토론할 수 있는 점을 말하는 것 같다. 이슈와 관련된 사람은 토론 내역을 Email로 통보받고 Push한 커밋에 대한 diff 결과도 웹에서 쉽게 확인할 수 있다.

### 6. The creepin’ commit

**언제 사용하나?:**

* 내가 만든 사소한 포매팅 버그를 발견했을 때(불필요한 공백이나 파일 끝에 한 줄 남기는 것을 빼먹었을 때)나
* 이전 커밋과 논리적으로 같은 커밋이 돼야 할 때
* (실패하는 테스트가 있거나 해서) 아직 커밋할 만한 코드가 아닌 상태에서 하나씩 실험해보고 다시 현재 코드로 되돌리거나 진행하고 싶을 때

**어떻게 하나?:**

* 첫 번째나 두 번째는 그냥 이전 커밋을 수정한다(Amend)
* 마지막은 일단 (Creeping) 커밋을 하나 만들어 놓고 실험하면서 점진적으로 Amend한다. 실험 결과가 안 좋으면 그냥 버린다. 커밋할만한 단계에 도달할 때까지 계속한다.

### 7. The forced branch

**언제 사용하나?:**

* 남이 Push한 Feature 브랜치를 Amend해야 할 때. 예를 들어, 커밋 메시지에 이유를 남기고 싶을 때

**어떻게 하나?:**

* 로컬에서 커밋을 Amend한다.
* Feature 브랜치를 리모트 저장소에 강제로(-f 옵션을 주고) Push한다.

보통 리모트 브랜치에 강제로 Push하는 것은 금단의 영역으로 취급된다. master 브랜치가 아니라면 내 경험상 별로 문제 되지 않았다(역주 - Long-Running 브랜치가 아니면 별로 문제 될 게 없다). GitHub은 PR 브랜치가 강제로 Push돼도 잘 처리한다. 이전 커밋에 있던 코멘트를 잃어버리거나 하지 않는다.

### 8. The reformat peel-off

**언제 사용하나?:**

* 코드를 수정하면서 코드 포멧도 수정할 계획이라면

**어떻게 하나?:**

* 포멧을 수정한 커밋은 master 브랜치에 직접 한다.
* 코드를 수정한 커밋이 들어 있는 브랜치는 master대해 Rebase한다.

이럴 때 코드 리뷰하는 사람은 코드를 수정한 브랜치에 Dill 하는 것이 더 좋다. 코드 수정 커밋이 있는 브랜치에는 포멧 수정 커밋이 없어서 Diff 결과가 더 깔끔하다.

### 9. The prototype PR

**언제 사용하나?:**

* 본격적으로 구현하기 전에 아이디어에 대해 피드백을 받고 싶을 때

**어떻게 하나?:**

* 브랜치에 뭔가 수정을 한다.
* 아직 완성된 코드가 아니라고 해도 일단 PR을 하면 토론의 시작점이 된다.
* 다음 단계로 뭘 할지 합의가 이루어지면 PR을 닫고 브랜치도 삭제한다.
* 다시 브랜치를 만들고 제대로 구현해서 PR을 한다.

나는 PR이 코드를 다 완성하고 나서 하는 것으로 생각했었다. 지금은 "Pull Request는 대화의 시작점"이라는 것을 깊이 공감한다. PR과 관련된 GitHub의 기능은(Inline Comment, Reply, Notification, Diff) 매우 훌륭하다. 코드와 설계에 대해 토론을 많이 하게 해서 개발자가 너무 멀리 가거나 벼랑 끝으로 향하는 일을 미리 방지해준다.

[Useful Github Patterns]: http://blog.quickpeople.co.uk/2013/07/10/useful-github-patterns/
