--- yaml
layout: 'article'
title: 'Git:Todo Plugin'
author: 'Changwoo Park'
date: '2012-01-21'
tags: ['Git', 'Todo', 'Branch']
---

branch 정보를 요약해주는 Plugin을 만들었다. 각 브랜치에 마지막 커밋 정보(SHA, 메시지, 시각, 커밋터)를 보여주고 그 브랜치가 기준 브랜치에서 얼마나 멀어졌는지 보여준다.

[`git branch -a -v` 명령에 대한 글][git-branch-a-v]을 썼었는데 그 글에 설명한 것을 발전시켜 구현했다. `git-todo` 같이 규모가 작은 프로젝트에서는 별도로 Issue를 관리하고 싶지 않아서 만들었다. 

브랜치 이름과 커밋 메시지를 잘 다듬으면 브랜치 정보를 요약해 보는 것만으로도 해야 할 일이 무엇이고 최근 어디까지 진행했는지 알 수 있다.

Pro Git 저장소를 예제로 사용하여 설명한다:

![git-todo][]

## Usage

 * ![checkouted][]가 표기된 ko 브랜치가 Checkcout한 브랜치다.
 * ![base_branch][]가 표기된 ko 브랜치가 기준 브랜치다. 이 브랜치를 기준으로 다른 브랜치의 ![ahead][]이나 ![behind][]을 계산한다.
 + ![ahead][]가 표기된 private-ko-build-ebook 브랜치는 ko 브랜치에 없는 커밋이 3개 있다는 것을 의미한다.
 + ![behind][]가 표기된 private-ko-build-ebook 브랜치는 ko 브랜치에 있는 커밋이 23개 없다는 것을 의미한다.

기본적으로 로컬 브랜치만 보여준다.

### 기준 브랜치

이 기준 브랜치가 `git branch -a -v`를 쓰지 않고 Plugin을 만든 진짜 이유다. 원하는 브랜치를 기준으로 두고 토픽 브랜치를 만들어 작업할 수 있다.

설정하지 않으면 master 브랜치가 기준 브랜치다. 이 브랜치를 기준으로 다른 브랜치의 거리를 계산한다. 이 브랜치는 다음과 같이 설정한다:

	git config todo.base ko

여기서 보여주는 예제는 Pro Git 저장소를 캡처한 것이기 때문에 기준 브랜치가 ko이다.

### 옵션

기본적으로 로컬 브랜치만 보여주지만, 리모트 브랜치와 tag도 보여준다

#### git todo -r

리모트 브랜치는 노란(똥)색으로 보여준다:

![git-todo-r][]

#### git todo -t

Tag는 흰색으로 보여준다:

![git-todo-t][]

#### git todo -a

로컬 브랜치, 리모트 브랜치, Tag를 모두 보여준다:

![git-todo-a][]

## 설치

[git-todo 저장소][git-todo.repo]를 적당한데다 클론하고 git-todo 파일을 실행 경로에 넣는다:

	cd ~
	git clone https://github.com/pismute/git-todo
	echo "export PATH=~/bin:$PATH" >> ~/.bash_profile
	mkdir ~/bin
	cd ~/bin
	ln -s ~/git-todo/git-todo git-todo

[git-branch-a-v]: /articles/2012/git-branch-a-v.html
[git-todo.repo]: https://github.com/pismute/git-todo

[git-todo]: /articles/2012/git-todo/git-todo.png
[git-todo-r]: /articles/2012/git-todo/git-todo-r.png
[git-todo-t]: /articles/2012/git-todo/git-todo-t.png
[git-todo-a]: /articles/2012/git-todo/git-todo-a.png

[checkouted]: /articles/2012/git-todo/checkouted.png
[base_branch]: /articles/2012/git-todo/base_branch.png
[ahead]: /articles/2012/git-todo/ahead.png
[behind]: /articles/2012/git-todo/behind.png

