//
//  ShoppingCategoryCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingCategoryCell.h"


@implementation ShoppingCategoryCell


- (void)dealloc {
    [super dealloc];
}



// just replace PPTableViewCell by the new Cell Class Name
+ (ShoppingCategoryCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingCategoryCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ShoppingCategoryCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ShoppingCategoryCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ShoppingCategoryCell*)[topLevelObjects objectAtIndex:0];
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingCategoryCell";
}

+ (CGFloat)getCellHeight
{
    return 60.0f;
}

- (void) updateAllButtonLabelsWithArray:(NSArray*)labels
{
	int START_TAG = 10;
    int BUTTON_COUNT = 8;
	int validCount = [labels count] > BUTTON_COUNT?BUTTON_COUNT:[labels count];
	for (int i = 0; i < validCount ; i++) {
		[(UIButton*)[self viewWithTag:i+START_TAG] setTitle:[labels objectAtIndex:i] forState:UIControlStateNormal];
	}
	for (int j=validCount; j<BUTTON_COUNT; j++){
        ((UIButton*)[self viewWithTag:j+START_TAG]).hidden = YES;
    }
	
}	

- (void) addButtonsAction:(SEL) selector AndHighlightTheSelectedLabel:(NSString*)selectedLabel
{
	
	int START_TAG = 10;
	int CATEGORY_COUNT = 8;
	for (int i = 0; i < CATEGORY_COUNT; i++) {
		UIButton* button = (UIButton*)[self viewWithTag:i+START_TAG];
		if([button.currentTitle isEqualToString:selectedLabel])
		{
			[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; 
		}else
		{
			[button setTitleColor:[UIColor colorWithRed:0.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal]; 
			
		}
		
		[button addTarget:self.delegate action:selector forControlEvents:UIControlEventTouchUpInside];
	}
}


@end
