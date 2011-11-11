//
//  DownloadWebViewController.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

typedef void (^WebViewBackHandler)(UIViewController*);

@interface DownloadWebViewController : PPViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *loadActivityIndicator;
@property (nonatomic, assign) WebViewBackHandler backAction;
@property (nonatomic, retain) UIViewController* superViewController;

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSString *webSite;
@property (nonatomic, retain) NSString *currentURL;
@property (nonatomic, retain) NSString *urlForAction;
@property (nonatomic, assign) BOOL openURLForAction;

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

- (IBAction)clickBack:(id)sender;


@end

DownloadWebViewController *GlobalGetDownloadWebViewController();