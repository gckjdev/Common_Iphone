//
//  SliderCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "SliderCell.h"
#import "AddShoppingItemController.h"

@implementation SliderCell
@synthesize priceTextField;
@synthesize priceCellDelegate;
@synthesize priceSeg;
@synthesize _priceArray;

#define NOT_LIMIT @"不限"

- (void)dealloc {

    [priceTextField release];
    [priceCellDelegate release];
    [priceSeg release];
    [_priceArray release];
    
    [super dealloc];
}

- (NSArray *)getPriceArray
{
    if (self._priceArray == nil || 
        [self._priceArray count] != PRICE_UNLIMIT_INDEX + 1) {
        self._priceArray = [NSArray arrayWithObjects:@"20",@"50", @"100", 
                            @"150", @"300", @"500", NOT_LIMIT, nil];
    }
    return self._priceArray;
}

- (void)SetPricePPSeg
{
    NSArray *array = [self getPriceArray];
    UIImage *bgImage = [[UIImage imageNamed:@"tu_39.png"]stretchableImageWithLeftCapWidth:8.5 topCapHeight:0];
    UIImage *selectedImage = [[UIImage imageNamed:@"tu_126-53.png"]stretchableImageWithLeftCapWidth:7.5 topCapHeight:0];
   
    self.priceSeg = [[PPSegmentControl alloc]initWithItems:array 
                                        defaultSelectIndex:PRICE_UNLIMIT_INDEX frame:CGRectMake(20, 38, 280, 40)];
    
    [self.priceSeg setBackgroundImage:bgImage];
    [self.priceSeg setSelectedSegmentImage:selectedImage];
    [self.priceSeg setTextFont:[UIFont boldSystemFontOfSize:12]];
    [self.priceSeg setSelectedSegmentTextFont:[UIFont boldSystemFontOfSize:12]];
    
    [self.priceSeg setTextColor:
     [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1]];
    [self.priceSeg setSelectedSegmentTextColor:
     [UIColor whiteColor]];

    [self.priceSeg setDelegate:self];
    [self addSubview:self.priceSeg];
    
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
    [cell SetPricePPSeg];
    [cell setPrice:nil];
    return cell;
    
}

#pragma ppSegmentControl delegate
-(void)didSegmentValueChange:(PPSegmentControl *)seg
{

    NSInteger index = [self.priceSeg selectedSegmentIndex];
    
    if (index == UISegmentedControlNoSegment) {
        return;
    }
    
    NSString *value = [self.priceSeg titleForSegmentAtIndex:index];
    NSNumber *price = nil;
    
    if (![value isEqualToString:NOT_LIMIT]) {
        price = [NSNumber numberWithInt:[value intValue]];
    }
    [self setPrice:price];

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
        return PRICE_UNLIMIT_INDEX;
    }
    NSString *priceString = [NSString stringWithFormat:@"%d",[price integerValue]];
    NSArray *array = [self getPriceArray];
    if ([array containsObject:priceString]) {
        return [array indexOfObject:priceString];
    }
    return UISegmentedControlNoSegment;
}


- (void)setPrice:(NSNumber *)price
{
    if (price == nil || [price intValue] < 0) {
        self.priceTextField.text = NOT_LIMIT;
    }else
    {
        self.priceTextField.text = [price stringValue];
    }
}


//- (void) setPrice:(NSNumber *)price segmentIndex:(NSInteger)index
//{
//    if (price == nil || [price intValue] < 0) {
//        self.priceTextField.text = NOT_LIMIT;
//    }else{
//        self.priceTextField.text = [price stringValue];
//    }
//    
//    [self.priceSeg setSelectedSegmentIndex:index];
//}

- (NSNumber *)getPrice
{
    NSNumber *price = nil;
    
    if (self.priceTextField.text && ![self.priceTextField.text isEqualToString:NOT_LIMIT]) {
        price = [NSNumber numberWithInt:[self.priceTextField.text intValue]];
    }

    return price;
}



- (void)setCellInfo:(NSNumber *)price
{

    [self setPrice:price];
    NSInteger index = [self segmentIndexForPrice:price];
    [self.priceSeg setSelectedSegmentIndex:index];
}

- (IBAction)textFieldDidBeginEditing:(id)sender {
    [self.priceSeg setSelectedSegmentIndex:UISegmentedControlNoSegment];
    if ([self.priceCellDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.priceCellDelegate textFieldDidBeginEditing:sender];
    }
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    NSNumber *price = [self getPrice];
    [self.priceSeg setSelectedSegmentIndex:[self segmentIndexForPrice:price]];
    
    if ([self.priceCellDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.priceCellDelegate textFieldDidEndEditing:sender];
    }
}


@end
