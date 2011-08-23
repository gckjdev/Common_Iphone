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


@property (nonatomic, retain) NSString* selectedCategory;

@property (nonatomic, retain) NSString* selectedSubCategory;

@property (nonatomic,assign) BOOL shouldShowSubCategoryCell;

@property (nonatomic,retain) NSDictionary* subCateogriesDict;


@end

@implementation AddShoppingItemController


@synthesize categories;
@synthesize subCategories;
@synthesize shouldShowSubCategoryCell;
@synthesize itemName;
@synthesize selectedCategory;
@synthesize selectedSubCategory;
@synthesize subCateogriesDict;

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
	
	self.shouldShowSubCategoryCell = NO;
	self.selectedCategory = @"不限";
	self.selectedSubCategory = @"不限";
	
	NSArray* food = [NSArray arrayWithObjects:@"粤菜",@"川菜",@"湘菜",@"火锅",@"自助餐",@"日韩料理",@"西餐",@"不限",nil];
	NSArray* shopping = [NSArray arrayWithObjects:@"数码家电",@"母婴儿童",@"家具家居",@"眼镜",@"珠宝饰品",@"化妆品",@"食品",@"不限",nil];
	NSArray* fun = [NSArray arrayWithObjects:@"KTV",@"电影票",@"画展",@"足疗按摩",@"咖啡厅",@"酒吧",@"桌游棋牌",@"不限",nil];
	NSArray* travel = [NSArray arrayWithObjects:@"北京",@"云南",@"九寨沟",@"日本游",@"澳洲游",@"马尔代夫",@"海南",@"不限",nil];
	NSArray* hotel = [NSArray arrayWithObjects:@"经济型",@"公寓式",@"度假村",@"三星级",@"四星级",@"五星级",@"七天",@"不限",nil];
	NSArray* luckyDraw = [NSArray arrayWithObjects:@"iphone",@"ipad",@"小米手机",@"HTC",@"摩托罗拉",@"macbook",@"美女",@"不限",nil];
	NSArray* sport = [NSArray arrayWithObjects:@"健身中心",@"游泳馆",@"羽毛球馆",@"乒乓球馆",@"瑜伽",@"网球场",@"篮球场",@"不限",nil];
	
	//self.subCategories = [[NSArray alloc] initWithObjects:foods,nil];
	//[NSDictionary alloc] initWithObjects:
	self.categories = [[NSArray alloc] initWithObjects:@"美食",@"购物",@"休闲娱乐",@"旅游",@"酒店",@"抽奖",@"运动健身",nil ];
	
	self.subCateogriesDict = [[NSDictionary alloc] initWithObjectsAndKeys:food,@"美食",shopping,@"购物",
							  fun,@"休闲娱乐",travel, @"旅游",hotel, @"酒店",
							  luckyDraw, @"抽奖",sport,@"运动健身",nil];
	
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
		
		int START_TAG = 10;
		int CATEGORY_COUNT = 8;
		for (int i = 0; i < CATEGORY_COUNT; i++) {
			UIButton* button = (UIButton*)[cell viewWithTag:i+START_TAG];
			if([button.currentTitle isEqualToString:self.selectedCategory])
			{
				[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; 
			}else
			{
				[button setTitleColor:[UIColor colorWithRed:0.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal]; 

			}
				   
			[button addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
		}
    }
	
	else if (indexPath.row == 1&&self.shouldShowSubCategoryCell==YES){
		
			NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
			cell = (ShoppingCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
		    if (cell == nil) {
				cell = [ShoppingCategoryCell createCell:self];
			}
		   
			[((ShoppingCategoryCell*)cell) updateAllButtonLabelsWithArray:[self.subCateogriesDict objectForKey:self.selectedCategory ]];
		   
		
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
	if([button.currentTitle isEqualToString:@"不限"]){
		shouldShowSubCategoryCell = NO;
	}else{
		shouldShowSubCategoryCell = YES;
	}
	self.selectedCategory = button.currentTitle;
	[self.dataTableView reloadData];
}


-(IBAction) selectSubCategory:(id) sender {
	UIButton *button = (UIButton *)sender;    
    
	self.selectedSubCategory = button.currentTitle;
	[self.dataTableView reloadData];
	
}
@end
