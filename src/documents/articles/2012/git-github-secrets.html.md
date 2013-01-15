--- yaml
layout: 'article'
title: 'Git: GitHub secrets'
author: 'Changwoo Park'
date: '2012-12-29'
tags: ['Git', 'GitHub', 'holman', 'Zach Holman', 'RedDotRubyConf']
---

이글은 @holman님이 싱가폴에서 열린 [RedDotRubyConf](http://reddotrubyconf.com/)에서 발표한 [Git and GitHub Secrets](http://zachholman.com/talk/git-github-secrets)에 설명을 달았다. 내용이 길어서 둘로 나눴는데 이 글은 `GitHub Secetets` 부분을 정리한 글이다. [Git Secrets](/articles/2012/git-secrets.html)은 다른 글에서 정리한다.

![holman](/articles/2012/git-github-secrets/holman.png)

이 글을 정리하면서 그림을 많이 삽입하지 않았다. `GitHub Secrets` 부분은 그림이 너무 많아서 생략했다. 이 글을 읽고서 슬라이드를 한번 보는게 좋을 것 같다.

## 숨겨진 기능

GitHub은 단순함을 추구한다. 그래서 GitHub에는 기능이 많은 데도 불구하고 굳이 화면에 보여주지 않는다.

### .patch, .diff

커밋 URL 뒤에 .patch나 .diff 붙이면 해당 포멧의 파일이 나온다. 정확하게는 'Compare View, Pull Requests, Commit Pages' 화면에서 사용할 수 있다.

* [.diff 예제](https://github.com/dogfeet/dogit/commit/a1f156b6415439a8a84c3d2fa89ea975fb3a7ac2.diff)
* [.patch 예제](https://github.com/dogfeet/dogit/commit/a1f156b6415439a8a84c3d2fa89ea975fb3a7ac2.patch)

## 공백문자는 무시하고 diff를 보여준다.

diff URL끝에 `?w=1`를 붙이면 공백문자를 무시한 결과를 보여준다.

![ignore_whitespace](/articles/2012/git-github-secrets/ignore-whitespace.png)

### SVN 클라이언트도 지원.

'SVN/Git 서비스 레이어'가 있어서 SVN 요청을 Git 요청으로 변환해준다.

당연히 Git 클라이언트를 사용할 수 있지만:

```sh
$ git clone https://github.com/dogfeet/dogit.git
```

SVN 클라이언트도 사용할 수 있다:

```sh
$ svn checkout https://github.com/dogfeet/dogit.git
```

### SSH & HTTP => HTTP & SSH

GitHub은 기본 프로토콜을 SSH에서 HTTP로 바꿨다. 원래 HTTP 프로토콜을 사용하는 방식은 성능이 후져서 SSH를 권장했는데 이제 SmartHTTP 덕택에 HTTP도 효율적이다.

원래 SSH를 먼저 보여줬었지만:

![before](/articles/2012/git-github-secrets/ssh-http.png)

지금은 HTTP를 먼저 보여준다:

![after](/articles/2012/git-github-secrets/http-ssh.png)

이제 HTTP도 효율적이기 때문에 1) 회사 방화벽 뒤에서도 맘껏 GitHub을 즐길 수 있고 2) SSH Key를 사용하기 힘든 Windows 환경에서도 사용하기 쉬워졌다. SSH key없이도 암호를 메모리에 저장해서 사용할 수 있다. 이 방법은 git 1.7.10부터 사용할 수 있고 GitHub의 [패스워드 캐싱하는 방법](https://help.github.com/articles/set-up-git)에 잘 설명돼 있다.

#### SmartHTTP

SmartHTTP는 git 1.6.6부터 지원한다. git 1.6.6은 2009년 말에 배포됐다.

Git은 개체를 'Packfile'이라는 덩어리에 묶어서 관리한다. 이전 버전에서는 사용자가 'Packfile'에 들어 있는 개체 한 개가 필요해도 `Packfile`을 통째로 전송해야 했다. 그래서 HTTP를 더미 프로토콜이라고 불렀다. 이제는 SmartHTTP가 있어서 'Packfile'에서 필요한 개체만 꺼내서 전송할 수 있다.

progit 책을 집필할 때에는 SmartHTTP가 없었기 때문에 이를 설명하지 않았다. SmartHTTP에 대해서 자세히 알아보려면 progit 9장과 [Smart HTTP Transport](http://git-scm.com/2010/03/04/smart-http.html)를 읽는게 좋다.

### URL에서 '.git'은 생략해도 된다.

```
git clone https://github.com/holman/boom.git
git clone https://github.com/holman/boom
```

### GitHub HD(tm)

GitHub 페이지의 아이콘이 HD 벡터 아이콘이라서 계속 확대해도 깨지지 않는다.

### Auditing

우리말로 하자면 '감사로그' 쯤 되는 건데, GitHub에서 일어난 중요한 액션은 로그가 남는다:

https://github.com/settings/security

### Octocat

@defunkt님이 에러페이지에 사용할 이미지를 찾다가 [Istockphoto](http://www.istockphoto.com/)에서 싸게 산 이미지였는데 사람들이 좋아해서 지금은 GitHub의 마스코드가 됐다. 처음에는 아니였지만 지금은 GitHub이 저작권을 가지고 있다.

[Octocat 스토리](http://www.quora.com/GitHub/What-is-the-story-behind-GitHub%E2%80%99s-octocat-mascot)는 Quora에서 참고.

http://octodex.github.com/ 에 가면 Octocat 이미지가 많다.

### git.io

GitHub용 URL Shortner이다. 작은 [쉘 스크립트](git.io/nxVVig)로 구현돼 있고 다음과 같이 사용한다.

```sh
$ gitio <url> <name>
```

[Chrome Extension](https://chrome.google.com/webstore/detail/gitio-url-shortener/baceaeopmlhkjbljoiinmbnnmpokgiml)도 있다.

### Linguist

저장소에 든 언어가 뭔지 찾아서 직접 그 저장소에서 개발된 파일만 추려서 'Syntax Highlighting'도 해준다. GitHub은 이 Linguist를 다음과 같은 걸 만들어 내는데 사용한다:

![linguist](/articles/2012/git-github-secrets/linguist.png)

기능:

* 'Language Detection' - 어떤 언어가 사용됐는지 찾는다.
* 'Stats' - 언어 통계를 알려준다.
* 'Syntax Highlighting' - Pygments를 사용한다.
* 'Vendored Files' - 저장소에 들어 있는 파일 중 다른 프로젝트에서 가져온 파일. ex) jquery.js
* 'Generated file detection' - 생성되는 파일을 알아서 제외한다.

### email reply

이메일로 comments에 답변을 달 수 있다.

### gist

단순히 코드 snippet을 공유하는 도구가 아니다. 코멘트, 스크린샷, 코드를 공유를 할 수 있기 때문에 프로토타이핑 도구로 사용하기에도 좋다. 개발자와 디자이너 모두에게 유용하다.

gist 자체가 git 저장소이기 때문에 clone할 수도 있다:

```
git clone git://gist.github.com/2720312
```

간단하게 만들어서 프로토타이핑을 해보기에 아주 좋다.

#### microgems.

Ruby Gem으로도 사용할 수 있는 것 같다. 나는 Ruby를 몰라서 알 수 없다.

http://jeffkreeftmeijer.com/2011/microgems-five-minute-rubygems/

### Image View Mode

Gist에 이미지를 올리고 비교하면 비교해보기 좋게 나열해준다. 정말 쩐다. 데모 페이지에 가서 클릭해보자.

이 기능은 [KaleidoScope](http://www.kaleidoscopeapp.com/)같은 도구에서 있는 건데 GitHub도 된다. [SourceTree](http://www.sourcetreeapp.com/)같은 데서도 가능하면 좋겠다.

GitHub의 [Behold: Image view modes](https://github.com/blog/817-behold-image-view-modes)에 잘 소개돼 있다.

### Command Line GitHub - hub

[hub](https://github.com/defunkt/hub)라는 프로그램이 있다. Command Line에서 GitHub을 사용할 수 있는 명령이다. git + github 명령이라고 생각하면 된다. GitHub을 사용하면서 자동화한다면 꼭 필요한 툴이라고 생각된다. 나중에 따로 정리해야 겠다.

### Keyboard Shortcuts

GitHub의 모든 페이지에서 `?`를 누르면 그 페이지에서 사용할 수 있는 단축키를 보여준다.

### Subscribing People

GitHub에서 글쓸때 `@pismute`쓰면 해당 사용자에게 알림이 간다. `@org/team`라는 팀 표현식도 있어서 팀 전체한테 노티를 줄수도 있다.

### GitHub Flavored Markdown

[GFM](http://github.github.com/github-flavored-markdown/)에 대한 설명도 있다.

### Auto-Closing Issues

커밋메시지에 `CLOSES/CLOSED/CLOSE #1`나 `FIXES/FIXED/FIX #1`라고 쓰면 해당 이슈가 자동으로 닫힌다.

### Commit by Author

GitHub의 커밋 페이지에서 `?author=holman` 처럼 파라미터를 넘기면 해당 사용자의 커밋만 볼 수 있다:

* https://github.com/progit/progit/commits/master?author=pismute

### Branch-to-Branch

Pull Request는 브랜치 단위로 하는 거라는 얘기. 그래서 원 저장소가 아니라 Clone 저장소에도 Pull Request를 보낼 수 있다.

### emoji!

GitHub에서 emoji 이모티콘을 사용할 수 있다. 사용할 수 있는 이모티콘은 http://www.emoji-cheat-sheet.com/ 에서 참고.

### Link Linking

GitHub 페이지에서 파일 보기 화면에서 URL 뒤에 `#L16`을 붙이면 16라인이 노랗게 보인다. `#L16-32`를 붙이면 16라인부터 32라인까지 노랗게 보인다. 다른 사람과 코드에 대해 수다떨 때 어떤 라인에 대해서 얘기하는 건지 콕 집어 줄 수 있다.

### Advanced Compare View

`github.com/user/repo/compare/{range}`과 같은 형식의 URL을 사용하면 되고 `{range}`부분에 다음과 같이 넣을 수 있다:

* `master@{1.day.ago}...master`
* `master@{yesterday}...master`
* `master@{2012-02-25}...master`

아래와 같이 사용한다:

https://github.com/dogfeet/dogit/compare/master@{60.day.ago}...master

