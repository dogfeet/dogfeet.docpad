--- yaml
layout: 'article'
title: 'iamport: python'
author: 'Changwoo Park'
date: '2012-6-2'
tags: ['python', 'coroutine', 'gevent', 'iamport']
---

포트가 열렸는지 확인하는 프로그램을 작성했다. 100개쯤되는 포트를 확인해보라고 해서 만들었는데, 이 참에 gevent를 적용해보았다.

![iamport](/articles/2012/iamport/iamport.jpg)

(from http://www.portofamsterdam.com/)

주 플랫폼이 Java라서 예전엔 이런일을 groovy로 했었는데 python이 훨씬 쉽다.

## iamport

다음은 포트가 열렸는지 순차적으로 확인하는 프로그램이다.

    #!/usr/bin/env python

    import socket
    import sys
    import time
    import re

    def tryToConnect( argv ):
        ip=argv[0]
        port=int(argv[1])

        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM )

        try:
            sock.connect( (ip, port) )
        except:
            print ip, port

        sock.close()

    if __name__ == '__main__':

        stime=time.time()

        file = open(sys.argv[1])

        jobs = []

        while True:
            line = file.readline()

            if not line:
                break

            opts = re.split('\s*', line)

            if len(opts) > 2:
                job = tryToConnect( opts )
                jobs.append( job )
            else:
                print opts[0]

        file.close()

        etime=time.time()

        print 'elapsed %f' % (etime - stime)

테스트할 포트 목록은 다음과 같은 파일을 파라미터로 넘겨주면 된다:

    127.0.0.1       22
    127.0.0.1       21
    168.126.63.1    18
    18.18.18.18     18
    18.18.18.18
    74.125.235.180  80

그러면 입력 값이 잘못 됐거나 열리지 않는, 아무튼 예외가 발생하는 것만 출력한다. 실행 결과는 다음과 같다:

    $ ./iamport.py port_scan 
    127.0.0.1 22
    127.0.0.1 21
    168.126.63.1 18
    18.18.18.18 18
    18.18.18.18
    elapsed 42.215497

100개 정도에 한번 해봤는데 27분 걸렸다.

## Coroutine

[Coroutine][]은 정말 유용하다. Python이 처음이라면 다음과 같은 글을 읽는 것이 도움이 된다.

- [Python 제너레이터+반복자의 마법](http://blog.dahlia.pe.kr/articles/2009/09/15/python-%EC%A0%9C%EB%84%88%EB%A0%88%EC%9D%B4%ED%84%B0%EB%B0%98%EB%B3%B5%EC%9E%90%EC%9D%98-%EB%A7%88%EB%B2%95)
- [파이썬 코루틴 (python coroutine) - 1](http://pyengine.blogspot.com/2011/07/python-coroutine-1.html)
- [파이썬 코루틴 (python coroutine) - 2](http://pyengine.blogspot.com/2011/07/python-coroutine-2.html)

[Coroutine]: /articles/2012/coroutine.html

## gevent

gevent를 이해하려면 eventlet을 알아봐야 하고:

- [greenlet은 어떻게 구현했을까?](http://ricanet.com/new/view.php?id=blog/111007)
- [Comparing gevent to eventlet](http://blog.gevent.org/2010/02/27/why-gevent/)

gevent의 적용은 너무 쉽다. 사실 세 줄만 바꿔주면 된다:

1. 멍키패칭으로 io api를 비동기+코루틴 방식의 구현체로 바꿔주고.
2. job들을 등록(spawn)하고서
3. join으로 다 끝나길 기다리면 된다(테스트는 안해봤지만 join이 호출될때 job이 실제로 시작하는 것 같다).

### gevent 버전의 iamport

아무리 내가 python을 잘 모른다지만 너무 간단하다. 눈이 의심스러울 정도로 간단하다.

    #!/usr/bin/env python

    import socket
    import sys
    import time
    import re
    import gevent
    import gevent.monkey

    def tryToConnect( argv ):
        ip=argv[0]
        port=int(argv[1])

        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM )

        try:
            sock.connect( (ip, port) )
        except:
            print ip, port

        sock.close()

    if __name__ == '__main__':

        stime=time.time()

        #멍키패칭
        gevent.monkey.patch_all()

        file = open(sys.argv[1])

        jobs = []

        while True:
            line = file.readline()

            if not line:
                break

            opts = re.split('\s*', line)

            if len(opts) > 2:
                #job을 spawn
                job = gevent.spawn(tryToConnect, opts )
                jobs.append( job )
            else:
                print opts[0]

        file.close()

        #spawn한 job이 모두 종료할 때까지 join
        gevent.joinall( jobs )

        etime=time.time()

        print 'elapsed %f' % (etime - stime)

27분 걸렸던게 27초만에 끝났다. 만세.


