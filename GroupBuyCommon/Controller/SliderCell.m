//
//  SliderCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "SliderCell.h"


@implementation SliderCell



- (void)dealloc {
    [super dealloc];
}



// just replace PPTableViewCell by the new Cell Class Name
+ (SliderCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SliderCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <SliderCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((SliderCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (SliderCell*)[topLevelObjects objectAtIndex:0];
}


+ (NSString*)getCellIdentifier
{
    return @"SliderCell";
}

+ (CGFloat)getCellHeight
{
    return 75;
}


@end
