//
//  ResourceCell.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@class TopSite;
@class Site;

@interface ResourceCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *siteUrlLabel;
@property (retain, nonatomic) IBOutlet UILabel *downloadCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *fileTypeButton;

+ (ResourceCell*) createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCellInfoWithTopSite:(TopSite*)site atIndexPath:(NSIndexPath*)indexPath;
- (void)setCellInfoWithSite:(Site*)site atIndexPath:(NSIndexPath*)indexPath;
- (void)setFileTypeBgImage:(NSString*)fileType;

- (void)setCellSelectedColor;
- (void)resetCellColor;
@end
