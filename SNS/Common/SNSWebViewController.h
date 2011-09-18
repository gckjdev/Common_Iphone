//
//  SNSWebViewController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-9-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@class CommonSNSRequest;

@protocol SNSWebViewControllerDelegate <NSObject>

- (void)finishParsePin:(int)result pin:(NSString*)pin snsRequest:(CommonSNSRequest*)snsRequest;

@end

@interface SNSWebViewController : PPViewController<UIWebViewDelegate> {
    
    UIWebView   *webView;
    NSURL       *url;
    CommonSNSRequest *snsRequest;
    id<SNSWebViewControllerDelegate> delegate;
}

@property (nonatomic, retain) CommonSNSRequest *snsRequest;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) id<SNSWebViewControllerDelegate> delegate;

@end
