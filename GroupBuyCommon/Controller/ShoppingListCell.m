//
//  ShoppingListCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingListCell.h"


@implementation ShoppingListCell
@synthesize keyWordsLabel;
@synthesize validPeriodLabel;
@synthesize priceLabel;
@synthesize editButton;
@synthesize boughtCountLabel;
@synthesize loadingIndicator;

- (void)dealloc {
    [keyWordsLabel release];
    [validPeriodLabel release];
    [priceLabel release];
    [editButton release];
    [boughtCountLabel release];
    [loadingIndicator release];
    [super dealloc];
}



// just replace PPTableViewCell by the new Cell Class Name
+ (ShoppingListCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingListCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ShoppingListCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ShoppingListCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ShoppingListCell*)[topLevelObjects objectAtIndex:0];
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingListCell";
}

+ (CGFloat)getCellHeight
{
    return 81.0f;
}

- (IBAction)clickEdit:(id)sender
{
    if ([delegate respondsToSelector:@selector(clickEdit:atIndexPath:)]){
        [self.delegate clickEdit:sender atIndexPath:indexPath];
    }
}

@end
