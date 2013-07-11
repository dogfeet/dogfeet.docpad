--- yaml
layout: 'article'
title: 'git: ckw Solarized! '
author: 'Changwoo Park'
date: '2013-7-11'
tags: ['git', 'msysgit', 'ckw', 'solarized']
---

[Solarized][]는 적당히 이쁜데다가 다양한 도구에서 사용할 수 있도록 이미 만들어진 테마가 많기 때문에 매우 편리하다. 문득 윈도우에서도 [Solarized][]를 사용하고 싶다는 생각이 들었다.

![](/articles/2013/git-msysgit-ckw-solarized/be-autiful.jpg)

## ckw

cmd 터미널은 너무 구려서 [ckw][]를 사용하고 있는데 찾아보니 [ckw용 Solarized 테마][ckw-solarized]를 만들어 놓은 훌륭한 분이 있었다.

바로 내 설정에 적용했다:

![ckw-solarized](/articles/2013/git-msysgit-ckw-solarized/git-msysgit-ckw-solarized.png)

Putty에도 [Solarized][]를 쓰고 있는데 ckw에도 적용했더니 둘이 많이 비슷해졌다.

하지만 미묘하게 이 ckw의 색감이 떨어진다. [Solarized 저장소](https://github.com/brantb/solarized)에서 배포하고 있는 것 만큼 색감이 좋지는 않다. 눈에 거슬리는 색은 조금씩 변경해서 쓰는게 좋겠다.


위 설정을 적용한 내 설정은 아래와 같다:

```
!
! ckw setting
!

Ckw*title: Powershell
Ckw*exec:  powershell -ExecutionPolicy RemoteSigned
Ckw*chdir: C:\Users\pismute\git

Ckw*scrollHide:  no
Ckw*scrollRight: yes
Ckw*internalBorder: 1
Ckw*lineSpace: 0
Ckw*topmost: no

Ckw*font: NanumGothicCoding
Ckw*fontSize: 22

Ckw*geometry:  80x26
Ckw*saveLines: 10000

!! theme
!! Solarized dark
!!

!Ckw*foreground:     #657b83
Ckw*background:     #073642
!Ckw*cursorColor:    #657b83
Ckw*cursorImeColor: #dc322f
!Ckw*backgroundBitmap: background.bmp
!Ckw*transp:           220
!Ckw*transpColor:      #000000

Ckw*color1:  #586e75
Ckw*color2:  #859900
Ckw*color3:  #2aa198
Ckw*color4:  #cb4b16
Ckw*color5:  #6c71c4
Ckw*color6:  #859900

Ckw*color8:  #839496
Ckw*color9:  #268bd2
Ckw*color10: #859900
Ckw*color11: #2aa198
Ckw*color12: #dc322f
Ckw*color13: #d33682
Ckw*color14: #b58900
Ckw*color15: #fdf6e3
```

[ckw-solarized]: https://gist.github.com/cd01/4307522
[Solarized]: http://ethanschoonover.com/solarized
[ckw]: http://d.hatena.ne.jp/hideden/20071115/1195229532
