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

enum {
    SELECT_ALL_ITEM,
    SELECT_COMPLETE_ITEM,
    SELECT_DOWNLOADING_ITEM,
    SELECT_STARRED_ITEM
};

@class ItemActionController;

@interface DownloadManageController : PPTableViewController <DownloadItemCellDelegate>

@property (nonatomic, retain) ItemActionController *actionController;
@property (nonatomic, assign) int currentSelection;
@property (nonatomic, retain) DownloadItem* lastPlayingItem;
@property (retain, nonatomic) IBOutlet UIButton *filterAllButton;
@property (retain, nonatomic) IBOutlet UIButton *filterCompleteButton;
@property (retain, nonatomic) IBOutlet UIButton *filterDownloadingButton;
@property (retain, nonatomic) IBOutlet UIButton *filterStarredButton;

- (IBAction)clickFilterComplete:(id)sender;
- (IBAction)clickFilterDownloading:(id)sender;
- (IBAction)clickFilterStarred:(id)sender;

- (NSArray*)findFilterDownloadItemByImage;

@end
