//
//  SliderCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "SliderCell.h"

NSArray* priceArray;

@implementation SliderCell
@synthesize priceSegment;
@synthesize priceTextField;

#define NOT_LIMIT @"不限"

- (void)dealloc {

    [priceTextField release];
    [priceSegment release];
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
    
    SliderCell *cell = [topLevelObjects objectAtIndex:0];
    cell.delegate = delegate;
    
    cell.priceTextField.text = NOT_LIMIT;
    
    return cell;
    
//    ((SliderCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
//    
//    return (SliderCell*)[topLevelObjects objectAtIndex:0];
}


+ (NSString*)getCellIdentifier
{
    return @"SliderCell";
}

+ (CGFloat)getCellHeight
{
    return 85;
}


- (NSInteger)segmentIndexForPrice:(NSNumber *)price;
{
    
    if (price == nil) {
        return UISegmentedControlNoSegment;
    }
    NSString *text = [price stringValue];
    for (int i = 0; i < self.priceSegment.numberOfSegments; ++ i) {
        if ([text isEqualToString:[self.priceSegment titleForSegmentAtIndex:i]]) {
            return i;
        }
    }
    return UISegmentedControlNoSegment;
}


@end
