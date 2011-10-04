//
//  AddShoppingItemController.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//


#import "AddShoppingItemController.h"
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

// UI elements
//@property (nonatomic,assign) BOOL shouldShowSubCategoryCell;


@end

@implementation AddShoppingItemController


@synthesize categories;
@synthesize subCategories;
//@synthesize shouldShowSubCategoryCell;
@synthesize itemName;

@synthesize itemId;

@synthesize shoppingListTableViewController;

//cell
@synthesize categoryCell;
@synthesize subCategoryCell;
@synthesize validPeriodCell;
@synthesize keywordCell;
@synthesize priceCell;
@synthesize locationCell;


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

- (void)setCells
{
    
    //get category cell;
    NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
    self.categoryCell = (ShoppingCategoryCell*)[self.dataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.categoryCell == nil) {
        self.categoryCell = [ShoppingCategoryCell createCell:self];
        [self.categoryCell addButtonsAction:@selector(selectCategory:)];
    }
    
    //get subcategory cell;
    CellIdentifier = [ShoppingSubCategoryCell getCellIdentifier];
    self.subCategoryCell = (ShoppingSubCategoryCell*)[self.dataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.subCategoryCell == nil) {
        self.subCategoryCell = [ShoppingSubCategoryCell createCell:self];
        [self.subCategoryCell addButtonsAction:@selector(selectSubCategory:)];
    }
    
    //get keyword cell;
    CellIdentifier = [ShoppingKeywordCell getCellIdentifier];
    self.keywordCell = (ShoppingKeywordCell*)[self.dataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.keywordCell == nil) {
        self.keywordCell = [ShoppingKeywordCell createCell:self];
        [self.keywordCell.keywordTextField setDelegate:self];
        [self.keywordCell setKeywordCellDelegate:self];
        
    }
    
    //get valid period cell;
    CellIdentifier = [ShoppingValidPeriodCell getCellIdentifier];
    self.validPeriodCell = (ShoppingValidPeriodCell*)[self.dataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.validPeriodCell == nil) {
        self.validPeriodCell = [ShoppingValidPeriodCell createCell:self];
    }
    
    //get price cell;
    CellIdentifier = [SliderCell getCellIdentifier];
    self.priceCell = (SliderCell*)[self.dataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.priceCell == nil) {
        self.priceCell = [SliderCell createCell:self];
        self.priceCell.priceCellDelegate = self;
    }
    
    //get location cell;
    CellIdentifier = [LocationCell getCellIdentifier];
    self.locationCell = (LocationCell*)[self.dataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.locationCell == nil) {
        self.locationCell = [LocationCell createCell:self];
        self.locationCell.locationCellDelegate = self;
    }
}

-(void) updateCellWithItem:(UserShoppingItem *)item
{
    if (item) {
        self.itemId = item.itemId;
        //category
        [self.categoryCell setAndHighlightSelectedCategory:item.categoryName];
        
        [self.subCategoryCell updateAllButtonLabelsWithArray:[CategoryManager getSubCategoriesByCategory:item.categoryName]];
        
        //category array
        NSArray *categoryArray = [UserShopItemManager getSubCategoryArrayWithCategoryName:item.subCategoryName];
        
        [self.subCategoryCell setAndHighlightSelectedSubCategories:categoryArray];
        if (self.categoryCell.selectedCategory != nil && [self.categoryCell.selectedCategory length] != 0) {
            isShowSubCategory  = YES;
        }
        
        //keywords
        [self.keywordCell setkeyword:item.keywords];
        
        //expireDate
        [self.validPeriodCell setAndCalculateExpireDate:item.expireDate];
        
        //price
        [self.priceCell setPrice:item.maxPrice];
        
        [self.locationCell setLatitude:item.latitude longitude:item.longitude radius:item.radius];
    }else{
        self.itemId = nil;
        isShowSubCategory = NO;
        [self.categoryCell setAndHighlightSelectedCategory:nil];
        [self.subCategoryCell setAndHighlightSelectedSubCategories:nil];
        [self.keywordCell setkeyword:nil];
        [self.validPeriodCell setAndCalculateExpireDate:nil];
        [self.priceCell setPrice:nil];
        [self.locationCell setLatitude:nil longitude:nil radius:nil];
    }

}

-(id) init{
    self = [super init];
    if (self) {
        //[self setDefaultSettings];
        [self setCells];
        [self updateCellWithItem:nil];
    }
    return self;
}

-(id) initWithUserShoppingItem:(UserShoppingItem *)item{
    self = [super init];
    if (self) {
        [self setCells];
        [self updateCellWithItem:item];
    }
    return self;
}

- (void)updateRowIndex
{
    if (self.categoryCell.selectedCategory == nil || [self.categoryCell.selectedCategory isEqualToString:NOT_LIMIT]) {
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
        rowOfLocation = -1;
        rowOfRebate = -1;       // not used
        rowOfCity = -1;         // not used
        rowNumber = 5;          // hide location
    }
    else{
        rowOfCategory = 0;
        rowOfSubCategory = -1;  // don't show
        rowOfKeyword = 1;
        rowOfValidPeriod = 2;
        rowOfPrice = 3;
        rowOfLocation = -1;
        rowOfCity = -1;         // not used 
        rowOfRebate = -1;       // not used
        rowNumber = 4;          // hide location
    }
    
    [self.dataTableView reloadData];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [self setNavigationRightButton:@"保存" action:@selector(clickSave:)];
    
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
    
    locationCell = nil;
    keywordCell = nil;
    categoryCell = nil;
    subCategoryCell = nil;
    validPeriodCell = nil;
    priceCell = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [itemId release];

	[categories release];
	[subCategories release];
	[itemName release];
    
    [shoppingListTableViewController release];
    
    //cell
    [locationCell release];
    [keywordCell release];
    [categoryCell release];
    [subCategoryCell release];
    [validPeriodCell release];
    [priceCell release];
    
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
    else if (indexPath.row == rowOfLocation){
        return [LocationCell getCellHeight];
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
        return self.categoryCell;
    }	
	else if (indexPath.row == rowOfSubCategory){		

        return self.subCategoryCell;
    }	
    else if (indexPath.row == rowOfKeyword){
        return self.keywordCell;

	}else if (indexPath.row == rowOfValidPeriod) {
        
        return self.validPeriodCell;
		
	}else if (indexPath.row == rowOfPrice)  {
        
        return self.priceCell;
		
	}else if(indexPath.row == rowOfLocation){
        
        return self.locationCell;
        
    }else{
        NSLog(@"ERROR: <cellForRowAtIndexPath> cannot found cell for row at %d", indexPath.row);
        return nil;
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    self.dataTableView.frame = self.view.bounds;
}


- (void) textFieldDidBeginEditing:(id)sender{
        
    // set correct keyboard type for text field
    NSIndexPath* indexPath = nil;
    if (self.keywordCell.keywordTextField == sender){
        indexPath = [NSIndexPath indexPathForRow:rowOfKeyword inSection:0];    
        self.currentKeyboardType = self.keywordCell.keywordTextField.keyboardType;

    }
    else if (self.priceCell.priceTextField == sender) {
        indexPath = [NSIndexPath indexPathForRow:rowOfPrice inSection:0];
        self.currentKeyboardType = self.priceCell.priceTextField.keyboardType;
    }
    
    // adjust table view frame to make text field visable
    CGRect frame = self.dataTableView.frame;
    frame.size.height = 480 - kKeyboadHeight - kNavigationBarHeight - kStatusBarHeight;
    self.dataTableView.frame = frame;
    [self.dataTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidEndEditing:(id)sender
{
//    NSLog(@"keyword text field text = %@, keywords = %@", self.keywordTextField.text, self.keywords);

    if (self.keywordCell.keywordTextField == sender) {
        
    }    
    else if (self.priceCell.priceTextField == sender) {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == rowOfLocation) {
            [self.navigationController pushViewController:self.locationCell.mapViewController animated:YES];
        }
    }
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
    NSString *title = button.currentTitle;
    
	if([title isEqualToString:NOT_LIMIT]){
        [self.categoryCell setAndHighlightSelectedCategory:nil];
        self.subCategoryCell.selectedSubCategories = nil;
	}else{
        [self.categoryCell setAndHighlightSelectedCategory:title];
        [self.subCategoryCell updateAllButtonLabelsWithArray:[CategoryManager getSubCategoriesByCategory:title]];
        [self.subCategoryCell setAndHighlightSelectedSubCategories:nil];
	}
    
    NSLog(@"<selectCategory> category=%@", button.currentTitle);
    
    [self updateRowIndex];
}



-(IBAction) selectSubCategory:(id) sender {    

	UIButton *button = (UIButton *)sender;        
    NSString *category = button.currentTitle;
    
    if ([category isEqualToString:NOT_LIMIT]) {
        //self.subCategoryCell.selectedSubCategories = nil;
        [self.subCategoryCell setAndHighlightSelectedSubCategories:nil];
    }
    else{
        [self.subCategoryCell addAndHighlightSelectedSubCategory:category];
    }
    [self updateRowIndex];
}

- (void)clickSave:(id)sender
{
    [self.view endEditing:YES];
    
    UserShopItemService* shopService = GlobalGetUserShopItemService();
    NSString* city = [GlobalGetLocationService() getDefaultCity];    
    NSString* categoryName = [self.categoryCell selectedCategory];
    NSArray* selectedSubCategories = [self.subCategoryCell getSelectedSubCategories];
    NSString *keywords = [self.keywordCell getKeywords];
    NSDate *expireDate = [self.validPeriodCell getExpireDate];
    NSNumber *price = [self.priceCell getPrice];
    NSNumber *latitude = [self.locationCell getLatitude];
    NSNumber *longitude = [self.locationCell getLongtitude];
    NSNumber *radius = [self.locationCell getRadius];
    
    if (itemId == nil) {
        [shopService addUserShoppingItem:city categoryName:categoryName subCategories:selectedSubCategories keywords:keywords maxPrice:price expireDate:expireDate latitude:latitude longitude:longitude radius:radius rebate:nil];
    }else{
        [shopService updateUserShoppingItem:itemId city:city categoryName:categoryName subCategories:selectedSubCategories keywords:keywords maxPrice:price expireDate:expireDate latitude:latitude longitude:longitude radius:radius rebate:nil];
    }
//    if (self.categoryCell.selectedCategory != nil)
//        categoryName = self.categoryCell.selectedCategory;
    
//    if (itemId == nil) {
//        [shopService addUserShoppingItem:city categoryName:categoryName subCategories:selectedSubCategories keywords:self.keywords maxPrice:maxPrice expireDate:expireDate rebate:nil viewController:self];
//    }else{
//        [shopService updateUserShoppingItem:itemId city:city categoryName:categoryName subCategories:self.selectedSubCategories keywords:self.keywords maxPrice:self.maxPrice expireDate:self.expireDate rebate:nil viewController:self];
//    }
        
}


#pragma cell delegete

-(void) didSwitchOn
{
    [self.navigationController pushViewController:self.locationCell.mapViewController animated:YES];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    NSLog(@"level two");
    NSString* str = [NSString stringWithString:@""];
	if (placemark == nil){
		return;
	}
	
	if (placemark.locality){
		str = [str stringByAppendingFormat:@"%@", placemark.locality];
	}
	
	if (placemark.subLocality){
		str = [str stringByAppendingFormat:@" %@", placemark.subLocality];
	}
    
    self.locationCell.locationLabel.text = str;
    NSLog(@"done: %@",self.locationCell.locationLabel.text);
    
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    self.locationCell.locationLabel.text = @"地址解析错误。";
    
}

@end
