//
//  SearchProductController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GuideController.h"
#import "SearchHistoryManager.h"
#import "SearchHistory.h"
#import "CommonProductListController.h"
#import "ProductPriceDataLoader.h"
#import "HotKeyword.h"
#import "HotKeywordManager.h"
#import "ProductManager.h"
#import "UIImageUtil.h"
#import "UIButtonExt.h"
#import "UserShopItemService.h"
#import "LocationService.h"
#import "GroupBuyNetworkConstants.h"
#import "CategoryTopScoreController.h"

//private methods
@interface GuideController()

-(void) refreshLatestSearchHistory;
-(void) addCategoryButton;

@end

@implementation GuideController


@synthesize searchTextFieldBackgroundView;
@synthesize searchButton;
@synthesize searchTextField;
@synthesize searchBackgroundView;
@synthesize scrollView;
@synthesize categoryArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//    [asrEngine release];
    [searchBackgroundView release];

    [keywordSearchBar release];
    [searchTextField release];
    [searchButton release];
    [searchBackgroundView release];
    [searchTextFieldBackgroundView release];
    [scrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadCategory
{
    [self showActivityWithText:@"加载数据中..."];
    CategoryService *service = GlobalGetCategoryService();
    [service getAllCategory:self];    
}

- (void)getAllCategoryFinish:(int)result jsonArray:(NSArray *)jsonArray
{
    [self hideActivity];
    
    self.categoryArray = jsonArray;
    
    
    if (self.categoryArray == nil || [self.categoryArray count] == 0){
        NSLog(@"<warning> no category data, result = %d", result);
        //        self.dataList = [CategoryManager getAllGroupBuyCategories];
    }
    else
    {
        [self addCategoryButton];
    }
}

- (void)viewDidLoad
{
    keywordSearchBar.hidden = YES;    
    
    [self setBackgroundImageName:@"background.png"];
    [self setGroupBuyNavigationTitle:self.tabBarItem.title];

    [super viewDidLoad];
    
    UIImage* searchTextFieldImage = [UIImage strectchableImageName:@"tu_46-18.png"];
    [self.searchTextFieldBackgroundView setImage:searchTextFieldImage];
    
    // set search button background
    UIImage* buttonBgImage = [UIImage strectchableImageName:@"tu_48.png"];
    [searchButton setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
    
    [self loadCategory];
        
    if (bannerView_ == nil){
        bannerView_ = [AdViewUtils allocAdMobView:self];  
    }
}


#define TITLE_HEIGHT 20    //分组名的高度
#define BUTTON_ROW  3      //列数
#define BUTTON_WIDTH  90   //每个按钮的宽度
#define BUTTON_HEIGHT  32  //每个按钮的高度
#define UNSELECTED_COLOR [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0]
#define SELECTED_COLOR [UIColor colorWithRed:164/255.0 green:174/255.0 blue:67/255.0 alpha:1.0]

-(void) addCategoryButton
{
    
    CGFloat space = (scrollView.frame.size.width - BUTTON_ROW * BUTTON_WIDTH) / (BUTTON_ROW + 1); //按钮之间的空隙
    
    //set title
    UILabel *categoryTitleLabel = [[UILabel alloc] init];
    categoryTitleLabel.text = @"分类导航";
    categoryTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    categoryTitleLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    categoryTitleLabel.frame = CGRectMake(10, space, 90, TITLE_HEIGHT);
    [scrollView addSubview:categoryTitleLabel];
    [categoryTitleLabel release];
    
    
    //set button
    UIImage* buttonBgImage = [UIImage strectchableImageName:@"tu_60.png"];
    CGFloat x,  y,row;
    int count = 0;  
    for (NSDictionary *category in categoryArray) {
        NSString *name = [category objectForKey:PARA_CATEGORY_NAME];
        NSNumber *n = [category objectForKey:PARA_CATEGORY_PRODUCTS_NUM];
        NSString *number = [NSString stringWithFormat:@"(%@)", n];
        
        //UIButton *button = [[UIButton alloc] init];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTag:count];
        [button addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        row = count % BUTTON_ROW;  //第几列
        x = row * (space + BUTTON_WIDTH) + space;
        y = space +  TITLE_HEIGHT + count/BUTTON_ROW * (space+BUTTON_HEIGHT) +space;
        button.frame = CGRectMake(x, y, BUTTON_WIDTH, BUTTON_HEIGHT); 
                
        //set name
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        CGSize size = [name sizeWithFont:nameLabel.font];
        x = 5;
        y = (BUTTON_HEIGHT - size.height) / 2;
        nameLabel.frame = CGRectMake(x, y, size.width, size.height);
        nameLabel.text = name;
        nameLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
        [button addSubview:nameLabel];
        [nameLabel release];
        
        //set number
        x = x + size.width + 2;
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.font = [UIFont systemFontOfSize:11];
        numberLabel.textColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0];
        size = [number sizeWithFont:numberLabel.font];
        y = (BUTTON_HEIGHT - size.height) / 2;
        numberLabel.frame = CGRectMake(x, y, size.width, size.height);
        numberLabel.text = number;
        [button addSubview:numberLabel];
        [numberLabel release];
        
        
        [scrollView addSubview:button];
        count++;
    
    }
    
    //set website title
    UILabel *websiteTitleLabel = [[UILabel alloc] init];
    websiteTitleLabel.text = @"团购网站";
    websiteTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    websiteTitleLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    websiteTitleLabel.frame = CGRectMake(10, space + TITLE_HEIGHT + (count/3+1) *(space + BUTTON_HEIGHT) + space, 90, TITLE_HEIGHT);
    [scrollView addSubview:websiteTitleLabel];
    [websiteTitleLabel release];
    
}

- (void)clickCategoryButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSDictionary *category = [categoryArray objectAtIndex:button.tag];
    NSString *categoryName = [category objectForKey:PARA_CATEGORY_NAME];
    NSString *categoryId = [category objectForKey:PARA_CATEGORY_ID];
    
    CategoryTopScoreController *controller = [[[CategoryTopScoreController alloc] init] autorelease];
    
    controller.categoryId = categoryId;
    controller.categoryName = categoryName;
    
    [controller setGroupBuyNavigationBackButton];    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidUnload
{        
    [self setSearchTextField:nil];
    [self setSearchButton:nil];
    [self setSearchBackgroundView:nil];
    [self setSearchTextFieldBackgroundView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
	[self refreshLatestSearchHistory];
    
    int top = searchBackgroundView.frame.size.height + searchBackgroundView.frame.origin.y;
    [self addBlankView:top currentResponder:searchTextField];
	
    [super viewDidAppear:animated];
}

-(void) refreshLatestSearchHistory
{
    
	
	NSArray* hotKeyWords = [HotKeywordManager getAllHotKeywords];
	 
    int START_TAG = 10;
    int BUTTON_COUNT = 9;
	for (int i = 0; i < [hotKeyWords count]; i++) {
		[(UIButton*)[self.view viewWithTag:i+START_TAG] setTitle:((HotKeyword *)[hotKeyWords objectAtIndex:i]).keyword forState:UIControlStateNormal];
	}
	for (int j=[hotKeyWords count]; j<BUTTON_COUNT; j++){
        ((UIButton*)[self.view viewWithTag:j+START_TAG]).hidden = YES;
    }
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -  
#pragma mark UISearchBarDelegate Methods  

- (void)search:(NSString*)keyword
{
    [ProductManager deleteProductsByUseFor:USE_FOR_KEYWORD];
	
	CommonProductListController *searchResultController = [[CommonProductListController alloc] init];
	searchResultController.superController = self;
	searchResultController.dataLoader = [[ProductKeywordDataLoader alloc] initWithKeyword:keyword];
    
	searchResultController.navigationItem.title = [NSString stringWithFormat:@"团购列表 － %@", keyword]; 
    [searchResultController setGroupBuyNavigationBackButton];
    [searchResultController setGroupBuyNavigationTitle:searchResultController.navigationItem.title];
    [searchResultController setBackgroundImageName:@"background.png"];
	[self.navigationController pushViewController:searchResultController animated:NO];
	[searchResultController release];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {  
    	
    if ([searchBar.text length] == 0){
        [UIUtils alert:@"搜索关键字不能为空"];
        return;
    }
    
	[searchBar resignFirstResponder];

	[SearchHistoryManager createSearchHistory:searchBar.text];	
	[self refreshLatestSearchHistory];
    
	[self search:searchBar.text];
}  

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

#pragma mark -  
#pragma mark alertView delegate Methods  
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //yes
        UserShopItemService* shopService = GlobalGetUserShopItemService();
        NSString* city = [GlobalGetLocationService() getDefaultCity];    
        NSString* categoryName = nil;
        NSArray* selectedSubCategories = nil;
        NSString *keywords = searchTextField.text;
        NSDate *expireDate = nil;
        NSNumber *price = nil;
        NSNumber *latitude = nil;
        NSNumber *longitude = nil;
        NSNumber *radius = nil;
        [shopService addUserShoppingItem:city categoryName:categoryName subCategories:selectedSubCategories keywords:keywords maxPrice:price expireDate:expireDate latitude:latitude longitude:longitude radius:radius rebate:nil];
    }
    if (buttonIndex == 0) {
        //no
    }
}

#pragma mark -
#pragma mark do Search

- (IBAction)clickSearchButton:(id)sender
{
    if ([searchTextField.text length] == 0){
        [UIUtils alert:@"搜索关键字不能为空"];
        return;
    }
    
	[searchTextField resignFirstResponder];
    
	[SearchHistoryManager createSearchHistory:searchTextField.text];	
	[self refreshLatestSearchHistory];
    
	[self search:searchTextField.text];    
}




@end
