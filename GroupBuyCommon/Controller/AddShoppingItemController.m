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

#pragma mark Private
@interface AddShoppingItemController()

// static data
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* subCategories;
@property (nonatomic,retain) NSDictionary* subCateogriesDict;

// data
@property (nonatomic, retain) NSString* selectedCategory;
@property (nonatomic, retain) NSString* selectedSubCategory;

// UI elements
@property (nonatomic,assign) BOOL shouldShowSubCategoryCell;
@property (nonatomic,retain) UITextField* keywordTextField;
@property (nonatomic,retain) UITextField* priceTextField;
@property (nonatomic,retain) UISegmentedControl* priceSegment;



@end

@implementation AddShoppingItemController


@synthesize categories;
@synthesize subCategories;
@synthesize shouldShowSubCategoryCell;
@synthesize itemName;
@synthesize selectedCategory;
@synthesize selectedSubCategory;
@synthesize subCateogriesDict;
@synthesize keywordTextField;
@synthesize priceSegment;
@synthesize priceTextField;


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

#define LIFE        @"生活服务"
#define TRAVEL      @"旅游"
#define SHOPPING    @"购物"
#define FUN         @"休闲娱乐"
#define HOTEL       @"酒店"
#define FOOD        @"美食"
#define SPORTS      @"运动健身"
#define FACE        @"丽人"
#define BUY2        @"服装鞋袜"

#define NOT_LIMIT   @"不限"

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
        rowOfRebate = -1;       // not used
        rowNumber = 5;
    }
    else{
        rowOfCategory = 0;
        rowOfSubCategory = -1;  // don't show
        rowOfKeyword = 1;
        rowOfValidPeriod = 2;
        rowOfPrice = 3;
        rowOfRebate = -1;       // not used
        rowNumber = 4;
    }
    
    [dataTableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationRightButton:@"保存" action:@selector(clickSave:)];
	
	self.shouldShowSubCategoryCell = NO;
	self.selectedCategory = NOT_LIMIT;
	self.selectedSubCategory = NOT_LIMIT;	    
    
	NSArray* food = [NSArray arrayWithObjects:
                     NOT_LIMIT,
                     @"粤菜", @"川菜", @"东北菜",
                     @"湘菜", @"寿司", @"韩国料理",
                     @"火锅", @"西餐", @"自助餐", nil];
    
	NSArray* shopping = [NSArray arrayWithObjects:
                         NOT_LIMIT,
                         @"鞋子",@"衣服",@"食品",
                         @"化妆品",@"酒",@"茶",
                         @"相机",@"家电",@"电脑",
                         nil];
    
	NSArray* fun = [NSArray arrayWithObjects:
                    NOT_LIMIT,
                    @"KTV",@"电影票",@"游戏币",
                    @"咖啡厅",@"酒吧",@"桌游",
                    @"棋牌", @"足疗按摩", @"桑拿水疗",
                    nil];
    
	NSArray* travel = [NSArray arrayWithObjects:
                       NOT_LIMIT,
                       @"北京游",@"云南游",@"九寨沟",
                       @"海南游",@"香港游",@"欧洲游",
                       @"日本游",@"澳大利亚",@"马尔代夫",
                       nil];
    
	NSArray* hotel = [NSArray arrayWithObjects:
                      NOT_LIMIT,
                      @"经济型",@"公寓",@"度假村",
                      @"三星级",@"四星级",@"五星级",
                      @"七天",nil];
    
	NSArray* luckyDraw = [NSArray arrayWithObjects:
                          NOT_LIMIT,
                          @"iPhone",@"iPad",@"小米手机",
                          @"HTC",@"摩托罗拉",@"MacBook",
                          @"美女",
                          nil];
    
	NSArray* sport = [NSArray arrayWithObjects:
                      NOT_LIMIT,
                      @"健身",@"游泳",@"瑜伽",
                      @"羽毛球",@"乒乓球",@"网球",
                      @"桌球",@"保龄球", @"篮球",
                      nil];
	
	NSArray* life = [NSArray arrayWithObjects:
                      NOT_LIMIT,
                      @"美发", @"照片冲印", @"洗车",
                      @"摄影写真", @"儿童写真", @"口腔护理",
                      @"体检", @"培训", @"报刊杂志",
                      nil];
    
    NSArray* face = [NSArray arrayWithObjects:
                     NOT_LIMIT,
                     @"化妆品", @"美发", @"美容SPA", 
                     @"瘦身纤体", @"美甲", @"艺术写真",
                     @"瑜伽", @"舞蹈",
                     nil];
    
    NSArray* buy2 = [NSArray arrayWithObjects:
                     NOT_LIMIT,
                     @"T恤", @"衬衫", @"裤子",
                     @"内裤", @"文胸", @"裙子", 
                     @"连衣裙", @"鞋", @"袜子", 
                     nil];
    
	//self.subCategories = [[NSArray alloc] initWithObjects:foods,nil];
	//[NSDictionary alloc] initWithObjects:
	self.categories = [[NSArray alloc] initWithObjects:
                       NOT_LIMIT,
                       FOOD, BUY2, FUN,
                       TRAVEL, HOTEL, SPORTS,
                       FACE, SHOPPING, LIFE,
                       nil ];
	
	self.subCateogriesDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              food, FOOD,
                              shopping, SHOPPING,
							  fun, FUN,
                              travel, TRAVEL,
                              hotel, HOTEL,
                              sport, SPORTS,
                              life, LIFE,
                              face, FACE,
                              buy2, BUY2,                              
                              nil];

    dataTableView.contentSize = CGSizeMake(320, 2000);
    
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
    
    
	[categories release];
	[subCategories release];
	[itemName release];
	[selectedCategory release];
	[selectedSubCategory release];
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
		   
        NSArray* subCategory = [self.subCateogriesDict objectForKey:self.selectedCategory];
        [cell updateAllButtonLabelsWithArray:subCategory];		   
        [cell highlightTheSelectedLabel:self.selectedSubCategory];		        

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
    dataTableView.frame = self.view.bounds;
}

- (void) textFieldDidBeginEditing:(id)sender{
    
    NSIndexPath* indexPath = nil;
    if (keywordTextField == sender){
        indexPath = [NSIndexPath indexPathForRow:rowOfKeyword inSection:0];    
    }
    if (priceTextField == sender) {
        indexPath = [NSIndexPath indexPathForRow:rowOfPrice inSection:0];   
    }
    
    CGRect frame = dataTableView.frame;
    frame.size.height = 480 - kKeyboadHeight - kNavigationBarHeight - kStatusBarHeight;
    dataTableView.frame = frame;
    [dataTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (void)segmentedDidValueChanged:(id)sender
{
    if (sender == self.priceSegment) {
        NSInteger index = self.priceSegment.selectedSegmentIndex;
        NSString *value = [self.priceSegment titleForSegmentAtIndex:index];
        priceTextField.text = value;
        
        NSInteger price = -1;
        if ([value compare:NOT_LIMIT] != 0) {
            price = [value integerValue];
        }
        maxPrice = [NSNumber numberWithInt:price];
    }
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
	if([button.currentTitle isEqualToString:NOT_LIMIT]){
		shouldShowSubCategoryCell = NO;
	}else{
		shouldShowSubCategoryCell = YES;
		self.selectedSubCategory = NOT_LIMIT;
	}
    NSLog(@"<selectCategory> category=%@", button.currentTitle);
	self.selectedCategory = button.currentTitle;
    [self updateRowIndex];
}


-(IBAction) selectSubCategory:(id) sender {    

	UIButton *button = (UIButton *)sender;        
    NSLog(@"<selectSubCategory> sub category=%@", button.currentTitle);
	self.selectedSubCategory = button.currentTitle;
    [self updateRowIndex];
}

- (void)clickSave:(id)sender
{
    if (keywordTextField != nil){
        if ([keywordTextField isFirstResponder])
            [keywordTextField resignFirstResponder];
        
        self.keywords = keywordTextField.text;
        NSLog(@"<save> keywords=%@", keywords);
    }
    
    UserShopItemService* shopService = GlobalGetUserShopItemService();
    [shopService addUserShoppingItem:itemId city:nil categoryName:nil subCategoryName:nil keywords:keywords maxPrice:nil minRebate:nil];
}




@end
