--- yaml
layout: 'article'
title: 'UIWebView 쿠기 유지하기'
author: 'Sean Lee'
date: '2012-08-27'
tags: ['uiwebview', 'ios', 'cookie', '쿠키']
---

애플리케이션에서 UIWebView를 사용할 때 쿠키를 저장하는 방법을 살펴본다. 쿠키를 저장하면 애플리케이션이 종료되더라도 로그인 상태 등을 유지할 수 있다. 서버가 특별히 쿠키의 지속 시간을 지정하지 않은 경우 쿠키는 애플리케이션이 종료되면(백그라운드에 남아있는 것과는 다르다) 쿠키 정보는 사라진다.

UIWebView can save and restore cookies. Although application has terminated, the cookies and the session can be restored.

<img src="http://farm1.staticflickr.com/182/403856634_db35669863.jpg" width="500" height="375" alt="cookies do not always wish to remain stacked.">
*<a href="http://www.flickr.com/photos/klara/403856634/" title="Flickr에서 Klara Kim님의 cookies do not always wish to remain stacked.">cookies do not always wish to remain stacked. by klara</a>*

[reference]: https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSHTTPCookieStorage_Class/Reference/Reference.html

## 애플리케이션 종료시 쿠키 저장

우선 애플리케이션이 종료되는 이벤트를 잡아야 한다. 현재 멀티태스킹이 지원되는 SDK를 사용하여 애플리케이션을 만든 경우 Application Delegate의 아래 메소드가 호출된다.

	- (void)applicationDidEnterBackground:(UIApplication *)application

멀티태스킹이 지원되기 이전 버전의 SDK나 멀티태스킹을 사용하지 않도록 설정한 애플리케이션은 다음고 같은 메소드에서 종료 이벤트를 잡을 수 있다.

	- (void)applicationWillTerminate:(UIApplication *)application

쿠키 정보를 저장할 때 UIWebView 인스턴스는 필요 없다 [[NSHTTPCookieStorage][reference] sharedHTTPCookieStorage] 메소드를 호출하면
애플리케이션에게 할당된 쿠키 저장소를 반환받는다. 즉 시스템 브라우저인 Safari나 다른 애플리케이션과 공유하지 않는 애플리케이션만의 쿠키 저장소이다. (iOS는 쿠키를 공유하지 않지만 Mac OS는 쿠키를 공유한다)

	{
		NSLog(@"%@", @"PersisteWebCookie");
	    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	    NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
	    [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:@"MySavedCookies"];
	    NSLog(@"%@", @"PersisteWebCookie Saved");
	}

저장소에 현재 저장된 쿠키를 배열로(NSArray) 받아와서 NSUserDefaults에 저장할 수 있도록 NSKeyedArchiver를 통해 NSData 인스턴스로 변환한다. 키 값은 **MySavedCookies**를 사용하여 NSUserDefaults에 저장해둔다.

일반적으로 쿠키는 브라우저나 애플리케이션이 종료되면(iOS의 경우 홈버튼을 더블탭 하여 마이너스 아이콘으로 종료시키면) 쿠키 정보가 삭제된다. 하지만 위와 같이 저장한 쿠키 정보는 애플리케이션을 다시 실행시켰을 때 복구할 수 있다.

## 애플리케이션으로 돌아왔을 때

애플리케이션이 백그라운드에서 돌아오거나 다시 실행되는 이벤트는 보통 다음 Application Delegate의 메소드에서 처리한다.

	- (BOOL)application:(UIApplication *)application 
		didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

쿠키를 다시 되살리는 방법은 저장하는 순서의 반대로 한다. 키 값을 **MySavedCookies**로 하여 NSUserDefaults로부터 데이터를 꺼내오고 배열로 만든 후 하나씩 다시 쿠키 저장소에 저장한다.

	{
		NSLog(@"%@", @"PersisteWebCookie");
	    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySavedCookies"];
	    if([cookiesdata length]) {
	        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
	        NSHTTPCookie *cookie;
	        
	        for (cookie in cookies) {
	            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
	        }
	    }
	    NSLog(@"%@", @"PersisteWebCookie Restored");
	}