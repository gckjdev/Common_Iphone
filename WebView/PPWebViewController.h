//
//  PPWebViewController.h
//  FreeMusic
//
//  Created by qqn_pipi on 10-10-10.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

typedef void (^WebViewBackHandler)(UIViewController*);

@interface PPWebViewController : PPViewController <UIWebViewDelegate> {
    
    UIWebView *webView;
    UIToolbar *toolbar;
    UIBarButtonItem *forwardButton;
    UIBarButtonItem *backButton;
    UIBarButtonItem *reloadButton;
    UIActivityIndicatorView *loadActivityIndicator;
    NSURLRequest *request;
    
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *reloadButton;
@property (nonatomic, retain) UIActivityIndicatorView *loadActivityIndicator;
@property (nonatomic, assign) WebViewBackHandler backAction;
@property (nonatomic, retain) UIViewController* superViewController;

@property (nonatomic, retain) NSURLRequest *request;

- (IBAction) clickBackBuuton;
- (IBAction) clickForwardBuuton;
- (IBAction) clickReloadBuuton;
- (id)init;
- (void)openURL:(NSString *)URLString;

//delegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
+ (void)show:(UIViewController*)superController url:(NSString*)url;

//for groupbuy
+ (void)showForGroupBuy:(UIViewController*)superController url:(NSString*)url;
- (void)enableGroupBuySettings;

- (IBAction)clickBack:(id)sender;

@end

extern PPWebViewController *GlobalGetPPWebViewController();