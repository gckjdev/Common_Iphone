//
//  ShoppingEffectiveDateCell.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@protocol  ShoppingValidPeriodDelegate<NSObject>

-(void) didSelectedValidPeriod:(NSDate *) date;
@end


@interface ShoppingValidPeriodCell : PPTableViewCell {

    UISegmentedControl *periodSegmented;
    UIButton *validPeriod;
    id<ShoppingValidPeriodDelegate> validPeriodDelegate;
    NSArray *dayArray;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *periodSegmented;
@property (nonatomic, retain) IBOutlet UIButton *validPeriod;
@property (nonatomic, retain) NSArray *dayArray;
@property (nonatomic, retain) id<ShoppingValidPeriodDelegate> 

validPeriodDelegate;
+ (ShoppingValidPeriodCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (IBAction)didSelectedPeriod:(id)sender;
- (NSDate *)calculateValidPeriodSinceNow:(NSInteger) day;
- (NSArray *)getDayArray;
@end
