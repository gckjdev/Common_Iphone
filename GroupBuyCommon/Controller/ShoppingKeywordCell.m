//
//  ShoppingKeywordCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingKeywordCell.h"


@implementation ShoppingKeywordCell
@synthesize keywordTextField;
@synthesize keywordCellDelegate;



- (void)dealloc {
    [keywordTextField release];
    [keywordCellDelegate release];
    [super dealloc];
}


// just replace PPTableViewCell by the new Cell Class Name
+ (ShoppingKeywordCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingKeywordCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ShoppingKeywordCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ShoppingKeywordCell* cell = (ShoppingKeywordCell*)[topLevelObjects objectAtIndex:0]; 
    cell.delegate = delegate;
    return cell;
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingKeywordCell";
}

- (IBAction)textFieldDidBeginEditing:(id)sender {
    if ([self.keywordCellDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.keywordCellDelegate textFieldDidBeginEditing:sender];
    }
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    if ([self.keywordCellDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.keywordCellDelegate textFieldDidEndEditing:sender];
    }
}

+ (CGFloat)getCellHeight
{
    return 70.0f;
}

- (void)setkeyword:(NSString *)keyword
{
    self.keywordTextField.text = keyword;
}

- (NSString *)getKeywords
{
    return self.keywordTextField.text;
}
@end
