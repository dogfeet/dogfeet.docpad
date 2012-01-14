--- yaml
layout: 'article'
title: 'Pro Git 번역 회고'
author: 'Sean Lee, Changwoo Park'
date: '2012-1-12'
tags: ['회고', 'retrospection', 'progit', '번역']
---

허접하게 나마 [Pro Git][progit]을 번역했다. 시간도 부족하고 경험도 부족했다. 부족한 점을 극복하기 위해 번역관련 책도 사서 읽고 새로운 도구와 방법도 찾아서 익혔다. 이 포스트에서는 어떻게 번역을 했는지 그리고 무엇을 배웠는지 얘기하고자 한다.

![progit](/articles/2011/progit/progit.book-big.jpg)

## 힘들구나 번역. 알면서도 왜 했었나?

**Lee** &raquo; 번역은 그 길이가 짧든 길든 간에 쉽지 않은 작업이다. 짧으면 짧은대로 길면 긴대로... Pro Git 번역 프로젝트는 적지 않은 양이었다. 전에도 함께 했었던 [Grails User Manual 번역][]이나, 번역 도중에 엎어진 모 책의 번역 작업을 생각해 봤을 때 스스로에 대한 큰 보상 없이 시작하기가 쉽지는 않았다.

**Lee** &raquo; Pro Git의 경우 Git에 대한 다른 좋은 Article들도 수 없이 많지만 Git을 사용하는데 있어서 정말 정리가 잘 되어있는 책이라고 함께 번역을 한 창우형이 엄청 칭찬을 했다. 읽어보니 확실히 궁금한 부분, 몰랐던 부분에 대한 빠짐없는 정리가 잘 되어 있다. 게다가 알아야 할 부분에 대한 내용이 깊지만 쉬운 글로 잘 풀어져 있다. 게다가 감사하게도 무료!

**Lee** &raquo; 또한 Pro Git의 출력물도 한 번 짚어볼만 하다. 앞서 책을 번역했던 프로젝트에서는 각 프로젝트에 맞게 한 가지 형태 즉 html로만 혹은 epub로만, pdf로만 출력을 뽑아냈었다. Pro Git은 하나의 Source로 한 번에 다수의 형태로 출력물을 뽑아내는 재밌는 프로젝트이다. 배워두면 쓸일있지 않을까?

**Park** &raquo; 2010년에 SVN 쓰면서 브랜치 관리로 골머리를 썩었었다. Spring+Maven으로 나름 갖은 트릭은 다 부렸는데도 잘 안되더라. 사실 그때도 Git이 좋다는 것은 알고 있었다. 그런데 위험요소를 회피하느라 피했지만 후회했다. SVN으로 브랜치 여러개를 동시에 관리하는 게 더 힘들다.

**Park** &raquo; Git은 정말 기능도 많고 설명도 많다. 일단 사다리를 그려줄 자료가 필요했다. 그래서 몇 가지를 검토한 후 progit을 읽었다. Chapter 순으로 읽으면 결국 이해되도록 잘 쓴 책이라 꼭 번역해야 겠다고 생각했다.

[Grails User Manual 번역]: http://dogfeet.github.com/grails-doc/guide/

## 뭘 가지고 어디에서 작업했나

**Lee** &raquo; 무엇부터 이야기해야 하나... 우선 나는 작은 13인치 MBP와 iMac을 주로 사용하였다. 집이나 카페(주로 스타벅스)에서는 MBP를 사용했으며 일터에서는 틈틈히 iMac을 사용하였다. MBP의 사용이 4/5 이상일 것이다. 

<img alt="MBP" width="500" src="/articles/2012/progit/mbp.jpg" />

**Park** &raquo; 나도 주로 집과 카페에서 했다. 특히 죽치고 않아 있기엔 스타벅스가 커피가 싸다. '싱글 벤티 드립'을 시키면 4~5시간은 버틸 수 있다. 다른 카페에서는 양이 작아서 두 잔 마셔야 된다.

**Park** &raquo; 2007년형 white MacBook으로 작업했다. Mac을 사용할 수 없을 때도 많아서 원격으로 접속해서 Ubuntu에서 작업하기도 했다.

<img alt="MBP Cafe" height="500" src="/articles/2012/progit/mbp-cafe.jpg" />

**Lee** &raquo; epub와 mobi 포맷을 확인하기 위해서 아이폰과 아이패드의 iBooks, Kindle 앱을 사용했다.

<img alt="iBooks" height="500" src="/articles/2012/progit/ibooks.jpg" />

**Lee** &raquo; 글쓰기를 위해서 [WriteRoom](http://www.hogbaysoftware.com/products/writeroom)을 사용하였다. 창우형은 대부분의 작업을 터미널에서 vim을 사용했다고 한다. 둘 다 모두 글쓰기에서는 고정폭 글꼴을 사용하기 위해 [나눔고딕코딩폰트](http://dev.naver.com/projects/nanumfont)를 사용했다.

<img alt="Writeroom" width="500" src="/articles/2012/progit/writeroom.png" />

**Park** &raquo; 터미널에서 vim으로 작업했다. vim은 익숙하기도 했고 언제 어디서는 인터넷만 연결되면 되기 때문에 좋다.

**Lee** &raquo; 번역을 도와줄 사전으로는 맥 기본 사전, 아이폰에서 [Dictionary Universal](http://itunes.apple.com/us/app/dictionary-universal/id312088272?mt=8), [Wiktionary](http://wiktionary.org)를 이용하였다. 맥이나 아이폰에서는 사용자 사전을 추가할 수 있어서 한영/영한 사전 및 시소러스 사전을 유용하게 사용했다. 온라인 한글 맞춤범 검사기와 워드프로세서 한글을 종종 사용하기도 했다.

<img alt="Universal Dictionary" height="500" src="/articles/2012/progit/ubdic.jpg" />

**Park** &raquo; 나보다 구글 번역기가 나을때도 많더라.

**Park** &raquo; [우리말 배움터][]에 감사드린다. 오래전부터 사용해왔지만 이번에는 정말 고마웠다.

[우리말 배움터]: http://urimal.cs.pusan.ac.kr/urimal_new/

**Lee** &raquo; 번역 소스 관리를 위해서 윈래 Pro Git이 호스팅되고 있는 [GitHub](http://github.com)에서 프로젝트를 dogfeet/progit로 Fork하여 작업했다. 개인적으로 iMac과 MBP를 옮 겨다닐 때는 BitBucket의 Private 저장소를 사용했다. GitHub가 좋긴하지만 결재하지 않아서 Private 저장소가 없었다. 소스의 Branch와 Commit을 관 리하기 위해 GitX를 사용했다. 번역 소스를 관리하기 위해 전에는 Subversion을 사용했는데 Git은 번역을 위한 프로젝트에서도 정말 괜찮았다! 아니 Git이 유일한 도구처럼 느껴졌다. 번역하면서 사용한 Git-Flow Pattern를 따로 정리할 예정이다.

**Park** &raquo; Github만 사용했다. BitBucket도 써보고 싶지만 아직 Github도 다 모른다. 나는 Git때문에 Github을 사용하는 것인지 Github때문에 Git을 사용하는 것인지 모를 정도로 Github가 맘에 든다.

<img src="/articles/2012/progit/gitx-progit.png" alt="GitX" width="500" />

**Lee** &raquo; HTML, ePub, Mobi, PDF 출력물을 빌드하기 위해 따로 Ubuntu 서버를 하나 사용했다. x-server를 사용하지 않고 빌드하기 위해 약간의 빌드 스크립트를 수정해서 사용하였으며 주로 pandoc과 xelatex 관련 패키지와 한글 폰트 패키지를 설치하고, [Jenkins](http://jenkins-ci.org)(구 Hudson)에 빌드스크립트를 등록하여 원격으로 빌드하곤 했다.

**Park** &raquo; 나는 Mac에서 빌드했다. 처음에는 무척이나 골치 아팠지만 결국 방법을 찾아내고 버그도 수정했다. schacon님이 이 fix도 accept해주었다. GitHub로 번역을 진행하면 이런 소소한 즐거움도 알게 됐다.

<img alt="Jenkins" width="500" src="/articles/2012/progit/jenkins-progit.png" />

**Lee** &raquo; 번역을 함께 진행하기 위해서 커뮤니케이션도구로 [Yammer](http://yammer.com)를, 서로 출력물을 항상 최신 것으로 공유하기 위해 [Dropbox](http://dropbox.com)를 사용하였다. 업무용 커뮤니케이션도구로 메신저도 좋고 메일도 좋지만 Yammer를 강추하는 바이다!

**Park** &raquo; yammer는 정말 좋은 도구다. 4년정도 같이 공부해오면서 2011년과 같이 알찬 해는 없었다. 거기에는 yammer에 힘이 컸다고 생각한다. 위키도 사용해보고 이슈트레커도 사용해봤지만 모두 실패하고 지금은 그냥 yammer로 토론하고 yammer에 메모한다.

<img alt="Yammer" width="500" src="/articles/2012/progit/yammer-progit.png" />

## 닥치고 번역에 중요한거 ##

**Lee** &raquo; 우선 배가 항해를 하는데 좋든 좀 모자라든 선장이나 항해사 없이 제대로 된 길을 가는 것은 불가능하다. 이번 프로젝트는 일꾼 두 명이 땀을 뻘뻘 흘리면서 열심히 노를 젓는 일만 할줄 알기에 자주 방향을 잃어가며 작업할 수 밖에. 틈틈히 Yammer로 대화를 하며 방향을 잡아갔지만 적당한 경험있는 편집자가 틀을 잡아줄 수 있었다면 좀 더 좋은 번역을 할 수 있지 않았을까.

**Park** &raquo; 특히 중요하게 생각한 점은 최종 결정은 마지막에 수정하는 사람이 결정하기로 했다. 그래서 아쉬운 사람이 한번 더 검토했다.

**Park** &raquo; 번역도 일종의 모험이다. 훌륭한 선장과 항해사를 갖추고 출발했었으면 더 좋았겠지만 그렇지 못했다. 그래서 애초에 목표를 크게 잡지도 않았다. 영어를 읽는 것보다는 쉽게 읽을 수 있게 하자는 것. Git은 내용이 많기 때문에 어짜피 영문으로 또 읽어볼 필요도 있으니 처음 사다리를 그릴때 한글로 좀 더 쉽게 그릴 수 있게 하자는 것 정도였다. 한글판을 읽었으면 영문으로도 한번 더 읽거나 영문으로 된 다른 자료를 더 읽기를 권한다.


<img alt="Translation" width="500" src="/articles/2012/progit/tran.jpg" />
<p style="text-align: center; font-size: 80%">출처: [casaubon](http://casaubon.tv)</p>

**Lee** &raquo; 영어의 표현을 틀리지 않게 이해하는 것도 어려웠지만 한글로 옮겨적는 것이 더 어려웠다. 용어번역표를 제대로 정리하지 못해서 전체적으로 어휘 일관성을 지키지 못한 점도 많이 부끄럽다.

**Park** &raquo; 국어 실력이 제일 중요한 것 같다. 자신감을 갖고 문장을 만들어야 한다. 틀릴 때는 그냥 확실히 틀려주는 것이 결국은 더 빠르다. 초반에 이렇게 신경쓰지 못해서 나중에 다 다시 리뷰해야 했다. 그리고 그 질도 떨어 진다. 시간도 더 들었고 질도 떨어 진다.

**Park** &raquo; 공부가 제일이다. 이렇게 긴 글을 번역할 기회가 적은데 번역에 대한 공부를 더 못한 것이 아쉽다.

## 나는 뭘 얻었나 ##

**Lee** &raquo; 물론 제대로 출력된 책은 Amazon에서 돈을 받고 팔기도 하지만 Pro Git 책은 기본적으로 무료다. 저자인 schacon님은 Git 에반젤리스트이기도 하고 GitHub의 CIO이기도 하다. 사람들이 Git을 많이 써서 GitHub를 많이 사용하게 된다면 좋은 일 아닌가 ^^ 하지만 우리 역자들은 ... ^^

**Lee** &raquo; 적지않은 노력과 부끄러움을 드러내며 읽고 또 읽는 과정에서 Git에 대해서 그리고 번역에 대해서 경험(이라고 쓰고 삽질)과 노하우를 얻은 것은 나름의 성과라고 할 수 있겠다. 행여나 같은 업종의 동지분들께 아까운 삽질로 시간을 낭비하지 않고 조금이라도 한 숨 돌릴 수 있는 여유시간을 만들어 줄 수 있다면 보람있겠다(윗사람은 Git 같은거 몰라도 되지 싶다 ^^).

**Park** &raquo; 국어, 정말 한글 공부를 열씸히 했다.

**Park** &raquo; 완주하려면 동료가 꼭 필요하다는 것을 배웠다. 혼자 했으면 분명히 포기했을 것이다.

[progit]: http://progit.org
[progit-ko]: /articles/2012/progit.html
