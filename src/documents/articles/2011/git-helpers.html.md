--- yaml
layout: 'article'
title: '힘내:git-helpers'
author: 'Changwoo Park'
date: '2011-12-01'
tags: ['힘내', 'git']
---

git을 사용할 때 유용한 설정, 도구등을 모아 정리해보려고 합니다.

![힘내](/articles/2011/git-/git-.png "힘내")

## git alias

만들어 쓰면 편리한 git alias를 정리합니다.

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

이건 좀 많이 편리합니다. 우연히 인터넷에서 줍은( ? ) 건데 너무 편리합니다. 현 브랜치의 히스토리를 short SHA값, author 정보, 커밋 트리 그리고 히스토리에서 특정 커밋을 가르키는 refs(브랜치, 태그 등)가 있는지도 보여줍니다. 각각의 요소를 다른 색으로 칠해줍니다.

    # Pimp-out log:
    # From: http://www.jukie.net/bart/blog/pimping-out-git-log
    git config --global alias.lg "log --name-status --color --abbrev-commit --date=relative --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"


