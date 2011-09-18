//
//  ShoppingKeywordCell.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@protocol KeywordCellDelegate <NSObject>

@required
- (void)textFieldDidBeginEditing:(id)sender;
- (void)textFieldDidEndEditing:(id)sender;

@end


@interface ShoppingKeywordCell : PPTableViewCell {

    UITextField *keywordTextField;
    id<KeywordCellDelegate> keywordCellDelegate;
}
@property (nonatomic, retain) IBOutlet UITextField *keywordTextField;
@property (nonatomic, retain) id<KeywordCellDelegate> keywordCellDelegate;
+ (ShoppingKeywordCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;

- (IBAction)textFieldDidBeginEditing:(id)sender;
- (IBAction)textFieldDidEndEditing:(id)sender;

- (void)setkeyword:(NSString *)keyword;
- (NSString *)getKeywords;

@end
