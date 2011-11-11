//
//  DownloadManageController.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "DownloadItemCell.h"

@class ItemActionController;

@interface DownloadManageController : PPTableViewController <DownloadItemCellDelegate>

@property (nonatomic, retain) ItemActionController *actionController;

@end
