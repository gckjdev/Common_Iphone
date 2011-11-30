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
@property (nonatomic, assign) int urlFileType;
@property (nonatomic, assign) BOOL openURLForAction;

@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) IBOutlet UIButton *addFavoriteButton;
@property (retain, nonatomic) IBOutlet UIButton *backwardButton;
@property (retain, nonatomic) IBOutlet UIButton *forwardButton;

- (IBAction) clickBackButton;
- (IBAction) clickForwardButton;
- (IBAction) clickReloadButton;
- (IBAction) clickStopButton;
- (IBAction) clickAddFavorite:(id)sender;

- (id)init;
- (void)openURL:(NSString *)URLString;

//delegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
+ (void)show:(UIViewController*)superController url:(NSString*)url;

- (IBAction)clickBack:(id)sender;
- (void)askDownload:(NSString*)urlString;

@end

DownloadWebViewController *GlobalGetDownloadWebViewController();