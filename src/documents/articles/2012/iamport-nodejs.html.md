--- yaml
layout: 'article'
title: 'iamport: nodejs'
author: 'Changwoo Park'
date: '2012-6-17'
tags: ['nodejs', 'coroutine', 'fiber', 'iamport']
---

[iamport: python][iamport-python]에서 100개쯤되는 포트를 확인해보려고 포트가 열렸는지 확인하는 프로그램을 python으로 작성했었다. [node-fibers][]를 살펴보면서 iamport를 nodejs로 포팅해봤다.

![iamport](/articles/2012/iamport/iamport.jpg)

(from http://www.portofamsterdam.com/)

## iamport: CPS

다음은 포트가 열렸는지 [CPS][] 방식으로 확인하는 프로그램이다:

    #!/usr/bin/env node

    var net = require('net');
    var fs = require('fs');

    var stime=new Date().getTime();
    var done=0;

    function tryToConnect( ip, port ){
        done++;

        var socket = net.createConnection(port, ip);

        socket.on('error', function(err){
            console.log( ip + ' ' + port );
        }).on('connect', function(connect) {
            socket.destroy();
        }).on('close', function(had_error){
            done--;

            if(done == 0 ){
                var etime=new Date().getTime();

                console.log( "elapsed(ms) " + (etime - stime)/1000 );
            }
        });
    }

    fs.readFile(process.argv[2], 'utf-8', function(err, data){
        var lines = data.split('\n');

        lines.forEach(function(line){
            if( line.trim().length < 1 ) return;
            var opts=line.match(/[0-9\.]+/g);

            if( opts && opts.length > 1 ) {
                tryToConnect(opts[0], opts[1]);
            } else {
                console.log(line);
            }
        });
    });

테스트할 포트 목록은 다음과 같은 파일을 파라미터로 넘겨주면 된다:

    127.0.0.1       22
    127.0.0.1       21
    168.126.63.1    18
    18.18.18.18     18
    18.18.18.18
    74.125.235.180  80

그러면 입력 값이 잘못 됐거나 열리지 않는, 아무튼 예외가 발생하는 것만 출력한다. 실행 결과는 다음과 같다:

    $ ./iamport.js port_scan 
    18.18.18.18
    127.0.0.1 21
    127.0.0.1 22
    18.18.18.18 18
    168.126.63.1 18
    elapsed(ms) 21.047

## iamport: fiber

[node-fibers][]의 Future을 적용한 예이다. 비동기 API를 Wrapping하는 다른 시도도 있지만 그냥 Future를 사용했다:

    #!/usr/bin/env node

    var net = require('net');
    var fs = require('fs');
    var Future = require('fibers/future'), wait = Future.wait;

    var stime=new Date().getTime();

    //api(..., callback(err,data))라는 컨벤션을 따라야 한다.
    function tryToConnect( ip, port, callback ){

        var socket = net.createConnection(port, ip);

        socket.on('error', function(err){
            console.log( ip + ' ' + port );
            callback(err, null);
        }).on('connect', function(connect) {
            socket.destroy();
            callback(null, connect);
        });
    }

    //Function.length를 이용해서 callback 파라미터의 위치를 자동으로 찾는다.
    //엄밀히 말하면 마지막 파라미터를 callback으로 가정함
    var connect = Future.wrap( tryToConnect );

    //readFile의 프로토타입은 readfile( port, [ip], [callback])이고
    //fs.readFile은 callback 파라미터의 위치가 동적이기 때문에
    //명시적으로 선언한게 아니라 arguments를 이용했다.
    //그래서 Function.legnth로 callback의 위치를 알 수 없다.
    //두번째 파라미터 2는 callback의 위치를 알려주는 것이다.
    var readFile = Future.wrap( fs.readFile, 2 );

    Fiber(function(){
        var data = readFile(process.argv[2], 'utf-8').wait();
        var lines = data.split('\n');
        var jobs = [];

        lines.forEach(function(line){
            if( line.trim().length < 1 ) return;

            var opts=line.match(/[0-9\.]+/g);

            if( opts && opts.length > 1 ) {
                jobs.push( connect(opts[0], opts[1]) );
            } else {
                console.log(line);
            }
        });

        //wait에는 Fiber 객체가 아니라 Future 객체가 필요하다.
        wait(jobs);

        var etime=new Date().getTime();

        console.log( "elapsed(ms) " + (etime - stime)/1000 );
    }).run();

[CPS][]이나 [node-fibers][]나 성능상에 차이날 이유가 없다. 실행 결과는 다음과 같다:

    $ ./iamport-fiber.js port_scan 
    18.18.18.18
    127.0.0.1 21
    127.0.0.1 22
    168.126.63.1 18
    18.18.18.18 18
    elapsed(ms) 21.093

gevent와 같은 구현체가 등장하면 쓸만 할지도 모르겠지만 node에서 Coroutine은 괜한 욕심일지도 모르겠다. 그래도 node-fiber를 좀 더 쉽게 사용할 수 있도록 만들려는 시도들이 있다. [fiberize][], [fibers-promise][], [node-sync][]를 참고하면 node-fiber를 사용하는데 도움이 될 것이다.

[fiberize]: https://github.com/lm1/node-fiberize
[fibers-promise]: https://github.com/lm1/node-fibers-promise
[node-sync]: https://github.com/0ctave/node-sync

[CPS]: /articles/2012/by-example-continuation-passing-style-in-javascript.html
[iamport-python]: /articles/2012/iamport-python.html

[node-fibers]: https://github.com/laverdet/node-fibers

