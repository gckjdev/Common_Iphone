//
//  ProductTextCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@class Product;

@interface ProductTextCell : PPTableViewCell {
    
}
+ (ProductTextCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCellInfoWithProduct:(Product*)product indexPath:(NSIndexPath*)indexPath;

@end

