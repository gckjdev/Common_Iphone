//
//  WebViewAdditions.m
//  tppispig
//
//  Created by gao wei on 10-7-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebViewAdditions.h"
#import "LogUtil.h"

@implementation HTMLLinkInfo

@synthesize src;
@synthesize href;
@synthesize tags;
@synthesize text;

- (void)dealloc
{
    [src release];
    [href release];
    [tags release];
    [text release];
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"src=%@, href=%@, tags=%@, text=%@", self.src, self.href, self.tags, self.text];
}

- (BOOL)hasLink
{
    return ([href length] > 0);
}

- (BOOL)hasImage
{
    return ([src length] > 0);
}

@end

@implementation UIWebView(WebViewAdditions)

- (CGSize)windowSize
{
	CGSize size;
	size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
	size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
	return size;
}

- (CGPoint)scrollOffset
{
	CGPoint pt;
	pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
	pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
	return pt;
}

- (void)loadGetURLJavaScript
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];	
	NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];	
	[self stringByEvaluatingJavaScriptFromString: jsCode];		    
}

- (HTMLLinkInfo*)getLinkInfo:(CGPoint)pt
{
    NSString *data = [NSString stringWithString:[self stringByEvaluatingJavaScriptFromString:
                                                 [NSString stringWithFormat:@"MyAppGetHTMLLinkAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]]];
	
	HTMLLinkInfo* info = [[[HTMLLinkInfo alloc] init] autorelease];
    NSArray* array = [data componentsSeparatedByString:@"$$_$$"];   // seperator is defined in JSTools
    if ([array count] >= 4){  // 4 components at least, refer to JSTools.js
        info.href = [array objectAtIndex:0];
        info.src = [array objectAtIndex:1];
        info.tags = [array objectAtIndex:2]; 
        info.text = [array objectAtIndex:3];
    }    
    
    return info;
}

- (void)openContextualMenuAt:(CGPoint)pt
{
	// Load the JavaScript code from the Resources and inject it into the web page
	[self loadGetURLJavaScript];
    HTMLLinkInfo* info = [self getLinkInfo:pt];
    PPDebug(@"Link Info = %@", [info description]);
	
    if (self.delegate && [self.delegate respondsToSelector:@selector(longpressTouch:info:)]){
        [self.delegate performSelector:@selector(longpressTouch:info:) withObject:self withObject:info];
    }
    
//	// create the UIActionSheet and populate it with buttons related to the tags
//	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Contextual Menu"
//													   delegate:nil cancelButtonTitle:@"Cancel"
//										 destructiveButtonTitle:nil otherButtonTitles:nil];
//	
//    //	// If a link was touched, add link-related buttons
//    //	if ([tags rangeOfString:@",A,"].location != NSNotFound) {
//    //		[sheet addButtonWithTitle:@"Open Link"];
//    //		[sheet addButtonWithTitle:@"Open Link in Tab"];
//    //		[sheet addButtonWithTitle:@"Download Link"];
//    //	}
//    //	// If an image was touched, add image-related buttons
//    //	if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
//    //		[sheet addButtonWithTitle:@"Save Picture"];
//    //	}
//	// Add buttons which should be always available
//	[sheet addButtonWithTitle:@"Save Page as Bookmark"];
//	[sheet addButtonWithTitle:@"Open Page in Safari"];
//	
//	[sheet showInView:self];
//	[sheet release];
}


- (void)contextualMenuAction:(NSNotification*)notification
{
	CGPoint pt;
	NSDictionary *coord = [notification object];
	pt.x = [[coord objectForKey:@"x"] floatValue];
	pt.y = [[coord objectForKey:@"y"] floatValue];
	
	// convert point from window to view coordinate system
	pt = [self convertPoint:pt fromView:nil];
	
	// convert point from view to HTML coordinate system
	// CGPoint offset  = [webView scrollOffset]; don't need offset, Benson
	CGSize viewSize = [self frame].size;
	CGSize windowSize = [self windowSize];
	
	CGFloat f = windowSize.width / viewSize.width;
	pt.x = pt.x * f; // + offset.x; don't need offset !
	pt.y = pt.y * f; // + offset.y; don't need offset !
	
	[self openContextualMenuAt:pt];
}

- (void)registerLongPressHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
}

- (NSString*)getTitle
{
    NSString *theTitle = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    return theTitle;
}


@end
