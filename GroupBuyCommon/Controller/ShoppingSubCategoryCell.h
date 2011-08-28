//
//  ShoppingSubCategoryCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPTableViewCell.h"

@interface ShoppingSubCategoryCell : PPTableViewCell {
    
    UIButton *selectCategoryLabel;
}
@property (nonatomic, retain) IBOutlet UIButton *selectCategoryLabel;
+ (ShoppingSubCategoryCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void) updateAllButtonLabelsWithArray:(NSArray*)labels;
- (void) addButtonsAction:(SEL) selector AndHighlightTheSelectedLabel:(NSString*)selectedLabel;
- (void) addButtonsAction:(SEL) selector;
- (void) highlightTheSelectedLabel:(NSString*)selectedLabel;
- (void)highlightTheSelectedLabels:(NSArray *)selectedLabels;
@end
