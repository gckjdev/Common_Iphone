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
#import "UserShopItemManager.h"
#import "TimeUtils.h"

#pragma mark Private
@interface AddShoppingItemController()

// static data
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* subCategories;
@property (nonatomic,retain) NSDictionary* subCateogriesDict;

// data


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

@synthesize shoppingListTableViewController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


#define NOT_LIMIT   @"不限"
-(void) setDefaultSettings
{
    isShowSubCategory = NO;
    self.selectedCategory = nil;
    self.selectedSubCategories = nil;
    self.maxPrice = nil;
    self.expireDate = nil;
    self.keywords = nil;
    self.itemId = nil;
    self.shouldShowSubCategoryCell = NO;
}
-(id) init{
    self = [super init];
    if (self) {
        [self setDefaultSettings];
    }
    return self;
}

-(id) initWithUserShoppingItem:(UserShoppingItem *)item{
    self = [super init];
    if (self) {
        if (item == nil) {
            [self setDefaultSettings];
        }else{
            self.selectedCategory = item.categoryName;
            self.maxPrice = item.maxPrice;
            self.expireDate = item.expireDate;
            self.keywords = item.keywords;
            self.itemId = item.itemId;
            NSArray *categoryArray = [UserShopItemManager getSubCategoryArrayWithCategoryName:item.subCategoryName];
            self.selectedSubCategories = [NSMutableArray arrayWithArray:categoryArray];
            if (self.selectedCategory != nil && [self.selectedCategory length] != 0) {
                isShowSubCategory  = YES;
            }
        }
    }
    return self;
}

- (void)updateRowIndex
{
    if (self.selectedCategory == nil || [selectedCategory isEqualToString:NOT_LIMIT]) {
        isShowSubCategory = NO;
    }else{
        isShowSubCategory = YES ;
    }
    
    if (isShowSubCategory){
        rowOfCategory = 0;
        rowOfSubCategory = 1;
        rowOfKeyword = 2;
        rowOfValidPeriod = 3;
        rowOfPrice = 4;
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
    
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [self setNavigationRightButton:@"保存" action:@selector(clickSave:)];
	
//    
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
    
    [shoppingListTableViewController release];
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
        //highlight the selected category.
        if (self.selectedCategory != nil && [self.selectedCategory length] != 0) {
            [cell highlightTheSelectedLabel:self.selectedCategory];
        }else{
            [cell highlightTheSelectedLabel:NOT_LIMIT];
        }
        
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
        
        if (self.selectedSubCategories != nil && [self.selectedSubCategories count] != 0) {
            [cell highlightTheSelectedLabels:self.selectedSubCategories];
        }else
        {
            [cell highlightTheSelectedLabel:NOT_LIMIT];
        }
        return cell;
    }	
    else if (indexPath.row == rowOfKeyword){
        
        ShoppingKeywordCell* cell = nil;

		NSString *CellIdentifier = [ShoppingKeywordCell getCellIdentifier];
		cell = (ShoppingKeywordCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingKeywordCell createCell:self];
            self.keywordTextField = cell.keywordTextField;
            [self.keywordTextField setDelegate:self];
            [cell.keywordTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [cell.keywordTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];

		}
        
        NSLog(@"set text field text to %@", self.keywords);
        cell.keywordTextField.text = self.keywords;
       
        
        return cell;

		
	}else if (indexPath.row == rowOfValidPeriod) {
        
        ShoppingValidPeriodCell* cell = nil;

		NSString *CellIdentifier = [ShoppingValidPeriodCell getCellIdentifier];
		cell = (ShoppingValidPeriodCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingValidPeriodCell createCell:self];
            self.periodSegment = cell.periodSegmented;
            self.periodButton = cell.validPeriod;
            
            [self.periodSegment addTarget:self action:@selector(segmentedDidValueChanged:) forControlEvents:UIControlEventValueChanged];
		}
        
        if (self.expireDate != nil) {
            self.periodButton.titleLabel.text = dateToString(self.expireDate);
        }else{
            self.periodButton.titleLabel.text = NOT_LIMIT;
        }
        NSInteger index = [cell segmentIndexForDate:self.expireDate];
        [self.periodSegment setSelectedSegmentIndex:index];
        
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
            [self.priceTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];

            [self.priceSegment addTarget:self action:@selector(segmentedDidValueChanged:) forControlEvents:UIControlEventValueChanged];
            
		}
        
        if (self.maxPrice == nil || [self.maxPrice intValue] < 0) {
            self.priceTextField.text = NOT_LIMIT;
            [self.priceSegment setSelected:PRICE_UNLIMIT_INDEX];
        }else
        {
            [self.priceSegment setSelectedSegmentIndex:[cell segmentIndexForPrice:self.maxPrice]];
            self.priceTextField.text = [self.maxPrice stringValue];
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

- (void)updateKeyword
{
    self.keywords = keywordTextField.text;
    NSLog(@"update keywords to %@", self.keywords);
}

- (void)updatePrice
{
    NSString *text = priceTextField.text;
    
    if (text == nil || [text length] == 0) {
        self.maxPrice = nil;
        [self.priceSegment setSelectedSegmentIndex:PRICE_UNLIMIT_INDEX];
    }
    else if ([text isEqualToString:NOT_LIMIT]){
        self.maxPrice = nil;
    }
    else {
        self.maxPrice = [NSNumber numberWithInteger:[priceTextField.text integerValue]];        
    }    
}

- (void)textFieldChange:(id)sender {

    NSLog(@"textFieldChange");
    if (keywordTextField == sender){
        [self updateKeyword];
    }
    else if (priceTextField == sender) {
    }    
}

- (void) textFieldDidBeginEditing:(id)sender{
        
    // set correct keyboard type for text field
    NSIndexPath* indexPath = nil;
    if (keywordTextField == sender){
        indexPath = [NSIndexPath indexPathForRow:rowOfKeyword inSection:0];    
        self.currentKeyboardType = keywordTextField.keyboardType;
        
        self.keywordTextField.text = keywords;
    }
    else if (priceTextField == sender) {
        indexPath = [NSIndexPath indexPathForRow:rowOfPrice inSection:0];   
        [self.priceSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        self.currentKeyboardType = priceTextField.keyboardType;
        
        if (self.maxPrice == nil || [self.maxPrice intValue] < 0)
            self.priceTextField.text = @"";
        else
            self.priceTextField.text = [self.maxPrice description];
    }
    
    // adjust table view frame to make text field visable
    CGRect frame = self.dataTableView.frame;
    frame.size.height = 480 - kKeyboadHeight - kNavigationBarHeight - kStatusBarHeight;
    self.dataTableView.frame = frame;
    [self.dataTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
//    NSLog(@"keyword text field text = %@, keywords = %@", self.keywordTextField.text, self.keywords);

}

- (void)textFieldDidEndEditing:(id)sender
{
//    NSLog(@"keyword text field text = %@, keywords = %@", self.keywordTextField.text, self.keywords);

    if (self.priceTextField == sender) {

        NSString *text = priceTextField.text;        
        if (text == nil || [text length] == 0) {
            priceTextField.text = NOT_LIMIT;
            [self.priceSegment setSelectedSegmentIndex:PRICE_UNLIMIT_INDEX];
        }
        
        [self updatePrice];
        
    }    
    else if (self.keywordTextField == sender) {

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)segmentedDidValueChanged:(id)sender
{
    
    if (sender == self.priceSegment) {
        NSInteger index = self.priceSegment.selectedSegmentIndex;
        
        if (index == UISegmentedControlNoSegment) {
            return;
        }
        
        NSString *value = [self.priceSegment titleForSegmentAtIndex:index];
        
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
        self.expireDate = date;
        
    }
    //[self.view endEditing:YES];
    
    [self updateRowIndex];
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
        self.selectedSubCategories = nil;
    }
    
	if([button.currentTitle isEqualToString:NOT_LIMIT]){
		shouldShowSubCategoryCell = NO;
        self.selectedCategory = nil;
        self.selectedSubCategories = nil;
	}else{
		self.shouldShowSubCategoryCell = YES;
        self.selectedCategory = button.currentTitle;
	}
    NSLog(@"<selectCategory> category=%@", button.currentTitle);
    [self updateRowIndex];
}



-(IBAction) selectSubCategory:(id) sender {    

	UIButton *button = (UIButton *)sender;        
    NSString *category = button.currentTitle;
    if ([category isEqualToString:NOT_LIMIT]) {
        self.selectedSubCategories = nil;
    }
    else{
        
        if (self.selectedSubCategories == nil) {
            self.selectedSubCategories = [[NSMutableArray alloc] initWithObjects:NOT_LIMIT, nil];
        }
        
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

- (void)clickSave:(id)sender
{
    [self.view endEditing:YES];
    
    if (keywordTextField != nil){        
        self.keywords = keywordTextField.text;
    }
    
    
    UserShopItemService* shopService = GlobalGetUserShopItemService();
    NSString* city = [GlobalGetLocationService() getDefaultCity];    
    NSString* categoryName = nil;
    
    if (self.selectedCategory != nil)
        categoryName = self.selectedCategory;
    if (itemId == nil) {
        [shopService addUserShoppingItem:city categoryName:categoryName subCategories:selectedSubCategories keywords:self.keywords maxPrice:maxPrice expireDate:expireDate rebate:nil viewController:self];
    }else{
        [shopService updateUserShoppingItem:itemId city:city categoryName:categoryName subCategories:self.selectedSubCategories keywords:self.keywords maxPrice:self.maxPrice expireDate:self.expireDate rebate:nil viewController:self];
    }
        
    
//    if (self.selectedSubCategories != nil && [self.selectedSubCategories count] > 0)
//    {
//        subCategoryName = [UserShopItemManager getSubCategoryNameWithArray:self.selectedSubCategories];
//    }
//
//    
//    
//    [shopService addUserShoppingItem:itemId city:city categoryName:categoryName subCategoryName:subCategoryName keywords:keywords maxPrice:maxPrice expireDate:expireDate];
//    
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
