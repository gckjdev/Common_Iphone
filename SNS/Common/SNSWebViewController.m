//
//  SNSWebViewController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-9-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SNSWebViewController.h"
#import "CommonSNSRequest.h"

@implementation SNSWebViewController

@synthesize webView;
@synthesize url;
@synthesize delegate;
@synthesize snsRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [snsRequest release];
    [webView release];
    [url release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#define WEB_VIEW_FRAME   CGRectMake(7, 8, 320-7*2, 480-44-20-8-55-8)

- (void)enableGroupBuySettings
{
    webView.frame = WEB_VIEW_FRAME;
    webView.backgroundColor = [UIColor clearColor];
    
    [self setGroupBuyNavigationBackButton];
    [self setBackgroundImageName:@"background.png"];
    [self setGroupBuyNavigationTitle:@"微博授权"];
}

- (void)viewDidLoad
{
    [self enableGroupBuySettings];
    [super viewDidLoad];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *) locateAuthPinInWebView: (UIWebView *) webViewVal {
    
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{6}" 
                                                                           options:0 
                                                                             error:NULL];
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];    
    NSLog(@"html : %@", html);
    if (html == nil)
        return nil;

    NSTextCheckingResult *match = [regex firstMatchInString:html 
                                                    options:0 
                                                      range:NSMakeRange(0, [html length])];
    
//    NSRange range = [match rangeAtIndex:1];
    if (match == nil)
        return nil;
    
    NSString* pin = [html substringWithRange:match.range];
    NSLog(@"pin : %@", pin);
    return pin;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"loading URL : %@", [url description]);
    [self showActivityWithText:@"正在加载页面..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewVal
{
    [self hideActivity];
    NSString* pin = [self locateAuthPinInWebView:webView];
    if ([pin length] > 0){
        if (delegate && [delegate respondsToSelector:@selector(finishParsePin:pin:snsRequest:)]){
            [delegate finishParsePin:0 pin:pin snsRequest:snsRequest];
        }
    }
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"load URL failure, error=%@", [error description]);
    [self hideActivity];
    [self popupMessage:@"加载页面失败，请确认你已经连接到互联网" title:nil];
}


@end
