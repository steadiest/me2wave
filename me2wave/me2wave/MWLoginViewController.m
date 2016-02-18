//
//  MWLoginViewController.m
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import "MWLoginViewController.h"
#import "MWMe2dayClient.h"

@implementation MWLoginViewController

- (void)login {
	
	NSLog(@"Login!");
	
	UIWebView *webView = [[UIWebView alloc] init];
	webView.delegate = self;
	
	webViewController = [[UIViewController alloc] init];
	webViewController.view = webView;
	[webView release];
	
	// get auth url
    NSString *authUrl;
    [MWMe2dayClient getAuthenticationUrl:&authUrl token:&token];
	    
	// launch uiwebview
	NSString *loginUrl = [NSString stringWithFormat:@"http://me2day.net/n/account/login?redirect_url=%@", [
                                                                                                           [authUrl stringByReplacingOccurrencesOfString:@"start_auth" withString:@"auth"]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
	NSURL *url = [[NSURL alloc] initWithString:loginUrl];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:60/*default value*/];
	
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	for (NSHTTPCookie *cookie in [cookieStorage cookiesForURL:url]) {
		NSLog(@"%@", cookie);
		[cookieStorage deleteCookie:cookie];
	}
	
    [self presentViewController:webViewController animated:NO completion:nil];
	[url release];
	[webView loadRequest:request];
	[request release];
}


#pragma mark UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIViewController *controller = [[UIViewController alloc] init];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    controller.view = view;
    [view release];
    
	[webViewController presentViewController:controller animated:NO completion:nil];
	[controller release];
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
    [webViewController dismissViewControllerAnimated:NO completion:nil];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSLog(@"finish load");
    
	NSString *accepted = [webView stringByEvaluatingJavaScriptFromString:
						  @"(function() { var meta = document.getElementsByTagName('meta'); for(var i = 0; i < meta.length; i++) { if('X-ME2API-AUTH-RESULT' == meta[i].name) { return meta[i].content; } } return ''; }) ()"];
	
	NSLog(@"returned value : %@", accepted);
	
	if (accepted == nil || accepted.length == 0) {
		NSLog(@"Not accepted, continue loading");
		return;
	}
	
	[webViewController release];
	webView = nil;
	[self dismissViewControllerAnimated:NO completion:nil];
	
	// 수락한 경우
	if ([accepted isEqualToString:@"accepted"]) {
		
        [MWMe2dayClient saveAccessTokenByFullAuthToken:token];
		NSLog(@"losing modal view");
		[self dismissViewControllerAnimated:NO completion:nil];
		
	} else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:NSLocalizedString(@"Authentication Error", @"인증 오류")];
        [alert setMessage:NSLocalizedString(@"Service approach to me2day denied by user.", @"사용자에 의해 미투데이 접근이 거부되었습니다")];
        alert.cancelButtonIndex = [alert addButtonWithTitle:NSLocalizedString(@"OK", @"확인")];
        [alert show];
        [alert release];
		[self dismissViewControllerAnimated:NO completion:nil];
	}
}


- (void)dealloc {
    [super dealloc];
}

@end
