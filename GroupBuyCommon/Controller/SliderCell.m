//
//  SliderCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "SliderCell.h"
#import "AddShoppingItemController.h"
NSArray* priceArray;

@implementation SliderCell
@synthesize priceSegment;
@synthesize priceTextField;
@synthesize priceCellDelegate;
#define NOT_LIMIT @"不限"

- (void)dealloc {

    [priceTextField release];
    [priceSegment release];
    [priceCellDelegate release];
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
    
    SliderCell *cell = (SliderCell *)[topLevelObjects objectAtIndex:0];
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


- (void)setPrice:(NSNumber *)price
{
    if (price == nil || [price intValue] < 0) {
        self.priceTextField.text = NOT_LIMIT;
        [self.priceSegment setSelectedSegmentIndex:PRICE_UNLIMIT_INDEX];
    }else
    {
        [self.priceSegment setSelectedSegmentIndex:[self segmentIndexForPrice:price]];
        self.priceTextField.text = [price stringValue];
    }
}

- (void) setPrice:(NSNumber *)price segmentIndex:(NSInteger)index
{
    if (price == nil || [price intValue] < 0) {
        self.priceTextField.text = NOT_LIMIT;
    }else{
        self.priceTextField.text = [price stringValue];
    }
    
    [self.priceSegment setSelectedSegmentIndex:index];
}

- (NSNumber *)getPrice
{
    NSNumber *price = nil;
    
    if (self.priceTextField.text && ![self.priceTextField.text isEqualToString:NOT_LIMIT]) {
        price = [NSNumber numberWithInt:[self.priceTextField.text intValue]];
    }

    return price;
}


- (IBAction)selectSegment:(id)sender {
    if (sender == self.priceSegment) {
        NSInteger index = self.priceSegment.selectedSegmentIndex;
        
        if (index == UISegmentedControlNoSegment) {
            return;
        }
        
        NSString *value = [self.priceSegment titleForSegmentAtIndex:index];
        NSNumber *price = nil;
        
        if (![value isEqualToString:NOT_LIMIT]) {
            price = [NSNumber numberWithInt:[value intValue]];
        }
        
        [self setPrice:price segmentIndex:index];
    } 
    
}
- (IBAction)textFieldDidBeginEditing:(id)sender {
    [self.priceSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    if ([self.priceCellDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.priceCellDelegate textFieldDidBeginEditing:sender];
    }
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    NSNumber *price = [self getPrice];
    [self.priceSegment setSelectedSegmentIndex:[self segmentIndexForPrice:price]];
    
    if ([self.priceCellDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.priceCellDelegate textFieldDidEndEditing:sender];
    }
}


@end
