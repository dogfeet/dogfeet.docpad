--- yaml
layout: 'article'
title: '예제로 설명하는 자바스크립트에서의 Continuation-passing style'
author: 'Yongjae Choi'
date: '2012-02-24'
tags: ['javascript', 'CPS', 'programming', 'continuation']
---

_이 글은 [By example: Continuation-passing style in JavaScript][]를 번역한 것이다. CPS에 대해 열심히 적어놨는데 간단히 말하자면 함수 호출의 끝에 원래의 context로 돌아가지 않고, 새로이 불릴 함수를 caller가 넘겨주는 프로그래밍 스타일을 말한다._

![recursive](/articles/2012/by-example-continuation-passing-style-in-javascript/279433682_23ac618518.jpg)

(Photo by [gadl](http://www.flickr.com/photos/gadl/279433682/))

컨티뉴에이션-패싱 스타일(CPS)은 1970년대에 프로그래밍 스타일의 하나로 생겨났고, 1980, 1990년대에 고급 프로그래밍 언어 컴파일러의 중간 표현으로써 주목받았다.

이 프로그래밍 스타일은 논 블로킹 시스템(그리고 보통 분산 시스템)에서 다시 조명받기 시작했다.

내가 박사 과정일 때에 CPS는 비밀무기였다. 그래서 난 CPS를 좋아한다. 아마 그 덕분에 난 2년 정도를 아낄 수 있었고, 끝없는 고통에서 벗어날 수 있었다.

이 글은 자바스크립트에서의 논 블로킹 프로그래밍 스타일로서의 CPS와 함수형 언어의 중간 형태로서의 CPS, 이렇게 두 가지 관점에서 CPS를 소개하는 글이다.

주제는 다음과 같다. 

 * 자바스크립트에서의 CPS
 * Ajax 프로그래밍을 위한 CPS
 * (node.js에서) 논 블로킹 프로그래밍을 위한 CPS 
 * 분산 프로그래밍을 위한 CPS 
 * CPS를 이용해서 예외처리하는 방법 
 * 미니말 Lisp을 위한 CPS 컨버터 
 * <strike>Lisp에서 call/cc 구현하는 방법</strike><sup>이 섹션은 이해가 모자라 제거했다.</sup>
 * 자바스크립트에서 call/cc 구현하는 방법 

시작하자.

## '컨티뉴에이션-패싱 스타일'이 뭐야?

만약 컨티뉴에이션을 지원하는 언어을 사용한다는 것은 프로그래머가 예외와 백트래킹, 스레드, 제네레이터(generator)등의 제어 구조를 추가할 수 있다는 것을 의미한다.

많은 컨티뉴에이션에 대한 설명은 막연하고 불충분하다. 뭔가 정말 도움이 되는 설명이 필요하다. 이 컨티뉴에이션-패싱 스타일이 바로 그런 것들을 해결해줄 것이다.

컨티뉴에이션-패싱 스타일은 코드라는 측면에서 컨티뉴에이션과 같다.

하지만, 다음의 원리만 깨우치면 프로그래머는 컨티뉴에이션-패싱 스타일을 스스로 깨달은 것이나 마찬가지다.

    어떠한 프로시저도 caller에 리턴(return)하지 않는다.

아래 힌트는 CPS로 프로그래밍하는 데 도움이 된다:

    프로시저는 리턴 값으로 호출 가능한 콜백을 받는다.

프로시저가 caller로 "리턴" 해야 할 때, 프로시저는 return 대신 "현재 컨티뉴에이션(current continuation)" 콜백을 호출한다. (이 콜백은 caller가 넘겨줬다.)

컨티뉴에이션은 퍼스트-클래스 리턴 포인트(first-class return point)이다.

### 예제: 항등 함수

항등 함수가 하나 있다:

    function id(x) {
        return x ;
    }

이 것을 CPS로 하면 다음과 같다:

    function id(x,cc) {
        cc(x) ;
    }

가끔 현재 컨티뉴에이션 인자를 ret로 명명해서 코드를 좀 더 명확하게 할 수 있다:

    function id(x,ret) {
        ret(x) ;
    }

### 예제: 단순무식한 팩토리얼

아래는 보통의 단순무식한 팩토리얼이다:

    function fact(n) {
        if(n == 0)
            return 1 ;
        else
            return n * fact(n-1) ;
    }

그리고 이를 CPS로 작성하면 다음과 같다:

    function fact(n,ret) {
        if(n == 0)
            ret(1) ;
        else
            fact(n-1,function(t0) { ret(n * t0) }) ;
    }

그리고 이 함수를 실제로 "사용"할 때에는 다음과 같이 콜백을 넘겨준다:

    fact (5,function(n) {
        console.log(n); // 콘솔에 120이 출력된다.
    })

### 예제: Tail-recursive 팩토리얼

아래는 tail-recursive 팩토리얼의 구현이다.

    function fact(n) {
        return tail_fact(n,1) ;
    }

    function tail_fact(n,a) {
        if(n == 0)
            return a ;
        else
            return tail_fact(n-1,n*a) ;
    }

그리고 아래는 CPS.

    function fact(n,ret) {
        tail_fact(n,1,ret) ;
    }

    function tail_fact(n,a,ret) {
        if(n == 0)
            ret(a) ;
        else
            tail_fact(n-1,n*a,ret) ;
    }

## CPS와 Ajax

Ajax는 자바스크립트의 XMLHttpRequest 객체를 이용해 비동기적으로 서버에서 데이터를 가져오는 웹 프로그래밍 기술이다.

(데이터가 꼭 XML일 필요는 없다.)

CPS는 Ajax 프로그래밍을 우아하게 하는 방법을 제공한다.

XMLHttpRequest를 이용하면 블로킹 프로시저인 'fetch(url)'을 작성할 수 있다. 이 프로시저는 url이 가리키는 페이지의 내용을 변수에 담아 문자열로 리턴한다.

이런 방식의 문제는 자바스크립트가 단일 스레드만 지원하는 언어라는 점이다. 자바스크립트가 블럭되면 그동안 브라우저가 멈춰버린다.

그러면 사용자 경험이 망가진다.

더 나은 방식은 프로시저를 'fetch(url, callback)' 형식으로 만드는 것이다. 이 프로시저는 블로킹 되지 않기 때문에, 코드 실행이나 브라우저 렌더링을 막지 않는다. 이 프로시저에는 http 요청이 끝나고 호출되야 할 콜백을 넘겨준다.

이렇게 코딩하는 과정에서 부분적으로 코딩 스타일이 CPS로 자연스레 변한다.

### fetch 구현

콜백 유무에 따라 non-blocking 모드나 블러킹 모드를 스위칭하며 동작하는 fetch는 어렵지 않게 구현할 수 있다:

    /*
     fetch는 클라이언트에서 서버로 리퀘스트를
     보낼 때 블로킹될 수도 있고 안될 수도 있다.
    
     만약 url만 넘겨주면 프로시저는 블로킹되고
     url이 가리키는 페이지의 내용을 리턴한다.
    
     만약 onSuccess 콜백이 주어지면 
     프로시저는 논 블로킹이 된다. 
     콜백은 페이지의 내용을 
     인자로 받아 호출될 것이다.
    
     만약 onFail 콜백까지 주어지면
     요청이나 응답이 실패했을 때에 
     onFail이 fatch 프로시저에 의해서 호출된다.
    */
    
    function fetch (url, onSuccess, onFail) {
        // 콜백을 정의했을 때만 비동기로 작동한다.
        var async = onSuccess? true: false;
        // (이 라인의 비효율성에 대해 태클 걸지 
        //  않길 바란다. 이건 중요한 게 아니다.)
    
        var req ; // XMLHttpRequest 객체.
    
        // XMLHttpRequest 콜백:
        function rocessReqChange() {
            if(req.readyState == 4) {
                if(req.status == 200) {
                    if(onSuccess)
                        onSuccess(req.responseText, url, req);
                } else {
                    if(onFail)
                        onFail(url, req);
                }
            }
        }
    
        // XMLHttpRequest 객체를 만든다:
        if(window.XMLHttpRequest)
            req =new XMLHttpRequest();
        elseif(window.ActiveXObject)
            req =new ActiveXObject("Microsoft.XMLHTTP");
    
        // 비동기 모드라면 콜백을 세팅한다:
        if(async)
            req.onreadystatechange = processReqChange;
    
        // 서버로 요청한다.
        req.open("GET", url, async);
        req.send(null);
    
        // 비동기 모드라면,
        //  요청 객체를 리턴한다; 아니라면
        //  응답을 리턴하다.
        if(async)
            return req ;
        else
            return req.responseText ;
    }


### 예제: 데이터 가져오기

UID의 이름을 가져오는 프로그램이 필요하다고 치고, fetch를 이용해서 두 버전(동기, 비동기)을 다 만들어보자.

    // 요청이 끝날 때까지 블로킹된다:
    var someName = fetch("./1031/name") ;
    
    document.write ("someName: "+ someName +"<br>") ;
    
    // 블로킹되지 않는다:
    fetch("./1030/name",function(name) {
        document.getElementById("name").innerHTML = name ;
    }) ;

([예제][])

## CPS and non-blocking programming

[node.js][]는 블로킹 프로시저가 없는 자바스크립트를 위한 고성능, 서버사이드 플랫폼이다. 

node.js에서는 보통의 블로킹되는 프로시저(e.g. 네트워크, 파일 I/O)가 전부 콜백을 받고 결과는 콜백을 실행하는 것을 반환한다.

프로그램을 CPS로 변환하는 것으로 node.js 프로그래밍 다운 프로그래밍이 뭔지 살펴보자.

### 예제 : 간단한 웹 서버

node.js 웹 서버는 파일을 읽는 프로시저에 컨티뉴에이션을 넘긴다. select를 이용하는 것보다 CPS를 이용하는 것이 더 간단한 non-blocking IO이다.

    var sys = require('sys') ;
    var http = require('http') ;
    var url = require('url') ;
    var fs = require('fs') ;
    
    // 웹 서버 루트 경로:
    var DocRoot ="./www/";
    
    // 콜백을 넘겨주면서 웹 서버를 만든다:
    var httpd = http.createServer(function(req, res) {
        sys.puts(" request: "+ req.url) ;
    
        // url 파싱:
        var u = url.parse(req.url,true) ;
        var path = u.pathname.split("/") ;
    
        // 경로에서 .. 를 없앤다.
        var localPath = u.pathname ;
        //  "<dir>/.." => ""
        var localPath = localPath.replace(/[^/]+\/+[.][.]/g,"") ;
        //  ".." => "."
        var localPath = DocRoot + 
        localPath.replace(/[.][.]/g,".") ;
    
        sys.puts(" local path: "+ localPath) ;
    
        // 요청받은 파일을 읽어서 되돌려 보낸다.
        // Note: readFile은 현재 컨티뉴에이션을 넘겨받는다.
        fs.readFile(localPath,function(err,data) {
            var headers = {} ;
    
            if(err) {
                headers["Content-Type"] ="text/plain";
                res.writeHead(404, headers);
                res.write("404 File Not Found\n") ;
                res.end() ; 
            } else {
                var mimetype = MIMEType(u.pathname) ;
    
                // 만약 'content type'을 못 찾으면
                // 클라이언트가 알아서 하도록 놔두자.
                if(mimetype)
                    headers["Content-Type"] = mimetype ;
    
                res.writeHead(200, headers) ;
                res.write(data) ;
                res.end() ;
            }
        }) ;
    }) ;
    
    // 확장자와 MIME 타입을 매핑 시킨다:
    var MIMETypes = {
        "html" :"text/html",
        "js"   :"text/javascript",
        "css"  :"text/css",
        "txt"  :"text/plain"
    } ;
    
    function MIMEType(filename) {
        var parsed = filename.match(/[.](.*)$/) ;
        if(!parsed)
            return false;
        var ext = parsed[1] ;
        return MIMEType[ext] ;
    }
    
    // 8000번 포트를 리스닝(listening) 포트로 하여 서버를 시작한다:
    httpd.listen(8000) ;


## 분산 컴퓨팅을 위한 CPS

CPS를 사용하면 로컬과 분산에서 처리하는 것이 더 간단해진다.

조합(combination)을 계산해주는 함수인 choose를 작성해보자. 우선 일반적인 방법:

    function choose (n,k) {
        return fact(n) /
            (fact(k) * fact(n-k)) ;
    }

이제 이 코드가 로컬 컴퓨터가 아닌 서버에서 동작해야 하면

fact 프로시저가 블로킹되어 서버에서 응답이 오기까지 기다리도록 작성할 수도 있지만, 이 방법은 좋지 않다.

대신 CPS로 choose를 작성해보자:

    function choose(n,k,ret) {
        fact (n,  function(factn) {
        fact (n-k,function(factnk) {
        fact (k,  function(factk) {
        ret  (factn / (factnk * factk)) }) }) })
    }

이제 비동기적으로 팩토리얼을 계산하는 fact 프로시저 만들기가 쉬워졌다. 아래와 같이 말이다:

    function fact(n,ret) {
        fetch ("./fact/"+ n,function(res) {
            ret(eval(res))
        }) ;
    }

## CPS로 예외처리하기

프로그램을 CPS로 작성하면, 언어의 표준 예외처리 매커니즘이 쓸모없어진다. 하지만, CPS로 예외처리를 구현하는 것은 어렵지 않다.

예외처리는 컨티뉴에이션의 특수한 케이스다.

'현재 예외적 컨티뉴에이션(current exceptional continuation)'을 '현재 컨티뉴에이션(current continuation)'과 함께 던지는 것으로 try/catch 구문을 없앨 수 있다.

다음 예제는 Exception을 이용해서 팩토리얼 "total" 버전을 정의한다:

    function fact (n) {
        if(n < 0)
            throw "n < 0";
        else if(n == 0)
            return 1 ;
        else
            return n * fact(n-1) ;
    }
    
    function total_fact (n) {
        try{
            return fact(n) ;
        }catch(ex) {
            return false;
        }
    }
    
    document.write("total_fact(10): "+ total_fact(10)) ;
    document.write("total_fact(-1): "+ total_fact(-1)) ;

예외를 처리하는 컨티뉴에이션을 추가해서 throw, try, catch 를 제거할 수 있다:

    function fact (n,ret,thro) {
        if(n < 0)
            thro ("n < 0");
        else if(n == 0)
            ret(1);
        else
            fact(n-1,
                function(t0) {
                    ret(n*t0);
                }, thro);
    }
    
    function total_fact (n,ret) {
        fact (n,ret,
            function(ex) {
                ret(false);
            });
    }
    
    total_fact(10,function(res) {
        document.write("total_fact(10): "+ res);
    });
    
    total_fact(-1,function(res) {
        document.write("total_fact(-1): "+ res);
    });


## 컴파일에서 CPS

지난 30년간 CPS는 함수형 언어 컴파일러에서 사용하는 강력한 중간 표현식이었다.

CPS는 함수의 리턴, 예외, [퍼스트-클래스 컨티뉴에이션(first-class continuation)][^2]을 제거한다. 함수 호출은 그냥 하나의 점프 명령어로 치환된다.

다시 말해서, CPS는 컴파일러 대신에 많은 것들을 해결해준다. 

### 람다 계산법을 CPS로 바꾸기

람다는 보편적인 계산을 할 수 있는 표현식(어플리케이션, 익명함수 변수 레퍼런스)을 가진 Lisp의 축소판이다. 

    exp ::= (expexp)           ; 함수 어플리케이션
        |  (lambda (var) exp)  ; 익명 함수
        |  var                 ; 변수 레퍼런스

아래의 코드는 이 언어를 CPS로 변환해주는 도구다:

    (define (cps-convert term cont)
        (match term
            [`(,f ,e)
                ; =>
                (let (($f (gensym 'f))
                        ($e (gensym 'e)))
                   (cps-convert f `(lambda (,$f)
                        ,(cps-convert e `(lambda (,$e)
                            (,$f ,$e ,cont))))))]
    
            [`(lambda (,v) ,e)
                ; =>
                 (let (($k (gensym 'k)))
                   `(,cont (lambda (,v ,$k)
                        ,(cps-convert e $k))))]
    
            [(? symbol?)
                ; =>
                `(,cont ,term)]))
    
    (define (cps-convert-program term)
        (cps-convert term '(lambda (ans) ans)))

관심 있는 사람은, [올리비에 댄비(Olivier Danvy)]가 효과적인 CPS 변환기에 관한 많은 논문을 써냈으니 참고하길 바란다.

## JavaScript에서 call/cc 구현하기

만약 어떤 자바스크립트 코드를 CPS로 바꾸고 싶다면 call/cc는 간단하게 정의할 수 있다.

    function callcc (f,cc) { 
        f(function(x,k) { cc(x) },cc)
    }


## 더 읽어 볼 것 

 * [JavaScript: The Definitive Guide][], the best book on JavaScript.
 * [JavaScript: The Good Parts][], the only other good JavaScript book.
 * Andrew Appel's timeless classic [Compiling with Continuations][].
 * [The Lambda Papers][].
 * My post [on programming with continuations by example][].
 * [Jay McCarthy][] et al.'s papers on a continuation-based web-server.

[^2]: http://en.wikipedia.org/wiki/Continuation#First-class_continuations

[By example: Continuation-passing style in JavaScript]:http://matt.might.net/articles/by-example-continuation-passing-style/
[예제]:http://matt.might.net/articles/by-example-continuation-passing-style/code/client.html
[올리비에 댄비(Olivier Danvy)]:http://www.brics.dk/~danvy/
[node.js]:http://nodejs.org/

[JavaScript: The Definitive Guide]:http://www.amazon.com/gp/product/0596101996?ie=UTF8&tag=ucmbread-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0596101996
[JavaScript: The Good Parts]:http://www.amazon.com/gp/product/0596517742?ie=UTF8&tag=ucmbread-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0596517742
[Compiling with Continuations]:http://www.amazon.com/gp/product/052103311X?ie=UTF8&tag=ucmbread-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=052103311X
[The Lambda Papers]:http://library.readscheme.org/page1.html
[on programming with continuations by example]:http://matt.might.net/articles/programming-with-continuations--exceptions-backtracking-search-threads-generators-coroutines/
[Jay McCarthy]:http://faculty.cs.byu.edu/~jay/home/

