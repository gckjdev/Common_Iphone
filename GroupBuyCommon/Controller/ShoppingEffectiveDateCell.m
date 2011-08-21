//
//  ShoppingEffectiveDateCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingEffectiveDateCell.h"


@implementation ShoppingEffectiveDateCell



- (void)dealloc {
    [super dealloc];
}


// just replace PPTableViewCell by the new Cell Class Name
+ (ShoppingEffectiveDateCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingEffectiveDateCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ShoppingEffectiveDateCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ShoppingEffectiveDateCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ShoppingEffectiveDateCell*)[topLevelObjects objectAtIndex:0];
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingEffectiveDateCell";
}

+ (CGFloat)getCellHeight
{
    return 80.0f;
}

@end
