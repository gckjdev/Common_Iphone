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

    UIButton *selectCategoryLabel;
}
@property (nonatomic, retain) IBOutlet UIButton *selectCategoryLabel;

+ (ShoppingCategoryCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void) updateAllButtonLabelsWithArray:(NSArray*)labels;
- (void) addButtonsAction:(SEL) selector AndHighlightTheSelectedLabel:(NSString*)selectedLabel;

@end
