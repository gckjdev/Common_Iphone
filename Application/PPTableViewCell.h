//
//  PPTableViewCell.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPTableViewController;

@interface PPTableViewCell : UITableViewCell {
    NSIndexPath *indexPath;    
    id delegate;
    PPTableViewController *tableViewController;
    
}

// copy and override three methods below
+ (PPTableViewCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCellStyle;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) PPTableViewController *tableViewController;

@end
