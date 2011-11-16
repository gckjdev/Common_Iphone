//
//  ResourceCategoryController.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ResourceService.h"

@interface ResourceCategoryController : PPTableViewController <ResourceServiceDelegate>

@property (nonatomic, assign) int requestType;

@property (nonatomic, retain) NSArray* topList;
@property (nonatomic, retain) NSArray* hotList;
@property (nonatomic, retain) NSArray* latestList;
@property (nonatomic, retain) NSArray* starredList;

- (IBAction)clickHot:(id)sender;
- (IBAction)clickTop:(id)sender;
- (IBAction)clickNew:(id)sender;

@end
