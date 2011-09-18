//
//  ShoppingCategoryCell.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

#define NOT_LIMT @"不限"
@protocol CategoryCellDelegate <NSObject>

- (void)didSelectCategory:(NSString *)categoryName;

@end

@interface ShoppingCategoryCell : PPTableViewCell {

    UIButton *selectCategoryLabel;
    NSArray  *labelsArray;
    NSString*  selectedCategory;
}
@property (nonatomic, retain) IBOutlet UIButton *selectCategoryLabel;
@property (nonatomic, retain) NSArray  *labelsArray;
@property (nonatomic, retain) NSString*  selectedCategory;


+ (ShoppingCategoryCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void) updateAllButtonLabelsWithArray:(NSArray*)labels;
- (void) addButtonsAction:(SEL) selector;
- (void) highlightTheSelectedLabel:(NSString*)selectedLabel;

- (void) setAndHighlightSelectedCategory:(NSString *)categoryName;

- (NSString *)getSelectedCategory;
@end
