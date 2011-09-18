//
//  ShoppingCategoryCell.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingCategoryCell.h"
#import "CategoryManager.h"

@implementation ShoppingCategoryCell

@synthesize selectCategoryLabel;
@synthesize labelsArray;
@synthesize selectedCategory;

- (void)dealloc {
    [labelsArray release];
    [selectCategoryLabel release];
    [selectedCategory release];
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
    ShoppingCategoryCell *cell = ((ShoppingCategoryCell*)[topLevelObjects objectAtIndex:0]);
    cell.delegate = delegate;
    NSArray *categories = [CategoryManager getAllCategories];
    [cell updateAllButtonLabelsWithArray:categories];
    return cell;
}


+ (NSString*)getCellIdentifier
{
    return @"ShoppingCategoryCell";
}

+ (CGFloat)getCellHeight
{
    return 91.0f;
}

- (void) updateAllButtonLabelsWithArray:(NSArray*)labels
{
    self.labelsArray = labels;
    
	int START_TAG = 11;     // make sure tag is set correctly in buttons of cell in Interface Builder
    int BUTTON_COUNT = 9;
	int validCount = [labels count] > BUTTON_COUNT?BUTTON_COUNT:[labels count];
	for (int i = 0; i < validCount ; i++) {
		[(UIButton*)[self viewWithTag:i+START_TAG] setTitle:[labels objectAtIndex:i] forState:UIControlStateNormal];
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

- (void) addButtonsAction:(SEL)selector AndHighlightTheSelectedLabel:(NSString*)selectedLabel
{
	
	int START_TAG = 10;
	int CATEGORY_COUNT = 10;
	for (int i = 0; i < CATEGORY_COUNT; i++) {
		UIButton* button = (UIButton*)[self viewWithTag:i+START_TAG];
		if([button.currentTitle isEqualToString:selectedLabel])
		{
			[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; 
		}
        else{
			[button setTitleColor:[UIColor colorWithRed:0.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal]; 
			
		}
		
		[button addTarget:self.delegate action:selector forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void) setAndHighlightSelectedCategory:(NSString *)categoryName
{
    self.selectedCategory = categoryName;
    if (self.selectedCategory == nil) {
        [self highlightTheSelectedLabel:NOT_LIMT];
    }else{
        [self highlightTheSelectedLabel:categoryName];
    }
}

- (NSString *)getSelectedCategory
{
    return self.selectedCategory;
}

@end
