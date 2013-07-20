--- yaml
layout: 'article'
title: 'git: msysgit + pageant'
author: 'Changwoo Park'
date: '2013-7-27'
tags: ['git', 'msysgit', 'pageant']
---

윈도우는 늘 불편하니까 [putty][]를 항상 띄워놓고 서버에서 논다. [msysgit][]을 쓰긴하지만 서버에서 놀기에 로컬에서는 설정 백업할 때나 사용했다. 최근 로컬에서도 git을 사용하는 빈도가 늘면서 매번 인증서 암호를 입력하는게 너무 불편했다. 왠지 [pageant][]와 연동이 잘될 것 같아서 Google님에게 물어보니 바로 나온다.

![select-plink](/articles/2013/git-msysgit-pageant/msysgit-pageant.png)

## pageant

[msysgit][]을 설치할 때 [plink][]를 선택하면 바로 동작한다. plink를 사용해서 뭘하려고 한적이 없어서 모르고 있었다:

![select-plink](/articles/2013/git-msysgit-pageant/msysgit-plink.png)

설치할 때 [OpenSSH][]를 사용하도록 설치했더라도 `$GIT_SSH` 환경 변수에 plink를 지정해주면 된다:

```
export GIT_SSH=/my/path/plink.exe
```

그리고 나서 사용하면 바로 pageant를 사용할 수 있는데, `git fetch` 명령으로 테스트를 해보면 아직 서버랑 인사 안했다고 다음과 같은 에러를 뱉는다:

```
$ git fetch
The server's host key is not cached in the registry. You
have no guarantee that the server is the computer you
think it is.
The server's rsa2 key fingerprint is:
ssh-rsa 2048 97:8c:1b:f2:6f:14:6b:5c:3b:ec:aa:46:46:74:7c:40
Connection abandoned.
fatal: Could not read from remote repository.
```

서버랑 인사를 한번해야 한다:

```
$ plink git@github.com
The server's host key is not cached in the registry. You
have no guarantee that the server is the computer you
think it is.
The server's rsa2 key fingerprint is:
ssh-rsa 2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
If you trust this host, enter "y" to add the key to
PuTTY's cache and carry on connecting.
If you want to carry on connecting just once, without
adding the key to the cache, enter "n".
If you do not trust this host, press Return to abandon the
connection.
Store key in cache? (y/n) y
Using username "git".
Server refused to allocate pty
Hi pismute! You've successfully authenticated, but GitHub does not provide shell access.
```

서버가 'Hi pismute!'라고 인사를 한다. 서버의 키는 레지스트리에 저장된다. 이제 실행하면 잘된다.

키를 자동으로 저장하는 방법이 있을 것 같은데 찾지 못했다. [Quest의 plink](http://rc.quest.com/topics/putty/)에는 `-auto_store_key_in_cache` 옵션이 있어서 자동으로 저장해주도록 만들 수 있는데, 이건 왠일인지 msysgit과 연동이 잘 안된다.

> 검색하다보니 [ssh-pageant][]라는 게 있어서 Cygwin에서는 openSSH 명령어 까지 pageant를 사용하도록 설정할 수 있는 것 같은데 msys 용은 아직 없는 것 같다.

[putty]: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
[pageant]: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
[plink]: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
[msysgit]: http://msysgit.github.io/
[OpenSSH]: http://www.openssh.org/

[ssh-pageant]: https://github.com/cuviper/ssh-pageant
