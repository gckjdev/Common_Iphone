//
//  ShoppingEffectiveDateCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingValidPeriodCell.h"
#import "TimeUtils.h"


@implementation ShoppingValidPeriodCell
@synthesize periodSegmented;
@synthesize validPeriod;
@synthesize exipireDate;

- (void)dealloc {
    [periodSegmented release];
    [validPeriod release];
    [expireDate release];
    
    [super dealloc];
}

+ (NSDate *)calculateValidPeriodSinceNow:(NSInteger) day{
    NSInteger seconds = day * 24 * 3600;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:seconds];
    return date;
}


+ (NSDate *)calculateValidPeriodWithSegmentIndex:(NSInteger) index
{
    NSArray *days = [ShoppingValidPeriodCell getDayArray];
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    NSDate * date = nil;
    
    if (index < PERIOD_UNLIMIT_INDEX) {
        NSNumber *day = [days objectAtIndex:index];
        date = [ShoppingValidPeriodCell calculateValidPeriodSinceNow:[day intValue]];
    }
    return date;
}



+ (NSArray *)getDayArray
{
    
    NSNumber *oneWeek = [NSNumber numberWithInt:ONE_WEEK];
    NSNumber *oneMonth = [NSNumber numberWithInt:ONE_MONTH];
    NSNumber *threeMonth = [NSNumber numberWithInt:THREE_MONTH];
    NSNumber *halfYear = [NSNumber numberWithInt:HALF_YEAR];
    NSNumber *unlimit = [NSNumber numberWithInt:UNLIMIT];
    NSArray *dayArray = [NSArray arrayWithObjects:oneWeek,oneMonth,threeMonth,halfYear,unlimit,nil];
    
    return dayArray;

}

// just replace PPTableViewCell by the new Cell Class Name
+ (ShoppingValidPeriodCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingValidPeriodCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ShoppingValidPeriodCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ShoppingValidPeriodCell *cell = [topLevelObjects objectAtIndex:0];
    cell.delegate = delegate;
    cell.validPeriod.titleLabel.text = NOT_LIMIT;
    
    return cell;
    
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingValidPeriodCell";
}

+ (CGFloat)getCellHeight
{
    return 80;
}

- (NSInteger)segmentIndexForDate:(NSDate *)date
{
    if (date == nil) {
        return PERIOD_UNLIMIT_INDEX;
    }
    NSString *dateString = dateToString(date);
    for (int i = 0; i < PERIOD_UNLIMIT_INDEX; ++ i) {
        NSDate *vDate = [ShoppingValidPeriodCell calculateValidPeriodWithSegmentIndex:i];
        NSString *vDateString = dateToString(vDate);
        if ([dateString isEqualToString:vDateString]) {
            return i;
        }
    }
    return UISegmentedControlNoSegment;
}

- (IBAction)didSelectPeriod:(id)sender {
    
    NSInteger index = self.periodSegmented.selectedSegmentIndex;
    
    if (index == UISegmentedControlNoSegment) {
        return;
    }
    self.exipireDate = [ShoppingValidPeriodCell calculateValidPeriodWithSegmentIndex:index];
    if (self.exipireDate) {
        self.validPeriod.titleLabel.text = dateToString(self.exipireDate);
    }else{
        self.validPeriod.titleLabel.text = NOT_LIMIT;
    }
}


- (void)setAndCalculateExpireDate:(NSDate *)date
{
    if (date == nil) {
        self.validPeriod.titleLabel.text = NOT_LIMIT;
        [self.periodSegmented setSelectedSegmentIndex:PERIOD_UNLIMIT_INDEX];
    }else
    {
        self.validPeriod.titleLabel.text = dateToString(date);
        int index = [self segmentIndexForDate:date];
        [self.periodSegmented setSelectedSegmentIndex: index];
    }
}
- (NSDate *)getExpireDate
{
    return self.exipireDate;
}
@end
