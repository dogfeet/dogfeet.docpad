--- yaml
layout: 'article'
title: 'J언어 배우기 - 제 2장: 리스트와 테이블'
author: 'Yongjae Choi'
date: '2012-04-14'
tags: ['J', 'jsoftware', 'language', 'J언어']
---

[Learning J][Learning J]의 Chapter2 를 번역했다. 이번엔 리스트와 테이블에 관한 내용이다. 굉장히 기초적이고 중요한 내용이다. 특히 배열의 차원(dimension)에 관한 이야기는 나중에 나올 랭크라는 개념을 이해하기 위한 초석이므로 예제들을 잘 봐야 한다. 눈에 보이는 데이터가 같다고 해서 같은 데이터가 아니라는 것도 중요하다. 지금 말하고 있는 게 무슨 말인지 모르겠다면 이번 챕터를 읽도록 하자.

자 시작하자.

![j-code](/articles/2012/learning-j-chapter2/j-code.png)

계산(computation)을 하려면 데이터가 필요하다. 지금까지 단일 숫자와 숫자 리스트로 된 데이터만을 다뤘다. 하지만 테이블 같은, 다른 형태를 가진 데이터도 생각해볼 수 있다. 그런 데이터 즉, 리스트나 테이블들을 "배열"(Array)이라고 한다.

## 2.1 테이블

2행 3열 테이블은 `$`함수로 만든다.

       table =: 2 3   $   5 6 7  8 9 10
       table
    5 6  7
    8 9 10

위 예제는 `x $ y`라는 표현식으로 테이블을 만드는 것을 보여준다. x는 테이블의 차원(dimensions)을 결정한다. x는 행의 개수 다음에 열의 개수가 오는 리스트의 형태이다. 테이블은 y의 내용으로 채워진다.
y의 아이템을 순서대로 가져와서 첫 번째 행을 채우고 다음에는 두 번째 행을 채워나간다. 행이 더 있으면 계속 y의 아이템을 가져와 순서대로 채운다. y는 적어도 하나 이상의 아이템을 가지고 있어야만 한다. 만약 y의 아이템 개수가 테이블을 채우기 부족하다면 y의 처음부터 재사용한다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>2 4 $ 5 6 7 8 9</tt></td>
<td><tt>2 2 $ 1</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6 7 8<br>
9 5 6 7</tt></td>
<td><tt>1 1<br>
1 1</tt></td>
</tr></tbody></table>

`$`함수는 한가지 방식으로만 테이블을 만든다. 더 많은 방식을 보고 싶다면 5장을 참고하시라.

우리가 배웠던 함수들은 이전에 리스트 데이터에서도 그랬듯이 테이블 데이터에도 정확하게 똑같이 적용된다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>table  </tt></td>
<td><tt>10 * table</tt></td>
<td><tt>table + table</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6&nbsp;&nbsp;7<br>
8 9 10</tt></td>
<td><tt>50 60&nbsp;&nbsp;70<br>
80 90 100</tt></td>
<td><tt>10 12 14<br>
16 18 20</tt></td>
</tr></tbody></table>

한 인자는 테이블, 또 다른 인자는 리스트인 경우도 가능하다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>table</tt></td>
<td><tt>0 1 * table</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6&nbsp;&nbsp;7<br>
8 9 10</tt></td>
<td><tt>0 0&nbsp;&nbsp;0<br>
8 9 10</tt></td>
</tr></tbody></table>

바로 위 예제에서, 리스트 `0 1`의 각 아이템은 자동으로 테이블의 행과 매칭되었다. 0은 첫 번째 행과 1은 두 번째 행과 매칭되었다. 다른 패턴들도 이런 식으로 매칭될 수 있다. 더 보려면 7장을 보면 된다.

## 2.2 배열

테이블은 차원이 2이다. (행과 열) 비슷하게, 리스트는 1차원이라고 말할 수 있다.
2개 이상의 차원을 가진 테이블 형 데이터 오브젝트도 있다. 그런 의미에서 `$`함수의 왼쪽 인자는 차원의 개수를 가지는 리스트라고도 말할 수 있다. "배열"이라는 단어는 차원을 가진 데이터 오브젝트를 가리키는 일반적인 말이다. 아래에는 1차원, 2차원, 3차원의 배열에 대한 예제이다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>3 $ 1</tt></td>
<td><tt>2 3 $ 5 6 7</tt></td>
<td><tt>2 2 3 $ 5 6 7 8</tt></td>
</tr><tr valign="TOP">
<td><tt>1 1 1</tt></td>
<td><tt>5 6 7<br>
5 6 7</tt></td>
<td><tt>5 6 7<br>
8 5 6<br>
<br>
7 8 5<br>
6 7 8</tt></td>
</tr></tbody></table>

위 예제의 3차원 배열은 2면, 2행, 3열로 이루어져 있다. 두 개의 면은 위아래 차례대로 출력되었다.

모나딕 `#`함수로 리스트의 길이를 알 수 있는 것을 상기하자.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt># 6 7</tt></td>
<td><tt># 6 7 8</tt></td>
</tr><tr valign="TOP">
<td><tt>2</tt></td>
<td><tt>3</tt></td>
</tr></tbody></table>

모나딕 `$`함수로는 인자의 차원 리스트를 알 수 있다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>L =: 5 6 7</tt></td>
<td><tt>$ L</tt></td>
<td><tt>T =: 2 3 $ 1</tt></td>
<td><tt>$ T</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6 7</tt></td>
<td><tt>3</tt></td>
<td><tt>1 1 1<br>
1 1 1</tt></td>
<td><tt>2 3</tt></td>
</tr></tbody></table>

그러므로 만약 x가 배열이라면 `# $ x`라는 표현식은 x의 차원 리스트의 길이, 즉 x의 차원 개수를 내뱉는다. 차원의 개수가 1이면 리스트, 2이면 테이블인 식이다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> L </tt></td>
<td><tt>$ L </tt></td>
<td><tt> # $ L</tt></td>
<td><tt> T </tt></td>
<td><tt>$T</tt></td>
<td><tt># $ T</tt></td>
</tr><tr valign="TOP">
<td><tt>5 6 7</tt></td>
<td><tt>3</tt></td>
<td><tt>1</tt></td>
<td><tt>1 1 1<br>
1 1 1</tt></td>
<td><tt>2 3</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

만약 x가 단일 숫자라면 `# $ x`는 0이다.

       # $ 17
    0

테이블은 2차원이고 리스트가 1차원이므로 단일 수는 차원이 없다라고 말할 수 있다. 단일수의 차원 수는 0이기 때문이다.(위 코드의 결과가 그 근거이다) 차원 수가 0인 데이터 오브젝트는 스칼라(scalar)라고 한다. 위에서 "배열"을 어떤 차원을 가지고 있는 데이터 오브젝트로 정의했었다. 그렇다면 스칼라 또한 배열이다. 다만 차원이 0일 뿐이다.

우리는 위에서 `# $ 17`이 0임을 확인했다. 여기서 이런 결론을 도출할 수 있을 것이다. 스칼라가 차원을 가지고 있지 않기 때문에, (`$ 17`의 결과물로써의) 차원 리스트는 길이가 0이거나 비어있는 리스트여야만 한다. 이제 2의 길이를 가진 리스트는 `2 $ 99` 와 같은 코드를 이용해서 만들어 낼 수 있다. 그리고 길이가 0인 빈 리스트는 `0 $ 99` 같은 코드로 만들어 낼 수 있겠다. (사실 99대신 아무 숫자나 쓰여도 된다.)

빈 리스트의 값은 표시되지 않는다.


<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>2 $ 99</tt></td>
<td><tt>0 $ 99</tt></td>
<td><tt> $ 17</tt></td>
</tr><tr valign="TOP">
<td><tt>99 99</tt></td>
<td><tt>&nbsp;</tt></td>
<td><tt>&nbsp;</tt></td>
</tr></tbody></table>

스칼라(예를 들면 `17`)는 길이가 1인 리스트(예를 들면 `1 $ 17`) 와는 다르다. 또 1행 1열짜리인 테이블(예를 들면 `1 1 $ 17`)과도 다르다. 스칼라는 차원이 없다. 리스트는 차원이 하나, 테이블은 두 개 이다. 하지만 세 개 모두 화면에는 똑같이 보인다.

       S =: 17
       L =: 1 $ 17
       T =: 1 1 $ 17

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> S </tt></td>
<td><tt> L </tt></td>
<td><tt> T </tt></td>
<td><tt># $ S</tt></td>
<td><tt># $ L</tt></td>
<td><tt># $ T</tt></td>
</tr><tr valign="TOP">
<td><tt>17</tt></td>
<td><tt>17</tt></td>
<td><tt>17</tt></td>
<td><tt>0</tt></td>
<td><tt>1</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

하나의 열을 가진 테이블도 여전히 2차원 테이블이다. 아래에 3행 1열의 `t`가 있다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>t =: 3 1 $ 5 6 7</tt></td>
<td><tt>$ t</tt></td>
<td><tt># $ t</tt></td>
</tr><tr valign="TOP">
<td><tt>5<br>
6<br>
7</tt></td>
<td><tt>3 1</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

## 2.3 용어: 랭크와 모양(Rank and Shape)

"차원 수"라고 부르는 속성은 J에서는 짧게 줄여 "랭크(Rank)"라고 한다. 그래서 단일 숫자는 랭크-0 배열(rank-0 array)이라고 부르고, 리스트는 랭크-1 배열이라고 한다. 차원 리스트는 "모양(Shape)"이라고 한다.
수학 용어에서 "벡터(Vector)"와 "매트릭스(Matrix)"는 위에서 말했던 "리스트"와 "테이블"과 관련이 있다. 3차원 이상의 배열(아, 이제는 랭크 3이상의 배열 이라고 하겠다.)은 "리포트(Report)"라고 한다.

아래 테이블에 배열에 대한 용어와 함수들을 정리해놓았다.

    +--------+--------+-----------+------+
    |        | Example| Shape     | Rank |
    +--------+--------+-----------+------+
    |        | x      | $ x       | # $ x|
    +--------+--------+-----------+------+
    | Scalar | 6      | empty list| 0    |
    +--------+--------+-----------+------+
    | List   | 4 5 6  | 3         | 1    |
    +--------+--------+-----------+------+
    | Table  |0 1 2   | 2 3       | 2    |
    |        |3 4 5   |           |      |
    +--------+--------+-----------+------+
    | Report |0  1  2 | 2 2 3     | 3    |
    |        |3  4  5 |           |      |
    |        |        |           |      |
    |        |6  7  8 |           |      |
    |        |9 10 11 |           |      |
    +--------+--------+-----------+------+

위 테이블은 사실 J로 짠 프로그램의 출력물이다. 게다가 저건 위에 작은 챕터를 할애해서 말했던 자료구조인 진짜 "테이블"이다. 이 테이블의 모양은 `6 4`이다. 하지만 이건 숫자로만 이루어진 테이블이 아니라 문자도 있고, 리스트도 담고 있다. 그럼 이제 숫자가 아닌 걸로 이루어진 배열을 살펴보자

## 2.4 문자로 이루어진 배열

문자는 알파벳, 구두점, 숫자 등을 말한다. 숫자로 배열을 만들었듯이 문자로도 배열을 만들 수 있다. 문자의 리스트를 만들려면 작은따옴표 안에 문자들을 넣으면 된다. 하지만 결과 화면에 출력될 때는 작은따옴표는 보이지 않는다. 예를 들자면 아래와 같다.

       title =: 'My Ten Years in a Quandary'
       title
    My Ten Years in a Quandary

문자의 리스트는 문자열(string)이라고 한다. 문자열 안의 작은따옴표를 넣으려면 작은따옴표를 연속 두 번 타이핑 한다.

       'What''s new?'
    What's new?

빈 문자열이나 길이가 0인 문자열을 나타내려면 연속된 두 개의 작은 따옴표를 타이핑한다. 이건 화면에 보이지 않는다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> '' </tt></td>
<td><tt># '' </tt></td>
</tr><tr valign="TOP">
<td><tt>&nbsp;</tt></td>
<td><tt>0</tt></td>
</tr></tbody></table>

## 2.5 배열에 사용되는 함수

이 장에서는 배열을 다루는 몇 가지 유용한 함수들을 알아보도록 한다. J는 매우 다양한 함수들을 가진 언어이다. 한번 살펴보자.

### 2.5.1 합치기

내장 함수인 `,`는 "Append"라고 한다. 이 함수는 여러 개의 요소를 붙여서 리스트를 만든다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>a =: 'rear'</tt></td>
<td><tt>b =: 'ranged'</tt></td>
<td><tt>a,b</tt></td>
</tr><tr valign="TOP">
<td><tt>rear</tt></td>
<td><tt>ranged</tt></td>
<td><tt>rearranged</tt></td>
</tr></tbody></table>

"Append" 함수는 리스트나 아이템 하나를 합친다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>x =: 1 2 3</tt></td>
<td><tt>0 , x </tt></td>
<td><tt>x , 0 </tt></td>
<td><tt>0 , 0</tt></td>
<td><tt>x , x </tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3</tt></td>
<td><tt>0 1 2 3</tt></td>
<td><tt>1 2 3 0</tt></td>
<td><tt>0 0</tt></td>
<td><tt>1 2 3 1 2 3</tt></td>
</tr></tbody></table>

"Append" 함수는 두 개의 테이블의 양 끝을 합쳐서 더 긴 테이블을 만들 수도 있다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T1=: 2 3 $ 'catdog'</tt></td>
<td><tt>T2=: 2 3 $ 'ratpig'</tt></td>
<td><tt>T1,T2</tt></td>
</tr><tr valign="TOP">
<td><tt>cat<br>
dog</tt></td>
<td><tt>rat<br>
pig</tt></td>
<td><tt>cat<br>
dog<br>
rat<br>
pig</tt></td>
</tr></tbody></table>

"Append"에 대한 더 많은 정보를 원하면 5장을 보라.

### 2.5.2 아이템

숫자로 이루어진 리스트의 아이템은 각각이 숫자다. 그리고 테이블의 아이템은 그 테이블의 행이라고 한다. 3차원 배열의 아이템은 그 배열의 평면이다. 일반적으로 말해서 아이템이라 함은 배열의 첫 번째 차원을 따라 늘어서 있는 요소들의 연속이다. 배열은 아이템으로 이루어진 리스트이다.
`#`("Tally")함수가 리스트의 길이를 반환한다고 했었다. 아래를 보자

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>x</tt></td>
<td><tt> # x</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3</tt></td>
<td><tt>3</tt></td>
</tr></tbody></table>

일반적으로 `#`는 배열의 아이템 개수, 즉 첫 번째 차원의 크기를 잰다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T1</tt></td>
<td><tt>$ T1</tt></td>
<td><tt># T1</tt></td>
</tr><tr valign="TOP">
<td><tt>cat<br>
dog</tt></td>
<td><tt>2 3</tt></td>
<td><tt>2</tt></td>
</tr></tbody></table>

확실히 `# T1`은 차원 리스트인 `$ T1`의 첫 번째 아이템이다. 차원이 없는 스칼라는 단일 아이템으로 취급한다.

       # 6
    1

밑에 있는 "Append"의 예를 다시 보자.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T1</tt></td>
<td><tt>T2</tt></td>
<td><tt>T1 , T2</tt></td>
</tr><tr valign="TOP">
<td><tt>cat<br>
dog</tt></td>
<td><tt>rat<br>
pig</tt></td>
<td><tt>cat<br>
dog<br>
rat<br>
pig</tt></td>
</tr></tbody></table>

이제 `x , y`의 의미를 `x`의 아이템 다음에 `y`의 아이템이 오는 리스트라고 일반화시켜 말할 수 있겠다.

"아이템"을 잘 이용하기 위한 다른 예제로 `+/` 함수가 있다. `+/`는 +를 리스트의 아이템 사이사이에 끼워 넣는다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>+/ 1 2 3</tt></td>
<td><tt>1 + 2 + 3</tt></td>
</tr><tr valign="TOP">
<td><tt>6</tt></td>
<td><tt>6</tt></td>
</tr></tbody></table>

일반적으로는 `+/`는 `+`를 배열의 아이템 사이에 끼워 넣는다. (리스트의 아이템 사이가 아니다.) 다음 예제는 아이템이 단일 숫자가 아니라 테이블의 행인 경우이다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>T =: 3 2 $ 1 2 3 4 5 6</tt></td>
<td><tt>+/ T</tt></td>
<td><tt>1 2 + 3 4 + 5 6</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2<br>
3 4<br>
5 6</tt></td>
<td><tt>9 12</tt></td>
<td><tt>9 12</tt></td>
</tr></tbody></table>

### 2.5.3 선택하기

이제 리스트에서 아이템을 선택하는 방법을 알아보자. 리스트에서 아이템의 위치는 0, 1, 2... 로 숫자를 매긴다. 첫 번째 아이템의 위치는 0이다.(10번째 아이템의 위치는 9이다.) 위치 정보를 가지고 아이템을 선택하기 위해서는 `{`("From") 함수를 사용한다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>Y =: 'abcd'</tt></td>
<td><tt>0 { Y</tt></td>
<td><tt>1 { Y</tt></td>
<td><tt>3 { Y</tt></td>
</tr><tr valign="TOP">
<td><tt>abcd</tt></td>
<td><tt>a</tt></td>
<td><tt>b</tt></td>
<td><tt>d</tt></td>
</tr></tbody></table>

위치를 나타내는 숫자는 "인덱스"라고 한다. `{`함수는 왼쪽 인자에 인덱스로써 단일수나 숫자 리스트를 받는다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> Y</tt></td>
<td><tt> 0 { Y</tt></td>
<td><tt> 0 1 { Y</tt></td>
<td><tt> 3 0 1 { Y</tt></td>
</tr><tr valign="TOP">
<td><tt>abcd</tt></td>
<td><tt>a</tt></td>
<td><tt>ab</tt></td>
<td><tt>dab</tt></td>
</tr></tbody></table>

`i.` 라는 내장 함수도 있다. 표현식 `i. n`은 크기가 n인 0부터 순서대로 커지는 양의 정수의 리스트를 생성한다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>i. 4</tt></td>
<td><tt>i. 6</tt></td>
<td><tt>1 + i. 3</tt></td>
</tr><tr valign="TOP">
<td><tt>0 1 2 3</tt></td>
<td><tt>0 1 2 3 4 5</tt></td>
<td><tt>1 2 3</tt></td>
</tr></tbody></table>

만약 x가 리스트라면 `i. # x`라는 표현식은 x에서 사용할 수 있는 모든 인덱스의 리스트를 만들어낸다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>x =: 'park'</tt></td>
<td><tt># x</tt></td>
<td><tt>i. # x</tt></td>
</tr><tr valign="TOP">
<td><tt>park</tt></td>
<td><tt>4</tt></td>
<td><tt>0 1 2 3</tt></td>
</tr></tbody></table>

`i.`의 인자로 리스트가 들어오면 배열이 만들어진다.

       i. 2 3
    0 1 2
    3 4 5

`i.`를 다이아딕으로 사용하면 이때는 `i.`를 "Index Of"라고 한다. `x i. y`라는 표현식은 x에 있는 y의 위치를 찾아낸다.

       'park' i. 'k'
    3

찾은 인덱스는 x에서 y가 처음으로 발견된 위치이다.


       'parka' i. 'a'
    1

x에 y가 없다면 마지막 위치보다 1 큰 수를 반환한다.

       'park' i. 'j'
    4

인덱싱에 대해 더 많은 것을 알고 싶다면 챕터 6을 보라.

### 2.5.4 같음과 매칭(Equality and Matching)

두 배열이 같은지 알아봐야 하는 상황이라면 내장 함수인 `-:`("Match")를 사용하면 된다. 이 함수는 두 개의 인자가 같은 모양, 같은 값을 가졌는지 검사한다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>X =: 'abc'</tt></td>
<td><tt>X -: X</tt></td>
<td><tt>Y =: 1 2 3 4</tt></td>
<td><tt>X -: Y</tt></td>
</tr><tr valign="TOP">
<td><tt>abc</tt></td>
<td><tt>1</tt></td>
<td><tt>1 2 3 4</tt></td>
<td><tt>0</tt></td>
</tr></tbody></table>

인자가 뭐든 간에 함수의 결과 값은 0 아니면 1이다.

빈 문자 리스트와 빈 숫자 리스트는 같다는 건 알아두어야 한다.

       '' -: 0 $ 0
    1

이 둘의 모양은 같고 모든 매핑되는 요소의 값들이 같기 때문에 위 식은 참이다. (물론 요소가 없긴 하다.)
`=`("Equal")라는 함수도 있다. 이 함수는 주어진 두 인자가 같은지를 확인한다. `=`는 매핑되는 각 요소의 값이 같은지 확인해서 요소와 같은 모양의 불리언 배열을 반환한다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>Y</tt></td>
<td><tt>Y = Y</tt></td>
<td><tt>Y = 2</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3 4</tt></td>
<td><tt>1 1 1 1</tt></td>
<td><tt>0 1 0 0</tt></td>
</tr></tbody></table>

결론적으로 `=`가 가지는 두 인자는 반드시 같은 모양이어야 한다. (아니면 적어도, `Y=2`의 경우와 같이 호환되는 모양이어야 한다) 그렇지 않으면 에러가 발생한다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>Y</tt></td>
<td><tt>Y = 1 5 6 4</tt></td>
<td><tt>Y = 1 5 6</tt></td>
</tr><tr valign="TOP">
<td><tt>1 2 3 4</tt></td>
<td><tt>1 0 0 1</tt></td>
<td><tt>error</tt></td>
</tr></tbody></table>

## 2.6 박스의 배열(Arrays of Boxes)

### 2.6.1 연결하기

`;`("Link")라는 내장 함수가 있다. 이 함수는 두 인자를 리스트의 형태로 연결한다. 두 인자는 다른 것 이어도 된다. 예를 들어 문자열과 숫자를 연결 할수 있다.

       A =: 'The answer is'  ;  42
       A
    +-------------+--+
    |The answer is|42|
    +-------------+--+

위 에서 A는 길이가 2인 리스트이다. 그리고 이 리스트는 박스의 리스트라고 한다. 첫 번째 박스 안에는 문자열 'The answer is'가 들어있고 두 번째 박스에는 숫자 42가 있다. 박스는 화면에 사각형으로 그려지고 안에 그 박스의 값을 담고 있는 형태로 그려진다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> A </tt></td>
<td><tt> 0 { A</tt></td>
</tr><tr valign="TOP">
<td><tt>+-------------+--+<br>
|The answer is|42|<br>
+-------------+--+</tt></td>
<td><tt>+-------------+<br>
|The answer is|<br>
+-------------+</tt></td>
</tr></tbody></table>

박스 하나는 안에 있는 값이 무엇이든 간에 스칼라로 취급한다. 박스는 그 안에 일반적인 배열(예를 들면 숫자로 이루어진 리스트 같은 거)을 넣을 수 있다. 따라서 A는 스칼라의 리스트이다. (A의 아이템들은 각각이 스칼라는 말이다.)

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt> A </tt></td>
<td><tt>$ A</tt></td>
<td><tt>s =: 1 { A</tt></td>
<td><tt> # $ s</tt></td>
</tr><tr valign="TOP">
<td><tt>+-------------+--+<br>
|The answer is|42|<br>
+-------------+--+</tt></td>
<td><tt>2</tt></td>
<td><tt>+--+<br>
|42|<br>
+--+</tt></td>
<td><tt>0</tt></td>
</tr></tbody></table>

박스로 이루어진 배열의 주목적은 다른 종류의 값들을 하나의 변수에 집어넣는 것이다. 예를 들어 구입 한 물건의 자세한 사항들(구매 날짜, 가격, 설명)을 담은 변수는 박스의 리스트로 나타낼 수 있다.

       P =: 18 12 1998  ;  1.99  ;  'baked beans'
       P
    +----------+----+-----------+
    |18 12 1998|1.99|baked beans|
    +----------+----+-----------+

"Link"와 "Append"의 차이점에 주목해야 한다. "Link"가 다른 종류의 값들을 합치는 반면 "Append"가 합치는 값들은 언제나 같은 종류이다. 즉 "Append" 함수에 주어지는 두 인자는 반드시 둘 다 숫자로 이루어진 배열이거나 둘 다 문자로 이루어진 배열이어야 한다. 아니면 둘 다 박스로 이루어진 배열이어야 한다. 그게 아니면 에러가 난다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>'answer is'; 42</tt></td>
<td><tt>'answer is' , 42</tt></td>
</tr><tr valign="TOP">
<td><tt>+---------+--+<br>
|answer is|42|<br>
+---------+--+</tt></td>
<td><tt>error</tt></td>
</tr></tbody></table>

문자열과 숫자를 연결해야 할 때가 있을 수 있다. 예를 들자면 어떤 결과 값과 그에 대한 설명은 같이 보여줘야 할 때가 있다. 그 때 위에서 봤듯이 문자열과 숫자를 "연결(Link)"할 수 있다. 하지만 더 부드러운 표현은 숫자를 문자열로 바꿔서 두 문자열을 연결하는 방식으로 처리하는 것이다. 그러면 결과물은 박스의 리스트가 아니라 문자열이 된다.

숫자를 문자열로 바꾸는 것은 내장 함수인 `":`("Format")을 이용한다. 아래 예제에서 n은 단일 숫자이고 s는 n을 포맷해서 만든 문자열이다. s는 길이가 2이다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>n =: 42</tt></td>
<td><tt>s =: ": n</tt></td>
<td><tt># s</tt></td>
<td><tt>'answer is ' , s</tt></td>
</tr><tr valign="TOP">
<td><tt>42</tt></td>
<td><tt>42</tt></td>
<td><tt>2</tt></td>
<td><tt>answer is 42</tt></td>
</tr></tbody></table>

"Format"에 대해서 더 알고 싶다면 19장을 보면 된다. 다시 박스로 돌아가도록 하자. 박스는 값이 상자로 둘러싸고 있는 형태이기 때문에, 박스가 화면에 보일 때에는 간단한 표의 형태로 보인다.

       p =: 4 1 $ 1 2 3 4
       q =: 4 1 $ 3 0 1 1
       
       2 3 $ ' p ' ; ' q ' ; ' p+q ' ;  p ; q ; p+q
    +---+---+-----+
    | p | q | p+q |
    +---+---+-----+
    |1  |3  |4    |
    |2  |0  |2    |
    |3  |1  |4    |
    |4  |1  |5    |
    +---+---+-----+

### 2.6.2 박싱과 언박싱(Boxing and Unboxing)

`<`("Box")라는 내장 함수가 있다. 이 함수는 인자로 들어온 값을 감싸 하나의 박스를 만든다.

       < 'baked beans'
    +-----------+
    |baked beans|
    +-----------+

박스는 숫자를 담을 수 있지만, 그 자체로 숫자는 아니다. 박스 안에 있는 값으로 계산 하려면 박스를 열어서 값을 꺼내야 한다. `>` 함수가 바로 그런 것이다. 이 함수는 "Open"이라고 한다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>b =: &lt; 1 2 3</tt></td>
<td><tt>&gt; b</tt></td>
</tr><tr valign="TOP">
<td><tt>+-----+<br>
|1 2 3|<br>
+-----+</tt></td>
<td><tt>1 2 3</tt></td>
</tr></tbody></table>

`<`를 깔때기 모양의 그림으로 생각하면 이해하기가 쉽다. 데이터가 넓은 쪽으로 흘러들어 가서 좁은 쪽으로 박스에 담겨 나온다. 나온 박스는 스칼라, 즉 차원이 없다. `>`도 비슷하게 생각하면 된다. 박스가 스칼라이기 때문에 `,`함수로 각 박스를 리스트로 묶을 수 있다. 하지만 `;`함수를 쓰는 게 좀 더 편하다. 이 함수는 박스에 담아 연결해주는 작업을 한 번에 해준다.

<table cellpadding="10" border="1">
<tbody><tr valign="TOP">
<td><tt>(&lt; 1 1) , (&lt; 2 2) , (&lt; 3 3)</tt></td>
<td><tt>1 1 ; 2 2 ; 3 3</tt></td>
</tr><tr valign="TOP">
<td><tt>+---+---+---+<br>
|1 1|2 2|3 3|<br>
+---+---+---+</tt></td>
<td><tt>+---+---+---+<br>
|1 1|2 2|3 3|<br>
+---+---+---+</tt></td>
</tr></tbody></table>

## 2.7 요약

결론적으로 J의 모든 데이터 오브젝트는 전부 n 차원 배열(n >= 0)이다. 배열은 숫자로 이루어진 배열일 수도 있고, 문자, 또는 박스로 이루어졌을 수도 있다. (물론 다른 것으로 이루어질 수도 있다.)

2장을 마친다.

[Learning J]: http://www.jsoftware.com/docs/help701/learning/contents.htm