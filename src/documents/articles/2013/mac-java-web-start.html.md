--- yaml
layout: 'article'
title: 'mac: java-web-start'
author: 'Changwoo Park'
date: '2013-3-8'
tags: ['mac', 'java', 'jnlp']
---

언제부터 안되더라? 왜 안되더라? 그런건 잘 모르겠고 Mac에서는 Java Web Start가 그냥 실행되지 않는다. Apple이 막은 건데, Oracle이 미운 이유는 뭘까! 아무튼 다시 켜는 방법이 있다.

![](/articles/2013/mac-java-web-start/mung-me.jpg)

## Java web start

윈도에서 처럼 매끄럽게 브라우저 안에서 Java App이 실행되지 않더라도 jnlp 파일을 다운로드 받아서 javaws 명령으로 실행시키면 실행해야 하는데 다음과 같은 에러를 내뱉는다:

```
$ javaws my.jnlp
Java Web Start splash screen process exiting ...
Can not find message file: No such file or directory
```

Google님께 물어보면 Java7을 설치하라는 얘기가 많다. 그래서 설치하고 이것 저것 해봤는데도 됐다가 안됐다가 했다. 자세한 히스토리는 알고 싶지 않았고 그냥 실행만 됐으면 했는데, 그래도 그냥 Java7을 설치했었다. Oracle Java7을 설치하라고 하니 왠지 내 Mac을 욕보이는 것 같았지만 그냥 설치했다.

어짜피 안돼서 Java7을 삭제했는데 Mac이 먹통ㅜㅜ. Mac까지 다시 설치해야 하나 싶었는데 이유는 모르겠지만 복구 됐다(야호!). 욕하고 싶은 상대가 Apple이 아닌 Oracle인건 왜일까!

아래와 같이 파일을 열고:

```
sudo vi /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.meta.plist
```

주석처리를 좀 하고:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<!--
  <key>JavaWebComponentVersionMinimum</key>
  <string>1.6.0_41-b02-446</string>
-->
  <key>LastModification</key>
  <string>Mon, 04 Mar 2013 21:47:02 GMT</string>
  <key>PlugInBlacklist</key>
  <dict>
    <key>10</key>
    <dict>
      <key>com.macromedia.Flash Player.plugin</key>
      <dict>
        <key>MinimumPlugInBundleVersion</key>
        <string>11.6.602.171</string>
      </dict>
<!--
      <key>com.oracle.java.JavaAppletPlugin</key>
      <dict>
        <key>MinimumPlugInBundleVersion</key>
        <string>1.7.15.04</string>
      </dict>
-->
    </dict>
  </dict>
  <key>Version</key>
  <integer>2033</integer>
</dict>
</plist>
```

리부팅한다. 그리고 아래와 같이 실행한다:

```
javaws my.jnlp
```

Apple이 Flash와 Java Applet을 BlackList로까지 분류하고 있는 줄은 몰랐다.

