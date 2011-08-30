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
#import "ShoppingSubCategoryCell.h"
#import "ShoppingValidPeriodCell.h"
#import "SliderCell.h"
#import "UserShopItemService.h"
#import "UIViewUtils.h"
#import "CategoryManager.h"
#import "LocationService.h"
 
#pragma mark Private
@interface AddShoppingItemController()

// static data
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* subCategories;
@property (nonatomic,retain) NSDictionary* subCateogriesDict;

// data
@property (nonatomic, retain) NSString* selectedCategory;
@property (nonatomic, retain) NSMutableArray* selectedSubCategories;

// UI elements
@property (nonatomic,assign) BOOL shouldShowSubCategoryCell;
@property (nonatomic,retain) UITextField* keywordTextField;
@property (nonatomic,retain) UITextField* priceTextField;
@property (nonatomic,retain) UISegmentedControl* priceSegment;
@property (nonatomic,retain) UISegmentedControl* periodSegment;
@property (nonatomic,retain) UIButton* periodButton;



@end

@implementation AddShoppingItemController


@synthesize categories;
@synthesize subCategories;
@synthesize shouldShowSubCategoryCell;
@synthesize itemName;
@synthesize selectedCategory;
@synthesize selectedSubCategories;
@synthesize subCateogriesDict;

@synthesize keywordTextField;
@synthesize priceSegment;
@synthesize priceTextField;
@synthesize periodSegment;
@synthesize periodButton;

@synthesize itemId;
@synthesize keywords;
@synthesize expireDate;
@synthesize maxPrice;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


#define NOT_LIMIT   @"ä¸??"

- (void)updateRowIndex
{
    if ([selectedCategory isEqualToString:NOT_LIMIT] == NO){
        isShowSubCategory = YES;
    }
    else{
        isShowSubCategory = NO;
    }
    
    if (isShowSubCategory){
        rowOfCategory = 0;
        rowOfSubCategory = 1;
        rowOfKeyword = 2;
        rowOfValidPeriod = 3;
        rowOfPrice = 4;
        rowOfCity = 5;
        rowOfRebate = -1;       // not used
        rowOfCity = -1;
        rowNumber = 5;
    }
    else{
        rowOfCategory = 0;
        rowOfSubCategory = -1;  // don't show
        rowOfKeyword = 1;
        rowOfValidPeriod = 2;
        rowOfPrice = 3;
        rowOfCity = -1;         // not used 
        rowOfRebate = -1;       // not used
        rowNumber = 4;
    }
    
    [self.dataTableView reloadData];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationRightButton:@"ä¿??" action:@selector(clickSave:)];
	
	self.shouldShowSubCategoryCell = NO;
	self.selectedCategory = NOT_LIMIT;
    self.selectedSubCategories = [NSMutableArray arrayWithObjects:NOT_LIMIT, nil];
    
    self.categories = [CategoryManager getAllCategories];
    
    [self activateKeyboardNumberPadReturn];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateRowIndex];
    [super viewDidAppear:animated];
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
    
    [maxPrice release];
    [expireDate release];    
    [itemId release];
    [keywords release];
    
    [keywordTextField release];
    [priceSegment release];
    [priceTextField release];
    [periodSegment release];
    [periodButton release];
    
	[categories release];
	[subCategories release];
	[itemName release];
    
	[selectedCategory release];
    [selectedSubCategories release];
    
	[subCateogriesDict release];
    [super dealloc];
}

#pragma mark Table View Delegate

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	//NSString *sectionHeader = [groupData titleForSection:section];	
	return sectionHeader;
}
 */


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == rowOfCategory){
        return [ShoppingCategoryCell getCellHeight];            
    }
    else if (indexPath.row == rowOfSubCategory){
        return [ShoppingSubCategoryCell getCellHeight];
    }
    else if (indexPath.row == rowOfKeyword){
        return [ShoppingKeywordCell getCellHeight];
    }
    else if (indexPath.row == rowOfValidPeriod){
        return [ShoppingValidPeriodCell getCellHeight];
    }
    else if (indexPath.row == rowOfPrice){
		return [SliderCell getCellHeight];
    }
    else if (indexPath.row == rowOfRebate){
		return [SliderCell getCellHeight];
    }
    else{
        return 0.0f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.row == rowOfCategory){
        
        ShoppingCategoryCell* cell = nil;		
		NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
		cell = (ShoppingCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingCategoryCell createCell:self];
            [cell updateAllButtonLabelsWithArray:self.categories];
            [cell addButtonsAction:@selector(selectCategory:)];
		}
        
		[cell highlightTheSelectedLabel:self.selectedCategory];		
        
        return cell;
    }	
	else if (indexPath.row == rowOfSubCategory){		
        
        ShoppingSubCategoryCell* cell = nil;
        
        NSString *CellIdentifier = [ShoppingSubCategoryCell getCellIdentifier];
        cell = (ShoppingSubCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
        if (cell == nil) {
            cell = [ShoppingSubCategoryCell createCell:self];
            [cell addButtonsAction:@selector(selectSubCategory:)];
        }
		   
        NSArray* subCategory = [CategoryManager getSubCategoriesByCategory:self.selectedCategory];
        [cell updateAllButtonLabelsWithArray:subCategory];		   		        
        [cell highlightTheSelectedLabels:self.selectedSubCategories];

        return cell;
    }	
    else if (indexPath.row == rowOfKeyword){
        
        ShoppingKeywordCell* cell = nil;

		NSString *CellIdentifier = [ShoppingKeywordCell getCellIdentifier];
		cell = (ShoppingKeywordCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingKeywordCell createCell:self];
            self.keywordTextField = cell.keywordTextField;
            [cell.keywordTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];

		}
        
        return cell;

		
	}else if (indexPath.row == rowOfValidPeriod) {
        
        ShoppingValidPeriodCell* cell = nil;

		NSString *CellIdentifier = [ShoppingValidPeriodCell getCellIdentifier];
		cell = (ShoppingValidPeriodCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingValidPeriodCell createCell:self];
            self.periodSegment = cell.periodSegmented;
            self.periodButton = cell.validPeriod;
            
//            [self.periodButton addTarget:self action:@selector(onClickPeriodButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.periodSegment addTarget:self action:@selector(segmentedDidValueChanged:) forControlEvents:UIControlEventValueChanged];
		}
        
        return cell;
		
	}else if (indexPath.row == rowOfPrice)  {

        SliderCell* cell = nil;
        
		NSString *CellIdentifier = [SliderCell getCellIdentifier];
		cell = (SliderCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [SliderCell createCell:self];
            self.priceTextField = cell.priceTextField;
            self.priceSegment = cell.priceSegment;
            
            [self.priceTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [self.priceTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            
            [self.priceSegment addTarget:self action:@selector(segmentedDidValueChanged:) forControlEvents:UIControlEventValueChanged];
            
		}
        return cell;
		
	} else if (indexPath.row == rowOfRebate)  {
        
        SliderCell* cell = nil;

		NSString *CellIdentifier = [SliderCell getCellIdentifier];
		cell = (SliderCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [SliderCell createCell:self];
		}
        return cell;
		
	}
    else{
        NSLog(@"ERROR: <cellForRowAtIndexPath> cannot found cell for row at %d", indexPath.row);
        return nil;
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    self.dataTableView.frame = self.view.bounds;
}

- (void) textFieldDidBeginEditing:(id)sender{
    
    NSIndexPath* indexPath = nil;
    if (keywordTextField == sender){
        indexPath = [NSIndexPath indexPathForRow:rowOfKeyword inSection:0];    
        self.currentKeyboardType = keywordTextField.keyboardType;
    }
    else if (priceTextField == sender) {
        indexPath = [NSIndexPath indexPathForRow:rowOfPrice inSection:0];   
        [self.priceSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        self.currentKeyboardType = priceTextField.keyboardType;
    }
    
    CGRect frame = self.dataTableView.frame;
    frame.size.height = 480 - kKeyboadHeight - kNavigationBarHeight - kStatusBarHeight;
    self.dataTableView.frame = frame;
    [self.dataTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    

}

- (void)textFieldDidEndEditing:(id)sender
{
    if (self.priceTextField == sender) {
        NSString *text = priceTextField.text;
        
        if (text == nil || [text length] == 0) {
            maxPrice = [NSNumber numberWithInteger:-1];
            priceTextField.text = NOT_LIMIT;
            [self.priceSegment setSelectedSegmentIndex:PRICE_UNLIMIT_INDEX];
        }
        else {
            self.maxPrice = [NSNumber numberWithInteger:[priceTextField.text integerValue]];
            
        }
        
    }
}

//- (void)onClickPeriodButton:(id)sender 
//{
//    NSIndexPath* indexPath = nil;
//        
//    if (sender == self.periodButton) {
//        indexPath = [NSIndexPath indexPathForRow:rowOfValidPeriod inSection:0];
//        CGRect frame = dataTableView.frame;
//        frame.size.height = 480 - kKeyboadHeight - kNavigationBarHeight - kStatusBarHeight;
//        dataTableView.frame = frame;
//        [dataTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//}

- (void)segmentedDidValueChanged:(id)sender
{
    
    if (sender == self.priceSegment) {
        NSInteger index = self.priceSegment.selectedSegmentIndex;
        
        if (index == UISegmentedControlNoSegment) {
            return;
        }
        
        NSString *value = [self.priceSegment titleForSegmentAtIndex:index];
        priceTextField.text = value;
        
        NSInteger price = -1;
        if ([value compare:NOT_LIMIT] != 0) {
            price = [value integerValue];
        }
        self.maxPrice = [NSNumber numberWithInt:price];
        
    } else if(self.periodSegment == sender){
        NSInteger index = self.periodSegment.selectedSegmentIndex;
        
        if (index == UISegmentedControlNoSegment) {
            return;
        }
        
        NSDate *date = [ShoppingValidPeriodCell calculateValidPeriodWithSegmentIndex:index];
        NSString * period = [ShoppingValidPeriodCell getPeriodTextWithDate:date];
        self.periodButton.titleLabel.text = period;
        self.expireDate = date;
    }
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}



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
    
    if (![button.currentTitle isEqualToString:self.selectedCategory]) {
        [self.selectedSubCategories removeAllObjects];
        [self.selectedSubCategories addObject:NOT_LIMIT];
    }
    
	if([button.currentTitle isEqualToString:NOT_LIMIT]){
		shouldShowSubCategoryCell = NO;
        [self.selectedSubCategories removeAllObjects];
        [self.selectedSubCategories addObject:NOT_LIMIT];
	}else{
		shouldShowSubCategoryCell = YES;
	}
    NSLog(@"<selectCategory> category=%@", button.currentTitle);
	self.selectedCategory = button.currentTitle;
    [self updateRowIndex];
}



-(IBAction) selectSubCategory:(id) sender {    

	UIButton *button = (UIButton *)sender;        

    NSString *category = button.currentTitle;
    if ([category isEqualToString:NOT_LIMIT]) {
        [self.selectedSubCategories removeAllObjects];
        [self.selectedSubCategories addObject:category];
    }
    else{
    
    if ([self.selectedSubCategories containsObject:NOT_LIMIT]) {
        [self.selectedSubCategories removeObject:NOT_LIMIT];
    }
    if ([self.selectedSubCategories containsObject:category]) {
        [self.selectedSubCategories removeObject:category];
    }else{
        [self.selectedSubCategories addObject:category];
    }
    }
    [self updateRowIndex];
}

- (void)displaySettings
{
    NSLog(@"*************************Display**********************");
    NSLog(@"selected category: %@", self.selectedCategory);
    NSString *subCategoriesStr = @"";
    for (int i = 0; i < [[self selectedSubCategories] count]; ++i) {
        subCategoriesStr = [NSString stringWithFormat:@"%@, %@",subCategories,[self.selectedSubCategories objectAtIndex:i]];
    }
    NSLog(@"selected subcategories: %@", subCategoriesStr);
    NSLog(@"keywords: %@",self.keywords);
    NSLog(@"max price: %d",[self.maxPrice integerValue]);
    NSLog(@"period: %@", [ShoppingValidPeriodCell getPeriodTextWithDate:self.expireDate]);
    
    
    
}

- (void)clickSave:(id)sender
{
    [self.view endEditing:YES];
    
    if (keywordTextField != nil){        
        self.keywords = keywordTextField.text;
        NSLog(@"<save> keywords=%@", keywords);
    }
    [self displaySettings];
    
    UserShopItemService* shopService = GlobalGetUserShopItemService();
    NSString* city = [GlobalGetLocationService() getDefaultCity];    
    NSString* categoryName = nil;
    NSString* subCategoryName = nil;
    
    if (self.selectedCategory != nil)
        categoryName = self.selectedCategory;
    if (self.selectedSubCategories != nil && [self.selectedSubCategories count] > 0)
        subCategoryName = nil; // TODO    
    
    [shopService addUserShoppingItem:itemId city:city categoryName:categoryName subCategoryName:subCategoryName keywords:keywords maxPrice:maxPrice minRebate:nil];
}




@end
