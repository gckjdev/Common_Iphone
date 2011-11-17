//
//  TopDownloadController.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ResourceService.h"

@class TopDownloadItem;

@interface TopDownloadController : PPTableViewController <ResourceServiceDelegate, UIActionSheetDelegate> {
    int requestType;
    int startOffset;
    NSMutableArray* toplist;
    TopDownloadItem* currentSelectItem;
}

@property (nonatomic, assign) int requestType;
@property (nonatomic, assign) int startOffset;
@property (nonatomic, retain) NSMutableArray* toplist;
@property (nonatomic, retain) TopDownloadItem* currentSelectItem;

- (void)askDownload;
- (UIColor*)getDefaultTextColor;
@end
