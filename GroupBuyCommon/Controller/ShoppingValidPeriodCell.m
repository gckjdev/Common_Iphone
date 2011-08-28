//
//  ShoppingEffectiveDateCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingValidPeriodCell.h"



@implementation ShoppingValidPeriodCell
@synthesize periodSegmented;
@synthesize validPeriod;

- (void)dealloc {
    [periodSegmented release];
    [validPeriod release];
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

+ (NSString *) getPeriodTextWithDate:(NSDate *)date
{
    if (date == nil) {
        return NOT_LIMIT;
    }
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [formatter setTimeZone:tzGMT];
    [formatter setDateFormat:DATE_FORMAT];
    NSString *period = [formatter stringFromDate:date];
    return period;
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
    
//    ((ShoppingValidPeriodCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
//    
//    return (ShoppingValidPeriodCell*)[topLevelObjects objectAtIndex:0];
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingValidPeriodCell";
}

+ (CGFloat)getCellHeight
{
    return 75;
}

@end
