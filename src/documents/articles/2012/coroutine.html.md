--- yaml
layout: 'article'
title: 'Coroutine'
author: 'Changwoo Park'
date: '2012-5-27'
tags: ['Coroutine', 'Wikipedia']
---

이 글은 [Wikipedia의 Coroutine][wikipedia-coroutine]을 번역한 것이다.

![coroutine-python](/articles/2012/coroutine/source-code.png)

[wikipedia-coroutine]: http://en.wikipedia.org/wiki/Coroutine

## Coroutine

Coroutine은 컴퓨터 프로그램에서 엔트리 포인트가 여러 개인 Subroutine이다. 그래서 어디서든지 잠시 멈췄다가 다시 이어서 실행할 수 있다. Coroutine은 [cooperative task][cooperative-task], [iterator][], [infinite list][infinite-list] and [pipe][] 같은 것을 구현하기에 좋다.

"Coroutine"이라는 용어는 Melvin Conway가 1963년에 자신의 논문에서 처음 사용했다.

[cooperative-task]: http://en.wikipedia.org/wiki/Cooperative_multitasking#Cooperative_multitasking.2Ftime-sharing
[iterator]: http://en.wikipedia.org/wiki/Iterator
[infinite-list]: http://en.wikipedia.org/wiki/Lazy_evaluation
[pipe]: http://en.wikipedia.org/wiki/Pipeline_(software)

## Subroutine과 비교

"Subroutine은 Coroutine 중 한 종류에 불과하다" - Donald Knuth]. Subroutine은 한번 실행하면 다 마칠 때까지 계속 실행되고 한번 호출할 때 한번 리턴한다. Coroutine도 이와 비슷하지만, Yield라는 것으로 빠져나오거나 다른 Coroutine을 호출해서 다시 해당 Coroutine이 하던 일을 이어서 할 수 있다.

그리고 Yield 없이 간단하게 Coroutine을 구현할 수도 있다.

언어를 개발할 때 Subroutine을 구현하려면 Subroutine을 실행하기 전에 스택을 하나 만들어야 한다. 하지만, Coroutine은 다른 Coroutine을 호출할 수 있어서 Continuation을 가지고 구현하는 것이 제일 좋다. Continuation은 스택이 여러 개 필요하기 때문에 보통 가비지컬렉터가 있는 언어에서 구현한다. 스택을 캐시해두거나 미리 할당하는 방식으로 좀 쉽게 Coroutine을 구현할 수 있다.

Coroutine이 얼마나 유용한지 보여 줄 수 있는 예제를 하나 보여주겠다. 소비자-생산자 관계인 Coroutine이 두 개 있다고 가정한다. 한쪽은 아이템을 생성해서 큐에 넣고 다른 쪽은 큐에서 아이템을 꺼내서 사용한다. 그리고 한꺼번에 아이템을 추가하거나 삭제해서 성능을 최적화할 수 있다. 이 내용을 코드로 구현하면 다음과 같다:

    var q := new queue

    coroutine produce
        loop
            while q is not full
                create some new items
                add the items to q
            yield to consume

    coroutine consume
        loop
            while q is not empty
                remove some items from q
                use the items
            yield to produce

큐가 다 차거나 다 비워지면 yield 명령어로 컨트롤를 다른 Coroutine에 양보한다. 그러면 그 Coroutine이 바로 시작한다.

이 예제는 멀티 Thread를 설명할 때 사용하는 예제랑 비슷하게 생겼지만, Thread를 두 개 만들지 않는다: 루틴이 돌다가 yield 구문을 만나면 다른 루틴으로 바로 점프한다.

## Coroutine과 Generator

Generator도 Subroutine보다 넓은(generalisation) 개념이지만 Generator를 처음 볼 땐 Coroutine보다 후져 보인다. Generator는 기본적으로 Iterator 코드를 단순화할 목적으로 사용하기 때문에 Generator의 yield 구문은 다른 Coroutine으로 점프하는 게 아니라 호출한 상위 루틴으로 값을 넘겨준다. 하지만, Generator로 Coroutine을 구현할 수 있다. Generator를 호출하는 상위 루틴을 'Dispatcher'로(엄밀히 말하자면 [Trampoline][trampoline]) 구현하면 되는데 한 Generator가 반환한 토큰으로 다른 Generator를 실행한다.

[trampoline]: http://en.wikipedia.org/wiki/Trampoline_(computing)

    var q := new queue

    generator produce
        loop
            while q is not full
                create some new items
                add the items to q
            yield consume

    generator consume
        loop
            while q is not empty
                remove some items from q
                use the items
            yield produce

    subroutine dispatcher
        var d := new dictionary(generator → iterator)
        d[produce] := start produce
        d[consume] := start consume
        var current := produce
        loop
            current := next d[current]

언어 차원에서 Coroutine을 지원하는 것도 많지만, native Coroutine이 없는 언어에서는 이렇게 많이들 구현한다. 예를 들어, Python 2.5 이전 버전에서는 이와 같은 방법을 사용했다.

[trampoline]: http://en.wikipedia.org/wiki/Trampoline_(computing)

## Coroutine의 용도

Coroutine은 다음과 같은 것을 구현할 때 유용하다:

 - Subroutine 하나로 구현하는 State-Machine에 유용하다.
이 머신의 State는 프로시저의 entry/exit point로 결정한다. 이렇게 하면 좀 더 가독성 높은 코드가 된다.
 - Concurrency에서 사용하는 Actor 모델에 유용하다. Actor마다 프로시저가 하나 있다(이 프로시저는 다시 여러 개로 나뉜다). 각 Actor는 스스로 스케쥴러에 컨트롤을 반환한다. 그래서 선점형 멀티태스킹 시스템처럼 차례로 실행된다.
 - Generator는 IO 처리나 자료구조를 Traverse하는 코드에 유용하다.

## Coroutine을 지원하는 언어들

Aikido, AngelScript, BCPL, Pascal, BETA, C#, ChucK, D, Dynamic C, Erlang, F#, Factor, GameMonkey, Go, Haskell, High Level Assembly, JavaScript(since 1.7), Icon, Io, Limbo, Lua, Lucid, µC++, MiniD, Modula-2, Nemerle, Perl(Perl 5 with Coro, Perl 6 native[citation needed]), Prolog, Python(since 2.5), Ruby, Sather, Scheme, Self, Simula-67, Squirrel, 스택less Python, SuperCollider, Tcl(since 8.6), urbiscript

Continuation으로도 Coroutine을 구현할 수 있어서 Continuation을 지원하는 언어라면 Coroutine은 쉽게 구현할 수 있다.

## Coroutine 대용으로 쓸 수 있는 것.

Coroutine은 원래 assembly 수준 기술이지만 일부 high-level 언어에서만 지원한다. Coroutine을 지원하는 언어는 Simula나 Modula-2가 처음이었고 최근에는 Lua나 Go에서도 지원한다.

2003년 당시에는 C나 그 파생언어들이 인기가 높았다. 하지만, 그 언어들은 언어 자체나 표준 라이브러리에서 Coroutine을 지원하지 않았다. Subroutine이 스택을 사용하기 때문에 어려웠다.

그런 이유로 Coroutine 자체는 구현하기 어렵지 않은데도 쓸 수가 없었다. 이렇게 Coroutine을 못 쓸 때는 State 변수나 플래그 같은 것의 조합으로 내부 상태를 관리하는 Subroutine을 만들어 쓸 수 있다. State 변수가 어떠냐에 따라서 전혀 다른 코드가 수행되는 것을 이용하는 것이다. 아니면 복잡한 switch 구문을 많이 써서 explicit state machine을 만드는 방법도 있다. 그렇지만, 이런 방법은 만들기도 어렵고 관리하기도 어렵다.

Thread는 많이 사용하는 언어에서 Coroutine 대용으로 사용한다. Thread는 동시성(simultaneously)이라는 여러 코드가 동시에 실행할 수 있는 기능을 제공한다. C 환경이나 Native로 Thread를 지원하는 다른 언어에서 널리 쓰인다. 많은 프로그래머가 알고 있고, 구현체도 매우 많고, 문서도 넘쳐나고, 지원도 잘된다. 하지만, Thread는 어려운 문제를 다루고 있어서 좀 더 강력하지만 복잡한 내용을 배워야 한다. 그래서 상대적으로 배우기 어렵다. Coroutine은 별로 알아야 할 게 없다. Thread를 사용하는 것은 소 잡는 칼로 닭 잡는 격이다.

Thread와 Coroutine의 가장 중요한 차이는 Thread는 선점형 스케쥴링이지만 Coroutine은 아니라는 것이다. Thread는 아무 데서나 스케쥴이 변경되고 Concurrent하게 실행한다. Thread를 사용하면 Locking할 때 조심해야 한다. 반대로 Coroutine은 스케줄이 변경되는 곳이 정해져 있고 Concurrent하게 실행되지 않는다. Coroutine은 전체적으로 locking이 필요 없다. 보통 이 특징은 event-driven이나 비동기 방식을 설명할 때도 장점으로 설명하는 특징이다.

그리고 Fiber라는 게 있어서 Coroutine을 구현해 쓸 수 있다. 하지만, Thread와 비교하면 Fiber를 지원하는 시스템은 별로 없다.

### .NET 프레임웤에서 fiber로 Coroutine 구현하기

.NET 프레임웤 2.0을 개발하면서 Microsoft는 fiber기반 스케줄링을 다룰 수 있도록 CLR(Common Langauge Runtime) 호스팅 API의 설계를 확장했다. 이것은 SQL 서버의 fiber-mode를 사용할 수 있도록 하기 위함이다. 릴리즈할 때에는 시간 제약사항(constraints) 때문에 타스크 스위칭을 지원하는 ICLRTask:SwitchOut을 제거했다. 그래서 타스크를 스위칭에 필요한 fiber API는 현재 .NET 프레임웤에서는 사용할 수 없다.

### Mono에서의 Coroutine

Mono CLR은 Continuation을 지원하기 때문에 coroutine을 만들 수 있다.

### Java에서의 Coroutine

Java는 추상화 때문에 Coroutine을 구현하기 어려운데도 구현체가 네 가지나 된다. JVM에서 불가능한 것은 아니다.

 - JVM 수정 버전들. Native로 Coroutine을 지원하도록 JVM을 Patch할 수 있다. Da Vinci JVM에는 해당 패치가 있다.
 - 바이트코드 수정 버전들. Coroutine은 Java 바이트코드를 수정해서 구현할 수도 있다. 컴파일할 때 수정할 수도 있고 실행할 때 수정할 수도 있다. [Java Coroutine](http://code.google.com/p/coroutines/) 프로젝트가 있다.
 - JNI로 구현. 해당 플랫폼용으로 구현된 C 라이브러리로 JVM에서 Coroutine을 사용한다.
 - Thread를 이용. 무겁디무거운(heavywight) 쓰레드로 Coroutine 라이브러리를 구현할 수도 있다. 성능은 JVM의 Thread 구현체에 따라 다르다.

### C에서의 Coroutine

다양한 시도가 있었는데 구현 정도가 다르다. C에서는 Subroutine과 마크로를 사용해서 Coroutine을 구현한다. 이 방법으로 구현한 것 중에서는 Simon Tatham이 구현한 것이 좋다. Tatham은 주석에서 이 방법의 한계를 잘 설명한다. 이 방법은 아직 논쟁`의 여지가 남아 있지만, 코드를 작성하기도 쉽고, 읽기도 쉽고, 관리하기도 쉽다. Tatham이 말하길 "물론, 이 방법은 책에서 말하는 코딩 규칙에 어긋난다. 하지만, 모든 코딩 규칙은 알고리즘의 명확성을 대가로 문법적 명확성을 얻는 방법들이다. 이 방법을 사용하자고 사장에게 말하면 사장는 분명히 그 직원을 건물 밖으로 드래그해버리라고 경비에게 소리칠 것이다"

Coroutine을 구현하는 좀 더 믿음직한 방법이 있는데, 대신 이식성이 떨어지고 특정 프로세서에서만 사용할 수 있다. 어셈블리 수준에서 Coroutine 컨텍스트를 저장했다가 다시 복원하는 기능이 있는 프로세서에서만 사용할 수 있다. 표준 C 라이브러리에는 setjmp와 longjmp 함수가 있어서 Coroutine 비슷하게 구현할 수 있다. 그런데 Harbison과 Steele은 "setjmp와 longjmp 함수로 구현하는 것은 매우 어렵다고 알려져 있다. 프로그래머는 setjmp와 longjmp에 대해 어떠한 가정도 하지 말하야 한다"라고 말한다. Harbison과 Steele이 말한 주의 사항과 제약 사항들은 무엇을 의미하는 걸까? setjmp와 longjmp를 사용해서 Coroutine을 구현했다 한들 다른 환경으로 옮기면 작동하지 않는다. 더욱 나쁜 것은 잘못 구현한 것들도 적지 않다. setjmp/longjmp는 실제로 스택 하나로 구현하는 거라서 제대로 된 Coroutine을 구현할 수 없다. 스택이 하나뿐이기 때문에 엉뚱한 Coroutine이 스택에 있는 변수를 수정해 버릴 수 있다.

그래서 C에서 스택기반 Coroutine을 구현하려면 스택을 만들고 점프할 수 있는 기능이 필요하다. 세 번째는 특정 머신에서만 동작하는 C로(machine-specific C) 작성하는 방법이다. 이 방법은 Coroutine용 컨텍스트가 지원돼야 한다. POSIX나 [Single UNIX Specification][single-linux]의 C 라이브러리에는 getcontext, setcontext, makecontext, swapcontext같은 루틴이 있다. setcontext류 함수들은 setjmp/longjmp 함수보다 상당히 강력하다. 하지만, 표준을 준수하는 구현체는 흔치않다. 이 방법의 최대 단점은 Coroutine의 스택 크기가 고정돼 있다는 것이다. 그래서 실행 중에 스택 크기는 커지지 않는다. 그래서 사람들은 스택 오버플로우를 예방하는 차원에서 처음부터 너무 큰 스택을 할당하는 경향이 있다.

표준 라이브러리의 한계 때문에 사람들은 직접 Coroutine 라이브리를 만들어 사용한다. Russ Cox가 만든 libtask라는 게 있는데 꽤 좋다. Native C 라이브러리에 context 함수가 있으면 그냥 그걸 사용하고 그게 아니면 자체적으로 구현한 ARM, PowerPC, Sparc, x86용 라이브러리를 사용한다. 그 외 살펴볼 만한 라이브러리로 libpcl, coro, lthread, libCoroutine, libconcurrency, libcoro가 있다.

[single-linux]: http://ko.wikipedia.org/wiki/%EB%8B%A8%EC%9D%BC_%EC%9C%A0%EB%8B%89%EC%8A%A4_%EA%B7%9C%EA%B2%A9

### C++에서의 Coroutine

 - Boost.Coroutine - Giovanni P. Deretta는 "Google Summer of Code 2006" 프로젝트로 이 라이브러리를 만들었다. 이 포터블한 Coroutine 라이브러리는 boost와 C++ 템플릿을 사용해서 만들었다. Boost.Coroutine은 아직 마무리되지 않았고 boost 공식 라이브러리가 아니므로 문서는 boost 싸이트가 아닌 다른 곳에서 호스팅하고 있다.
 - Mordor - Mozy는 2010년에 C++ Coroutine 라이브러리를 만들었다. 비동기 I/O를 사용하는 순차(sequential) 프로그래밍 모델처럼 사용할 수 있게 하였다.

### C#에서의 Coroutine

 - MindTouch Dream - MindTouch Dream REST 프레임웤은 C# 2.0의 iterator 패턴으로 구현한 Coroutine이 들어 있다.
 - Caliburn - WPF용 Caliburn 스크린 패턴 프레임웤은 C# 2.0의 iterator를 사용해서 UI 프로그래밍과 비동기 씨나리오를 좀 더 쉽게 구현할 수 있게 하였다.
 - Power Threading Library - Jeffrey Richter가 만든 Power Threading Library에는 AsyncEnumerator라는 게 있다. 그래서 Coroutine 기반으로 비동기 프로그래밍을 쉽게 할 수 있다.
 - Sevletat Pieces - Yevhen Bobrov가 만든 Servelat Pieces 프로젝트는 Silverlight WCF 서비스에 비동기를 투명하게(transparent asynchrony) 제공하고 동기 콜을 비동기적으로 호출하는 방법도 제공한다.
 - [13][13-link] - .NET 프레임웤은 2.0+ 부터 자체적으로 iterator 패턴과 yield 키워드로 coroutine을 제공한다. 

[13-link]: http://msdn.microsoft.com/en-us/library/dscyy5s0(VS.80).aspx

### Python에서의 Coroutine

 - [PEP 342](http://www.python.org/peps/pep-0342.html) - Pythone 2.5에 확장된 Generator를 기반으로 Coroutine 같은 기능을 구현하기 쉬워졌다.
 - [Greenlets](http://codespeak.net/py/0.9.2/greenlet.html)
 - [kiwi tasklets](http://www.async.com.br/projects/kiwi/api/kiwi.tasklet.html)
 - [multitask](http://pypi.python.org/pypi/multitask)
 - [chiral](http://chiral.j4cbo.com/trac)
 - [cogen](http://code.google.com/p/cogen)
 - [Kamaelia](http://www.kamaelia.org/)
 - [Shrapnel](https://github.com/ironport/shrapnel/)

### Ruby에서의 Coroutine

 - Ruby 1.9은 fiber로 구현한 Coroutine을 지원한다.
 - [Marc De Scheemaecker가 만든 것도 있다][marc-de-scheemaecker]

[marc-de-scheemaecker]: http://liber.sourceforge.net/coroutines.rb

### Perl에서의 Coroutine

 - [Coro](http://search.cpan.org/dist/Coro/)

Perl 6 부터 Coroutine을 지원한다.

### Smalltalk에서의 Coroutine

Smalltalk에서는 실행 스택이 First-class citizen이기 때문에 VM이 지원이나 다른 라이브러리 필요없이 Coroutine을 구현할 수 있다.

### Scheme에서의 Coroutine

Since Scheme provides full support for continuations, the implementation of coroutines is nearly trivial, requiring only that a queue of continuations be maintained.

### Delphi에서의 Coroutine

 - Bart van der Werf가 만든 [Coroutine 함수](http://www.festra.com/wwwboard/messages/12899.html)가 있는데 정말 작고 좋다.
 - Sergey Antonov는 [C# Yield를 델파이에서 구현했다][yield-delphi].

[yield-delphi]: http://hallvards.blogspot.com/2007/10/sergey-antonov-implements-yield-for.html

### assembly에서의 Coroutine

(이 부분은 이해할 수 없군요)

Machine-dependent assembly languages often provide direct methods for coroutine execution. For example, in MACRO-11, the assembly language of the PDP-11 family of minicomputers, the “classic” coroutine switch is effected by the instruction "JSR PC,@(SP)+" (which assembles as octal "004736") which jumps to the address popped from the stack and pushes the current (i.e that of the next) instruction address onto the stack. On VAXen (in Macro-32) the comparable instruction is "JSB @(SP)+" (which assembles as hex "9E 16" as the assembler shows it (with in effect bytes reversed). Even on a Motorola 6809 there is the instruction "JSR [,S++]", which assembles as (hex) "AD F1"; note the "++", as 2 bytes (of address) are popped from the stack. This instruction is much used in the (standard) 'monitor' Assist 09.

Simply calling back the routine whose address is on the top of the stack, does not, of course, exhaust the possibilities in assembly language(s)!

## See also

 - Unix pipes – 프로그램끼리 통신하는 데 사용하는 pipe도 Coroutine의 한 종류다.
