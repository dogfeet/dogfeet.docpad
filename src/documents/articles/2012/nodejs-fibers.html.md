--- yaml
layout: 'article'
title: 'nodejs: node-fibers'
author: 'Changwoo Park'
date: '2012-6-10'
tags: ['nodejs', 'node-fibers' ]
---

JavaScript는 [Coroutine][]을 지원하지 않기 때문에 외부 모듈이 필요하다. 이 글에서는 [node-fibers][]로 node에서 Coroutine을 어떻게 응용해야 할지 알아본다.

![fiberware](/articles/2012/nodejs-fibers/puton-fiber.jpg)

(from http://www.fiberbaya.blogspot.kr/)

## node-fibers

nodejs에 포함돼지도 않았고 안정성도 검증돼지 않았지만 [node-fibers][]를 사용하면 Coroutine 뿐만아니라 JavaScript에는 없는 sleep()이라든지 Generator라든지를 만들어 쓸 수 있다.

공식 페이지에 소개된 sleep()을 구현하는 코드를 보자.

    var Fiber = require('fibers');

    function sleep(ms) {
        var fiber = Fiber.current;
        setTimeout(function() {
            fiber.run(); //ms후에 다시 깨운다.
        }, ms);
        Fiber.yield(); //여기서 멈추고
    }

    Fiber(function() {
        console.log('wait... ' + new Date);
        sleep(1000);
        console.log('ok... ' + new Date);
    }).run();
    console.log('back in main');

[node-fibers][]는 강력한 도구지만 실제 힘을 발휘하려면 gevent같은 게 필요하다. 기존 API를 [node-fibers][]을 적용해서 다시 구현할 수는 없다.

### 멍키 패칭하고 싶다.

Python에서는 gevent를 사용하면 IO api와 thread api를 모두 멍키 패칭해주므로 투명하게 Coroutine으로 코드의 가독성을 높일 수 있었다. 하지만, node에서는 쉽지 않다. JavaScript는 플랫폼 전반에 CPS 스타일이 뼛속까지 녹아 있어서 멍키 패칭할 동기 API가 부족하다. 예를 들어, 파일 IO에는(fs 모듈) `xxxSync` 메소드가 갖춰져 있지만, 소켓 IO에는(net 모듈) 없다.

다시 말해서 gevent 방식이 더 낫다고 생각하지만:

1) 멍키 패칭할 `xxxSync` 메소드가 필요하고
2) 멍키 패칭을 구현한 모듈도 필요하고
3) 그러려면 node-fiber가 정식으로 node에 포함되든 JavaScript 표준에 Coroutine이 도입되든 안정성과 지원도 필요하고
4) 주렁주렁...궁시렁궁시렁...

gevent의 아이디어를 그대로 node에서 사용할 수는 없다.

멍키 패칭이든 뭐든 기존 API를 Coroutine에서 사용할 수 있도록 해주는 도우미가 필요한데, [node-fibers][]에는 Future라는 게 있다. Future는 Node의 비동기 API를 감싸서(wrap) Cotoutine을 사용할 수 있게 해준다.

### ls.js

다음 예제는 [node-fibers][]에서 Future를 설명하는데 보여주는 것이다. fs.readdir과 fs.stat를 감싸서 순차적으로 사용하는 것을 볼 수 있다:

    var Future = require('fibers/future'), wait = Future.wait;
    var fs = require('fs');

    // This wraps existing functions assuming the last argument of the passed
    // function is a callback. The new functions created immediately return a
    // future and the future will resolve when the callback is called (which
    // happens behind the scenes).
    var readdir = Future.wrap(fs.readdir);
    var stat = Future.wrap(fs.stat);

    Fiber(function() {
        // Get a list of files in the directory
        var fileNames = readdir('.').wait();
        console.log('Found '+ fileNames.length+ ' files');

        // Stat each file
        var stats = [];
        for (var ii = 0; ii < fileNames.length; ++ii) {
            stats.push(stat(fileNames[ii]));
        }
        wait(stats);

        // Print file size
        for (var ii = 0; ii < fileNames.length; ++ii) {
            console.log(fileNames[ii]+ ': '+ stats[ii].get().size);
        }
    }).run();

이 코드를 CPS 스타일의 코드로 바꾸면 다음과 같다:

    var fs = require('fs');

    fs.readdir('.', function(err, fileNames){
        console.log('Found '+ fileNames.length+ ' files');

        // Stat each file
        fileNames.forEach(function(fileName){
            fs.stat( fileName, function(err, stat){
                console.log( fileName + ': '+ stat.size);
            });
        });
    });

이 예제에서 알 수 있듯이 node에서는 CPS 스타일을 사용하는 게 더 낫다. 언어에서 [Coroutine][]을 정식 지원하는 것도 아니고 API도 준비돼 있지 않다. 환경이 준비됐다고 가정하고 스케쥴링을 목적으로 하는 것이라면 Coroutine이 더 낫다고 볼 수 있지만 적어도 아직은 node에서 CPS가 더 나을지도...

아무튼 `for`문을 `forEach`로 바꿀 수밖에 없다. 예를 들어 다음과 같은 코드는 ii 값이 변하기 때문에 동작하지 않는다:

        for (var ii = 0; ii < fileNames.length; ++ii) {
            fs.stat( fileName[ii], function(err, stat){
                console.log( fileName[ii] + ': '+ stat.size);
            });
        }

JavaScript의 가장 큰 문제는 매일매일 단련해야 한다는 것 같다. 하루라도 안 하면 잊어버려서 꼭 다음번에 삽질한다.

### Future

Future는 Node API 컨벤션이 일정한 것을 이용한다. node API는 `api(..., callback(err, ...))` 형식으로 돼 있기 때문에 이점을 이용한다. callback()으로 결과가 반환될 때까지 yield()시켰다가 callback()이 호출돼서 api 결과를 알게 되면 다시 resume 시킨다.

이 내용은 다음과 같이 생각하면 된다. 다음과 같은 코드를 추상화시킨 것이 future라고 생각하면 된다:

    function future_wrap(){
        fiber = fiber.current;

        api(..., callback(err, data){
            fiber.run();
        });

        Fiber.yield();
    }

그러니까 (직접 구현해보지 않았지만) 자체제작 api를 만든다면 표준 컨벤션을 지켜서 구현해야 Future를 사용할 수 있고 [node-fibers][]도 사용하기 쉽다. 아예 api를 [node-fibers][]에 의존하게 하여도 되지만 권하고 싶지 않다.

실제 Future.wrap() 코드를 보면 아예 api를 감싸버린다:

    Future.wrap = function(fn, idx) {
        idx = idx === undefined ? fn.length - 1 : idx;
        return function() {
            var args = Array.prototype.slice.call(arguments);
            if (args.length > idx) {
                throw new Error('function expects no more than '+ idx+ ' arguments');
            }
            var future = new Future;
            args[idx] = future.resolver();
            fn.apply(this, args);
            return future;
        };
    };

resolver()가 api 콜백인데 다음과 같이 생겼다:

    resolver: function() {
        return function(err, val) {
            if (err) {
                this.throw(err);
            } else {
                this.return(val);
            }
        }.bind(this);
    }

[node-fibers][]의 future.js 코드는 흥미롭다. 분석해보면 재밌을 거로 생각하지만 공부했던 것을 잊어버려서(게을러서) 나중으로 미뤄야겠다.

지구가 멸망하기 전에 `Secrets of the JavaScript Ninja`가 출간되는 날이 오면 그때나 다시 공부하고 분석해봐야겠다.

[node-fibers]: https://github.com/laverdet/node-fibers
[Coroutine]: /articles/2012/coroutine.html

