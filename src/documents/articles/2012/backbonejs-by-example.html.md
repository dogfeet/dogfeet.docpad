--- yaml
layout: 'article'
title: 'Backbone.js by example - Part 1'
author: 'Changwoo Park'
date: '2012-2-18'
tags: ['backbone.js', 'MVC', 'Chaker Nakhli']
---

*이 글은 [Chaker Nakhli][]의 '[Backbone.js by example](http://www.javageneration.com/?p=839)'을 번역한 것이다. Backbone.js를 처음 접하는 사람이 다른 자료를 보기 전에 보면 좋다.*

[Backbone.js][]는 JavaScript MVC 라이브러리다. 클라이언트 코드를 깔끔하고 쉽게 만들고 관리할 수 있도록 도와준다. 나는 Backbone.js가 가볍고(~4.5kb) 내가 애플리케이션 관리하는 방식을 해치지 않아서 좋다. Backbone.js는 심지어 [Single Page Interfaces][]나 JavaScript Heavy 애플리케이션에도 사용할 수 있다. Backbone.js로는 클라이언트 코드를 확장하기 쉽고 관리하기도 쉬운 구조를 만들 수 있다.

나는 Backbone.js를 만난 지 몇 주 밖에 안됐지만, 사랑에 빠졌다. 이 글에서 단계별로 짚어가며 그래픽 편집기를 하나 만들어 볼 거다. 어떤 편집기인지 궁금하면 [Demo][online-demo]를 먼저 보자. 이 편집기의 JavaScript 코드는 100밖에 안된다. 우선 Model과 View에 집중할 거고 서버와 통신하기, 라우팅은 다음 글에서 다루겠다.

[Chaker Nakhli]: http://www.javageneration.com/
[Backbone.js]: http://documentcloud.github.com/backbone/
[Single Page Interfaces]: http://itsnat.sourceforge.net/php/spim/spi_manifesto_en.php

## Before we start

이 그래픽 편집기는 파일을 3개로 구성한다. 파일은 editor.js, editor.css, editor.html 인 데 아직 editor.js, edtior.css는 빈 파일이다. 먼저 editor.html 파일을 보자:

    <!doctype html>
    <html>
        <head>
            <link rel="stylesheet" type="text/css" href="editor.css">
            <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
            <script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.2.1/underscore-min.js"></script>
            <script src="http://cdnjs.cloudflare.com/ajax/libs/backbone.js/0.5.3/backbone-min.js"></script>
            <script src="editor.js"></script>
        </head>
        <body>
            <div id="page" style="width:2000px;height:2000px;"></div>
        </body>
    </html>

나는 [cloudflare][]가 제공하는 [cdnjs][]를 사용했다. cloudflare에는 Google이나 Microsoft CDN이 제공하지 않는 것도 있다.

[jsfiddle](http://jsfiddle.net/nakhli/td6Eg/5/)에도 코드를 올려놓았으니 편한 대로 보면 된다. 각 절의 코드를 jsfiddle에 올려놓았다. 그러니 즉시 살펴보고, 테스트하고, Fork해 볼 수 있다.

이제 준비 운동은 끝냈으니 시작하자!

[cdnjs]: http://www.cdnjs.com/
[cloudflare]: https://www.cloudflare.com/

## Models

간단한 도형을 나타내는 Model인 Shape 클래스를 만든다:

    var Shape = Backbone.Model.extend({
        defaults: { x:50, y:50, width:150, height:150, color:'black' },
        setTopLeft: function(x,y) {
            this.set({ x:x, y:y });
        },
        setDim: function(w,h) {
            this.set({ width:w, height:h });
        },
    });

Shape 클래스는 Backbone.Model 클래스를 확장해서 만든다. 클래스를 확장하는 extend 메소드에 어떤 Model인지에 대한 정보를 인자로 넘긴다. 이 Model에 대한 설정은 defaults, setTopLeft, setDim 프로퍼티가 있다:

 * defaults는 특별한 프로퍼티다. 이 프로퍼티에 Model의 기본 프로퍼티와 기본 값을 정의한다. 그래서 모든 Shape 인스턴스에는 x, y, width, height, color 프로퍼티가 있고 기본 값도 할당된다. 중요한 건 Backbone.js가 프로퍼티를 감싸준다는(encapsulation) 것이다. 직접 프로퍼티를 접근하기(getting/setting)보다 Backbone Model에서 상속한 get/set 메소드를 사용한다. Encapsulation 덕에 Model 프로퍼티가 수정되는 것을 관리할 수 있다. set 메소드가 호출되면 event가 발생한다. 그래서 이벤트 리스너를 등록하면 Model이 변경되는 것을 관리할 수 있다.
 * setTopLeft와 setDim은 Helper 메소드로 Backbone의 set 메소드를 호출한다. 이 메소드로 Shape의 크기와 위치를 좀 더 쉽게 설정한다.

Model 클래스는 정의했으니 이제, 인스턴스를 만들고 프로퍼티에 이벤트를 바인딩하는 예제를 살펴보자([jsfiddle](http://jsfiddle.net/nakhli/td6Eg/1/)):

    var shape = new Shape();

    shape.bind('change', function() { alert('changed!'); });
    shape.bind('change:width', function() { alert('width changed! ' + shape.get('width')); });

    shape.set({ width: 170 });
    shape.setTopLeft(100, 100);

3번째 줄은 Model 프로퍼티가 변경될 때 발생하는 change 이벤트를 처리하도록 Listener를 등록하는 것이다. 4번째 줄의 코드는 'width' 프로퍼티만 Listen하는 거다. 6번째 줄에서 width 값을 바꾸면 두 Callback이 모두 실행된다. 하지만, 7번째 줄에서처럼 'setTopLeft' 메소드로 Shape의 위치를 변경하면 'change' 이벤트만 발생한다.

## Binding page elements to model changes

Model을 정의하고 Change 이벤트 리스너를 등록하는 방법을 살펴봤다. 이제, 이 이벤트를 활용하는 방법을 살펴보자. html 페이지에 div 엘리먼트를 정의한다:

    <div class='shape' />

Model이 바뀌면 엘리먼트도 바뀌게 묶는다(jQuery로 DOM 정보를 바꾼다).

    shape.bind('change', function() {
        $('.shape').css({ left:       shape.get('x'),
                          top:        shape.get('y'),
                          width:      shape.get('width'),
                          height:     shape.get('height'),
                          background: shape.get('color') });
    });

매우 쉽다! Model을 수정하면 DOM도 바뀐다. Firebug 같은 브라우저 콘솔을 열어서 다음과 같이 실행해 본다:

    shape.setTopLeft(10, 10);
    shape.setDim(500, 500);

그러면 페이지가 자동으로 업데이트되고 그 Shape 객체의 위치/크기가 새로 바뀐다. 여기서 중요한 것은 DOM을 직접 관리하지 않는다는 것이다. Model이 바뀌면 Model의 Listener가 페이지도 바꾼다. [jsfiddle](http://jsfiddle.net/nakhli/td6Eg/1/)에서 한번 실행해 보자.

사용자가 뭔가 입력하는 상황을 살펴보자. 사용자가 입력해서 Model이 수정되면 간접적으로 페이지도 수정된다.

## Basic user input handling

이 절에서는 사용자가 Shape 객체를 드래그할 수 있게 한다. mousedown, mouseup, mousemove 이벤트를 지켜보다가 Model을 업데이트하는 코드를 살펴보자([jsfiddle](http://jsfiddle.net/nakhli/td6Eg/2/)):

    var dragging = false;

    $('.shape').mousedown(function (e) {
        dragging = true;
        shape.set({ color: 'gray' });
    });

    $('#page').mouseup(function () {
        dragging = false;
        shape.set({ color: 'black'});
    });

    $('#page').mousemove(function(e) {
        if(dragging) {
            shape.setTopLeft(e.pageX, e.pageY);
        }
    });

여기서 보면 shape의 div 엘리먼트가 아니라 page 엘리먼트의 mousemove와 mouseup 이벤트를 Listen한다. 마우스가 div 개체의 영역에서 벗어나도 div 객체가 마우스 포인터를 따라다녀야 하기 때문에 그렇게 한다.

사용자 입력을 jQuery로 간단하게 처리한다는 게 포인트이다. 여기에 DOM을 수정하는 코드는 하나도 없다. 단지 이벤트를 지켜보다가 Model을 바꾼다. 그러면 신기하게도 페이지는 업데이트된다.

정리하자. 사용자 입력을 처리하는 코드, Model을 관리하는 코드, Model이 바뀌면 View도 바꾸는 코드를 분리시켰다. 이제 막 우리는 MVC(Model-View-Controller)를 구현했다.

관련된 것끼리 따로 모으는 방법은 좋다. JQuery Callback이 매우 많은 페이지에서 Callback 스파게티로 만들지 않을 수 있다. 하지만, 아직 더 개선할 수 있다. 아직 Controller 코드와 View 코드가 마구 섞여 있는데 View 클래스 정의해서 해결할 수 있다.

## Model Collections

Backbone Model에는 Collection이라는 Model이 있다. Collection은 Model을 정렬된 집합으로 관리할 수 있게 도와주는 Container다. 이 Collection은 add, remote 이벤트가 있고 이 이벤트를 Listen할 수 있다.

Model 컬렉션을 사용한다. Shape 객체를 담는 Collection인 'Document' Model를 만들자:

    var Document = Backbone.Collection.extend({ model: Shape });

Document 객체를 만들고 add, remote 이벤트 리스너를 등록한다:

    var document = new Document();

    document.bind('add', function(model) { alert('added'); });
    document.bind('remove', function(model) { alert('removed'); });

    document.add(shape); // fires add event
    document.remove(shape); // fires remove event

## Views

Backbone.js에서 View는 Model(이나 Collection)과 함께 사용한다. View의 역할은 다음과 같다:

 * Model을 DOM 엘리먼트로 렌더링한다. Model의 change 이벤트를 지켜보고 있다가 바뀌면 페이지도 바꾼다.
 * DOM 엘리먼트의 이벤트를 처리하고 다시 Model을 업데이트한다.

MVC 이론과 비교했을 때, Backbone의 View는 View와 Controller의 역할을 둘 다 떠맡는다. Backbone의 View는 사용자 입력(DOM 이벤트)을 처리하고 Model도 업데이트한다. 게다가 Model 이벤트를 Listen하다가 바뀌면 다시 화면을 업데이트한다. 하지만, 실제로 구현할 때 다른 메소드에 구현할 거라서 이 점은 별로 중요하지 않다. 

### Shape View

Shape Model을 사용하는 Shape View 코드를 살펴보자. 이 View는 Shape을 표현하는 Html 엘리먼트와 그 Html 엘리먼트를 감싸는(Decorate) 'control' 엘리먼트를 관리한다. 'control' 엘리먼트는 사용자가 Shape을 드레그하고, Shape의 크기를 바꾸고, Shape을 삭제하고, Shape의 색을 바꿀 수 있게 해준다.

    var ShapeView = Backbone.View.extend({
        initialize: function() {
            this.model.bind('change', this.updateView, this);
        },
        render: function() {
            $('#page').append(this.el);
            $(this.el)
                .html('<div class="shape"/>'
                      + '<div class="control delete hide"/>'
                      + '<div class="control change-color hide"/>'
                      + '<div class="control resize hide"/>')
                .css({ position: 'absolute', padding: '10px' });
            this.updateView();
            return this;
        },
        updateView: function() {
            $(this.el).css({
                left:       this.model.get('x'),
                top:        this.model.get('y'),
                width:      this.model.get('width') - 10,
                height:     this.model.get('height') - 10 });
            this.$('.shape').css({ background: this.model.get('color') });
        },
        events: {
            'mousemove'               : 'mousemove',
            'mouseup'                 : 'mouseup',
            'mouseenter .shape'       : 'hoveringStart',
            'mouseleave'              : 'hoveringEnd',
            'mousedown .shape'        : 'draggingStart',
            'mousedown .resize'       : 'resizingStart',
            'mousedown .change-color' : 'changeColor',
            'mousedown .delete'       : 'deleting',
        },
        hoveringStart: function () {
            this.$('.control').removeClass('hide');
        },
        hoveringEnd: function () {
            this.$('.control').addClass('hide');
        },
        draggingStart: function (e) {
            this.dragging = true;
            this.initialX = e.pageX - this.model.get('x');
            this.initialY = e.pageY - this.model.get('y');
            return false; // prevents default behavior
        },
        resizingStart: function() {
            this.resizing = true;
            return false; // prevents default behavior
        },
        changeColor: function() {
            this.model.set({ color: prompt('Enter color value', this.model.get('color')) });
        },
        deleting: function() {
            this.remove();
        },
        mouseup: function () {
            this.dragging = this.resizing = false;
        },
        mousemove: function(e) {
            if (this.dragging) {
                this.model.setTopLeft(e.pageX - this.initialX, e.pageY - this.initialY);
            } else if (this.resizing) {
                this.model.setDim(e.pageX - this.model.get('x'), e.pageY - this.model.get('y'));
            }
        }
    });

코드는 좀 길지만 매우 간단하다. 중요한 것만 짚어보자:

 * initialize는 View가 생성될 때 실행되는 함수다. Model의 이벤트 리스너를 등록하려면 여기서 해야 한다. View에서 Model change 이벤트를 등록한다.
 * render는 View를 초기화하고 나서 실행된다. 여기서 View에 필요한 Html 엘리먼트를 초기화하고 DOM에 추가한다. View의 Html 엘리먼트를 el 프로퍼티에 할당시켜 놓는다. 이 el 프로퍼티는 Backbone View에서 상속받은 거다. 먼저 '#page'에 el을 추가하고 그다음 줄에서 shape과 control 엘리먼트를 추가한다. 그리고 마지막 줄에서 Model을 View에 적용한다.
 * View에서 events 해시는 매우 중요하다. 이 부분이 이벤트와 리스너를 연결하는 부분이다. `{ 'event selector': 'handler' }` 형식으로 정의한다. 예를 들어 `{ 'mousedown .shape': 'draggingStart' }`는 '.shape' 에 mousedown 이벤트가 Fire되면 draggingStart 메소드를 실행시킨다. 이 events 해시는 사용자 입력을 어떻게 처리할지를 정의하는 것인데 이 부분이 Controller 역할에 해당한다.

사실 여기에 기술적인 문제가 조금 있다. 'Basic user input handling' 절에서도 말했지만, Shape Div 그 자체가 아니라 부모인 page 엘리먼트의 mousemove와 mouseup 이벤트를 Listen하고 있어야 더 나은 UX를 얻을 수 있다. 현 코드는 사용자가 마우스를 너무 빨리 움직일 때 부드럽지 못하다. 이 코드는 [jsfiddle](http://jsfiddle.net/nakhli/td6Eg/4/)에 구현했다.

### Document View

먼저 만들었던 Document Model를 위한 DocumentView도 만들어야 한다. 그래야 Shape View를 관리할 수 있다:

    var DocumentView =  Backbone.View.extend({
        id: 'page',
        views: {},
        initialize: function() {
            this.collection.bind('add', this.added, this);
            this.collection.bind('remove', this.removed, this);
        },
        render: function() {
            return this;
        },
        added: function(m) {
            this.views[m.cid] = new ShapeView({
                model: m,
                id:'view_' + m.cid
            }).render();
        },
        removed: function(m) {
            this.views[m.cid].remove();
            delete this.views[m.cid];
        }
    });

id 프로퍼티는 View에 묶인 DOM의 id다. Backbone은 이 값으로 DOM을 찾아 el 프로퍼티를 설정한다. 이미 html 페이지에 있는 엘리먼트를 사용하기 때문에 render 메소드에서 새로 만들지 않는다.

initailize 메소드에서 Collection View의 add, remove 이벤트 Listener를 등록한다. Add 이벤트에서 Shape Model과 View를 만들고 렌더링한다. Shape View는 모두 views 프로퍼티에서 관리한다. 그리고 remove 이벤트가 발생하면 document에서 해당 Shape을 페이지에서도 삭제하고 views 프로퍼티에서도 삭제한다.

이 코드는 [jsfiddle](http://jsfiddle.net/nakhli/td6Eg/4/)에 있다.

## Conclusion

이 소스는 [github](https://gist.github.com/1596813)와 [jsfiddle](http://jsfiddle.net/nakhli/td6Eg/5/)에 있다. 그리고 [데모][online-demo]도 있다.

이 튜토리얼은 Backbone.js의 MVC와 이벤트 시스템이 어떻게 생겼는지 보여준다. 앞에서도 언급했지만, 아직 서버와 통신하기, 라우팅에 대해서 다루지 않았다. Backbone.js는 CRUD를 쉽게 처리할 수 있도록 돕는다. 다음 글에서는 이 내용을 다룰 것이다.

[online-demo]: http://www.javageneration.com/wp-content/uploads/2012/01/editor.html
