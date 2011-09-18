//
//  ShoppingSubCategoryCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPTableViewCell.h"
#define NOT_LIMIT @"不限"
@interface ShoppingSubCategoryCell : PPTableViewCell {
    
    UIButton *selectCategoryLabel;
    NSMutableArray* selectedSubCategories;
}

@property (nonatomic, retain) IBOutlet UIButton *selectCategoryLabel;
@property (nonatomic, retain) NSMutableArray* selectedSubCategories;

+ (ShoppingSubCategoryCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void) updateAllButtonLabelsWithArray:(NSArray*)labels;
- (void) addButtonsAction:(SEL) selector AndHighlightTheSelectedLabel:(NSString*)selectedLabel;
- (void) addButtonsAction:(SEL) selector;
- (void) highlightTheSelectedLabel:(NSString*)selectedLabel;
- (void) highlightTheSelectedLabels:(NSArray *)selectedLabels;
- (void) setAndHighlightSelectedSubCategories:(NSArray *)subCategories;
- (void) addAndHighlightSelectedSubCategory:(NSString *)category;
- (NSArray *)getSelectedSubCategories;
@end
