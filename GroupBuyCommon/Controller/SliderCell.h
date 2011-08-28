//
//  SliderCell.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"


#define PRICE_UNLIMIT_INDEX 6

@interface SliderCell : PPTableViewCell {
    UITextField *priceTextField;
    UISegmentedControl *priceSegment;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *priceSegment;
@property (nonatomic, retain) IBOutlet UITextField *priceTextField;

+ (SliderCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;


@end
