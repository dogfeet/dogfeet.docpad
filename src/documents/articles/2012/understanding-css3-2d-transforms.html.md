--- yaml
layout: 'article'
title: 'Understanding CSS3 2D Transforms'
author: 'Yongjae Choi'
date: '2012-9-10'
tags: ['2d', 'transform', 'css', 'translation']
---
 
이 글은 Klemen Slavič의 [Understanding CSS3 2D Transforms][]를 번역한 글이다. 최근 CSS의 transform으로 DOM 객체를 이동시키는데 좌표이동이 헷갈려 정리하고 지나가려 한다. 2011년 3월의 글이라 현재는 다 구현되었는데 글에서는 구현 중으로 표현할 수도 있으니 혼란스러워하지 말길 바란다.

![optimus-prime][]

## 변환(Transformation)이 뭐냐?

수학적으로 엄격하고 광의로의 변환은 한 집합의 요소 X를 다른 집합의 Y로 대응시키는 연산이다. 기하학에서는 한 공간상의 객체들을 다른 기하 공간상에 1:1로 옮기는 수학적 방법이라고 한다.

더 쉽게 말하자면, 우리가 물건을 하나 집어서 이리저리 변형을 시킬 수 있다는 뜻이다. '이리저리 변형'이라는 것은 순서가 있는 변환 연산 리스트이다. 변환 연산의 종류는 이동, 확대, 반사, 회전, 기울임이 있다. 이 정도면 쉽게 설명했다. 오케이?

객체를 다루는 영역으로 들어가기 전에 우린 이런 변환들이 정확히 어떻게 동작하는지 알아야 한다. 말했듯이 변환 그룹은 순서 있는 변환 연산의 집합이다. 따라서 변환 연산의 순서에 따라 결과가 달라진다. 변환은 객체의 현재 위치 등 온갖 기하학적 요소를 고려해서 적용되기 때문이다.

### 변환의 원점(Origin) 이해하기

아래의 간단한 예제를 보자. 2x2 크기의 사각형의 중심이 원점(0, 0)에 있다.

![origin][]

이 객체를 2 만큼 확대한 후 1 만큼 오른쪽으로 이동하고 나서 0.5만큼 위로 이동시키면 아래와 같은 결과가 나타난다.

![scale-then-move][]

정확히 원하던 결과가 나왔다. 사각형은 이제 4x4 크기의 중심이 (1, 0.5)로 옮겨졌다. 하지만 만약 우리가 이 순서를 반대로 적용했다면? 아래에 그 결과가 있다.

![move-then-scale][]

결과는 올바르다. 하지만 딱 보기에 좀 이상하게 보인다. 사각형의 중심이 이전 예제와는 다르게 (1, 0.5)가 아니라 (2, 1)이다. 변환 결과의 위치가 바뀐 이유는 변환이 변환 원점에 의존적이고 변환 원점이 위치를 포함한 객체의 모든 특성에 적용되기 때문이다. 만약 객체에 변환 원점과 관련이 있는 오프셋이 있다면 이 위치는 다른 특성들을 따라 같이 변환된다. 이 경우에는 객체의 x, y가 2만큼 늘어났다. (즉, 늘어난 뒤 이동한 게 아니라 이동 뒤에 늘어났기 때문이다.)

이게 어려워도 혼란스러워 하지 마라. 변환 원점의 기본값이 (0, 0)이긴 하지만 명시적으로 이 원점을 바꿀 수 있다. 다음 예제는 사각형을 (2, 2)를 기준으로 시계방향 30도 회전한 것이다.

![rotate-without-origin][]

객체가 원점에서부터 떨어져 있기 때문에 사각형 전체가 원점을 중심으로 회전했다. 만약 객체가 왼쪽 위를 중심으로 돌아가게 하고 싶다면 변환 원점을 객체의 왼쪽 위로 옮긴 다음에 회전해야 한다.

여기서 짚고 넘어가야 할 기술적 이슈가 있다. 단일 변환 그룹은 단일 변환 원점에만 적용할 수 있다. 이것은 또 다른 원점을 지정하더라도 다른 개별 변환이 진행되는 동안에는 원점이 변하지 않는다는 의미다. 이를 우회하는 방법은 객체를 원점 주위에 위치시키고 변환을 적용한 후에 객체를 제자리에 옮기면 된다.

### 화면 공간 vs 유클리드 공간

모니터 화면을 고전적인 유클리드 공간이라 생각하면 변환에 대해 더 정확히 이해할 수 있다. 실제 컴퓨터 그래픽(웹페이지도 포함해서)에서는 좌표시스템을 변경해서 사용한다.

편의상 모든 윈도우에서 원점은 왼쪽 위에 있고 y축이 아래쪽이다. 그래서 화면의 모든 픽셀은 양의 정수로 표현할 수 있다.


## TILT!

변환의 수학적인 개념을 숙지한 채로 이것들을 CSS로 어떻게 구현하는지 알아보자.

시작하기 전에 주의할 것이 있다. 여기서 사용할 CSS의 기능들이 모든 브라우저에서 구현이 안 되어있다. 따라서 표준 CSS 프로퍼티 앞에 벤더에 종속적인 접두어를 표기 할 것이다. '흥미로운 것들' 섹션을 보면 크로스-브라우저 CSS 변환을 위한 중복 표기를 우회하는 방법을 설명해놨다.


### 변환 원점(Transformation origin)

변환 원점을 지정하는 건 trasform-origin이라는 CSS 프로퍼티를 이용한다.

  1. -moz-transform-origin: 50% 50%;
  2. -webkit-transform-origin: 50% 50%;
  3. -ms-transform-origin: 50% 50%;
  4. -o-transform-origin: 50% 50%;
  5. transform-origin: 50% 50%;

변환 원점의 기본값은 바운딩 박스(bounding box)의 가운데이고 바운딩 박스의 왼쪽 위 모서리 좌표가 (0,0)이다.

### 변환 그룹(Transformation groups)

CSS의 transform 프로퍼티에 적용할 변환 연산의 리스트를 순서대로 적어주는 것만으로 변환 그룹을 만들 수 있다.

  1. -moz-transform: &lt;trans1&gt; &lt;trans2&gt; ...;
  2. -webkit-transform: &lt;trans1&gt; &lt;trans2&gt; ...;
  3. -ms-transform: &lt;trans1&gt; &lt;trans2&gt; ...;
  4. -o-transform: &lt;trans1&gt; &lt;trans2&gt; ...;
  5. transform: &lt;trans1&gt; &lt;trans2&gt; ...;

여기서 &lt;trans1&gt;, &lt;trans2&gt;등은 서로 다른 변환 연산들이다. 각 연산은 공백문자로 구분한다.

### 평행이동(Translation)

객체를 평행이동시키려면 translate, translateX, translateY라는 키워드를 사용한다.

  1. -moz-transform: translate(tx[, ty]) | translateX(tx) | translateY(ty);
  2. -webkit-transform: translate(tx[, ty]) | translateX(tx) | translateY(ty);
  3. -ms-transform: translate(tx[, ty]) | translateX(tx) | translateY(ty);
  4. -o-transform: translate(tx[, ty]) | translateX(tx) | translateY(ty);
  5. transform: translate(tx[, ty]) | translateX(tx) | translateY(ty);

tx는 가로 방향 오프셋이고 ty는 세로 방향 오프셋이다. 아래는 이미지를 60픽셀 오른쪽, 20픽셀 아래쪽으로 움직이는 예제이다.

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl04_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/01.html" height="220" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. -moz-transform: translate(60px, 20px);
  2. -webkit-transform: translate(60px, 20px);
  3. -ms-transform: translate(60px, 20px);
  4. -o-transform: translate(60px, 20px);
  5. transform: translate(60px, 20px);


### 스케일링(Scaling)

객체를 확대하거나 축소하려면 scale이나 scaleX, scaleY를 이용한다.

  1. -moz-transform: scale(sx[, sy]) | scaleX(sx) | scaleY(sy);
  2. -webkit-transform: scale(sx[, sy]) | scaleX(sx) | scaleY(sy);
  3. -ms-transform: scale(sx[, sy]) | scaleX(sx) | scaleY(sy);
  4. -o-transform: scale(sx[, sy]) | scaleX(sx) | scaleY(sy);
  5. transform: scale(sx[, sy]) | scaleX(sx) | scaleY(sy);

스케일링은 인자로 들어온 크기만큼 객체를 확대/축소 시킨다. 각 인자는 단위가 없는 숫자이다. 만약 scale 키워드에 인자 하나만 넘긴다면, 유니폼 스케일로 작동한다. (가로 세로의 비율을 유지하면서 스케일링 된다.) 음수가 인자로 들어오면 각 축에 대칭적으로 스케일링 된다.

아래에 객체를 오른쪽 위를 기준으로 80% 축소하는 예제를 보자.

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl07_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/02.html" height="220" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. /* 원점을 오른쪽 위로 지정한다. */
  2. -moz-transform-origin: 100% 0;
  3. -webkit-transform-origin: 100% 0;
  4. -ms-transform-origin: 100% 0;
  5. -o-transform-origin: 100% 0;
  6. transform-origin: 100% 0;
  7. &nbsp;
  8. /* 80% 축소 */
  9. -moz-transform: scale(0.8);
  10. -webkit-transform: scale(0.8);
  11. -ms-transform: scale(0.8);
  12. -o-transform: scale(0.8);
  13. transform: scale(0.8);

x축을 기준으로 이미지를 반전시키려면 scaleY에 음수를 넘긴다. 

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl09_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/03.html" height="220" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. /* 요소의 중간을 원점으로 잡기(기본값) */
  2. -moz-transform-origin: 50% 50%;
  3. -webkit-transform-origin: 50% 50%;
  4. -ms-transform-origin: 50% 50%;
  5. -o-transform-origin: 50% 50%;
  6. transform-origin: 50% 50%;
  7. &nbsp;
  8. /* 이미지의 가운데를 중심으로 가로로 뒤집기 */
  9. -moz-transform: scaleY(-1);
  10. -webkit-transform: scaleY(-1);
  11. -ms-transform: scaleY(-1);
  12. -o-transform: scaleY(-1);
  13. transform: scaleY(-1);

### 회전(Rotation)

객체를 회전시킬 때에는 rotate를 사용한다.

  1. -moz-transform: rotate(&lt;angle&gt;);
  2. -webkit-transform: rotate(&lt;angle&gt;);
  3. -ms-transform: rotate(&lt;angle&gt;);
  4. -o-transform: rotate(&lt;angle&gt;);
  5. transform: rotate(&lt;angle&gt;);

&lt;angle&gt;은 객체를 변환 원점을 기준으로 얼마나 회전시킬지를 결정한다. 단위를 적어줘야 한다(deg, rad, grad 중에 하나) 양수는 시계방향 회전을 의미한다. 아래 예제는 객체를 오른쪽 아래 모서리를 기준으로 회전시키는 것이다.

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl12_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/04.html" height="220" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. /* 오른쪽 아래를 원점으로 잡기 */
  2. -moz-transform-origin: 100% 100%;
  3. -webkit-transform-origin: 100% 100%;
  4. -ms-transform-origin: 100% 100%;
  5. -o-transform-origin: 100% 100%;
  6. transform-origin: 100% 100%;
  7. &nbsp;
  8. /* 시계방향으로 30도 회전 */
  9. -moz-transform: rotate(30deg);
  10. -webkit-transform: rotate(30deg);
  11. -ms-transform: rotate(30deg);
  12. -o-transform: rotate(30deg);
  13. transform: rotate(30deg);

### 기울이기(Skewing)

객체를 기울이려면 skew나 skewX, skewY를 사용한다.

  1. -moz-transform: skew(&lt;angleX&gt;[, &lt;angleY&gt;]) | skewX(&lt;angleX&gt;) | skewY(&lt;angleY&gt;);
  2. -webkit-transform: skew(&lt;angleX&gt;[, &lt;angleY&gt;]) | skewX(&lt;angleX&gt;) | skewY(&lt;angleY&gt;);
  3. -ms-transform: skew(&lt;angleX&gt;[, &lt;angleY&gt;]) | skewX(&lt;angleX&gt;) | skewY(&lt;angleY&gt;);
  4. -o-transform: skew(&lt;angleX&gt;[, &lt;angleY&gt;]) | skewX(&lt;angleX&gt;) | skewY(&lt;angleY&gt;);
  5. transform: skew(&lt;angleX&gt;[, &lt;angleY&gt;]) | skewX(&lt;angleX&gt;) | skewY(&lt;angleY&gt;);

기울이기는 축의 방향만 바꾸는 거라서 변환 원점과는 관계가 없다. 각도의 단위는 deg, rad, grad 중에 하나를 사용한다. 회전 연산에서 각도가 양수이면 시계 방향으로 회전하지만 여기서는 반대로 동작한다. 그리고 논리적으로 추측해 봤을 때 skewX와 skewY는 각각 x와 y축 자체에 영향을 줄 것으로 생각할 수 있지만 사실 그건 객체가 기울어질 방향을 의미한다.

예제를 보자

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl15_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/05.html" height="220" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. /* 원점을 왼쪽 위 모서리로 옮김 */
  2. -moz-transform-origin: 0 0;
  3. -webkit-transform-origin: 0 0;
  4. -ms-transform-origin: 0 0;
  5. -o-transform-origin: 0 0;
  6.  transform-origin: 0 0;
  7. &nbsp;
  8. /* 객체를 가로축을 기준 시계방향으로 20도 기울임 */
  9. -moz-transform: skewX(-20deg);
  10. -webkit-transform: skewX(-20deg);
  11. -ms-transform: skewX(-20deg);
  12. -o-transform: skewX(-20deg);
  13. transform: skewX(-20deg);

변환이 어떻게 일어나는지 이 예제로 확실히 알 수 있다. 만약 skewX에 음수의 인자를 넘긴다면 객체는 오른쪽으로 기울진다. 수평 방향 기울이기도 똑같다. 하지만 여기선 양수가 시계방향을 의미한다.

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl17_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/06.html" height="220" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. /* 원점을 왼쪽 위 모서리로 옮김 */
  2. -moz-transform-origin: 0 0;
  3. -webkit-transform-origin: 0 0;
  4. -ms-transform-origin: 0 0;
  5. -o-transform-origin: 0 0;
  6. transform-origin: 0 0;
  7. &nbsp;
  8. /* 객체를 세로축 기준, 반시계방향으로 20도 기울임 */
  9. -moz-transform: skewY(-20deg);
  10. -webkit-transform: skewY(-20deg);
  11. -ms-transform: skewY(-20deg);
  12. -o-transform: skewY(-20deg);
  13. transform: skewY(-20deg);

아직도 어떤 방향이 어떤 것인지 모르겠다면 우선 해보는 게 더 나을 것이다.

## 바이바이 수평, 우린 널 기억할 거야.

우리는 각 변환을 마스터했다. 이제는 원하는 효과를 내기 위해서 변환 그룹을 배워보자.

일반적으로 CSS 변환은 버튼에 마우스를 올리면 비틀고, 확대해서 사용자가 그들을 클릭하도록 하는 데에 사용된다. 이 효과는 회전과 스케일링을 이용하면 간단히 구현할 수 있다. 한번 만들어보자.

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl19_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/07.html" onload="setFrameHeight(this);" height="100%" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. button {
  2.   padding: 1em 2em;
  3. }
  4. &nbsp;
  5. button:hover {
  6. -moz-transform: rotate(3deg) scale(1.05);
  7. -webkit-transform: rotate(3deg) scale(1.05);
  8. -ms-transform: rotate(3deg) scale(1.05);
  9. -o-transform: rotate(3deg) scale(1.05);
  10. transform: rotate(3deg) scale(1.05);
  11. }

묘하게 회전하면서 확대되는 효과를 만들어서 버튼이 사용자에게 튀어 오르는 효과를 만들어 클릭을 유도했다.

안에 있는 요소의 변환 그룹과 함께 변환할 수도 있다. 아래는 버튼을 다른 요소로 감싸서 버튼과 버튼을 감싼 요소를 서로 다른 방향으로 회전시킨 예제이다.

<iframe id="ctl00_MTContentSelector1_mainContentContainer_ctl21_iframeinclude" src="http://www.microsoft.com/feeds/ScriptJunkie/articlesamples/gg709742/08.html" onload="setFrameHeight(this);" height="100%" width="550" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>

  1. .wrapper {
  2.   margin: 5px;
  3.   padding: 5px;
  4.   background: red;
  5. }
  6. &nbsp;
  7. .wrapper:hover {
  8. -moz-transform: rotate(-3deg) scale(1.05);
  9. -webkit-transform: rotate(-3deg) scale(1.05);
  10. -ms-transform: rotate(-3deg) scale(1.05);
  11. -o-transform: rotate(-3deg) scale(1.05);
  12. transform: rotate(-3deg) scale(1.05);
  13. }
  14. &nbsp;
  15. .wrapper button {
  16.   padding: 5px 10px;
  17. }
  18. &nbsp;
  19. .wrapper button:hover {
  20. -moz-transform: rotate(6deg) scale(1.05);
  21. -webkit-transform: rotate(6deg) scale(1.05);
  22. -ms-transform: rotate(6deg) scale(1.05);
  23. -o-transform: rotate(6deg) scale(1.05);
  24. transform: rotate(6deg) scale(1.05);
  25. }

이런 경우엔 마우스가 버튼을 감싼 요소에 올라갔을 때 감싼 요소가 가진 모든 요소가 변환된다. 그 뒤에 마우스가 버튼 위에 올라갔을 땐 버튼에 적용된 변환 그룹에 따라 변환된다. 이 둘은 독립적이지만 계층적으로 적용된다. 즉 부모 요소의 변환은 모든 자식 요소에 적용된다.

### 2D 변환 vs 3D 변환

여기서 지금까지 배운 것으로 3D변환을 하려면 어떻게 해야 할까. 흠, 만약 단순한 정사영만 필요하다면 객체를 기울이고 이동시키는 변환만으로 가능하다. 하지만 진짜 원근법(아니면 비선형 투영)이 필요하다면 불쌍하다고 해야겠다.

위에서 봤듯이 기울이기는 두 축의 각도를 바꾸기만 하는데 세 번째 축이 생기면 원근법이 적용되어 공간상의 점이 한쪽 평면에 투영되었을 때, 위치가 변한다. 다시 말해, 객체가 더 멀어질수록 더 작게 보인다는 것이다. 이건 2D 변환을 이용해서는 정확하게 구현할 수 없다.

만약 3D 변환이 필요하다면 2가지 선택지가 있다. CSS 2D 변환과 비슷한 문법을 가진 실제 CSS 3D 변환을 하거나 WebGL을 이용하는 것이다. 그런데 두 가지 전부 제대로 지원하는 브라우저가 없고 가장 최신의 몇몇 브라우저만이 지원한다. 게다가 이건 이 글에서 다루지 않기로 했었다.

만약 초심자용 글을 원한다면 [웹킷 블로그](http://www.ticketmonster.co.kr/deal/5807965/)를 보면 된다. 여기에 3D 변환의 기초 구현 예제들이 있다.

## 그래서 이게 어디서 돌아가는데?

옛날에 IE6에서 자기들만의 CSS의 필터를 처리하기 위해 DXtransform을 지원하기는 했지만, 그 당시에는 비슷한 기능이라도 구현한 브라우저는 없었기에 2D 변환은 지금 브라우저에서는 참신한 것이다. 그래도 최근에 브라우저 개발 경쟁에 불이 붙어 모든 주요 브라우저 벤더들이 자사 브라우저들의 최신 릴리즈에 2D 변환기능을 넣어가고 있고 하드웨어 가속을 이용하는 브라우저도 있다.  (역자 주: 2011년 3월 글이다.)

현재 다음의 브라우저들이 변환을 지원하고 있다.

<style>
  .grid td {
    padding: 5px;
    border: solid #333 1px;
  }
</style>
<table class="grid">
  <thead>
    <tr style="background-color:black;color:white;">
      <th id="th204812500000">Browser</th>
      <th id="th204812500001">Since</th>
      <th id="th204812500002">Implementing</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th style="padding: 5px; border: solid #333 1px;" id="th204812500100" rowspan="2">Internet Explorer</th>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500001 th204812500100">5.5</td>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500002 th204812500100"><ul><li>Via proprietary CSS DirectX filter:&nbsp;<a id="ctl00_MTContentSelector1_mainContentContainer_ctl24" href="http://msdn.microsoft.com/en-us/library/ms533014(VS.85,loband).aspx" onclick="javascript:Track('ctl00_MTContentSelector1_mainContentContainer_ctl00|ctl00_MTContentSelector1_mainContentContainer_ctl24',this);">Matrix Filter</a></li></ul></td>
    </tr>
    <tr>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500000 th204812500100 th204812500300 th204812500400 th204812500500 th204812500600 th204812500700">9.0</td>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500001"><ul><li>-ms-transform</li></ul></td>
    </tr>
    <tr>
      <th style="padding: 5px; border: solid #333 1px;" id="th204812500300">Firefox (Gecko)</th>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500001 th204812500300">3.5 (1.9.1)</td>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500002 th204812500300"><ul><li>-moz-transform</li><li>transform (<em>newer versions</em>)</li></ul></td>
    </tr>
    <tr>
      <th style="padding: 5px; border: solid #333 1px;" id="th204812500400">Opera</th>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500001 th204812500400">10.5</td>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500002 th204812500400"><ul><li>-o-transform</li><li>transform (<em>newer versions</em>)</li></ul></td>
    </tr>
    <tr>
      <th style="padding: 5px; border: solid #333 1px;" id="th204812500500">Safari (WebKit)</th>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500001 th204812500500">3.1 (525)</td>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500002 th204812500500"><ul><li>-webkit-transform</li><li>transform (<em>newer versions</em>)</li></ul></td>
    </tr>
    <tr>
      <th style="padding: 5px; border: solid #333 1px;" id="th204812500600">Chrome</th>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500001 th204812500600">1.0</td>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500002 th204812500600"><ul><li>-webkit-transform (using WebKit engine)</li><li>transform (<em>newer versions</em>)</li></ul></td>
    </tr>
    <tr>
      <th style="padding: 5px; border: solid #333 1px;" id="th204812500700">iOS</th>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500001 th204812500700">all versions</td>
      <td style="padding: 5px; border: solid #333 1px;" headers="th204812500002 th204812500700">-webkit-transform (using WebKit engine)</td>
    </tr>
  </tbody>
</table>


## 흥미로운 것들

### 성능

위의 브라우저 지원 목록을 보고 곧바로 자리에 앉아 막 객체들을 변환해서 홈페이지를 이리저리 돌아다니도록 할 수도 있다. 기술적으로 분명 가능하다. 하지만 CSS 변환을 이용한 크로스-브라우저 지원은 비용이 많이 들어가고 성능상의 문제도 있다.

2D 하드웨어 가속을 지원하지 않는 브라우저는 모든 변환을 CPU로 해결한다. 구린 렌더링 엔진을 가진 브라우저의 예로 Firefox pre-4.0이나 Internet Explorer pre-9 정도가 있다. 가속하든 안 하든 올바르게 변환되지만, IE 같은 경우는 성능이 구리다. 많은 변환 연산을 하는 웹페이지는 성능저하를 일으킬 것이다. IE는 z-index 문제도 일어날 수 있다.  

### 렌더링

여러 플랫폼에서 돌아가는 크롬에 관해 주의해야 할 또 다른 점은 회전/기울어진 이미지(다른 DOM 요소는 해당하지 않는다.)의 가장자리가 윈도우즈에서는 안티엘리어싱이 적용되지 않고 톱니 모양으로 자글자글한다는 것이다. 이 문제는 리눅스에서도 보인다. 리눅스에서 모든 회전된 문자열은 안티엘리어싱이 적용되지 않고, 글자들 일부분은 끊어져 깨져 보이는 데다가 대부분의 작은 글자는 변환 연산을 거치면 읽을 수도 없다.

### 애들...아니 유저를 생각해!

아직도 CSS 변환을 만지작 거리고 있다면(그리고 그래야만 한다면!) 2D CSS 변환을 지원하지 않는 브라우저를 이용하고 있는 사용자들을 위해 [Modernizr][]를 이용하면 그런 변환을 대체할 수 있는 표현이나 우아하게 다운그레이드된 화면을 보여줄 수 있다. 만약 그게 필요하다면 브라우저의 지원 여부를 알아내서 순수 CSS로 대체 화면을 만들어내거나 요소를 숨기거나 할 수 있다. 예제로 이 글에 있는 iframe은 대체 할 화면을 보여줄 수 있으며 사용자에게 CSS 변환을 지원하지 않는 버전을 사용하고 있다고 알려준다.

또, 만약 여러 버전의 CSS 어트리뷰트를 작성하기가 싫다면 [cssSandpaper][]를 사용해보는 것도 좋다. cssSandpaper는 표준 문법으로 모든 벤더들에서 작동하는 CSS 어트리뷰트를 만들어준다. 그리고 W3C 문법을 DirectX필터로 바꿔서 Explorer5.5에서도 돌아갈 수 있도록 만들어준다.

## 가랏!

그게 2D CSS 변환의 요지이다. 우리는 텍스트, 이미지에 무려 비디오까지 기울이고 자르고 늘이고 줄일 수 있다. 우리는 우리가 과거에 비트맵에서 했던 모든 것들을 여기서 할 수 있다.
이제 가서 슬슬 일해!

 
[origin]: /articles/2012/css-transform/gg709742.01-origin(en-us,MSDN.10).png
[scale-then-move]: /articles/2012/css-transform/gg709742.02-scale-then-move(en-us,MSDN.10).png
[move-then-scale]: /articles/2012/css-transform/gg709742.03-move-then-scale(en-us,MSDN.10).png
[rotate-without-origin]: /articles/2012/css-transform/gg709742.04-rotate-without-origin(en-us,MSDN.10).png
[rotate-with-origin]: /articles/2012/css-transform/gg709742.05-rotate-with-origin(en-us,MSDN.10).png
[optimus-prime]: /articles/2012/css-transform/optimus-prime.jpeg

[Webkit blog]: http://webkit.org/blog/386/3d-transforms/
[Understanding CSS3 2D Transforms]: http://msdn.microsoft.com/en-us/magazine/gg709742.aspx
[Modernizr]: http://modernizr.com/
[cssSandpaper]: http://www.useragentman.com/blog/2010/03/09/cross-browser-css-transforms-even-in-ie/





