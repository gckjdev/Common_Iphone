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

- (void)viewDidLoad
{
    
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
    
    
    
    
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
    
    NSLog(@"html:%@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"]);
    
    NSArray       *arr  = [html componentsSeparatedByString:@"获取到的授权码："];
    
    if ([arr count] > 1) {
        
        NSArray       *_arr = [[arr objectAtIndex:1] componentsSeparatedByString:@"Copyright"];
        
        NSString *pin = [[_arr objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        pin = [pin stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSLog(@"pin:%@",pin);
        
        if (pin.length > 0) return pin;
        
    }
    
    
    
    if (html.length == 0) return nil;
    
    
    
    return nil;
    
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
