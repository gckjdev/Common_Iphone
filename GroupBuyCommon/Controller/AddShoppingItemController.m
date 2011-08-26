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
#import "UserShopItemService.h"

#pragma mark Private
@interface AddShoppingItemController()

@property (nonatomic, retain) NSArray* categories;

@property (nonatomic, retain) NSArray* subCategories;


@property (nonatomic, retain) NSString* selectedCategory;

@property (nonatomic, retain) NSString* selectedSubCategory;

@property (nonatomic,assign) BOOL shouldShowSubCategoryCell;

@property (nonatomic,retain) NSDictionary* subCateogriesDict;

@property (nonatomic,retain) UITextField* keywordTextField;

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

@synthesize itemId;
@synthesize keywords;

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
                       FACE, LIFE, SHOPPING, 
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
    
    [itemId release];
    [keywords release];
    [keywordTextField release];
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
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
    if (indexPath.row == 0 ){
        return [ShoppingCategoryCell getCellHeight];
    }
	else if (indexPath.row == 1&&self.shouldShowSubCategoryCell==YES){
		return [ShoppingCategoryCell getCellHeight];
	}
	
    else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 2) ||
			 (self.shouldShowSubCategoryCell==NO && indexPath.row == 1)) {
		return [ShoppingKeywordCell getCellHeight];
	}  else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 3) ||
				(self.shouldShowSubCategoryCell==NO && indexPath.row == 2)) {
		return [ShoppingValidPeriodCell getCellHeight];	
	}  else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 4) ||
				(self.shouldShowSubCategoryCell==NO && indexPath.row == 3))  {
		return [SliderCell getCellHeight];
	}
	else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 5) ||
			 (self.shouldShowSubCategoryCell==NO && indexPath.row == 4))  {
		return [SliderCell getCellHeight];
	}
    else{
        return 0.0f;
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
	
	if (indexPath.row == 0){
		
		NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
		cell = (ShoppingCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingCategoryCell createCell:self];
		}
		[((ShoppingCategoryCell*)cell) addButtonsAction:@selector(selectCategory:) AndHighlightTheSelectedLabel:self.selectedCategory];
		
        [((ShoppingCategoryCell*)cell).selectCategoryLabel setTitle:@"请选择主分类" forState:UIControlStateNormal];
    }
	
	else if (indexPath.row == 1&&self.shouldShowSubCategoryCell==YES){
		
			NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
			cell = (ShoppingCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
		    if (cell == nil) {
				cell = [ShoppingCategoryCell createCell:self];
			}
		   
			[((ShoppingCategoryCell*)cell) updateAllButtonLabelsWithArray:[self.subCateogriesDict objectForKey:self.selectedCategory ]];
		   
		    [((ShoppingCategoryCell*)cell) addButtonsAction:@selector(selectSubCategory:) AndHighlightTheSelectedLabel:self.selectedSubCategory];
		
        [((ShoppingCategoryCell*)cell).selectCategoryLabel setTitle:@"请选择子分类" forState:UIControlStateNormal];
        
		}
	
    else if ((self.shouldShowSubCategoryCell==YES && indexPath.row == 2) ||
		(self.shouldShowSubCategoryCell==NO && indexPath.row == 1)) {
		NSString *CellIdentifier = [ShoppingKeywordCell getCellIdentifier];
		cell = (ShoppingKeywordCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingKeywordCell createCell:self];
            self.keywordTextField = ((ShoppingKeywordCell*)cell).keywordTextField;
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
	self.selectedCategory = button.currentTitle;
	[self.dataTableView reloadData];
}


-(IBAction) selectSubCategory:(id) sender {
	UIButton *button = (UIButton *)sender;    
    
	self.selectedSubCategory = button.currentTitle;
	[self.dataTableView reloadData];
	
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
