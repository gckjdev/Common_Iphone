//
//  ShoppingEffectiveDateCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingValidPeriodCell.h"


@implementation ShoppingValidPeriodCell



- (void)dealloc {
    [super dealloc];
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
