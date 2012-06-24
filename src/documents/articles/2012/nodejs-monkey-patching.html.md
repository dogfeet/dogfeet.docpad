--- yaml
layout: 'article'
title: 'nodejs에서의 멍키 패칭'
author: 'Changwoo Park'
date: '2012-6-24'
tags: ['nodejs', 'Monkey Patching' ]
---

JavaScript에서 멍키 패칭이 가능할까? 'require'를 어떻게 좀 바꾸면 될 것 같은데, 그런게 가능하긴 할까해서 찾아봤다. 명색이 프로토타입 언어인데 쓸데가 있을지는 둘 째치고 가능할꺼라는 생각이 들었다.

![monkey-patch](/articles/2012/nodejs-monkey-patching/monkey_patch.jpg)

(from http://geargeeksreview.blogspot.kr/2008/09/milspecmonkey-monkey-patch.html)

## require

소스에서 require를 사용할 수 있는 이유는 다음과 같은 코드로 wrapper되기 때문이다. 다음 코드는 node/src/node.js에 있는(node 소스) 코드다:

    NativeModule.wrapper = [
        '(function (exports, require, module, __filename, __dirname) { ',
        '\n});'
    ];

소스에서 exports, require, module, __filename, __dirname 변수를 사용할 수 있는 이유는 우리가 구현하는 모듈이 이 wrapper의 바디에 해당되기 때문이다.

모든 모듈은 Module 객체이다. `require('fs')`라고 호출하면 fs.js를 로드해서 Module 객체 인스턴스로 만들어서 반환한다. `node/lib/module.js` 코드를 보면 모든 모듈은 Module 객체로 만드는 부분이 있다.

    var module = new Module(filename, parent);

require는 module 객체 자체를 반환하는 것이 아니라 `module.exports`를 반환한다. 그래서 require로 Module 객체에 접근할 수 없다. 

module 객체에는 해당 모듈에 필요한 정보를 담고 있으면서 _cached 프로퍼티에 캐시된다. 실제 module.js 소스를 보자:

    var cachedModule = Module._cache[filename];
    if (cachedModule) {
        return cachedModule.exports;
    }

require가 호출되면 먼저 _cache에 등록는지 확인하고 캐시한 것을 반환한다. 즉, 해당 모듈 객체는 딱 하나만 만든다. 이 것은 API 문서에도 잘 나와 있다.

### Module.prototype.require

그럼 require는 어딨는 걸까? 뭘 고쳐야 require 호출을 가로챌 수 있을까? 우리가 호출하는 require는 다음과 같은 위치에 있다:

    Module.prototype.require = function(path) {
      return Module._load(path, this);
    };

메인 모듈(실행하는 스크립트)뿐만 아니라 모든 모듈 객체의 prototype에 있는 require를 호출한다. 그리고 저걸 바꿔주는 모듈을 만들면 내가 만든 require 함수가 호출되도록 할 수 있다.

## 멍키 패칭

require 함수를 바꾸는 mp.js 모듈을 만든다:

    var Module = require('module');

    // orig 함수를 두는 위치는 아무 의미없다--;
    // 그냥 prototype._require__에 넣은 것이다. 실제로 사용하려면 문제가 될 수 있다.
    Module.prototype.__require__ = Module.prototype.require;
    Module.prototype.require = function fevent_require(id) {

        //여기에 멍키 패칭 코드를 넣을 수 있다.
        //fs나 net 모듈 같은 걸 수정할 수 있다.
        console.log('called require');

        return this.__require__(id);
    }

mp.js 모듈을 사용해보자:

    require('fs');

    require('./mp');

    require('fs'); //called require
    require('net'); //called require

잘된다.

그런데 여기서 한가지 의문이 든다. Module.prototype.require를 수정했지만 `(function (exports, require, module, __filename, __dirname) `라는 wrapper를 통해 파라미터로 넘겨진 require의 레퍼런스는 그대로 인데도 잘 수행된다.

이 wrapper를 통해 넘겨진 함수는 다음과 같다:

    var self = this;
    //....
    function require(path) {
        return self.require(path);
    }

그래서 해당 모듈의 require 함수가 호출되는 것이기 때문에 잘된다.

require 함수를 바꿀 수 있으니 이제 원하는 모듈을 멍키 패칭할 수 있다. 이 방법의 안정성은 좀 더 다듬어야 하고--; 멍키 패칭이 필요한 이유도 아직 없지만--;; 가능하긴 하다는 것을 알아 보았다.

