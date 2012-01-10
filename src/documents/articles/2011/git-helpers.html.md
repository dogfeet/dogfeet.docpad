--- yaml
layout: 'article'
title: 'Git:git 도우미'
author: 'Changwoo Park'
date: '2011-12-01'
tags: ['git']
---

git에 좋은 설정, 도구, 읽을 거리등 git에 관한 잡다한 정보를 정리한다.

![heading image](/articles/2011/git.png)

## git alias

만들어 쓰면 편리한 git alias를 정리한다.

### 단순 약어

    # Abbreviations
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.br branch
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.cs "commit -s"

`commit -s`은 signed commit인데 

### git log

이건 좀 많이 편리하다. 우연히 인터넷에서 줍은( ? ) 건데 너무 편리하다. 현 브랜치의 히스토리를 short SHA값, author 정보, 커밋 트리 그리고 히스토리에서 특정 커밋을 가르키는 refs(브랜치, 태그 등)가 있는지도 보여준다. 게다가 각각의 요소를 다른 색으로 칠해주기까지...

    git config --global alias.lg "log --name-status --color --abbrev-commit --date=relative --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

브랜치를 중심으로 히스토리를 보고 싶으면 다음과 같이 사용하는 게 좋다.

    git config --global alias.tree "log --graph --decorate --pretty=oneline --abbrev-commit --all"

## 읽을 거리

 * [progit][] - git 학생용
 * [A Visual Git Reference][] - git의 핵심 용어를 이해하는데 유용함.
 * [Git In The Trenches][] - git 선생용

[progit]: /articles/2012/progit.html
[Git In The Trenches]: http://cbx33.github.com/gitt/
[A Visual Git Reference]: http://marklodato.github.com/visual-git-guide/index-ko.html

## github

### widget

 * [gitview][] - github 저장소를 보여주는 widget
 * [githubbadge][] - github 계정 요약을 보여주는 widget

[gitview]: http://gitview.logicalcognition.com/
[githubbadge]: http://githubbadge.appspot.com/

