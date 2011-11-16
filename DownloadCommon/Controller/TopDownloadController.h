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
    NSArray* siteList;
    TopDownloadItem* currentSelectItem;
}

@property (nonatomic, assign) int requestType;
@property (nonatomic, retain) NSArray* siteList;
@property (nonatomic, retain) TopDownloadItem* currentSelectItem;

- (void)askDownload;

@end
