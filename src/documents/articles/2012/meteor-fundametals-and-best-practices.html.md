--- yaml
layout: 'article'
title: 'Meteor: Learn Meteor Fundamentals and Best Practices'
author: 'Changwoo Park'
date: '2012-8-19'
tags: ['meteor', 'node', 'Andrew Scala']
---

이 글은 @agscala의 [Learn Meteor Fundamentals and Best Practices][orig]를 번역한 것이다. [Meteor](http://meteor.com/)를 처음 접할 때 좋은 것 같아 번역하였다. [Meter 공식 문서][docs]는 아직 설명이 부족해 어렵다.

[orig]: http://andrewscala.com/meteor/
[docs]: http://docs.meteor.com/

![](/articles/2012/meteor-fundametals-and-best-practices/agscala.jpeg) **Andrew Scala**

## Introduction

이 새롭고 기괴한 [Meteor](http://meteor.com/)가 어떻게 동작하는지 알고 싶어 왔는가? 그레이트, 제대로 왔다. 내가 Meteor 프로젝트가 어떻게 생겼는지 보여주고 Meteor 애플리케이션을 만들 때 꼭 기억해야 하는 비법(Best Practices)을 알려 주겠다.

## What is Meteor?

Meteor에서는 적은 코드로도 엄청난 양의 동적 페이지가 시전된다(create). Meteor는 아직 Beta이고 이 글을 쓰는 시점에서 Meteor는 `preview 0.3.8` 버전에 불과하다. 그러니 이 글의 내용이 동작하지 않더라도 쫄지 말자.

Meteor는 [Node.js](http://nodejs.org/)에서 Javascript로 만들었다. 그래서 우리가 만드는 Meteor 앱도 Javascript로 만들어야 한다. Javascript 공력이 부족하면 [Javascript Garden](http://bonsaiden.github.com/JavaScript-Garden/ko/)을 보라. Javscript 내공을 증진하는데 매우 좋다.

Meteor는 [MongoDB](http://www.mongodb.org/)를 사용해서 데이터를 저장한다. Meteor는 MongoDB를 직접 쓰지 않고 Minimongo라는 인터페이스를 사용한다. Minimongo는 MongoDB 인터페이스를 많이 지원하지만, 아직 전부 지원하지 못한다. MongoDB가 정확히 어떻게 동작하는지 알 필요는 없지만 적어도 Meteor의 [컬랙션 문서](http://docs.meteor.com/#collections)는 보는 게 좋다. 어떻게 해야 하는지 알려준다.

메테오는 현재 [handlebars](http://handlebarsjs.com/)을 템플릿 엔진으로 사용한다. 아직은 handlebars밖에 사용할 수 없지만, 조만간에 다른 문파의 템플릿 엔진도 사용할 수 있는 날이 올 것이다.

어찌 됐건 우리는 계속 웹사이트를 만들고 있을 테니 HTML과 CSS의 고수도 돼야 한다.

## The Basics

Meteor 프로젝트는 대부분 Javascript 파일로 구성된다. 프로젝트 디렉토리 중 아무 데나 `*.js` 파일을 두면 Meteor가 자동으로 로드해서 실행한다. Meteor 프로젝트에 있는 모든 Javascript 파일은 서버와 클라이언트에 모두 배포된다(꼭 그런 것은 아니고 제외하는 방법이 있다). 이것은 Meteor의 절대 무공(really cool) 중에 하나다. 우리는 모든 것을 Javascript로 개발하고 코드를 한 번만 시전해도(write) 서버와 클라이언트 양쪽에서 사용할 수 있다.

또 다른 Meteor만의 독문 무공으로 `*.less` 파일을 프로젝트 디렉토리 중 어디엔가 두면 Meteor가 자동으로 컴파일하고 클라이언트에 전송해서 페이지에 포함한다.

그것뿐만 아니라 Meteor 서버 코드와 클라이언트 코드를 구분하는 방법도 제공한다. `Meteor.is_server`와 `Meteor.is_client` 플래그로 구분할 수 있다.

다음은 서버코드와 클라이언트 코드를 구분하는 예제다. 브라우저의 Javascript 콘솔에 "Hi. I'm CLIENT"이라는 로그가 찍히고 Meteor 서버에는 "Hi. I'm SERVER"라고 출력된다.

```javascript
// This function is available on both the client and the server.
var greet = function(name) {
    console.log("Hi. I'm " + name);
}

// Everything in here is only run on the server.
if(Meteor.is_server) {
    greet("SERVER");
}

// Everything in here is only run on the client.
if(Meteor.is_client) {
    greet("CLIENT");
}
```

정말 간단하다. 클라이언트와 서버는 코드를 공유하기 쉬워서 재사용성을 극대화할 수 있고 개발 시간이 극적으로 줄어든다.

## Project Structure

클라이언트와 서버랑 공유하지 않는 코드가 많으면 어떻게 할까. 가문의 독문(private) 알고리즘이 있으면 서버에서만 실행돼야 하고 절대 다른 사람이 보면 안 되니까 클라이언트에 전송되면 안 된다. Meteor는 서버와 클라이언트 코드를 구분하는 "특별" 디렉토리가 두 개 있다. `[project_root]/client/`와 `[project_root]/server/`가 그것이다. server 디렉토리에 있는 Javascript는 클라이언트에 전송되지 않고 서버에서만 실행된다. 반대로 client 디렉토리에 있는 코드는 클라이언트에서만 실행된다. `Meteor.is_client`와 `Meteor.is_server`를 안 써도 되기 때문에 매우 편리하다. 그냥 코드를 client 디렉토리에 넣으면 클라이언트 코드가 된다.

파일이 어떻게 로드되는지 알려면 다른 것보다 일단 프로젝트 구조를 알아야 한다. 파일이 두 개 있을 때 어떤 파일이 먼저 로드될까? 다음과 같은 순서로 Javascript 파일을 로드한다.

1. `[project_root]/lib`의 파일이 먼저 로드된다. 라이브러리는 이 디렉토리에 넣는다.
2. 디렉토리 깊이로 파일을 정렬해서 로드한다. 디렉토리 깊이가 깊은 게 먼저 로드된다.
3. 파일은 알파벳 순으로 정렬한다.
4. `main.*` 파일은 마지막에 로드한다. 다른 스크립트와 라이브러리가 모두 로드되고 나서 로드돼야 하는 코드에 적합하다.

Meteor에는 client/sever 코드를 구분하고 로드 순서를 관리하는데 몇 가지 중요한 디렉토리가 있다:

* `[project_root]/lib/` - 이 디렉토리에 있는 파일은 client/server 코드가 시작하기 전에 로드된다.
* `[project_root]/client/` - 이 디렉토리에 있는 파일은 클라이언트인 브라우저에만 전송되고 서버에서는 실행할 수 없다.
* `[project_root]/server/` - 서버에서만 실행하고 클라이언트에 전송하지 않을 파일은 이 디렉토리에 넣는다.
* `[project_root]/public/` - 정적 파일은 이 디렉토리에 넣는다. image.jpg를 이 디렉토리에 넣고 바로 html에서 사용한다.
* `[project_root]/.meteor/` - Meteor는 사용하는 모듈이 무었인지 등등의 프로젝트 관리 정보를 여기에 둔다. **개발자가 직접 이 디렉토리를 건드리지 않아도 된다**.

## Reactivity

Meteor는 데이터가 변경되면 화면에 다시 반영해야 하는 노력을 줄여 준다. "Reactive" 데이터 소스와 컨텍스트를 사용해서 구현한다. Reactive 컨텍스트는 Reactive 데이터 소스를 사용하고 필요하면 다시 실행되는 함수다. 처음에는 이 말을 받아들이는 게 쉽지 않을 것이다. 다음 예제가 명백하게 해줄 것이다.

다음은 html 페이지, `cool_dude`라는 이름의 Meteor [템플릿](http://docs.meteor.com/#templates), 클라이언트 Javascript 함수다. 이 Javascript 함수는 템플릿을 렌더링하는 데 필요한 `name`의 값을 리턴한다.

```html
<html>
  <head>
  </head>
  <body>
    {{> cool_dude }}
  </body>
</html>
```

```html
<template name="cool_dude">
  <p class="important">{{ name }} sure is one cool dude!</p>
</template>
```

```javascript
// On the client:
Template.cool_dude.name = function() {
    return "Andrew Scala";
};
```

페이지를 렌더링하면 "Andrew Scala sure is one cool dude!"라고 출력된다. 뭐, 참말이다.

템플릿은 Reactive 컨텍스트다. 템플릿을 렌더링할 때 Reactive 데이터 소스를 사용하면 그 데이터 소스가 변경될 때 다시 렌더링한다. 클라이언트의 `Session` 객체는 Reactive 데이터 소스다. 클라이언트 `Session` 객체는 키-밸류 형태로 클라이언트에 정보를 저장한다. 그리고 페이지가 새로 고쳐지면 날아간다.

Reactive 데이터 소스를 사용해서 템플릿 컨텍스트를 변경해보자:

```javascript
// When the app starts,
// associate the key "username" with the string "Andrew Scala"
Meteor.startup(function() {
    Session.set("username", "Andrew Scala");
});

Template.cool_dude.name = function() {
    return Session.get("username");
};
```

템플릿은 Session에 있는 `"username"`의 값을 가져다가 템플릿 변수 `name`에 넣는다. 이제 Reactive 컨텍스트에 Reactive 데이터 소스가 있는 상태가 됐다. Session의 `"username"` 값이 변하면 템플릿은 새 값을 이용해서 자동으로 다시 렌더링힌다. `"username"` 값을 바꿔보자:

```javascript
Session.set("username", "Bill Murray");
```

이 함수를 호출하자마자(어디서 호출하던 위치는 상관없다) 페이지는 "Bill Murray sure is one cool dude!"로 변경된다. 뭐, 이 말도 참말이다.

Reactive 컨텍스트와 데이터 소스가 궁금하면 Meteor의 [Reactivity 문서](http://docs.meteor.com/#reactivity)를 봐라.

## Publish/Subscribe

***Note:*** 프로젝트 루트 디렉토리에서 `$ meteor remove autopublish`를 꼭 실행해야 한다. Meteor는 기본적으로 모든 데이터를 Publish하는데 이 것른사파의 사술이다(poor practice).

서버는 클라이언트가 사용할 데이터를 Publish하고 클라이언트는 그 데이터를 Subscribe한다. 처음부터 서버가 데이터를 Publish하고 클라이언트가 Subscribe하는 관계를 이해하긴 어렵다. 

경험에 의하면 **

채팅 프로그램이라면 클라이언트는 자기가 참여 중인 채널에서만 메시지를 받아야지 다른 체널의 메시지를 받지 않아야 한다. 사용자 정보도 마찬가지다.

다음 예제는 좀 엉성하다. 클라이언트는 데이터베이스의 모든 메시지를 받는다:

```javascript
var Messages = new Meteor.Collection("messages");

if(Meteor.is_server) {
    Meteor.publish("messages", function() {
        return Messages.find({});
    });
}

if(Meteor.is_client) {
    Meteor.subscribe("messages");
}
```

클라이언트는 이제 `Messages.find({})`를 호출해서 데이터베이스의 모든 메시지를 볼 수 있다. 저질(Bad).

(역주, 클라이언트에서 실행하는 find()는 서버에 요청하지 않고 Minimongo 캐시에서 찾는다. 그러니까, 서버에서 Publish한 데이터는 자동으로 로컬에 캐시되고, 클라이언트에서 find()를 실행하면 그 캐시에서 찾는 구조다. )

Subscribe할 때 파라미터를 명시하면 이 문제를 해결할 수 있다. 모든 메시지에 대해서 Subscribe하는 것이 아니라 실질적으로 필요한 것만 Subscribe한다. `"cool_people_channel"` 채널에 있는 메시지만 받게 고쳐보자:

```javascript
var Messages = new Meteor.Collection("messages");

if(Meteor.is_server) {
    Meteor.publish("messages", function(channel_name) {
        return Messages.find({channel: channel_name});
    });
}

if(Meteor.is_client) {
    Meteor.subscribe("messages", "cool_people_channel");
}
```

이제 클라이언트가 연결하고 메시지를 가져올 때 `"cool_people_channel"` 채널에 있는 것만 가져온다.

`"cool_people_channel"` 채널에 있는 메시지만 보는 것으로는 충분하지 않다. 다른 채널의 메시지도 이용할 수 있어야 한다. Meteor의 "Reactivity" 이용하면 Session 값에 따라서 동적으로 Subscibe하도록 만들 수 있다.

```javascript
var Messages = new Meteor.Collection("messages");

if(Meteor.is_server) {
    Meteor.publish("messages", function(channel_name) {
        return Messages.find({channel: channel_name});
    });
}

if(Meteor.is_client) {
    Session.set("current_channel", "cool_people_channel");

    Meteor.autosubscribe(function() {
        Meteor.subscribe("messages", Session.get("current_channel"));
    });
}
```

[Meteor.autosubscribe](http://docs.meteor.com/#Meteor_autosubscribe)는 Reactive 컨텍스트다. 그래서 그 안에서 사용한 Reactive 데이터 소스가 변경되면 다시 실행된다. `"current_channel"`라는 Session 변수에 무슨 채널인지 저장하고 있고 그 값이 바뀌면 Subscription은 갱신되고 다른 메시지도 받게 된다. 만약 사용자가 "breakfast talk"라는 채널로 바꾸려면 `Session.set("current_channel", "breakfast_talk")`라고 실행해주면 된다. 그러면 autosubscribe의 Reactive 컨텍스트 함수가 다시 실행돼서 이제는 "breakfast_talk" 채널의 메시지를 보게 된다.

클라이언트에 컬렉션을 전부 Publish해야 할 때도 있을 수도 있는데 정말 그게 필요한지 한 번 더 생각해보길 바란다. 그리고 컬렉션의 도큐먼트를 전부 전송하기보다 특정 필드만 전송하는 게 더 낫다.

## Server Methods

클라이언트에서는 데이터베이스에 있는 데이터를 읽어오는 것 말고는 아무것도 하지 않는 것이 좋다. 그러면 클라이언트는 정보를 어떻게 저장해야 할지 궁금해진다. Meteor 서버의 [Method](http://docs.meteor.com/#methods_header)를 사용해서 이 문제를 해결한다. 데이터를 수정하는 것과 같이 위험한 일은 꼭 Method를 이용한다. 서버에 함수를 정의하고 나서 클라이언트에서 그 함수를 호출해서 리턴 값을 받는다. 이게 핵심 아이디어다. 그러면 클라이언트에서는 그 함수가 어떻게 구현됐는지 알 수 없고 다른 방법으로 데이터를 수정하지도 않는다. 그리고 서버는 잘 동작할 것이다.

서버 코드에 `create_user`라는 Method를 만든다. 이 Method는 데이터베이스에 사용자를 추가하는 Method이고 사용자 이름을 아규먼트로 받는다. 사용자를 추가하고 나중에 도큐먼트를 가져올 수 있도록 도큐먼트 ID를 반환한다. 

```javascript
if(Meteor.is_server) {
    Meteor.methods({
        create_user: function(username) {
            console.log("CREATING USER");
            var USER_id = Users.insert({name: username});
            return user_id;
        },
    });
}

// Remember, the client's browser only ever sees the code below:
if(Meteor.is_client) {
    var username = "Andrew Scala";

    Meteor.call("create_user", username, function(error, user_id) {
        Session.set("user_id", user_id);
    });
}
```

이 예제에서, `user_id`를 받아서 클라이언트 Session에 넣는다. 그러면 user_id를 사용하는 템플릿은 자동으로 업데이트된다.

## Protecting your data

클라이언트 앱에서 Javascript 콘솔을 열고 **데이터베이스 쿼리를 실행할 수 있다**. 이것은 정말 구리다. Meteor 앱에 접속해서 콘솔을 열고 `Users.remove({})`라고 실행하면 사용자 데이터가 전부 날아간다.

언젠가는 Meteor가 뭔가 해결책을 제시하겠지만, 지금은 그렇다. 다음은 Meteor의 [madewith](http://madewith.meteor.com) 사이트의 [소스][https://github.com/Meteor/madewith]에서 발췌한 것이다. 이 코드는 클라이언트에서 insert/update/remote 할 수 없게 한다. 다음 코드를 서버 쪽 아무 데나 넣으면 된다:

```javascript
// Relies on underscore.js. In your project directory:
// $ meteor add underscore
Meteor.startup(function() {
    var collections = ['collection_name_1', 'collection_name_2'];

    _.each(collections, function(collection) {
        _.each(['insert', 'update', 'remove'], function(method) {
            Meteor.default_server.method_handlers['/' + collection + '/' + method] = function() {};
        });
    });
});
```

## Stay Tuned

이것으로 Meteor 앱을 만들 준비가 다 됐을까? 기다려라. 두 번째 글, Meteor 앱을 완성하는 방법에 대한 비급을 기대하시라.

이 글이 도움됐는지 알려주면 감사하겠다.

Cheers,

Andrew Scala
