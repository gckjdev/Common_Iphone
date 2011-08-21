//
//  ShoppingCategoryCell.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@interface ShoppingCategoryCell : PPTableViewCell {

}
+ (ShoppingCategoryCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void) updateAllButtonLabelsWithArray:(NSArray*)labels;
- (void) addAction:(SEL) selector AndSetColorBySelectedLabel:(NSString*)selectedLabel;
@end
