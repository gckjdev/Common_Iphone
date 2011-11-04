//
//  ShoppingSubCategoryCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingSubCategoryCell.h"

#ifndef DEFAULT_COLOR
#define DEFAULT_COLOR ([UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0])
#endif

@implementation ShoppingSubCategoryCell

@synthesize selectCategoryLabel;
@synthesize selectedSubCategories;

- (void)dealloc {
    [selectCategoryLabel release];
    [selectedSubCategories release];
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
    return 130.0f;
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
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIImage *bgImage = [[UIImage imageNamed:@"tu_126-53.png"]stretchableImageWithLeftCapWidth:7.5 topCapHeight:0];
            [button setBackgroundImage:bgImage forState:UIControlStateNormal];
		}
        else{
			[button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal]; 
            [button setBackgroundImage:nil forState:UIControlStateNormal];   
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
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIImage *bgImage = [[UIImage imageNamed:@"tu_126-53.png"]stretchableImageWithLeftCapWidth:7.5 topCapHeight:0];
            [button setBackgroundImage:bgImage forState:UIControlStateNormal];
		}
        else{
			[button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal]; 
            [button setBackgroundImage:nil forState:UIControlStateNormal];   
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
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIImage *bgImage = [[UIImage imageNamed:@"tu_126-53.png"]stretchableImageWithLeftCapWidth:7.5 topCapHeight:0];
            [button setBackgroundImage:bgImage forState:UIControlStateNormal];
		}
        else{
			[button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal]; 
            [button setBackgroundImage:nil forState:UIControlStateNormal];   
		}
		
		[button addTarget:self.delegate action:selector forControlEvents:UIControlEventTouchUpInside];
	}
}


- (void) setAndHighlightSelectedSubCategories:(NSArray *)subCategories
{
    if (subCategories == nil) {
        [self highlightTheSelectedLabels:[NSArray arrayWithObject:NOT_LIMIT]];
        self.selectedSubCategories = nil;
    }else{
        self.selectedSubCategories = [NSMutableArray arrayWithArray:subCategories];
        [self highlightTheSelectedLabels:subCategories];
    }
}
- (void) addAndHighlightSelectedSubCategory:(NSString *)category
{
    if (self.selectedSubCategories == nil) {
        self.selectedSubCategories = [NSMutableArray arrayWithObject:category];
    }else{
        if ([self.selectedSubCategories containsObject:category]) {
            [self.selectedSubCategories removeObject:category];
        }else{
            [self.selectedSubCategories addObject:category];
        }
    }
    [self highlightTheSelectedLabels:self.selectedSubCategories];
}

- (NSArray *)getSelectedSubCategories
{
    return self.selectedSubCategories;
}

@end
