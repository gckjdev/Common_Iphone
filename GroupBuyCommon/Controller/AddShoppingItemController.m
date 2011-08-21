//
//  AddShoppingItemController.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "AddShoppingItemController.h"
#import "ShoppingKeywordCell.h"
#import "ShoppingCategoryCell.h"
#import "ShoppingValidPeriodCell.h"
#import "SliderCell.h"

#pragma mark Private
@interface AddShoppingItemController()

@property (nonatomic, retain) NSArray* categories;

@property (nonatomic, retain) NSArray* subCategories;

@property (nonatomic,assign) BOOL shouldShowSubCategoryCell;

-(IBAction) selectCategory:(id) sender;

@end

@implementation AddShoppingItemController


@synthesize categories;
@synthesize subCategories;
@synthesize shouldShowSubCategoryCell;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSArray* foods = [[NSArray alloc] initWithObjects:@"Good",@"VeryGood",@"Food",@"Fish",@"KFC",@"RealKongfu",@"Lamian",@"DimSum",nil];
	self.subCategories = [[NSArray alloc] initWithObjects:foods,nil];
	[foods release];
	self.shouldShowSubCategoryCell = NO;
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark Table View Delegate


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	
	return sectionHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
    if (indexPath.row == 0 || indexPath.row == 1){
        return [ShoppingCategoryCell getCellHeight];
    }
    else if (indexPath.row == 2) {
		return [ShoppingKeywordCell getCellHeight];
	} else if(indexPath.row == 3) {
		return [ShoppingValidPeriodCell getCellHeight];	
	} else if(indexPath.row == 4 || indexPath.row == 5) {
		return [SliderCell getCellHeight];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.shouldShowSubCategoryCell){
		return 6;
	}
	else {
		return 5;
	}
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPTableViewCell* cell = nil;
	int additionalCellCount = 0;
	if(self.shouldShowSubCategoryCell){
		additionalCellCount = 1;
	}
	if (indexPath.row == 0 || indexPath.row == 1){
		
		NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
		cell = (ShoppingCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingCategoryCell createCell:self];
		}
		
		int START_TAG = 10;
		int CATEGORY_COUNT = 8;
		for (int i = 0; i < CATEGORY_COUNT; i++) {
			[(UIButton*)[cell viewWithTag:i+START_TAG] addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
		}
    }
	
	else if (indexPath.row == 1&&self.shouldShowSubCategoryCell==YES){
		
			NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
			cell = (ShoppingCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [ShoppingCategoryCell createCell:self];
			}
		}
	
    else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 2) ||
		(self.shouldShowSubCategoryCell==NO && indexPath.row == 1)) {
		NSString *CellIdentifier = [ShoppingKeywordCell getCellIdentifier];
		cell = (ShoppingKeywordCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingKeywordCell createCell:self];
		}
		
	}  else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 3) ||
				(self.shouldShowSubCategoryCell==NO && indexPath.row == 2)) {
		NSString *CellIdentifier = [ShoppingValidPeriodCell getCellIdentifier];
		cell = (ShoppingValidPeriodCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingValidPeriodCell createCell:self];
		}
		
	}  else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 4) ||
				(self.shouldShowSubCategoryCell==NO && indexPath.row == 3))  {
		NSString *CellIdentifier = [SliderCell getCellIdentifier];
		cell = (SliderCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [SliderCell createCell:self];
		}
		
	}
	else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 5) ||
			 (self.shouldShowSubCategoryCell==NO && indexPath.row == 4))  {
		NSString *CellIdentifier = [SliderCell getCellIdentifier];
		cell = (SliderCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [SliderCell createCell:self];
		}
		
	}
	return cell;
}




//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
//}



/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
		
}*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
	
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


-(IBAction) selectCategory:(id) sender {
	UIButton *button = (UIButton *)sender;    
    //button.currentTitle;    
	if([button.currentTitle isEqualToString:@"不限"]{
		shouldShowSubCategoryCell = NO;
	}else{
		shouldShowSubCategoryCell = YES;
	}
	//TODO? refresh cell
	[self.tableView setNeedsDisplay];
}

@end
