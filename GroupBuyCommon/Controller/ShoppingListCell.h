//
//  ShoppingListCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@interface ShoppingListCell : PPTableViewCell {
    
}

+ (ShoppingListCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

@end
