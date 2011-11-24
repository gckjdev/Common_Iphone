//
//  CommonFileActionController.h
//  Download
//
//  Created by  on 11-11-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownloadItem;

@protocol CommonFileActionProtocol <NSObject>

- (id)initWithDownloadItem:(DownloadItem*)item;
- (void)show:(UIView*)superView;
- (void)preview:(UIViewController*)viewController downloadItem:(DownloadItem*)item;

@optional
- (void)preview:(UIViewController*)viewController itemList:(NSArray*)list index:(int)indexValue;

@end
