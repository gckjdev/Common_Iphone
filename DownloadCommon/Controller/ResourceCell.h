//
//  ResourceCell.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@class TopSite;

@interface ResourceCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *siteUrlLabel;
@property (retain, nonatomic) IBOutlet UILabel *downloadCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *siteNameLabel;

+ (ResourceCell*) createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCellInfoWithSite:(TopSite*)site atIndexPath:(NSIndexPath*)indexPath;

@end
