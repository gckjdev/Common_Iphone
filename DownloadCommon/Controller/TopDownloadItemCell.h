//
//  TopDownloadItemCell.h
//  Download
//
//  Created by gckj on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@class TopDownloadItem;

@interface TopDownloadItemCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UILabel *rankLabel;
@property (retain, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *totalDownloadButton;
@property (retain, nonatomic) IBOutlet UIButton *fileTypeButton;
@property (retain, nonatomic) IBOutlet UILabel *webSiteNameLabel;

+ (TopDownloadItemCell*) createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCellInfoWithTopDownloadItem:(TopDownloadItem*)item atIndexPath:(NSIndexPath*)indexPath;

- (void)setCellSelectedColor;
- (void)resetCellColor;
@end
