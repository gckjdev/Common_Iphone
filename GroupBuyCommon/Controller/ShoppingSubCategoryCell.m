//
//  ShoppingSubCategoryCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingSubCategoryCell.h"


@implementation ShoppingSubCategoryCell

@synthesize selectCategoryLabel;


- (void)dealloc {
    [selectCategoryLabel release];
    [super dealloc];
}



// just replace PPTableViewCell by the new Cell Class Name
+ (ShoppingSubCategoryCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingSubCategoryCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ShoppingSubCategoryCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ShoppingSubCategoryCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ShoppingSubCategoryCell*)[topLevelObjects objectAtIndex:0];
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingSubCategoryCell";
}

+ (CGFloat)getCellHeight
{
    return 90.0f;
}

- (void) updateAllButtonLabelsWithArray:(NSArray*)labels
{
	int START_TAG = 11;         // skip not limit tag
    int BUTTON_COUNT = 10;
	int validCount = [labels count] > BUTTON_COUNT?BUTTON_COUNT:[labels count];
	for (int i = 0; i < validCount ; i++) {
		[(UIButton*)[self viewWithTag:i+START_TAG] setTitle:[labels objectAtIndex:i] forState:UIControlStateNormal];
        ((UIButton*)[self viewWithTag:i+START_TAG]).hidden = NO;
	}
	for (int j=validCount; j<BUTTON_COUNT; j++){
        ((UIButton*)[self viewWithTag:j+START_TAG]).hidden = YES;
    }
	
}	

- (void) addButtonsAction:(SEL) selector
{
	int START_TAG = 10;
	int BUTTON_COUNT = 10;
	for (int i = 0; i < BUTTON_COUNT; i++) {
		UIButton* button = (UIButton*)[self viewWithTag:i+START_TAG];
		[button addTarget:self.delegate action:selector forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void) highlightTheSelectedLabel:(NSString*)selectedLabel
{
	int START_TAG = 10;
	int BUTTON_COUNT = 10;
	for (int i = 0; i < BUTTON_COUNT; i++) {
		UIButton* button = (UIButton*)[self viewWithTag:i+START_TAG];
		if([button.currentTitle isEqualToString:selectedLabel])
		{
			[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; 
		}
        else{
			[button setTitleColor:[UIColor colorWithRed:0.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal]; 
			
		}
	}    
}

- (void)highlightTheSelectedLabels:(NSArray *)selectedLabels
{
    
    int START_TAG = 10;
	int BUTTON_COUNT = 10;
	for (int i = 0; i < BUTTON_COUNT; i++) {
		UIButton* button = (UIButton*)[self viewWithTag:i+START_TAG];
		if([selectedLabels containsObject:button.currentTitle])
		{
			[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; 
		}
        else{
			[button setTitleColor:[UIColor colorWithRed:0.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal]; 
			
		}
	}    

}

- (void) addButtonsAction:(SEL) selector AndHighlightTheSelectedLabel:(NSString*)selectedLabel
{
	
	int START_TAG = 10;
	int CATEGORY_COUNT = 10;
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
