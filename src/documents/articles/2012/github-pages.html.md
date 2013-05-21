--- yaml
layout: 'article'
title: 'GitHub의 페이지 기능 이용하기'
author: 'Yongjae Choi'
date: '2012-10-10'
tags: ['github', 'git', 'pages', 'blog']
---

GitHub의 Pages 기능을 이용하는 방법에 대해 정리해보고자 한다. @pismute님의 '한 때 버전 컨트롤, 위키, 블로그를 다 따로 사용했었는데, GitHub를 알고 나서 Git, GitHub으로만 사용하고 있다'는 말을 듣고 블로깅을 GitHub로 해보면 어떨까 하는 생각이 들었다. GitHub의 Page 기능을 이용하면 이 블로그처럼 글을 써서 남길 수 있다.
GitHub의 [help 페이지에 있는 Pages의 글](https://help.github.com/categories/20/articles) 들중 몇 가지만 빼고 한국어로 옮겨봤다.

![help](/articles/2012/github-pages/github-help.jpg)

## 1. GitHub의 Pages란?
GitHub의 Pages란(이하 페이지) GitHub에서 무료로 호스팅하는 공개 웹페이지이다. GitHub에서 제공하는 페이지 제작 도구로 쉽게 페이지를 만들어 공개할 수도 있고, 로컬에서 git을 이용해 수동으로 만들 수도 있다.

## 2. 사용자와 프로젝트를 위한 페이지
우리는 두 가지 타입의 페이지를 만들 수 있다. 사용자 페이지와 프로젝트 페이지가 그것이다. 이 둘은 몇 가지 사항을 빼고는 거의 똑같다. (역자주 : 원문에는 User, Organization and Project Page라고 나와있다. 하지만 User와 Organization을 나누는 것은 계정을 혼자 사용하느냐 여럿이서 사용하느냐에 따른 차이일 뿐이다. 사용 방법에는 아무런 차이가 없으므로 이 글에서는 뭉쳐서 사용자라고만 표기한다.)

### 사용자 페이지
사용자 페이지는 페이지만을 위한 특별한 저장소에 저장한다. 이 저장소의 이름은 계정 이름을 사용한다. 만약 계정이 dogfeet라면 이 조직을 위한 저장소의 이름은 [dogfeet/dogfeet.github.io](https://github.com/dogfeet/dogfeet.github.io) 이 된다.

* 저장소의 이름은 반드시 `username/username.github.com`의 구조를 가진다.
* __master__ 브랜치의 내용이 곧 페이지에서 보이는 내용이다.

> __알아둘 것__: 사용자 페이지의 저장소는 반드시 그 자신의 계정 이름밖에 사용하지 못한다. 다시 말해서 `joe/bob.github.com`식의 저장소는 페이지로 작동하지 않는다.

### 프로젝트 페이지
사용자 페이지와는 다르게 __프로젝트 페이지__는 그 프로젝트의 저장소를 그대로 사용한다. (새로 저장소를 만들 필요 없다.) 그렇게 만들어진 페이지는 몇 가지를 제외하고 사용자 페이지와 완전히 똑같다.

* 페이지를 만들거나 퍼블리싱 할 때에 __gh-pages__ 브랜치를 사용한다.
* 커스텀 도메인을 사용하지 않으면 프로젝트 페이지는 사용자 페이지의 서브 경로로 제공된다. 주소는 `username.github.com/projectname`의 형태를 띈다.
* 커스텀 404 에러 페이지를 사용하려면 커스텀 도메인을 사용해야 한다. 커스텀 도메인을 사용하지 않으면 사용자 페이지의 404 에러 페이지를 사용하게 된다.

## 3. 자동으로 페이지 만들기
프로젝트나 사용자의 페이지를 빠르게 만들려면 GitHub에서 제공하는 페이지 제작 도구를 이용한다.

### 사용자 페이지
사용자 페이지를 만들려면 우선 `username.github.com`이나 `orgname.github.com`이란 이름의 저장소를 만들어야 한다. 물론 여기서 username이나 orgname은 자기 자신의 github계정 이름이어야 한다. 그렇지 않으면 페이지는 만들어지지 않는다. 저장소의 admin 페이지에 가면 제작 도구를 사용할 수 있다.

### 프로젝트 페이지
모든 프로젝트 저장소에서 페이지를 만들고 퍼블리싱 할 수 있다. 하지만 주의할 것은 비공개 저장소에서 만든 페이지는 공개 페이지가 된다. (비공개 페이지를 만들 수 없다.)

### 자동 페이지 제작 도구
1.	저장소의 admin 페이지로 간다.
	
	![repo-actions-admin](/articles/2012/github-pages/repo-actions-admin.png)
2.	"Automatic Page Generator" 버튼을 클릭한다.
	
	![pages-automatic-page-generator](/articles/2012/github-pages/pages-automatic-page-generator.png)
3.	마크다운 에디터로 내용을 작성한다.
4.	"Continue To Layouts" 버튼을 누른다.
5.	제공되는 테마들을 적용해서 미리보기로 확인한다.
	
	![page-generator-picker](/articles/2012/github-pages/page-generator-picker.png)
6.	좋아하는 테마를 발견했으면 "Publish"를 클릭한다.
	
	![page-generator-publish](/articles/2012/github-pages/page-generator-publish.png)

페이지가 만들어진 후에 로컬에 복사본을 얻을 수 있다. 프로젝트 페이지를 만들었다면 새로운 브랜치를 fetch 후 checkout 한다.

	$ cd repo
	$ git fetch origin
	remote: Counting objects: 92, done.
	remote: Compressing objects: 100% (63/63), done.
	remote: Total 68 (delta 41), reused 0 (delta 0)
	Unpacking objects: 100% (68/68), done.
	From https://github.com/user/repo.git
	 * [new branch]      gh-pages     -> origin/gh-pages

	$ git checkout gh-pages
	Branch gh-pages set up to track remote branch gh-pages from origin.
	Switched to a new branch 'gh-pages'

사용자 페이지를 만들었다면 페이지 코드는 gh-pages 브랜치가 아니라 master 브랜치에 페이지의 코드가 들어있다. 따라서 그냥 master 브랜치를 check out 한 뒤 pull 명령을 내리면 된다.

	$ cd repo
	$ git checkout master
	Switched to branch 'master'
	$ git pull origin master
	remote: Counting objects: 92, done.
	remote: Compressing objects: 100% (63/63), done.
	remote: Total 68 (delta 41), reused 0 (delta 0)
	Receiving objects: 100% (424/424), 329.32 KiB | 178 KiB/s, done.
	Resolving deltas: 100% (68/68), done.
	From https://github.com/user/repo.git
	 * branch      master     -> FETCH_HEAD
	Updating abc1234..def5678
	Fast-forward
	index.html                                     |  265 ++++
	...
	98 files changed, 18123 insertions(+), 1 deletion(-)
	create mode 100644 index.html
	...

## 4. 수동으로 페이지 만들기
git을 command-line으로 사용해왔다면 수동으로 새로운 페이지를 만드는 건 어렵지 않다.

### 안전하게 가자
프로젝트에 페이지를 만들어 넣으려면 저장소에 "부모가 없는(orphan)" 브랜치를 만들어야 한다. 이걸 하는 가장 안전한 방법은 우선 새로 저장소를 클론하는 것이다.

	git clone https://github.com/user/repo.git
	Clone our repo

	Cloning into 'repo'...
	remote: Counting objects: 2791, done.
	remote: Compressing objects: 100% (1225/1225), done.
	remote: Total 2791 (delta 1722), reused 2513 (delta 1493)
	Receiving objects: 100% (2791/2791), 3.77 MiB | 969 KiB/s, done.
	Resolving deltas: 100% (1722/1722), done.

### 이제 놀자!
깨끗한 저장소를 손에 넣었다. 이제 새로운 브랜치를 만들고 작업 디렉토리와 인덱스의 모든 내용을 지워야 한다.

	$ cd repo

	$ git checkout --orphan gh-pages
	Creates our branch, without any parents (it's an orphan!)

	Switched to a new branch 'gh-pages'

	git rm -rf .
	Remove all files from the old working tree

	rm '.gitignore'

> __알아둘 것__: `gh-pages` 브랜치는 처음 커밋이 되기 전까지는 `git branch`의 브랜치 목록에 나타나지 않는다.

비어있는 작업 디렉토리를 얻었다. 이 안에 내용을 채워넣고 GitHub로 푸시하면 된다. 예를 들자면 다음과 같다.

	$ echo "My GitHub Page" > index.html
	$ git add .
	$ git commit -a -m "First pages commit"
	$ git push origin gh-pages

> __알아둘 것__: 최초의 푸시를 한 뒤에 페이지가 보이기까지는 몇 분 정도 기다려야 한다.

## 5. Jekyll과 페이지
일반적인 HTML 컨텐츠를 지원하는 차원에서 GitHub의 페이지는 [Jekyll](https://github.com/mojombo/jekyll)을 지원한다. (역자주: '지킬 박사와 하이드'의 지킬이다.) Jekyll은 'Tom Preston-Werner'이 제작한 간단한 스태틱 사이트 제네레이터이다. Jekyll을 이용하면 웹사이트 전체에 적용되는 헤더, 푸터를 파일을 여러 번 복제하지 않고도 만들 수 있다. 블로그 기능이나 멋진 템플릿 기능들도 지원한다.

### Jekyll 사용하기
GitHub의 모든 페이지는 Jekyll로 돌아간다. 일반 HTML 파일 또한 유효한 Jekyll 사이트이기 때문에 이미 가지고 있던 HTML 파일들을 수정하지 않아도 된다. 그냥 전부 HTML 파일이면 괜찮다. [README](https://github.com/mojombo/jekyll/blob/master/README.textile)에 Jekyll의 기능들과 그 사용법이 적혀있다.

### Jekyll 설정하기
`_config.yml` 파일에 Jekyll의 대부분의 설정이 다 들어있다. 퍼머 링크의 스타일이나 마크다운 렌더러를 Maruku에서 RDiscount로 바꿀 수도 있다. 아래와 같은 옵션만 바꾸면 된다.

	safe: true
	source: <your pages repo>
	destination: <the build dir>
	lsi: false
	pygments: true

### Troubleshooting
사이트를 GitHub에 푸시 후에도 Jekyll 사이트가 보이지 않는다면 Jekyll을 로컬에서 돌려보면 여러 오류를 잡을 수 있다. 이 기능을 위해 GitHub에서 사용하는 것과 같은 버전의 Jekyll을 사용하길 바란다.

GitHub의 페이지 서버는 Jekyll 버전 0.11.0, Liquid 버전 2.2.2를 사용하고 다음 명령어로 실행을 시킨다.

	$ jekyll --pygments --no-lsi --safe

만약 GitHub에 푸시하고도 페이지가 만들어지지 않으면 '페이지가 안 보여요'가이드를 보라.

#### Jekyll 끄기
Jekyll을 그만 사용하려면 저장소의 루트에 `.nojekyll`이란 이름의 파일을 만들고 푸시하기만 하면 된다. 

### 기여하기
Jekyll에 필요한 기능이 있으면 주저하지 말고 [fork](https://github.com/mojombo/jekyll) 한 뒤에 풀 리퀘스트를 보내면 된다. 이런 건 언제든지 환영한다

## 6. 페이지에 커스텀 도메인 설정하기
GitHub의 페이지에 사용자가 지정하는 도메인 이름을 설정해줄 수 있다.

### 저장소에 도메인 설정하기.
우리가 가지고 있는 도메인이 `example.com`라 치고 이걸 우리 페이지에 연결해보자. GitHub에게 이 도메인으로 서비스해주세요~ 라고 말하는 건 쉽다. 페이지의 루트에 CNAME 이라는 파일을 하나 만들고 도메인 이름을 적어넣으면 된다.

	example.com

> __알아둘 것__: 이 파일을 만들고 GitHub에서 페이지를 성공적으로 만들었다는 알림을 확인한 후에 다음 단계인 'DNS 세팅하기'를 시작해야 한다.

만약 __사용자 페이지__ 저장소에서 작업하고 있다면 이 일은 __master__브랜치에서 해야 하고 __프로젝트 페이지__ 저장소라면 __gh-pages__브랜치에서 작업을 해야 한다.

> __알아둘 것__: 하나의 페이지에는 하나의 커스텀 도메인만 할당할 수 있다. 만약 같은 페이지에 여러 도메인을 할당하고 싶다면 다른 도메인에서 당신의 페이지로 리다이렉트 해주는 서비스 등을 이용해야 할 것이다.

### DNS 세팅하기
다음은 DNS를 세팅할 차례이다. 세팅은 사용하는 도메인의 종류에 따라서 두 가지 방법으로 나눌 수 있다.

아, DNS 변경이 전 세계로 퍼지기까지는 약 하루가 걸린다. 인내를 가지고 기다려야 한다.

#### Top-level 도메인 (TLD)
`example.com`과 같은 TLD은 __A 레코드__가 204.232.175.78를 가리키도록 해야 한다.

	$ dig example.com +nostats +nocomments +nocmd
	# Look up DNS record for example.com
	;example.com.                    IN      A
	example.com.             3259    IN      A       204.232.175.78

> __경고__: TLD에는 CNAME 레코드를 사용하면 안 된다. CNAME 레코드를 쓰면 해당 도메인의 다른 서비스들(예를 들면 이메일 같은)에 문제가 생길 수 있다.

#### 서브 도메인
서브 도메인을 할당하려면 __CNAME 레코드__로 사용자 페이지 서브 도메인을 가리키는게 최고다. 이 방법을 이용하면 GitHub 서버의 IP가 바뀌어도 자동으로 조정해준다. CNAME 레코드는 A 레코드 위에 쓸 수도 있다. 하지만 이 정보는 자동으로 업데이트 되지 않는다.

	$ dig www.example.com +nostats +nocomments +nocmd
	;www.example.com.                 IN      A
	www.example.com.          3592    IN      CNAME   username.github.com.
	username.github.com.      43192   IN      A       204.232.175.78

### 자동 리다이렉트
커스텀 도메인을 세팅하면 서버는 자동으로 몇 가지 리다이렉트 기능을 제공한다.

* 사용자 페이지에서는 `username.github.com` ⇒ `example.com`
* TDL에서는 `www.example.com` ⇒ `example.com`
* www 서브 도메인을 사용 중이라면 `example.com` ⇒ `www.example.com`

`www` ⇔ TLD 리다이렉트가 동작하려면 TLD와 `www` 서브 도메인 DNS의 레코드가 페이지의 서버를 가리키고 있어야 한다.

> __알아둘 것__: 사용자 페이지의 커스텀 도메인은 자체의 커스텀 도메인을 가진 프로젝트 페이지는 제외하고 그 계정 아래에 있는 모든 프로젝트 페이지를 같은 도메인으로 리다이렉트한다.

> __경고__: `http://username.github.com/projectname`과 같은 프로젝트 페이지의 서브 경로는 프로젝트의 커스텀 도메인으로 리다이렉트 되지 않는다.

### 실제 예제
[mojombo.github.com](http://github.com/mojombo/mojombo.github.com/) 은 [tom.preston-werner.com](http://tom.preston-werner.com/) 로 리다이렉트 된다. 커스텀 도메인은 [이 파일](https://github.com/mojombo/mojombo.github.com/blob/master/CNAME)에 정의되어 있다.

### Troubleshooting
커스텀 도메인 설정에 문제가 생기면 [이 가이드](https://help.github.com/articles/my-custom-domain-isn-t-working)를 보면 된다.

## 7. 커스텀 404 페이지
404.html 파일을 저장소의 루트에 넣어두면 기존 404페이지 대신 저장소의 404.html 페이지를 보여준다. 404 페이지는 반드시 html 파일이어야 한다.

> __알아둘 것__: 커스텀 404 페이지는 페이지 도메인의 루트에 존재해야만 작동한다. 커스텀 도메인을 사용하지 않는 프로젝트 페이지의 커스텀 404 페이지는 동작하지 않는다. (프로젝트 페이지는 루트도메인 외에 프로젝트 이름이 경로에 추가되므로)

### 실제 예제
[Tekkub의 404](http://github.com/tekkub/tekkub.github.com/blob/master/404.html) 페이지는 [tekkub.net/404.html](http://tekkub.net/404.html) 에서 볼 수 있다.

## 8. 페이지가 안 보여요. "unable to run Jekyll!"
가끔 페이지는 푸시 후에 빌드에 실패해서 "unable to run jekyll"이라는 에러를 내뱉을 때가 있다. 이 에러가 나올 수 있는 몇몇 원인을 알아보자.

### 저수준 태그 에러
Jekyll은 현재 저수준의 Liquid 태그에 대한 [이슈사항](https://github.com/mojombo/jekyll/issues/425)이 있다. 만약 이 기능을 사용한다면 템플릿에 중괄호 등을 이스케이프 시킬 때는 HTML 이스케이프 시퀀스 같은 방법을 사용하는 등의 우회로를 찾아야 한다.

### 안전하지 않은 플러그인
페이지의 서버는 안전하다고 확인되지 않은 플러그인은 빌드하지 않는다. `_plugins`폴더에 있는 모든 플러그인 또한 이 규칙에 적용받는다.
이 문제는 두 가지 해결책이 존재한다.

* 안전하지 않은 플러그인을 지운다. 또는
* 소스 파일 대신에 페이지를 로컬에서 빌드하고 그 결과 파일을 푸시한다.

두 번째 해결책이 [Octopress](http://octopress.org/)가 취하고 있는 전략이다.

### 문법 에러
때로 타이핑을 잘못 했다던가 하는 이유로 빌드가 실패하는 때도 있다. 이는 [jekyll](http://jekyllrb.com/)을 로컬에서 `jekyll --safe`를 이용해 확실히 잡아야 한다. GitHub에서 사용하는 서버에서 사용하는 jekyll의 버전은 Jekyll과 페이지 섹션에서 알 수 있다.

### 소스 세팅
GitHub의 빌드 서버는 당신의 페이지를 빌드할 때 `source` 세팅을 덮어쓴다. 만약 당신이 이 세팅을 바꾼다면 페이지가 빌드되지 않을 수도 있다.

## 9. 프로젝트 페이지 지우기
프로젝트 페이지를 없애려면 `gh-pages` 브랜치를 지우면 된다.

	$ git push origin --delete gh-pages
	Delete the gh-pages branch from origin
	
	To https://github.com/username/repo.git
	- [deleted]         gh-pages

## 10. 브랜치 모델
섹션 9 까지는 번역이었고, 10 부터는 dogfeet 블로그에서 사용하는 브랜치 모델에 대해서 설명하려 한다. 어렵지 않으나 중요하므로 얼른 하고 마치자.

### draft/* 브랜치
모든 글은 각자 하나의 브랜치를 가진다. 이 글은 `draft/github-pages`라는 브랜치 위에서 작성 중이다. 이 블로그의 모든 글이 `draft/`라는 접미사를 가진 브랜치를 가지고 있었다. 각 글들은 자신의 브랜치 위에서 작성되고 다른 사람들과 공유하여 리뷰를 받는다. 추가돼야 할 내용이나 오타, 비문 등을 지적받고 다시 고친 뒤에 커밋 한다. 
글이 완성되면 저장용, 공유용 커밋들을 rebase를 이용해 합쳐서 1~2개의 커밋으로 정리한다. 이는 중앙 저장소의 히스토리를 예쁘게 유지하기 위함이다. 히스토리가 복잡해지면 같이 공유하는 사람에 대한 예의에 어긋난다. (...) 사람마다 다르겠지만 내 경우에 완전한 창작 글은 하나의 커밋으로 합치고 번역 글은 markdown으로 포메팅된 원문이 보존된 커밋 하나와 완성된 번역문 두 개로 정리한다.
정리가 다 되면 ready 브랜치로 합친다.

### ready 브랜치
정리된 draft 브랜치는 ready 브랜치로 합친다. dogfeet은 완성된 글을 곧바로 퍼블리싱하지 않고 ready 브랜치에 먼저 저장한다. 그리고는 매 주마다 master 브랜치를 ready 브랜치로 fast-forwording하여 실제 웹페이지로 보이도록 발행한다. 저장은 merge나 rebase를 하는데 둘 중에 어떤 것을 할지는 [이 글](/articles/2012/git-merge-rebase.html)을 참고 하길 바란다.

master 브랜치는 항상 fast-forwording만 한다.

### 정리
하나의 글을 퍼블리싱 하는 프로세스는 다음과 같다.

1. master 브랜치에서 draft/<어쩌구 저쩌구> 라는 이름으로 새로운 브랜치를 딴다.
2. 글을 쓰고 커밋을 정리한다. 필요에 따라 서로 리뷰를 부탁하기도 한다.
3. ready로 merge 하거나 rebase 시킨다.
4. ready 브랜치를 master 브랜치로 fast-forword 한다.

