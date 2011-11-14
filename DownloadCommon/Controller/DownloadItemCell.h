//
//  DownloadItemCell.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@class DownloadItem;

@protocol DownloadItemCellDelegate <NSObject>

- (void)clickPause:(id)sender atIndexPath:(NSIndexPath*)indexPath;
- (void)clickStar:(id)sender atIndexPath:(NSIndexPath*)indexPath;

@end

@interface DownloadItemCell : PPTableViewCell

+ (DownloadItemCell*) createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
@property (retain, nonatomic) IBOutlet UILabel *webSiteLabel;

@property (retain, nonatomic) IBOutlet UIButton *pauseButton;
@property (retain, nonatomic) IBOutlet UIButton *starButton;
@property (retain, nonatomic) IBOutlet UILabel *fileTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (retain, nonatomic) IBOutlet UILabel *downloadDetailLabel;

- (void)setCellInfoWithItem:(DownloadItem*)item indexPath:(NSIndexPath*)indexPath;
- (IBAction)clickPause:(id)sender;
- (IBAction)clickStar:(id)sender;

@end
