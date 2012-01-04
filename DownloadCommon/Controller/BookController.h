//
//  BookController.h
//  Download
//
//  Created by gckj on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@interface BookController : PPViewController<UIWebViewDelegate>

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, retain) UILabel *tipsLabel;
@property (nonatomic, retain) UIWebView *webView;

- (void)showBook:(int)indexValue;
@end
