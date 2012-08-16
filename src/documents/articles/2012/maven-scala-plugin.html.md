--- yaml
layout: 'article'
title: 'Maven에서 스크립트 사용하기'
author: 'Changwoo Park'
date: '2012-9-2'
tags: ['maven', 'scala', 'plugin']
---

기본적으로 Maven에는 로직을 넣을 수 없다. 로직이 있으면 있는 대로 없으면 없는 대로 장단점이 있어서 일률적으로 '좋다', '나쁘다.'라고 말할 수 없다. 하지만, 나는 로직을 넣을 수 있는 것이 더 좋다. Ant도 그렇지만 Maven으로 프로젝트를 관리하다 보면 답답할 때가 잦다. 특히 자주 저지르는 실수를 검증하는 코드는 넣고 싶을 때가 잦다(항상 틀린 걸 또 틀리니까!).

Maven에 Plugin으로 스크립트를 Embed할 방법이 있는데 [maven-antrun-plugin][], [gmaven-plugin][], [maven-scala-plugin][]이 쓸만하다:

* `maven-antrun-plugin`: run 골을 이용해서 ant 스크립트를 실행할 수 있다.
* `gmaven-plugin`: execute 골을 이용해서 groovy 스크립트를 실행할 수 있다.
* `maven-scala-plugin`: script 골을 이용해서 scala 스크립트를 실행할 수 있다.

![maple](/articles/2012/maven/maple.jpeg)
(from http://www.talismancoins.com/servlet/detail?no=920)

## maven-antrun-plugin 

ant도 원래 로직을 넣을 수 없다. [Ant-Contrib](http://ant-contrib.sourceforge.net/) Task를 추가하면 로직을 사용할 수 있지만 `Maven->Ant Plugin->Ant-Contrib` 형태로 의존성이 생기는 거라 볼썽사납다.

기본적으로 `<target>` 타스크의 unless 속성을 이용하면 아주 간단한 로직은 구현할 수 있다. 특정 변수가 있을 때 실행할 배치작업을 쉽게 구현할 수 있다(from http://stackoverflow.com/questions/6342071/ant-target-to-run-only-based-on-condition):

```xml
<target name="check-abc">
    <available file="abc.txt" property="abc.present"/>
</target>

<target name="do-unless-abc" depends="check-abc" unless="abc.present">
    ...
</target> 
```

`abc.present`가 있을 때만 "do-unless-abc" 타스크가 수행된다. 특정 변수가 있을 때 실행하는 것을 조절하는 것뿐이지 로직을 구현할 수 있을 만큼은 아니다. 

maven-antrun-plugin은 maven 자체로는 하기 어려운 배치작업을 구현할 때 좋다. 파일을 복사하거나 삭제하고, ssh로 원격에서 작업한다거나 하는 일을 할 때 좋다. 로직을 넣어서 검증하는 코드를 작성하기에는 좋지 않다.

### javascript

최근에는 Rhino엔진이 들어가 있어서 jar파일을 추가하지 않고서도 바로 `<script>` 타스크에서 Javascript를 사용할 수 있지만 실제로 써보지 않았다.

더군다나 maven-antrun-plugin에서 `<script>` 타스크를 쓰는 것은 바람직하지 않다.

## gmaven-plugin

groovy 스크립트를 실행할 수 있기 때문에 Maven 모델에 접근해서 정보를 가져와서 검사할 수 있다. 사용해본지 너무 오래됐고 이제는 `maven-scala-plugin`만 사용하기 때문에 정확하게 정리할 수는 없지만, 다음과 같이 할 수 있다(from http://grumpyapache.blogspot.kr/2012/08/maven-is-groovy.html):

```html
<plugin>
    <groupId>org.codehaus.gmaven</groupId>
    <artifactId>gmaven-plugin</artifactId>
    <version>1.4</version>
    <executions>
        <execution>
        <phase>prepare-package</phase>
        <goals>
            <goal>execute</goal>
        </goals>
        <configuration>
            <source><![CDATA[
            def concat(s1, s2, t) {
                def java.io.File f1 = new java.io.File(s1)
                def java.io.File f2 = new java.io.File(s2)
                def java.io.File ft = new java.io.File(t)
                def long l1 = f1.lastModified()
                def long l2 = f2.lastModified()
                def long lt = ft.lastModified()

                if (l1 == 0) {
                    throw new IllegalStateException("Source file must exist:" + f1);
                } else if (l2 == 0) {
                    throw new IllegalStateException("Source file must exist:" + f2); 
                } else if (lt == 0 || l1 > lt || l2 > lt) {
                    java.io.File pd = ft.getParentFile()

                    if (pd != null && !pd.isDirectory() && !pd.mkdirs()) {
                        throw new IOException("Unable to create parent directory: " + pd)
                    }

                    println("Creating target file: " + ft)
                    println("Source1 = " + f1)
                    println("Source2 = " + f2)

                    java.io.FileInputStream fi1 = new java.io.FileInputStream(f1)
                    java.io.FileInputStream fi2 = new java.io.FileInputStream(f2)
                    ft.append(fi1)
                    ft.append(fi2)
                    fi1.close()
                    fi2.close()
                } else {
                    println("Target file is uptodate: " + ft)
                    println("Source1 = " + f1)
                    println("Source2 = " + f2)
                }
            }
            concat("target/classes/com/softwareag/de/s/framework/demo/db/derby/initZero.sql",
                "src/main/db/init0.sql",
                "target/classes/com/softwareag/de/s/framework/demo/db/hsqldb/init0.sql")

            concat("target/classes/com/softwareag/de/s/framework/demo/db/derby/initZero.sql",
                "src/main/db/init0.sql",
                "target/classes/com/softwareag/de/s/framework/demo/db/hsqldb/init0.sql")
            ]]></source>
        </configuration>
        </execution>
    </executions>
</plugin>
```

이 예제를 왜 만들었는지는 JOCHEN WIEDMANN의 [글](http://grumpyapache.blogspot.kr/2012/08/maven-is-groovy.html)을 참고하라.

groovy는 Java랑 비슷하니까 대충 짜서 사용할 수 있다. 

## maven-scala-plugin

최근에 Maven에 로직을 넣을 일이 있으면 이 플러그인을 사용한다. 간단한 스크립트를 짜는 게 전부니까 maven에서 scala가 groovy보다 나을 이유는 없다. 익숙한 걸 사용하면 되는데, 최근 scala를 공부하고 있기도 하고 gmaven-plugin보다 사이트가 더 잘 정리돼 있어서 보기 편하다.

scala를 java처럼 사용해도 충분하다. scala의 현란한 문법은 몰라도 된다.

```xml
<plugin>
    <groupId>org.scala-tools</groupId>
    <artifactId>maven-scala-plugin</artifactId>
    <version>2.15.2</version>
    <executions>
        <execution>
            <phase>validate</phase>
            <goals>
                <goal>script</goal>
            </goals>
        </execution>
    </executions>
    <configuration>
        <script> <![CDATA[
            import java.io.File

            //필요한 환경 변수가 있는지 검사.
            if( System.getenv("MY_HOME") == null ) {
                throw new RuntimeException( "MY_HOME variable not found ")
            }

            //NEED_DIR = "need1, need2, need3"
            val needDirs="${NEED_DIR}".split(',')

            //프로젝트 이름도 얻어올 수 있다.
            //project 변수를 통해서 Maven 내부에 접근할 수 있고 Maven의 정보를 이용할 수 있다.
            println(project.getName+" is the current project")

            //필요한 디렉토리가 만들어져 있는지 검사.
            needDirs.foreach(dir=>{
                val file = new File( dir )
                if( !file.exists() ){
                    throw new RuntimeException( "[" + dir + "] dir not found ")
                }
            })
        ]]> </script>
    </configuration>
</plugin>
```

validate Phase에서 내가 빠트린 것을 점검할 수 있다. 그리고 project 변수를 이용하면 더 많은 것들을 할 수 있다.

이 project의 타입은 org.scala.tools.maven.model.MavenProjectAdapter 이고 이 클래스가 제공하는 인터페이스로 Maven 정보를 이용할 수 있다. 자세한 내용은 [apidoc](http://scala-tools.org/mvnsites/maven-scala-plugin/apidocs/)을 봐라.

## 결론

`maven-scala-plugin`가 킹왕짱. 사견이지만, Maven에서 배치스크립트를 실행할 때는 `maven-antrun-plugin`이 검증코드 등 로직을 넣을 때는 `maven-scala-plugin`이 좋다.

[maven-scala-plugin]: http://scala-tools.org/mvnsites/maven-scala-plugin/
[maven-antrun-plugin]: http://maven.apache.org/plugins/maven-antrun-plugin/
[gmaven-plugin]: http://groovy.codehaus.org/GMaven
