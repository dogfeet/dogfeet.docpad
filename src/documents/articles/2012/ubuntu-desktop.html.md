--- yaml
layout: 'article'
title: 'Ubuntu'
author: 'Changwoo Park'
date: '2012-4-28'
tags: ['ubuntu']
---

Ubuntu 12.04 릴리즈를 기념해서 Ubuntu Desktop 설치 노트를 만들었다. 이번 프로젝트에서는 Linux가 주 플랫폼인데 Linux가 필요해서 Ubuntu Desktop을 설치했다.

![ubuntu](/articles/2012/ubuntu-desktop/ubuntu.png)

만날 X 없이 Server만 깔아서 쓰다가 Desktop을 설치했는데 너무 편하다. 앞으로는 Ubuntu Desktop을 많이 쓸 것 같다.

## 할 일

 * /tmp를 tmpfs로 만들기

noexec로 하면 `/tmp`에 압축을 풀고 설치하는 인스톨러들이(특히 오라클 제품들...) 실패한다. 보안을 위해 noexec로 설명하는 글들이 많은데, 서버가 아니니 exec로 하도록 하자.

    #/etc/fstab
    tmpfs            /tmp           tmpfs   defaults,exec,nosuid 0       0

 * apt source를 ftp.daum.net로 변경. - System Settings/Software Sources
 * virtual kernel 설치.
 * dselect 설치 - `sudo apt-get install dselect`
 * vmware tools 설치 - `sudo apt-get install open-vm-dkms`
 * 나눔폰트 설치 - `sudo apt-get install ttf-nanum ttf-nanum-coding ttf-nanum-extra`
 * 한글설정 - System Settings/Language Support
 * 폰트, 폰트 크기 변경 - `sudo apt-get install gnome-tweak-tool`
 * git 설치 - git
 * 7zip 설치 - p7zip, p7zip-full
 * nvm, node를 위해 - curl, libss-dev
 * vim - default는 vim-tiny
 * 가끔 필요 - jekyll

이걸 다 더하면:

    sudo apt-get install dselect open-vm-dkms ttf-nanum ttf-nanum-coding ttf-nanum-extra gnome-tweak-tool git p7zip p7zip-full curl libss-dev vim ruby ruby1.9.1 ruby1.9.1-dev

    sudo gem install jekyll

### chrome 설치

인증서를 등록하고:

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

apt source 등록:

    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

update하고:

    sudo apt-get update

안정 버전을 설치한다:

    sudo apt-get install google-chrome-stable

[원문](http://www.howopensource.com/2011/10/install-google-chrome-in-ubuntu-11-10-11-04-10-10-10-04/)

### sumlime text

 * [sublime text 설치](http://www.webupd8.org/2011/03/sublime-text-2-ubuntu-ppa.html)

### ubuntu one

모류 5G라, home directory를 백업하기 적당해 보인다.

백업하지 않을 디렉토리:

    .nvm
    .npm
    .jenkins
    .m2
    .cache #chrome cache
    .mozilla/firefox #firefox cache

### git-svn, svn

12.04에서만 발생하는 에러일 수도 있지만 당분간 해결되지 않을 것 같은 느낌이다. SVN에서 https인 저장소에 접근하면 다음과 같은 에러가 발생한다.

    └─▪ git svn dcommit
    Committing to https://my.svn/trunk ...
    RA layer request failed: OPTIONS of 'https://my.svn/trunk': SSL handshake failed: SSL error: Key usage violation in certificate has been detected. (https://my.svn) at /usr/lib/git-core/git-svn line 577

뭐 이런 에러가 발생하면 다음과 같이 임시로 조치할 수 있다.:

    sudo apt-get install libneon27
    cd /usr/lib
    sudo mv libneon-gnutls.so.27 libneon-gnutls.so.27.old
    sudo ln -s libneon.so.27.2.6 libneon-gnutls.so.27

임시로 이렇게 우회할 수 있지만 Ubunut가 자동으로 복구한다.

그냥 간단하게 스킴을 https가 아니라 http로 해주는 게 더 편하다.

### USB에 있는 Ubuntu를 VM에서 부팅 하고자 할 때

USB에 우분트를 설치한 게 있는데 그걸 VM에서 부팅하고 싶다면 [Plop Boot Manager]로 부팅시킬 수 있다.

[Plop Boot Manager]: http://www.plop.at/en/bootmanager/plpbt.bin.html
