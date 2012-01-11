--- yaml
layout: 'article'
title: 'Git:diff'
author: 'Changwoo Park'
date: '2011-12-24'
tags: ['git', 'diff']
---

Git은 명령어가 엄청나게 많지만, 알면 알수록 일관적인 명령어에 감탄하게 된다.
(아무리 그래도 너무 많다.--;)

이 글에서는 `git diff` 명령어의 사용법을 간단히 정리한다.

![heading image](/articles/2011/git-diff/christmas-in-jelly-village.jpg)

산타와 함께 하는 틀린 그림 찾기 "Christmas In Jelly Village". [출처](http://blog.daum.net/_blog/BlogTypeView.do?blogid=0TE6a&articleno=429&categoryId=0&regdt=20100512215001#ajax_history_home)

## Unified Format

`git diff`는 결과를 [Unified Format][diff-unified-format]으로 보여준다. 이 형식에 익숙하지 않으면 링크를 따라가 읽어보는 것이 도움될 것이다. 

## git diff

diff를 잘 활용하자.

### Modified, Staged, Unmodified 사이 비교

Modified(Working Directory에 있는)와 Staged(Staging Area에 있는)는 다음과 같이 비교한다:

    git diff

특정 파일만 비교할 수도 있다:

    git diff my-file

Staged와 Unmodified(HEAD의)는 다음과 같이 비교한다:

    git diff --staged/--cached

`--staged`와 `--cached`는 똑같다. 이것도 특정 파일만 비교할 수 있다:

    git diff --staged my-file

### Revision 비교

리비전 두 개를 골라 비교할 수도 있다:

    git diff bd976f4 59d60f9

그중 파일 하나만 비교할 수 있다:

    git diff bd976f4 59d60f9 my-file

다음처럼도 비교할 수도 있다:

    git diff bd976f4:my-file 59d60f9:my-file

### Modified, Staged와 Revision 비교

Working Directory에 있거나 Staging Area에 수정한 파일을 HEAD의 파일이 아니라 이전 커밋하고 비교할 수도 있다. Working Directory를 `HEAD~18`에 비교할 수 있다:

    git diff HEAD~18

특정 파일만 비교할 수 있다:

    git diff HEAD~18 my-file

Staging Area와 `HEAD~18`과 비교하려면 다음과 같이 한다:

    git diff --staged HEAD~18

이때도 특정 파일만 비교하려면 다음과 같다:

    git diff --staged HEAD~18 my-file

### 파일 이름만 보기

`--name-only` 옵션을 주면 관련 파일을 볼 수 있다. 다음은 해당 커밋에 수정된 파일 목록을 보여준다:

    git show --name-only HEAD~4

다음은 Working Directory와 HEAD~4에서 변경된 파일 이름만 보여준다.

    git diff --name-only HEAD~4

이 옵션은 `git log` 명령에도 사용할 수 있다. 해당 commit에 수정된 파일 이름도 같이 보여준다.

    git log --name-only

[diff-unified-format]: /articles/2011/1316924580.html

