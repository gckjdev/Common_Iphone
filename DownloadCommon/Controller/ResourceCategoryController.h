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

@property (nonatomic, retain) NSMutableArray* topList;
@property (nonatomic, retain) NSMutableArray* hotList;
@property (nonatomic, retain) NSMutableArray* latestList;
@property (nonatomic, retain) NSMutableArray* starredList;
@property (retain, nonatomic) IBOutlet UIButton *topButton;
@property (retain, nonatomic) IBOutlet UIButton *hotButton;
@property (retain, nonatomic) IBOutlet UIButton *newButton;
@property (retain, nonatomic) IBOutlet UIButton *starredButton;

- (IBAction)clickHot:(id)sender;
- (IBAction)clickTop:(id)sender;
- (IBAction)clickNew:(id)sender;

@end
