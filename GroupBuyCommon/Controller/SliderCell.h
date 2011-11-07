//
//  SliderCell.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "PPSegmentControl.h"


@protocol PriceCellDelegate <NSObject>
@required

- (void)textFieldDidBeginEditing:(id)sender;
- (void)textFieldDidEndEditing:(id)sender;

@end

#define PRICE_UNLIMIT_INDEX 6


@interface SliderCell : PPTableViewCell<PPSegmentControlDelegate> {
    UITextField *priceTextField;
    PPSegmentControl *priceSeg;
    id<PriceCellDelegate>priceCellDelegate;
    NSArray *_priceArray;
}

@property (nonatomic, retain) IBOutlet UITextField *priceTextField;
@property (nonatomic, retain) id<PriceCellDelegate>priceCellDelegate;
@property (nonatomic, retain) PPSegmentControl *priceSeg;
@property (nonatomic, retain) NSArray *_priceArray;

+ (SliderCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (NSInteger)segmentIndexForPrice:(NSNumber *)price;

- (void)setPrice:(NSNumber *)price;
- (NSNumber *)getPrice;
- (NSArray *)getPriceArray;

- (IBAction)textFieldDidBeginEditing:(id)sender;
- (IBAction)textFieldDidEndEditing:(id)sender;
- (void)setCellInfo:(NSNumber *)price;

@end
