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

@interface TopDownloadController : PPTableViewController <ResourceServiceDelegate> {
    int requestType;
    NSArray* siteList;
}

@property (nonatomic, assign) int requestType;
@property (nonatomic, retain) NSArray* siteList;

@end
