//
//  PPTableViewCell.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PPTableViewCell : UITableViewCell {
    NSIndexPath *indexPath;    
    id delegate;
}

+ (PPTableViewCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;

@end
