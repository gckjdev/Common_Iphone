//
//  ShoppingListCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@protocol ShoppingListCellDelegate <NSObject>

- (void)clickEdit:(id)sender atIndexPath:(NSIndexPath*)indexPath;

@end

@interface ShoppingListCell : PPTableViewCell {
    
    UILabel *keyWordsLabel;
    UILabel *validPeriodLabel;
    UILabel *priceLabel;
    UIButton *editButton;
    UILabel *matchCountLabel;
    UIActivityIndicatorView *loadingIndicator;
}
@property (nonatomic, retain) IBOutlet UILabel *keyWordsLabel;
@property (nonatomic, retain) IBOutlet UILabel *validPeriodLabel;
@property (retain, nonatomic) IBOutlet UIImageView *matchCountBackgroundImageView;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UIButton *editButton;
@property (nonatomic, retain) IBOutlet UILabel *matchCountLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;

+ (ShoppingListCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (IBAction)clickEdit:(id)sender;

@end
