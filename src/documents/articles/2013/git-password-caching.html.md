--- yaml
layout: 'article'
title: 'git: password caching'
author: 'Changwoo Park'
date: '2013-3-28'
tags: ['git', 'password', 'http', 'https']
---

요즘은 뭐든 Smart한 시대인지라 http(s) 프로토콜도 Smart하지 않을 수 없다([Smart http][]). [Pro Git](http://git-scm.com/book/ko)에서는 http(s)가 Smart하지 않다고 설명하지만 그건 [Pro Git][]이 출간되고 나서 만들어진 거라 책에는 내용이 빠져 있다. 이제는 ssh를 사용하든 http(s)를 사용하든 효율의 차이는 없다.

ssh는 회사 방화벽에서 막아버릴 수도 있고 익명접근도 허용하지 않지만, http(s)는 그런 게 없다. GitHub도 이제는 ssh가 아닌 http(s)가 기본이다(https 주소를 먼저 보여준다):

![](/articles/2013/git-password-caching/http-ssh.png)

그런데 ssh는 인증서를 사용하면 ssh-agent를 사용하면 암호를 한 번만 입력할 수 있는데, http(s)에서는 Basic 인증을 통해서 인증하는지라 다른 메커니즘이 필요하다. 이 글은 GitHub help 페이지에 있는 Password Caching을 요약한 글이다.

## Password Caching.

*Git버전이 1.7.10 이상 돼야 한다. 그래야 이 기능을 사용할 수 있다.*

나는 주로 ssh를 사용하므로 http(s)를 잘 사용하지 않는다. ssh에 익숙해져서 http(s)가 더 어색하다. 하지만, gist에서는 http(s)를 사용하는 것이 편하다. GitHub이 Gist에서는 git 프로토콜 주소를 안내하지 않고 있다:

![](/articles/2013/git-password-caching/gist-clone.png)

화면의 주소는 다음과 같은 형태다:

```
https://gist.github.com/xxxxxxxxxxxxxxxxxxxx.git
```

ssh 프로토콜로도 사용할 수 있긴 하다. 단지 복사해서 붙여 넣을 수 없을 뿐이다:

```
git@gist.github.com:xxxxxxxxxxxxxxxxxxxx.git
```

gist는 git을 이용하지만 전문 버전관리 도구가 아니라 프로토타이핑 도구라서 http(s) 프로토콜만으로도 충분할 수 있다. 그래도 명령을 실행할 때마다 암호를 입력하는 일은 좀 불편하다. http(s)에도 ssh처럼 사용할 수 있는 매우 편리한 방법이 있다.

### Linux

다음과 같이 설정하면 한번 입력한 암호가 저장된다:

```
% git config --global credential.helper cache
```

기본적으로 15분 저장해주는데 다음과 같이 기간을 수정할 수 있다:

```
% git config --global credential.helper 'cache --timeout=3600'
```

'ssh-agent'로 하는 것과 거의 비슷하다.

### Mac

Mac에서는 'osxkeychain credential helper'라는 게 있어서 ssh처럼 keychain을 사용할 수 있다.

먼저 osxkeychain이 잘 동작하는지 확인하고:

```
% git credential-osxkeychain
Usage: git credential-osxkeychain <get|store|erase>
```

설치돼 있지 않으면 아래와 같이 설치한다:

```
% git credential-osxkeychain
git: 'credential-osxkeychain' is not a git command. See 'git --help'.

% curl -s -O http://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
% chmod u+x git-credential-osxkeychain
% sudo mv git-credential-osxkeychain `dirname \`which git\``
```

'credential helper'로 osxkeychain을 사용할 것이라고 알린다.:

```
% git config --global credential.helper osxkeychain
```

이제 ssh를 사용할 때는 ssh 인증서가 사용되고 http(s)를 사용할 때는 'osxkeychain credential helper'가 사용된다.

이렇게 설정하면 CLI뿐만 아니라 [SourceTree][]같은 GUI에서도 매번 암호를 입력하지 않을 수 있다.

### Windows

[git-credential-winstore](http://blob.andrewnurse.net/gitcredentialwinstore/git-credential-winstore.exe)를 내려받아서 실행경로에 넣고 한번 실행해준다. 그러면 msysgit 에서 잘 사용할 수 있다. 'GitHub for Windows'에는 이미 포함돼 있어서 별도로 설치할 필요가 없다.

Windows XP에서는 SourceTree를 설치할 수 없어서 확인하지 못했다.

[Pro Git]: http://git-scm.com/book/ko
[Smart Http]: http://git-scm.com/2010/03/04/smart-http.html
[SourceTree]: http://www.sourcetreeapp.com/
