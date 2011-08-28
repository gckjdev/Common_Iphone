//
//  ShoppingEffectiveDateCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingValidPeriodCell.h"

#define ONE_WEEK 7
#define ONE_MONTH 30
#define THREE_MONTH 90
#define HALF_YEAR 183
#define UNLIMIT 0
#define UNLIMIT_INDEX 4

@implementation ShoppingValidPeriodCell
@synthesize periodSegmented;
@synthesize validPeriod;
@synthesize validPeriodDelegate;

- (void)dealloc {
    [validPeriodDelegate release];
    [periodSegmented release];
    [validPeriod release];
    [super dealloc];
}

- (NSDate *)calculateValidPeriodSinceNow:(NSInteger) day{
    NSInteger seconds = day * 24 * 3600;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:seconds];
    return date;
}

- (IBAction)didSelectedPeriod:(id)sender{
    NSDate *date;
    NSNumber *oneWeek = [NSNumber numberWithInt:ONE_WEEK];
    NSNumber *oneMonth = [NSNumber numberWithInt:ONE_MONTH];
    NSNumber *threeMonth = [NSNumber numberWithInt:THREE_MONTH];
    NSNumber *halfYear = [NSNumber numberWithInt:HALF_YEAR];
    NSNumber *unlimit = [NSNumber numberWithInt:UNLIMIT];
    NSArray * days = [NSArray arrayWithObjects:oneWeek,oneMonth,threeMonth,halfYear,unlimit,nil];
    
    NSInteger index = periodSegmented.selectedSegmentIndex;
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeZone:tzGMT];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    if (index < UNLIMIT_INDEX) {
        NSNumber *day = [days objectAtIndex:index];
        date = [self calculateValidPeriodSinceNow:[day intValue]];
        NSString* str = [formatter stringFromDate:date];
        validPeriod.titleLabel.text = str;
    }else if(index == UNLIMIT_INDEX){
        date = nil;
        validPeriod.titleLabel.text = @"不限";
    }
    
    if ([validPeriodDelegate respondsToSelector:@selector(didSelectedValidPeriodIndex:)]) {
        [validPeriodDelegate didSelectedValidPeriod:date];
    }    
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
    
    ((ShoppingValidPeriodCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ShoppingValidPeriodCell*)[topLevelObjects objectAtIndex:0];
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
