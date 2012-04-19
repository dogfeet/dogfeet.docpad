--- yaml
layout: 'article'
title: '프로그래머 관점에서의 바둑'
author: 'Yongjae Choi'
date: '2012-05-01'
tags: ['go', '바둑', 'programmer', 'computing']
---
이 글은 Louis Chatriot이 자신의 블로그에 쓴 [The Game of Go: A Programmer's Perspective](http://needforair.com/blog/2012/04/18/game-of-go/)를 번역한 것이다.

AI 프로그래머가 바라 봤을 때 바둑은 매우 흥미로운 게임이다. 컴퓨터가 실력 좋은 바둑 기사를 이기는게 매우 어렵고, 많은 연구자가 이 문제에 도전하기 때문이다. 모순적이게도 랜덤하게 돌을 놓는 것이 컴퓨터에겐 더 좋은 전략이다.

<a href="http://www.flickr.com/photos/obli/322662164/" title="COPA EMBAJADOR DE COREA 2006 by oblivionz, on Flickr"><img src="http://farm1.staticflickr.com/134/322662164_0260e91add.jpg" width="250" height="166" alt="COPA EMBAJADOR DE COREA 2006"></a>
by [oblivionz](http://www.flickr.com/photos/obli/)

## 바둑: 엄청나게 간단한 개요

바둑은 아시아에선 대중적인 게임이지만 서양에는 많이 알려지지 않았다. 바둑은 체스와 비슷하게 두 명이서 차례를 바꿔가며 바둑판에 돌을 놓는 전략게임이다. 체스와 바둑이 완전 다른 점은 두 개 정도있다.

* 바둑에선 바둑판이 비어있는 상태로 시작하고 차례를 바꿔가며 돌을 놓는다. 반면 체스는 말을 놓고 시작하며 상대편의 말을 쓰러트려야 하는 게임이다.
* 게임 [규칙][go-rules]은 체스보다 바둑이 더 간단하다. 체스는 6개의 다른 말이 있지만, 바둑은 한 종류의 돌만 놓으면 된다.

[여기][go-introduce]에서 배울 수 있고 [여기][go-play]에서 바둑을 둘 수 있으니 확인해보라고 하고 싶다.

## 체스와의 복잡도 비교

규칙이 단순할지라도 좋은 바둑 프로그램을 만드는것은 매우 어렵다고 증명되어있다. 정말로 가장 뛰어난 체스 프로그램은 가장 뛰어난 체스 플레이어를 이기는게 가능했다. 1997년에 딥 블루가 게리 카스파로프(Gary Kasparov)를 이겼다. 하지만 가장 뛰어난 바둑 프로그램은 그냥 강한 아마추어에게 참패했다. 그리고 강한 아마추어는 프로 기사보다 엄청 약하다. 이런 일이 가능한 것에는 세가지 주된 이유가 있다.

* **게임-트리 복잡도** : 체스에는 [10^123개의 게임][chess-num-of-game]이 있다. 바둑에 있어서는 [여러 추정치][estimates-vary]가 나올 수 있지만, [미국 바둑 협회 계산으로는 10^700개의 가능한 게임][go-num-of-game]이 있다고 한다. 바둑에는 플레이어에게 주어진 턴이 더 많고(평균적으로 200 대 50) 각각의 턴에서 돌을 놓을 수 있는 경우의 수(350 대 50)가 바둑이 더 많기에 바둑의 게임 수가 더 많다.
* **[훌륭한 휴리스틱의 부족][lack-of-good-heuristic]** : 체스 프로그램은 어떤 행동이 다른 행동보다 좋은 것인지 꽤나 빠르고 정확하게 판단할 수 있다. 반대로 바둑에 대해선 아직 좋은 휴리스틱이 발견되지 않았다.
* **패턴 인식** : 뛰어난 바둑 기사라는건 판에 놓여진 돌이 만드는 모양을 인식하는 것에 달려있다. 게임을 하는 도중에 컴퓨터가 그 모양을 인식 하기엔 너무 많은 시간이 든다. [사람은 컴퓨터보다 훨씬 빠르다.][human-better]

## 지금까지의 바둑 프로그램을 넘어설 핵심 아이디어

바둑 알고리즘 연구가 흥미로운 이유가 이런 복잡도가 있기 때문이다. 우리는 몇 년전 스팩타클한 성능 향상을 보인 [MoGo][mogo]라는 이름이 프로그램을 보았다. MoGo의 핵심 아이디어는 이렇다.

* **랜덤 게임을 이용한 위치 선정** : 역설적이게도 지금까지 알아낸 돌을 놓을 위치를 알아내는 최고의 방법은 현재 상태에서 시작해 각각의 선수가 바둑판에 랜덤으로 돌을 놓는 수많은 경기를 진행해 보는것 이다. 바둑판 위, 한 위치의 점수는 단순히 랜덤 게임들이 이긴 확률이다.
* 브랜칭 팩터(각 턴마다 가능한 행동-돌을 놓는 등-의 경우의 수)를 줄이기 위해 **'[multi-armed bandit][multi-armed-bandit] 알고리즘'를 이용**한다. 목표는 탐색(새로운 행동을 하는 것)과 개척(이미 알고 있는 행동 중에 최적의 하나를 찾아내는 것) 사이에 트레이드 오프를 최적화 하는 것이다. 컴퓨터는 처음에 가능한 모든 행동에 대해 사전 확률 분포를 만든다. 이 분포에 따라 하나를 고르고 그에 상응하는 위치를 기반으로 랜덤 게임을 돌린다. 그리고 결과를 이용해 그 행동에 대한 확률을 업데이트한다. 그리고 업데이트된 분포를 이용해 다음 가능한 수를 선택한다. 그렇게 계속 해나간다.
* **작은 전문 지식을 이용** : 'multi-armed bandit'에서 쓰이는 사전 분포는 적은 노력으로 멍청한 행동을 피하는 용도로 사용한다. 게임을 시작하면 고전적인 시작 위치를 선호한다. 그리고 랜덤 게임을 하는데 사실 이 랜덤 게임은 완전한 랜덤이 아니다. 간단한 패턴에 따라 특정 행동들은 제거하기 때문이다. 그렇게 몇가지를 제거한다 해도 전문 지식은 탐사 알고리즘 부분의 정말 작은 상처 하나에 불과하다.
* **병렬화** : MoGo같은 프로그램은 컴퓨터 클러스터에서 더 나은 성능을 보인다. 랜덤 게임 부분이 여러개의 CPU에서 돌 수 있기 때문이다. [성능 향상][speed-up-factor]은 약 8배 정도이다.
* **강화된 학습** : MoGo는 게임을 진행하는 동안이나 랜덤 게임을 진행하는 동안 계속 학습한다. 잘못된 결과를 가져오는 행동을 했을때 그 행동에 더 작은 확률을 부여한다.

[이 글][article-to-learn-mogo]에 MoGo에 대해 더 많은 자료가 있다.

## 현재 컴퓨터의 성능

오늘날 바둑 프로그램은 조그마한 게임 판에서 프로 바둑 기사를 이기고 잘하는 아마추어 기사를 정식 바둑판에서 이기는 수준이다. 이건 굉장한 성과이지만 정식 바둑판에서 프로 바둑 기사를 상대하기 까지는 너무 먼 여정이 남아있다.

*난 그리 실력이 좋지 않을지 모르겠지만, 스스로 바둑 플레이어라고 말한다. 2008년에 컴퓨터 공학 연구실에 인턴으로 있을 때, 한 2달 정도 MoGo를 사용했었다.
이 글을 검토해준 [Arpad Rimmel](http://www.linkedin.com/pub/arpad-rimmel/b/9a7/847)에게 감사의 말을 전한다. 그는 박사과정을 지내는 중 3년 정도 MoGo를 사용했다.*


[go-rules]: http://senseis.xmp.net/?RulesOfGoIntroductory
[go-introduce]: http://senseis.xmp.net/?RulesOfGoIntroductory
[go-play]: http://www.gokgs.com/

[chess-num-of-game]: http://en.wikipedia.org/wiki/Shannon_number
[estimates-vary]: http://en.wikipedia.org/wiki/Go_and_mathematics
[go-num-of-game]: http://www.usgo.org/resources/topten.html
[lack-of-good-heuristic]: http://en.wikipedia.org/wiki/Evaluation_function
[human-better]: http://curiosity.discovery.com/question/humans-better-than-computers
[mogo]: http://www.lri.fr/~teytaud/mogo.html

[multi-armed-bandit]: http://en.wikipedia.org/wiki/Multi-armed_bandit
[speed-up-factor]: http://en.wikipedia.org/wiki/Amdahl's_law
[article-to-learn-mogo]: http://www.pleinsud.u-psud.fr/specialR2008/en/12_GOthique.pdf
