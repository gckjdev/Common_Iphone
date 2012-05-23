//
//  BookController.h
//  Download
//
//  Created by gckj on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@class GADBannerView;

@interface BookController : PPViewController<UIWebViewDelegate>

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, retain) UILabel *tipsLabel;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) GADBannerView* bannerView;

- (void)showBook:(int)indexValue;
@end
