---yaml
layout: 'article'
title : '잘 빠진 군체 알고리즘 - flock'
author: 'Yongjae Choi'
date: '2012-12-3'
tags: ['flocking', 'algorithm']
---

<style>
canvas {display:block;}
.flock {margin-left: 10px;}
</style>

![flock](/articles/2012/flocking-algorithm/800px-Red-billed_quelea_flocking_at_waterhole.jpg)

[harry](http://harry.me/2011/02/17/neat-algorithms---flocking/) 님의 사이트에서 보았던 플로킹 알고리즘(flockng algorithm)을 정리했다.(무려 2011년 2월 글이다.) 플로킹 알고리즘은 떼(flock)의 각 개체의 행동 모델이다. 각 개체는 보이드(boid)라고 부르며 이들은 세 가지 규칙을 이용해 움직인다. 이 알고리즘은 1986년에 Craig Reynolds가 낸 논문에서 처음 소개되었다. 원래 알고리즘은 [여기서](http://www.red3d.com/cwr/boids/) 볼 수 있다. 그는 이 모델을 이용해 새 떼나 물고기 떼 등을 시뮬레이션했으며 배트맨 리턴즈의 박쥐 떼가 날아다니는 영상, 소셜 네트워크에서 의견의 흐름을 시뮬레이션해서 미래 의견을 예측하거나 분산 시스템에서도 이용되었다고 한다. 어디에서 쓰였는지는 링크를 확인하고 알고리즘이 어떻게 동작하는지 보자.

## 예제 먼저

<div class="flock" id="prettyDemo"></div>

옆의 버튼을 눌러서 한 보이드에 대한 자세한 정보와 그 범례를 볼 수 있다. : <button class="awesome" id="decorateDemo">Undecorate</button>

구현은 harry 사이트의 것을 그대로 가져왔다. Coffee Script로 이루어져 있으며 HTML5의 canvas를 이용해서 애니메이션 데모를 보여준다. 따라서 애니메이션 데모를 보고 싶다면 canvas가 지원되는 브라우저로 들어오기를 바란다.  애니메이션은 [ProcessingJS](http://processingjs.org/)를 이용해서 이루어진다. (ProcessingJS에 대한 지식은 그리 필요하진 않다.) 이 페이지의 모든 애니메이션 데모는 버튼으로 애니메이션 속도를 조정할 수 있고 애니메이션 화면을 클릭해서 일시 정지시킬 수 있다. 물론 다시 클릭하면 다시 애니메이션이 진행된다. 정지 되었을 때에는 각 보이드에 마우스를 올려서 그 보이드의 정보를 볼 수 있다. 정보를 보는 법은 이 글을 읽으면서 알 수 있으니 성급해하지 말자.

## 보이드 - Boid

보이드는 무리를 이루는 개체 하나하나를 부르는 이름이다. 여기저기에서 에이전트라고 하기도 하고 오브젝트라고도 하지만 원문에 보이드라고 되어있으니 여기서도 보이드라고 부르기로 하자. 보이드는 위치와 속도를 데이터로 가지고 있다. 그리고 위에서 말한 세 가지 행동 규칙을 이용해 가속도를 계산한다. 가속도는 현재 속도에 영향을 미치고 속도에 의해 다음 위치가 결정된다. 이런 일을 하는 메서드가 `step`이다. 보이드가 너무 빨라지지 않도록 최고 속도를 정해놓고 그보다는 높아지지 않도록 조종하는 것도 중요하다. 다음 코드를 보자. 

```coffeescript
# Ported almost directly from http://processingjs.org/learning/topic/flocking
# thanks a whole lot to Craig Reynolds and Daniel Shiffman

class Boid
  location: false
  velocity: false

  constructor: (loc, processing) -&gt;
    @velocity = new Vector(Math.random()*2-1,Math.random()*2-1)
    @location = loc.copy()
    @p = processing

  # Called every frame. Calculates the acceleration using the flock method, 
  # and moves the boid based on it.
  step: (neighbours) -&gt;
    acceleration = this.flock(neighbours)
    @velocity.add(acceleration).limit(MAX_SPEED) # Limit the maximum speed at which a boid can go
    @location.add(@velocity)
    this._wrapIfNeeded()

  # Implements the flocking algorthim by collecting the three components 
  # and returning a weighted sum.
  flock: (neighbours) -&gt;
    separation = this.separate(neighbours).multiply(SEPARATION_WEIGHT)
    alignment = this.align(neighbours).multiply(ALIGNMENT_WEIGHT)
    cohesion = this.cohere(neighbours).multiply(COHESION_WEIGHT)
    return separation.add(alignment).add(cohesion)
```

제일 마지막 메서드인 `flock`이 앞으로 설명할 세 가지 행동 규칙으로 가속도를 만들어내는 메서드이다. 이에 대한 자세한 이야기는 이 글의 끝에서 하도록 한다.

## 응집 - Cohesion

<div class="flock" id="cohesionDemo" style="float:right;"></div>

보이드는 자기 주변의 보이드의 곁으로 가려는 성질이 있다. 즉 무리지으려는 성질이라고 볼 수 있다. &lsquo;자기 주변의 보이드'는 자신 주변 반경 n 픽셀 안에 있는 보이드로 정의되고 `NEIGHBOUR_RADIUS`라는 상수가 그 주변을 결정하는 반경 값이다. 하나의 보이드는 주변 보이드들 사이의 무게 중심 쪽으로 방향을 튼다. 

옆의 예제를 보면 분홍색 보이드의 Cohesion 정보가 표시되고 있다. 녹색 원이 자신의 주변을 뜻하는 범위이고 그 안에 들어온 보이드들은 녹색으로 표시된다. 그리고 짙은 보라색 화살표가 주변 보이드들의 평균 위치 한 점으로 모인다. 분홍색 보이드는 분홍색 화살표를 이용해 '나 그쪽으로 회전 중입니다'라고 알리고 있다.

<div style="clear:right"></div>

### 코드

Cohesion은 `NEIGHBOUR_RADIUS`안에 있는 모든 보이드의 위치의 평균이다. 코드는 `steer_to`메서드를 거쳐 리턴한다. `stear_to`는 현재 위치와 갈 곳을 계산해서 보이드의 방향을 자연스럽게 틀어주는 역할을 한다. 일종의 보정이라고 생각하면 된다.

```coffeescript
class Boid

  # 가속도를 계산할 때 cohesion요소를 계산하기 위해 호출한다.
  cohere: (neighbours) -&gt;
    sum = new Vector
    count = 0
    for boid in neighbours
      d = @location.distance(boid.location)
      if d &gt; 0 and d &lt; NEIGHBOUR_RADIUS
        sum.add(boid.location)
        count++

    if count &gt; 0
      return this.steer_to sum.divide(count)
    else
      return sum # 아무런 영향도 주지 않기 위해 빈 벡터를 리턴한다.

  steer_to: (target) -&gt;
    desired = Vector.subtract(target, @location) # 현재 위치에서 가려 하는 곳을 가리키는 벡터
    d = desired.magnitude()  # 현재 위치에서 목적지까지의 거리는 벡터의 크기이다.

    # 만약 거리가 0보다 크면 변경할 방향을 계산한다. (아니면 0을 리턴한다.)
    if d &gt; 0
      desired.normalize()

      # 원하는 벡터의 크기를 계산하기 위한 두 옵션(1 -- 거리에 기초하여, 2 -- 최대 스피드)
      if d &lt; 100.0
        desired.multiply(MAX_SPEED*(d/100.0)) # 이 제동은 임의적으로 정했다.
      else
        desired.multiply(MAX_SPEED)

      # Steering = Desired minus Velocity
      steer = desired.subtract(@velocity)
      steer.limit(MAX_FORCE)  # 방향 전환 정도에 제한을 둔다.
    else
      steer = new Vector(0,0)

    return steer
```

## 정렬 - Alignment

<div class="flock" id="alignmentDemo" style="float:right;"></div>

각 보이드는 주변의 보이드와 같은 방향을 향하려는 특성도 가지고 있다. 응집도와 비슷하게 `NEIGHBOUR_RADIUS`의 내에 들어온 주변 보이드들의 속도의 평균을 향한다. 속도는 방향과 크기를 가지고 있으므로 평균을 구하면 방향뿐만이 아니라 크기까지 평균이 된다. 따라서 주변 보이드의 속력이 빠를 수록 정렬되려는 힘도 커진다.

옆의 예제에서 보면 역시 분홍색 보이드의 정보가 보인다. 녹색 원 안에 녹색 보이드가 주변 보이드로 선정된 녀석들이고 주변 보이드의 속도는 녹색 화살표로 표시된다. 이 녹색 화살표의 평균이 분홍색 보이드의 연녹색 화살표이다. 검은색 화살표는 분홍색 보이드의 현재 속도이다. 분홍색 보이드는 다음 프레임에서 자신의 위치와 방향을 결정할 때 연녹색 화살표의 값을 이용한다. 

<div style="clear:right"></div>

### 코드

이번 코드는 그리 길지 않다. 로직은 응집도 계산과 똑같다. 다만 위치의 평균이 아니라 속도의 평균인 점이 다르다. 물론 이번에도 최대값이 있어서 너무 커다란 값이 되지 않도록 조정한다.

```coffeescript
class Boid

  # Alignment component for the frame's acceleration
  align: (neighbours) -&gt;
    mean = new Vector
    count = 0
    for boid in neighbours
      d = @location.distance(boid.location)
      if d &gt; 0 and d &lt; NEIGHBOUR_RADIUS
        mean.add(boid.velocity)
        count++

    mean.divide(count) if count &gt; 0
    mean.limit(MAX_FORCE)
    return mean
```

## 분리 - Separation

<div class="flock" id="separationDemo" style="float:right;"></div>

각 보이드들은 너무 가까워지지 않으려는 경향이 있다. 보이드는 일정 공간을 두어 그 안으로 다른 보이드가 들어오면 그 보이드의 반대편으로 힘이 작용하여 멀어진다. 그 개인적인 공간은 `DESIRED_SEPARATION`이 결정하고 이 값은 `NEIGHBOUR_RADIUS`보다 작아야 한다. 만약 이 값이 `NEIGHBOUR_RADIUS`보다 크다면 이웃은 사라지고 모든 보이드를 배척하게 된다.

이번 예제는 빨간 원이 하나 더 생겼다. 이것이 `DESIRED_SEPARATION`값으로 결정된 생긴 개인 공간이고 이 안에 들어온 보이드는 빨간색으로 표시된다. 그리고 빨간 원 안으로 들어온 보이드에 의해 빨간 화살표로 멀어지려는 힘이 계산된다. 그 방향을 빨간 보이드의 반대 방향이 된다.

<div style="clear:right"></div>

### 코드

코드를 보면 주변 보이드들과의 거리를 검사해서 `DESIRED_SEPARATION`보다 가까운 보이드와 거리를 정규화해서 평균을 낸다. 그 중간에 정규화된 벡터를 자신과 주변 보이드간의 거리에 반비례하게 크기를 변경한다. 이는 가까이 있을수록 더 빨리 멀어지고 싶어한다는 개념을 넣은 것이다.

```coffeescript
class Boid

  # Separation component for the frame's acceleration
  separate: (neighbours) -&gt;
    mean = new Vector
    count = 0
    for boid in neighbours
      d = @location.distance(boid.location)
      if d &gt; 0 and d &lt; DESIRED_SEPARATION
        # Normalized, weighted by distance vector pointing away from the neighbour
        mean.add Vector.subtract(@location,boid.location).normalize().divide(d)
        count++

    mean.divide(count) if count &gt; 0
    mean
```
## 죄다 합쳐보자

위에서 계산했던 세 가지 행동 요소들을 이용해서 무리를 움직이게 하려면 아래와 같이 하면 된다. 보이드 클래스에 자신을 그리는 `render`메서드를 넣고 이 보이드의 무리를 만들어서 움직일 `flock`이라는 함수를 만들어 ProcessingJS의 인스턴스에 넘겨준다. `flock`에서는 보이드를 만들어 각 보이드의 `step`메서드와 `render`메서드를 넣어준다.

```coffeescript
class Boid
  r: 2 # "radius" of the triangle
  render: () -&gt;
    # Draw a triangle rotated in the direction of velocity
    theta = @velocity.heading() + @p.radians(90)
    @p.fill(70)
    @p.stroke(255,255,0)
    @p.pushMatrix()
    @p.translate(@location.x,@location.y)
    @p.rotate(theta)
    @p.beginShape(@p.TRIANGLES)
    @p.vertex(0, -1 * @r *2)
    @p.vertex(-1 * @r, @r * 2)
    @p.vertex(@r, @r * 2)
    @p.endShape()
    @p.popMatrix()

# flock function, passed the Processing instance by Processing itself
flock = (processing) -&gt;
  start = new Vector(processing.width/2,processing.height/2)

  # Instantiate 100 boids who start in the middle of the map, have a maxmimum 
  # speed of 2, maximum force of 0.05, and give them a reference to the 
  # processing instance so they can render themselves.
  boids = for i in [0..100]
    new Boid(start, 2, 0.05, processing)

  processing.draw = -&gt;
    processing.background(255)
    for boid in boids
      boid.step(boids)
      boid.render()
    true

canvas = $('&lt;canvas width="550" height="550"&gt;&lt;/canvas&gt;').appendTo($('#flockingDemo'))[0]
processingInstance = new Processing(canvas, flock)
```

여기서 보이는 `flock`함수는 보이드의 `flock` 메서드와는 다르다. 위에 코드가 있지만 난 친절하니까 밑에 다시 코드를 적어주겠다.

```coffeescript
flock: (neighbours) -&gt;
  separation = this.separate(neighbours).multiply(SEPARATION_WEIGHT)
  alignment = this.align(neighbours).multiply(ALIGNMENT_WEIGHT)
  cohesion = this.cohere(neighbours).multiply(COHESION_WEIGHT)
  return separation.add(alignment).add(cohesion)
```

자 이것이 보이드의 `flock`메서드이다. 보이드의 것은 세 가지 행동 요소(분리, 정렬, 응집)를 이용해 가속도로 사용할 값을 계산하는 것이다. 각 요소 값을 계산하고 그것을 그대로 쓰는 것이 아니라 그 것이 가속도에 끼칠 영향도(weight)를 곱해준다. 그 값은 각각 `SEPARATION_WEIGHT`, `ALIGNMENT_WEIGHT`, `COHESION_WEIGHT`이다. 보이드의 `flock`메서드는 각 요소에 영향도를 곱해서 전부 더한다. 그게 끝이다.
전체 코드는 [여기](https://github.com/hornairs/blog/tree/master/assets/coffeescripts/flocking)에서 구할 수 있다.

## 변칙

### 다른 이웃

여기까지가 기본적인 플로킹 알고리즘이었다. 지금까지는 주변 보이드를 계산할 때 그냥 주변을 360도를 전부 검사했다. 하지만 만약 보이드가 인간이나 동물의 추상체라면 자신의 주변은 관찰 가능한 곳에 있는, 또는 눈에 보이는 보이드로 한정될 것이다. 따라서 주변 보이드를 계산할 때 자신의 뒤쪽은 배제할 수도 있다. 또는 정말 시야에 들어오는 보이드만을 이웃으로 규정할 수도 있다. 이런 이웃을 계산하는 방법에 따라 많은 변칙이 가능해진다.
공간에서 이웃은 위치상의 근접 개체이지만 다른 문제로 환원하면 논리적 근접을 다시 정의해야 한다. 예를 들어 만약 소셜 네트워크라면 이웃은 자신의 친구나 친구가 공유한 다른 친구로 될 것이다. 웹 사이트라면 직접 링크한 문서들을 이웃으로 정할 수도 있겠다.

### 영향도 수정

글에는 세 행동 요소들에 적용되는 영향도 값을 적어놓진 않았지만, 이 영향도 값들을 수정함으로써 보이드들이 다른 행동 양식을 보이도록 할 수도 있다.

### 장애물 피하기

위 데모가 진행되는 동안 마우스를 보이드로 가져다 대면 그들이 마우스 포인터를 휙휙 피하는 모습을 관찰할 수 있다. 아예 갈 수 없는 곳을 피하기도 하는데 이에 대한 설명은 글에서 하지 않았다. 공부를 더 해야 하지만 단순히 추측해보자면 특정 반경 안에 장애물이 감지되거나 장에물과 보이드가 충돌하면 속도를 줄이거나 멈추고 장애물이 없는 방향으로 속도를 올리는 것으로 생각된다. 장애물이 단순 벽일 때, 각이 있는 모서리 일 때, ㄷ자 형태의 벽일 때에 따라 장애물을 피해서 다시 빠져나갈 방법을 잘 설계해야 한다. 잘못하면 아마 벽에 무한으로 부히는 상황이 올지도 모른다.

## 마무리

이 글은 그냥 개인적으로 관심 있던 분야의 글이 뉴스 사이트에 올라왔고 호기심에 읽어본 글이 어쩌다 보니 이해되어 쓴 글이다. 이 모델을 어디에 사용할지는 아직 나도 모르겠지만 군체의 움직임이 예쁘게 모델링 되어있어 소개한다. 사실 예쁘게 모델링 되었다는게 정확한 모델링이라는 것과는 다른 말이지만 더 정교한 알고리즘의 기반 지식이라도 될까 기대해본다.

<script type="text/javascript">
  var Harry = {};
</script>

<script src="/articles/2012/flocking-algorithm/js/processing.js" type="text/javascript"></script>
<script src="/articles/2012/flocking-algorithm/js/vector.js" type="text/javascript"></script>
<script src="/articles/2012/flocking-algorithm/js/boid.js" type="text/javascript"></script>
<script src="/articles/2012/flocking-algorithm/js/flock.js" type="text/javascript"></script>
<script src="/articles/2012/flocking-algorithm/js/flocking.js" type="text/javascript"></script>
