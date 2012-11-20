--- yaml
layout: 'article'
title: 'Git: rerere'
author: 'Changwoo Park'
date: '2012-11-22'
tags: ['git', 'rerere', 'Reuse Recored Resolution']
---

왠지 '거꾸로 해도 이효리'가 떠오르는 이 이름, 명령어는 외우기는 쉽지만, 용법을 이해하는 데는 공을 좀 들여야 한다.

어떤 Topic 브랜치는 오랫동안 Merge하지 않고 유지하기도 한다. 이런 Topic 브랜치를 Merge하면 Conflict가 날 확률이 높다. Conflict가 예상되는 브랜치를 Merge할 때 `git rerere` 명령으로 난관을 극복하는 방법을 알아보자.

![overcome](/articles/2012/git-rerere/overcome.jpg)

이 글은 [Rerere your boat...][rerere-your-boat]을 주로 참고 했다. 내용은 거의 같다.

## rerere(Reuse Recorded Resolution)

`rerere`는 간단히 말하자면 Conflict를 해결한 Resolution을 저장해두고 같은 Conflict가 나면 저장한 Resolution을 재사용하는 명령이다.

Conflict가 발생하면 우선 conflict를 해결한 다음에, 다시 Merge하기 전으로 돌아와서 다시 Merge하면 저장된 Resolution이 적용돼서 Conflict 없이 자동으로 Merge된다.

어떻게 보면 말장난 같아 보일 수도 있다. Conflict를 Resolve하는 실험을 하고 실험에 성공하면 수동으로 그 실험을 재현해서 적용한다. 실패하면 다시 처음으로 돌아와 다시 시도한다. 그런데 이때 성공한 실험 내용을 기록해 뒀다가 자동으로 다시 적용하면 매우 편리할 것이다. **`rerere` 옵션을 켜면 Conflict를 Resolve하는데 성공하면 그 내용을 자동으로 저장해주고 같은 일을 다시 시도하면 git이 자동으로 재현해준다.**

그러면 이 명령어 어떻게 동작하는지 예제와 함께 살펴보자.

### 설정

`rerere` 기능은 설정해야 사용할 수 있다:

```sh
% git config --global rerere.enabled 1
```

각 저장소에 `.git/rr-cache` 디렉토리를 만들어도 이 기능이 켜지지만, 그냥 `--global`에 설정하자.

### Hello World

`hello.js` 프로그램 하나인 프로젝트가 있다. master 브랜치의 `hello.js` 프로그램은 아래와 같다:

```javascript
#!/usr/bin/env node

console.log( 'hello world')
```

그리고 아래와 같이 프로젝트를 진행한다. master 브랜치의 메시지를 'hola world'로 변경하고 i18n-world 브랜치의 메시지는 'hello mundo'로 변경한다:

![rerere1](/articles/2012/git-rerere/rerere1.png)

이 상태에서 Merge를 하면 Conflict가 난다. 이 예제의 Conflict는 너무 간단해서 Recorded Resolution이 필요하지 않지만 `rerere`를 설명하기에는 더없이 좋은 예다.

### Recored Resolution 만들기

@chacon님은 쓴 원래 글에서는 Conflict를 해결하는 브랜치에 바로 Merge하는 방법으로 Resolution을 만들었다. 그리고 Reset한 후에 다시 Merge해서 Resolution을 저장했다. 이 글에서는 detached HEAD를 이용하는 방법을 설명한다. 뭐 결과는 같지만 난 이 방법이 더 좋다.

먼저 detached HEAD 상태로 만든다:

```sh
% git checkout HEAD^0
Note: checking out 'HEAD^0'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at 7d71bbe... hola world
```

master 브랜치가 가리키는 `7d71bbe`를 checkout 했기 때문에 워킹 디렉토리 내용은 master 브랜치와 같다. 단지 'detached HEAD' 상태인 것만 다르다. 그래서 여기서 커밋을 하면 'detached HEAD' 상태로 커밋된다. master 브랜치는 움직이지 않는다.

그러면 여기서 Merge한다:

```sh
% git merge i18n-world
Auto-merging hello.js
CONFLICT (content): Merge conflict in hello.js
Recorded preimage for 'hello.js'
Automatic merge failed; fix conflicts and then commit the result.
```

보통 Conflict 날 때의 상황과 다르게 "Recorded preimage for 'hello.js'" 라는 메시지를 추가로 보여준다. `rerere`를 켰기 때문에 생겼다.

`git status`는 Conflict가 있다고 아래와 같이 알려준다:

```sh
% git status
# Not currently on any branch.
# Unmerged paths:
#   (use "git add/rm <file>..." as appropriate to mark resolution)
#
#       both modified:      hello.js
#
no changes added to commit (use "git add" and/or "git commit -a")
```

`git diff`라고 실행하면 어느 부분에서 Conflict가 난 것인지 보여준다:

```sh
diff --cc hello.js
index 68d2f27,2c3b5e5..0000000
--- a/hello.js
+++ b/hello.js
@@@ -1,4 -1,4 +1,8 @@@
  #!/usr/bin/env node

++<<<<<<< ours
 +console.log( 'hola world')
++=======
+ console.log( 'hello mundo')
++>>>>>>> theirs
```

이제 'hello.js' 파일을 편집해서 'hola mundo'로 Conflict를 해결하고 저장한다. 아직 Resolve를 Mark하지 않은 상태에서 `git diff`를 실행하면 아래와 같이 나온다:

```sh
diff --cc hello.js
index 68d2f27,2c3b5e5..0000000
--- a/hello.js
+++ b/hello.js
@@@ -1,4 -1,4 +1,4 @@@
  #!/usr/bin/env node

- console.log( 'hola world')
 -console.log( 'hello mundo')
++console.log( 'hola mundo')
```

이 명령은 'hola world'가 'hello mundo'와 Merge돼서 'hola mundo'가 되는 거라고 보여준다. 그런데 웬걸 `git add` 명령으로 Resolution을 Mark하면 `git diff` 명령은 더는 이런 메시지를 보여주지 않는다. 대신 `git rerere diff`를 사용해야 한다:

```sh
--- a/hello.js
+++ b/hello.js
@@ -1,8 +1,4 @@
 #!/usr/bin/env node

-<<<<<<<
-console.log( 'hello mundo')
-=======
-console.log( 'hola world')
->>>>>>>
+console.log( 'hola mundo')
```

Resolution은 다 만들었고 이제 커밋한다:

```sh
% git commit -m 'sample resolution'
Recorded resolution for 'hello.js'.
[detached HEAD f35bf55] sample resolution
```

"Recorded resolution for 'hello.js'"라는 메시지는 Resolution이 저장됐음을 보여주는 것이고 "detached HEAD"는 detached HEAD 상태에서 커밋했기 때문에 보여주는 것이다.

이제 Resolution은 다 만들었다. Conflict를 해결하는 실험을 성공적으로 마친 것이다. 이 실험 결과를 실전에 적용해보자.

## rerere

i18n-world를 master로 Merge하기 전에 i18n-world를 Rebase한다. 먼저 i18n-world를 Checkout한다:

```sh
% git co i18n-world
Warning: you are leaving 1 commit behind, not connected to
any of your branches:

  f35bf55 sample resolution

If you want to keep them by creating a new branch, this may be a good time
to do so with:

 git branch new_branch_name f35bf550d886286e5e75569fb9597c664cd7743d

Switched to branch 'i18n-world'
```

detached HEAD에서 벗어난다는 경고 메시지를 보여준다. 그리고 Rebase한다:

```sh
% git rebase master
First, rewinding head to replay your work on top of it...
Applying: hello mundo
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging hello.js
CONFLICT (content): Merge conflict in hello.js
Resolved 'hello.js' using previous resolution.
Failed to merge in the changes.
Patch failed at 0001 hello mundo

When you have resolved this problem run "git rebase --continue".
If you would prefer to skip this patch, instead run "git rebase --skip".
To check out the original branch and stop rebasing run "git rebase --abort".
```

"Resolved 'hello.js' using previous resolution" 메시지가 추가돼 있다. 편집기로 hello.js를 열어보면 좀 전에 만들었던 Resolution대로 파일이 Resolve됐음을 알 수 있다. `git diff` 명령으로 차이를 확인할 수 있다:

```sh
% git diff
diff --cc hello.js
index 68d2f27,2c3b5e5..0000000
--- a/hello.js
+++ b/hello.js
@@@ -1,4 -1,4 +1,4 @@@
  #!/usr/bin/env node

- console.log( 'hola world')
 -console.log( 'hello mundo')
++console.log( 'hola mundo')
```

![rerere1](/articles/2012/git-rerere/rerere3.png)

그러면 이 상태에서 Resolution을 Mark하고 `git rebase --continue`를 실행하면 Rebase가 완료된다. 아래와 같이 실행한다:

```sh
# git add .
# git rebase --continue
Applying: hello mundo
```

`rerere`를 이용한 Merge를 마쳤다. 'detached HEAD' 상태를 만들어서 Conflict를 해결하는 실험을 하고 Resolution을 만들어 놓는다. 그다음에 다시 Merge를 하면 만들어 놓은 Resolution이 재사용된다. 그래서 명령어 이름이 'rerere(REuse REcorded REsolution)'이다.

### Resolution을 재사용하지 않기

Resolution을 Mark하기 전으로 돌아가 보자. `git rebase master`를 실행하면 자동으로 저장된 Resolution이 적용된다. 그 상태로 돌아가서 `git diff`를 실행하면 결과는 아래와 같다:

```sh
% git diff
diff --cc hello.js
index 68d2f27,2c3b5e5..0000000
--- a/hello.js
+++ b/hello.js
@@@ -1,4 -1,4 +1,4 @@@
  #!/usr/bin/env node

- console.log( 'hola world')
 -console.log( 'hello mundo')
++console.log( 'hola mundo')
```

여기서 git이 자동으로 적용해준 Resolution이 마음에 들지 않으면 다시 Conflict 파일을 생성할 수 있다:

```sh
% git checkout --conflict=merge hello.j
% cat hello.js
#!/usr/bin/env node

<<<<<<< ours
console.log( 'hola world')
=======
console.log( 'hello mundo')
>>>>>>> theirs
```

`--conflict` 옵션은 Conflict를 해결할 때 사용하면 유용하다. `merge` 대신 `diff3`를 사용하면 base Commit의 것도 알 수 있다. Checkout명령은 `.git` 데이터베이스에 들어 있는 내용을 워킹 디렉토리로 복사하는 명령이다. 이 명령을 실행하면 충돌이 표시된 hello.js파일이 워킹 디렉토리에 생성된다:

```sh
% git checkout --conflict=diff3 hello.js
% cat hello.js
#!/usr/bin/env node

<<<<<<< ours
console.log( 'hola world')
||||||| base
console.log( 'hello world')
=======
console.log( 'hello mundo')
>>>>>>> theirs
```

이제 원하는 데로 편집하고 `git add .;git rebase --continue` 명령을 실행하면 Rebase는 완료된다. 하지만, 저장해둔 Resolution을 다시 적용하고 싶어지면 아래와 같이 복원한다:

```sh
% git rerere
Resolved 'hello.js' using previous resolution.
% cat hello.js
#!/usr/bin/env node

console.log( 'hola mundo')
```

Conflict를 다시 해결했으니 계속 진행해서 Rebate를 완료한다:

```sh
# git add .
# git rebase --continue
Applying: hello mundo
```

이상으로 `rerere` 명령에 대해 알아보았다.

## 참고

* [git-rerere][]
* [Rerere your boat...][rerere-your-boat]
* [Fun with rerere][fun-with-rerere]

[git-rerere]: http://www.kernel.org/pub/software/scm/git/docs/git-rerere.html
[rerere-your-boat]: http://git-scm.com/2010/03/08/rerere.html
[fun-with-rerere]: http://gitster.livejournal.com/41795.html
