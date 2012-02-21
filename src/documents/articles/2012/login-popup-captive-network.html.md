--- yaml
layout: 'article'
title: 'Login Popup & Captive Network'
author: 'Sean Lee'
date: '2012-2-27'
tags: ['Login', 'Popup', 'Captive', 'Network', 'UX']
---

스마트폰이나 노트북을 항상 들고다니는 사람이 늘어남에 따라 모바일AP 즉 핫스팟을 이용하는 사람도 많이 늘어났다. 핫스팟에 접속을 하고 인터넷을 하게되면 회원가입이나 인증이 되지 않은 접속장치에 한해서 핫스팟 제공자의 안내페이지나 로그인 페이지가 뜨게 된다.

![firstwifi][]

## Captive Network & Problem

위의 화면은 한국에 가장 많이 사용되는 핫스팟 서비스인 ollehWifi(구, 네스팟)에 접속한 화면이다. 수 많은 호텔이나 큰 규모의 건물 혹은 장소들에 위와 같은 핫스팟 사용 안내 페이지 혹은 인증 페이지를 볼 수 있다. 이러한 페이지를 Captive Portal이라고 한다.

물론 위에서 ollehWifi 서비스에 가입을 했고 해당 장치가 적절히 인증을 받았다면 위와 같은 화면이 뜨지 않고 바로 원하는 사이트로 이동할 수 있다. 인터넷에 연결되지 않은 것은 아니지만, 사용자가 원하는 사이트가 아니라 다른 사이트가 나온다는 점에서 작은 문제가 발생한다.

모바일 어플리케이션이나 웹브라우저에서 어떤 인터넷의 데이터를 요청해서 받아오는 경우 Wifi를 통해 네트워크에 접속은 되었지만 실제 받아온 데이터는 원하는 데이터가 아닌 Captive Network의 안내페이지의 데이터를 받아오게 된다. 예를 들어 http 프로토콜로 JSON 데이터를 요청하는 어플리케이션이 있다면 Captive 네트워크에 스마트폰이 Wifi로 접속해 있다면 html로 된 Captive Portal의 페이지 정보를 받게 될 가능성이 높다. 이러한 데이터 에러를 제대로 처리하지 못하면 어플리케이션에 심각한 문제가 발생할수도 있다.

## Captive Network Detection

앞서 살펴본 ollehWifi 인증 화면 iOS에 설치된 Captive Network 에 대한 Portal 화면이다. 이 화면은 브라우저를 띄우지 않아도 Captive Network에 접속하게 되면 OS가 자동으로 띄워준다. OS는 이러한 환경을 어떻게 찾아낼 수 있는것일까? 

![panera-captive][]
<sup>http://www.docstechnotes.com/2011/07/os-x-lion-learns-wi-fi-login-trick-from.html</sup>

모바일뿐만 아니라 요즘은 데스크톱 OS에서도 적용되어 있다. iOS의 경우 3.0부터, Mac의 경우 Lion부터, Win의 경우 Win7부터 적용된 것 같다. Lion의 경우 브라우저 말고 이런 팝업창에서 입력한 Captive Network에 대한 사용자ID와 패스워드를 OS 차원에서 저장해주기도 한다.

![mac-captive][]
<sup>http://www.apple.com/macosx/whats-new/features.html#networking</sup>

Captive Network인지를 확인하기 위해 Lion의 경우 Captive Service가 항상 동작하고 있으며 수시로 네트워크 상황을 확인한다. Captive Network인지 확인하기 위해서 다음과 같은 URL의 데이터를 불러와본다.

    $ curl http://www.apple.com/library/test/success.html
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
    <HTML>
    <HEAD>
    	<TITLE>Success</TITLE>
    </HEAD>
    <BODY>
    Success
    </BODY>
    </HTML>

<code>http://www.apple.com/library/test/success.html</code>의 데이터를 불러왔을 때 진짜로 원하는 데이터가 들어있는지 확인하는 [방식][Apple's secret "wispr" request]이다. 간단하다. Windows또한 비슷한 방식을 사용하며 [NCSI:Network Connectivity Status Indicator][Windows 7의 NCSI(Network Connectivity Status Indicator)]라고 부른다.

## 적용 및 참고

어플리케이션이 네트워크를 통해 데이터를 불러와서 사용할 때 확인해야할 것으로 다음과 같은 것이 있다.

* 장치가 네트워크를 사용할 수 있는지
* 네트워크를 통해 데이터를 불러올 수 있는지
* 불러온 데이터가 원하는 대로 형식을 갖고 있는지

Captive Network의 경우 위에서 확인할 사항 중 세 번째 사항에 해당할 것이다. Captive Network에 대하여 알아보려면 다음과 같은 사이트를 더 참고해 볼 수 있다.

* [Apple's secret "wispr" request]
* [iOS 3.0에서 Captive Network 찾기]
* [Web-based 인증을 위한 표준 제안]
* [Windows 7의 NCSI(Network Connectivity Status Indicator)]

## 사족

Captive Network에서 인증을 하지 않으면 원하는 사이트에 접근할 수 없는 경우가 대부분이며 접속할 수 있는 포트 또한 제한되어 있다. 인증을 거쳐야만 제대로 사용할 수 있는 것이다. 하지만 보통 인증을 위하여 DNS 프로토콜 53번 포트는 열려있는 경우가 있으므로 이를 잘 활용해(SSH 터널링, Proxy) 볼 수도 있을 것이다.

[firstwifi]: /articles/2012/captive-network/firstwifi.jpg
[panera-captive]: /articles/2012/captive-network/panera-captive.png
[mac-captive]: /articles/2012/captive-network/mac-captive.png

[Apple's secret "wispr" request]: http://erratasec.blogspot.com/2010/09/apples-secret-wispr-request.html
[iOS 3.0에서 Captive Network 찾기]: http://www.mactalk.com.au/31/66812-iphone-3-0-wireless-captive-portal-support.html
[Web-based 인증을 위한 표준 제안]: http://tools.ietf.org/html/draft-nottingham-http-portal-02
[Windows 7의 NCSI(Network Connectivity Status Indicator)]: http://blog.superuser.com/2011/05/16/windows-7-network-awareness/

