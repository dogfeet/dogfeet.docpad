--- yaml
layout: 'article'
title: 'sbt: Getting Started Guide: .sbt Build Definition'
author: 'Changwoo Park'
date: '2012-7-30'
tags: ['sbt']
---

이 글은 [Getting Started sbt][orig-getting-started]을 번역한 것이다. 

![sbt](/articles/2012/sbt/sbt.png)

## `.sbt` Build Definition

이 페이지는 sbt 빌드를 정의하는 법을 설명한다. sbt "원리"와 `build.sbt`의 문법을 설명한다. [sbt를 실행하는 방법][running]은 이미 숙지했다고 가정하고 설명한다. 아직 익히지 못했으면 이전 페이지를 읽어라.

### `.sbt` vs. `.scala` Definition

sbt 빌드는 base 디렉토리에 `.sbt` 파일을 만들고 그 파일에 정의한다. `.scala` 파일은 base 디렉토리 하위에 `project` 디렉토리에 만들고 거기에 넣는다.

두 파일 중 아무거나 하나만 만들어 사용할 수도 있고 함께 혼용해도 된다. 그래도 `.sbt` 파일로 할 수 없는 일만 `.scala` 파일로 구현하고 대부분은 `.sbt` 파일을 사용하는 것이 바람직하다:

 - sbt 커스트마이즈하기(설정이나 타스크를 추가한다)
 - 네스티드(nested) 서브 프로젝트를 정의한다.

이 글은 `.sbt` 파일만 설명한다. `.scala` 파일을 사용하는 방법은 [.scala build definition][.scala-build-definition]에서 설명한다.

### What is a build definition?

** 이 부분은 반드시 절대로 꼭 읽어주세요. **

sbt는 실제로 빌드하기 전에 프로젝트를 검사하고 빌드 스크립트를 처리한다. 그 전처리를 완료하면 immutable 맵이 하나 생성되는데 그 맵에 빌드 정보가 `키/밸류` 형태로 들어간다.

예를 들어, 키가 `name`인 항목의 스트링 밸류는 프로젝트 이름을 의미한다.

_우리가 만든 빌드 정의가 바로 sbt 맵으로 만들어지는 것이 아니다._

우선 모든 빌드 정의를 `Setting[T]` 타입의 객체를 담는 리스트로 만든다. `Setting[T]`의 T는 맵의 밸류 타입을 의미한다. Java에서 `Setting<T>`이라고 하는 것과 같은 표현이다. `Setting`에는 맵으로 변환하기 위한 정보가 들어간다. 예를 들어, `키/밸류` 항목을 새로 만들어야 하는지 기존의 항목의 밸류에 추가하면 되는지의 정보가 담긴다. '함수형 프로그래밍' 정신에 따라서 맵으로 변형 시 기존의 맵을 수정해서 리턴하는 것이 아니라 맵을 새로 만들어 리턴한다.  

`build.sbt` 파일에서 다음과 같이 프로젝트 이름을 정의하면 `Setting[String]` 인스턴스가 만들어진다:

```scala
name := "hello"
```

키가 `name`이고 밸류가 `"hello"`인 `Setting[String]` 객체가 생성되고 sbt 맵에 키가 `name`인 항목이 있으면 그 항목의 밸류만 교체하고 없으면 해당 항목을 새로 만든다. 다시 말하지만, 이때 변형된 맵은 새로 생성된다.

이 맵이 만들어지는 과정을 살펴보자. sbt는 먼저 Setting 리스트을 정렬한다. 키가 같은 항목들은 하나로 합치고 밸류에서 다른 항목을 사용하고 있으면 그 항목부터 처리한다. 설정 간 의존성이 있으면 의존성부터 해결한다. sbt는 정렬된 `Setting` 리스트를 하나씩 map으로 변환한다.

요약: _빌드 정의는 먼저 `Setting[T]` 리스트로 만들고 다시 `Setting[T]` 리스트를 sbt 맵으로 변환한다. `T`는 각 밸류의 타입이다_.

### How `build.sbt` defines settings

`build.sbt` 파일의 자료구조는 `Seq[Setting[_]]`이다. 이 파일은 Scala Expression의 리스트인데 한 줄 띄우는 것으로 구분한다. 각 줄은 리스트의 항목 하나이고 순서대로 처리된다. `.scala` 파일에서 `.sbt` 파일의 내용을 `Seq(`와 `)`로 감싸고 빈 줄 대신에 콤마를 넣으면 `.sbt` 파일에서 한 것과 동일한 코드가 된다.

다음은 `.sbt` 파일 예제이다:

```scala
name := "hello"

version := "1.0"

scalaVersion := "2.9.1"
```

`build.sbt` 파일은 빈 줄로 구분하는 `Setting` 객체의 리스트다. 각 `Setting`은 Scala Expression으로 정의한다. 

`build.sbt`에 있는 Expression은 서로서로 독립적이고 문법상으로 Scala Statement가 아니라 Scala Expression이다. 그래서 `build.sbt` 파일에 Scala Expresion을 정의할 때 그 Expresion 제일 앞에는 `val`, `object`, 클래스, 메소드를 정의할 수 없다.

왼쪽에 사용한 `name`, `version`, `scalaVersion`은 _키_다. 키는 `SettingKey[T]`, `TaskKey[T]`, `InputKey[T]`의 인스턴스이고 `T`는 밸류의 타입이다. 아래에서 키에 대해서 좀 더 설명한다.

키는 `Settings[T]`를 리턴하고 이름이 `:=`인 메소드를 호출한다. 이 메소드는 Java 처럼 호출할 수도 있다:

```scala
name.:=("hello")
```

스칼라에서는 `name := "hello"`라고 사용해도 메소드를 호출할 수 있다. 스칼라 문법에서는 이렇게 메소드를 호출하는 것도 가능하다.

`name` 키에 있는 `:=` 메소드는 `Setting` 객체를 반환한다. 정확한 타입은 `Setting[String]`이다. `name` 키의 타입은 `SettingKey[String]`인데 여기서 `String`은 `name` 자체의 타입이다. `Setting[String]` 인스턴스가 반환되면 `name`을 키로 해서 sbt 맵에 넣는다. 이 `Setting[String]` 인스턴스의 값은 `"hello"`다.

타입을 틀리게 넣으면 컴파일 안 된다:

```scala
name := 42  // will not compile
```

### Settings are separated by blank lines

다음과 같이 `build.sbt` 파일을 작성할 수 없다:

```scala
// will NOT work, no blank lines
name := "hello"
version := "1.0"
scalaVersion := "2.9.1"
```

Setting을 구분해 주는 구분자가 필요하다. sbt는 구분자가 있어야 Scala Expression을 구분할 수 있다.

`.sbt` 파일에 구현하는 것은 Scala Expression이지 Scala 프로그램이 아니다. sbt는 각 Scala Expression을 하나씩 잘라서 개별적으로 컴파일한다.

Scala 프로그램을 사용하고 싶으면 `.sbt` 파일이 아니라 [.scala 파일][.scala-build-definition]로 구현해야 한다. 이때에는 `.sbt` 파일이 없어도 된다. `.scala` 파일을 사용하는 방법은 나중에 설명한다. 어떻게 하는지 살짝 들춰보자면 `.sbt` 파일에서 정의하던 Setting Expression을 `.scala` 파일에서 `Seq[Setting]` 자료구조로 정의하면 된다.

### Keys are defined in the Keys object

빌트인 키는 [Keys][] 객체에 정의되 있다. `build.sbt`에는 `import sbt.Keys._`가 묵시적으로 선언돼 있어서 `sbt.Keys.name`라고 안 쓰고 `name`이라고 바로 써도 되는 것이다.

Key를 새로 정의하려면 [.scala 파일][.scala-build-definition]이나 [plugin][using-plugins]으로 정의해야 한다.

### Other ways to transform settings

`:=`으로 리플레이스 하는 것이 가장 단순한 변형 방법이지만 다른 방법도 있다. 예를 들어 `+=`으로도 Setting 밸류를 추가할 수 있다.

다른 방법에 대해서 [scopes][scopes]과 그 다음으로 이어지는 '[More About Settings][more-about-settings]'에서 자세히 설명한다.

### Task Keys

Key는 세 종류이다:

 - `SettingKey[T]`: 이 키와 밸류는 딱 한 번 해석한다. 프로젝트를 로드할 때 해석하고 다시 해석하지 않는다.
 - `TaskKey[T]`: 이 키와 밸류는 매번 다시 해석한다. 그래서 문제가 될 수도 있다.
 - `InputKey[T]`: 이 가이드에서는 `InputKey`는 설명하지 않는다. 이 가이드를 다 보고 나서 [Input Task][]를 봐라.

_타스크_를 정의한다고 sbt에 말할 때 `TaskKey[T]`를 사용한다. `compile`이나 `package` 같은 것이 타스크이다. 이 타스크는 `Unit`을 리턴하거나 해당 타스크와 관련된 어떤 밸류를 리턴한다. 스칼라에서는 `Unit`이 `void`다. 예를 들어 `package` 타스크는 타입이 `TaskKey[File]`이고 생성할 jar 파일을 리턴한다.

타스크를 실행할 때마다 항상 다시 실행한다. `compile` 타스크를 실행하면 `compile` 타스크에 필요한 모든 타스크가 한 번씩 다시 실행된다.

sbt 맵에는 프로젝트 정보가 담겨 있다. `name` 같은 게 이에 해당하고 항상 고정된 밸류를 저장한다. `compile`같은 타스크는 고정 값이 아니라 실행 코드이다. 이 실행 코드가 스트링을 리턴한다고 해도 스트링을 얻으려면 항상 다시 실행해야 한다.

_타스크나 설정이나 키를 사용하는 것은 동일하다._ 매번 실행하는 것인지 아닌지가 타스크인지 아닌지를 구분하는 요소이며 이것은 밸류가 아니라 키의 프로퍼티에 해당한다.

`:=`을 사용해서 타스크에 코드를 할당할 수 있다. 이 코드는 매번 실행된다:

```scala
hello := { println("Hello!") }
```

타스크 키로 `Setting`을 만들 때와 설정 키로 `Setting` 을 만들 때는 타입이 다르다. `taskKey := 42` 가 생성하는 결과의 타입은 `Setting[Task[T]]`이지만 `settingKey := 42`가 생성하는 결과의 타입은 `Setting[T]`이다. 타스크는 타스크를 실행해서 `T` 타입의 밸류를 생성하는 것뿐이고 그 외에는 차이가 없다.

내부적으로 `T`와 `Task[T]` 타입이 다른 점이 더 있다. 설정키는 프로젝트를 로드할 때 한 번만 처리하기 때문에 타스크 키에 의존하지 않는다. 곧 읽게 될 [More About Settings][more-about-settings]에서 이 문제를 자세히 다룬다.

### Keys in sbt interactive mode

대화형 모드에서 타스크 이름을 입력하면 해당 타스크가 실행된다. `compile`이라는 타스크 키가 있으니까 대화형 모드에서 `compile`이라고 입력했을 때 compile 타스크가 실행될 수 있다.

타스크 키가 아니라 설정 키를 입력하면 그냥 화면에 그 키의 밸류를 보여준다. 
타스크 키를 입력하면 타스크가 실행되지만, 그 결과를 보여주진 않는다. 타스크의 결과를 보고 싶으면 `show <task name>`이라고 입력해야 한다.

키 이름은 Scala 관례에 따라 카멜케이스 방식으로 지어야 하고 sbt 명령어는 `하이픈 구분자` 방식을 사용한다. [Keys]에 정의된 키를 sbt에서 사용할 때는 하이픈 구분자를 사용해야 한다. `Keys.scala`에 정의한 것 중 한 예를 보자:

```scala
val scalacOptions = TaskKey[Seq[String]]("scalac-options", "Options for the Scala compiler.")
```

sbt에서 타스크를 입력할 때는 `scalacOptions`이 아니라 `scalac-options`라고 입력한다.

sbt 대화형 모드에서 `inspect <keyname>`을 입력하면 입력한 키에 대한 정보를 자세히 보여준다. `inspect`는 입력한 키의 밸류와 간략한 설명을 보여준다. 물론 처음 보는 정보들까지도 함께 보여준다.

### Imports in `build.sbt`

`build.sbt` 파일에 import 구문을 사용할 수 있다. import 구문은 한 줄 띄우기를 할 필요가 없다.

다음을 보면 무슨 소린지 한 번에 알 수 있다:

```scala
import sbt._
import Process._
import Keys._
```

([.scala build definition][.scala-build-definition]를 보면 `Build`나 `Plugin` 객체도 임포트해서 사용하는 방법을 설명한다. `Build`나 `Plugin` 객체를 임포트해야 하면 [.scala build definition][.scala-build-definition]를 보라.)

### Adding library dependencies

라이브러리 의존성을 추가하는 방법은 두 가지다. 하나는 unmanaged 방식으로 `lib/` 디렉토리에 jar 파일을 그냥 넣으면 된다. 다른 하나는 managed 방식으로 `build.sbt` 파일에 다음과 같이 추가한다:

```scala
libraryDependencies += "org.apache.derby" % "derby" % "10.4.1.3"
```

이 것은 버전이 10.4.1.3인 Apache Derby 라이브러리를 managed 방식으로 추가하는 것을 보여준다. 

`libraryDependencies`에서는 `+=`와 `%` 메소드를 추가로 알아야 한다: `+=`는 기존의 밸류를 교체하는 것이 아니라 기존의 밸류에 새 밸류를 추가하는 것이다. 자세한 것은 [More About Settings][more-about-settings]에서 설명한다. `%`는 Ivy 모듈 ID를 조합하는 데 사용하고 자세한 설명은 [Library Dependencies][library-dependencies]에 있다.

라이브러리 의존성은 [Library Dependencies][library-dependencies]에서 다룰 예정이다. 여기서는 이 정도로 마무리하겠다.

[orig-getting-started]: https://github.com/harrah/xsbt/wiki/Getting-Started-Welcome
[getting-started]: /articles/2012/sbt-getting-started.html
[setup]: /articles/2012/sbt-getting-started-setup.html
[hello-world]: /articles/2012/sbt-getting-started-hello.html
[directory-layout]: /articles/2012/sbt-getting-started-directory-layout.html
[running]: /articles/2012/sbt-getting-started-running.html
[.sbt-build-definition]: /articles/2012/sbt-getting-started-sbt-build-definition.html
[scopes]: /articles/2012/sbt-getting-started-scopes.html
[more-about-settings]: /articles/2012/sbt-getting-started-more-about-settings.html
[library-dependencies]: /articles/2012/sbt-getting-started-library-dependencies.html
[.scala-build-definition]: /articles/2012/sbt-getting-started-scala-build-definition.html
[using-plugins]: /articles/2012/sbt-getting-started-using-plugins.html
[multi-project-builds]: /articles/2012/sbt-getting-started-multi-project-builds.html
[custom-settings-and-tasks]: /articles/2012/sbt-getting-started-custom-settings-and-tasks.html
[summary]: /articles/2012/sbt-getting-started-summary.html

[Keys]: http://harrah.github.com/xsbt/latest/sxr/Keys.scala.html
[Input Task]: https://github.com/harrah/xsbt/wiki/Input-Tasks
