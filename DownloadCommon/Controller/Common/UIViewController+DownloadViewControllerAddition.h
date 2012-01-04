//
//  UIViewController+DownloadViewControllerAddition.h
//  Download
//
//  Created by  on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DownloadViewControllerAddition)

- (void)setDownloadRightBarButton:(NSString*)buttonText selector:(SEL)selector;
- (void)setBackButton;
- (void)setNextButton;
- (void)setPreviousButton;
- (void)updateNavigationTitle:(NSString*)titleString;
@end
