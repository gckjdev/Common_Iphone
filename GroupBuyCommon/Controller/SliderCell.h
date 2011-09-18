//
//  SliderCell.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@protocol PriceCellDelegate <NSObject>
@required

- (void)textFieldDidBeginEditing:(id)sender;
- (void)textFieldDidEndEditing:(id)sender;

@end

#define PRICE_UNLIMIT_INDEX 6


@interface SliderCell : PPTableViewCell {
    UITextField *priceTextField;
    UISegmentedControl *priceSegment;
    id<PriceCellDelegate>priceCellDelegate;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *priceSegment;
@property (nonatomic, retain) IBOutlet UITextField *priceTextField;
@property (nonatomic, retain) id<PriceCellDelegate>priceCellDelegate;

+ (SliderCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (NSInteger)segmentIndexForPrice:(NSNumber *)price;
- (void)setPrice:(NSNumber *)price;
- (NSNumber *)getPrice;

- (IBAction)textFieldDidBeginEditing:(id)sender;
- (IBAction)textFieldDidEndEditing:(id)sender;

- (IBAction)selectSegment:(id)sender;

@end
