//
//  UIWebViewUtil.m
//  LeleBrowser
//
//  Created by qqn_pipi on 10-12-14.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIWebViewUtil.h"


@implementation UIWebView (UIWebViewUtil)

- (NSURL*) locationURL
{
	NSString *rawLocationString = [self stringByEvaluatingJavaScriptFromString:@"location.href;"];	
	
	if(!rawLocationString)
		return nil;
	//URLWithString: needs percent escapes added or it will fail with, eg. a file:// URL with spaces or any URL with unicode.
	NSString* locationString = [locationString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [NSURL URLWithString:locationString];
}

- (NSString*) currentURL
{
	NSString *rawLocationString = [self stringByEvaluatingJavaScriptFromString:@"location.href;"];	
	if (rawLocationString == nil)
		return @"";
	else {
		return rawLocationString;
	}

}

- (NSString*) currentTitle
{
	NSString* webviewTitle = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
	if (webviewTitle == nil)
		return @"";
	else
		return webviewTitle;
}

@end