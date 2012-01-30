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

-(void) addCategoryButton;

@end

@implementation GuideController


@synthesize searchTextFieldBackgroundView;
@synthesize searchButton;
@synthesize searchTextField;
@synthesize searchBackgroundView;
@synthesize scrollView;
@synthesize categoryArray;
@synthesize siteNameArray;
@synthesize siteIdArray;

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
    [searchBackgroundView release];
    [keywordSearchBar release];
    [searchTextField release];
    [searchButton release];
    [searchBackgroundView release];
    [searchTextFieldBackgroundView release];
    [scrollView release];
    [categoryArray release];
    [siteNameArray release];
    [siteIdArray release];
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
    
    //@"开心"-@"kaixin"
    //@"饭统"-@"fantong"
    //@"聚齐"-@"juqi"
    //@"团宝"-@"tuanbao"
    //@"QQ团"-@"qq"
    //@"乐淘"-@"letao"
    //@"Z团"-@"ztuan",
    //@"粉团"-@"fentuan"
    //@"库巴"-@"coo8"
    //@"36团"-@"36tuan"
    //@"搜狐爱家"-@"sohu"
    
    self.siteNameArray = [NSArray arrayWithObjects:
                          @"美团",   @"大众点评",  @"拉手",   @"去哪儿",    @"京东团",
                          @"糯米",   @"满座",     @"高朋",   @"嘀嗒",     @"窝窝团",
                          @"赶集团", @"爽团",     @"58团",    @"好划算",   @"聚美优品",
                          @"团好",   @"好特会",   @"星800",  @"爱帮团",   @"新浪团", 
                          @"24券",   @"最淘",     @"天机88", @"钱库",     @"秀团",   
                          @"5151团", @"5151泡泡", @"米奇",   @"好易订",   @"F团",
                          nil];
    
    self.siteIdArray = [NSArray arrayWithObjects:  
                        @"meituan",  @"dianping",   @"lashou",   @"qunaer",     @"jingdong",
                        @"nuomi",    @"manzuo",     @"gaopeng",  @"dida",       @"wowo",
                        @"ganji",    @"shuangtuan", @"58",       @"haohuasuan", @"jumeiyoupin",
                        @"tuanhao",  @"haotehui",   @"xing800",  @"aibang",     @"sina",
                        @"24quan",   @"zuitao",     @"tianji88", @"qianku",     @"xiutuan",
                        @"5151tuan", @"5151paopao", @"miqi",     @"haoyiding",  @"ftuan",
                        nil];
    
    [self loadCategory];
        
    if (bannerView_ == nil){
        bannerView_ = [AdViewUtils allocAdMobView:self];  
    }
}


#define TITLE_HEIGHT 21    //分组名的高度
#define BUTTON_ROW  3      //列数
#define BUTTON_WIDTH  90   //每个按钮的宽度
#define BUTTON_HEIGHT  34  //每个按钮的高度

-(void) addCategoryButton
{
    CGFloat newX = 0;  //x坐标
    CGFloat newY = 0;  //y坐标
    
    CGFloat space = (scrollView.frame.size.width - BUTTON_ROW * BUTTON_WIDTH) / (BUTTON_ROW + 1); //按钮之间的空隙
    
    //set title
    UILabel *categoryTitleLabel = [[UILabel alloc] init];
    categoryTitleLabel.text = @"分类导航";
    categoryTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    categoryTitleLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    newY = space;
    categoryTitleLabel.frame = CGRectMake(10, newY, 90, TITLE_HEIGHT);
    [scrollView addSubview:categoryTitleLabel];
    [categoryTitleLabel release];
    
    newY = newY + TITLE_HEIGHT + space;
    
    //add category button
    UIImage* buttonBgImage = [UIImage strectchableImageName:@"tu_60.png"];
    UIImage* buttonSelectImage = [UIImage strectchableImageName:@"tu_71.png"];
    
    CGFloat row;
    int categoryCount = 0;  
    for (NSDictionary *category in categoryArray) {
        NSString *name = [category objectForKey:PARA_CATEGORY_NAME];
        NSNumber *n = [category objectForKey:PARA_CATEGORY_PRODUCTS_NUM];
        NSString *number = [NSString stringWithFormat:@"(%@)", n];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTag:categoryCount];
        [button addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonSelectImage forState:UIControlStateHighlighted];
        row = categoryCount % BUTTON_ROW;  //第几列
        newX = row * (space + BUTTON_WIDTH) + space;
        if (0 == row) {
            if (0 == categoryCount) 
                newY = newY;
            else
                newY = newY + BUTTON_HEIGHT + space;
        }
        
        button.frame = CGRectMake(newX, newY, BUTTON_WIDTH, BUTTON_HEIGHT); 
                
        //set name
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        CGSize size = [name sizeWithFont:nameLabel.font];
        CGFloat x,  y;
        x = 8;
        y = (BUTTON_HEIGHT - size.height) / 2;
        nameLabel.frame = CGRectMake(x, y, size.width, size.height);
        nameLabel.text = name;
        nameLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [button addSubview:nameLabel];
        [nameLabel release];
        
        //set number
        x = x + size.width + 2;
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.font = [UIFont systemFontOfSize:10];
        numberLabel.textColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0];
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        size = [number sizeWithFont:numberLabel.font];
        y = (BUTTON_HEIGHT - size.height) / 2;
        numberLabel.frame = CGRectMake(x, y, size.width, size.height);
        numberLabel.text = number;
        [button addSubview:numberLabel];
        [numberLabel release];
        
        
        [scrollView addSubview:button];
        categoryCount++;
    }
    
    UIImage *splitLineImage = [UIImage imageNamed:@"tu_179.png"];
    UIImageView *splitLineImageView = [[UIImageView alloc] initWithImage:splitLineImage];
    newX = 0;
    newY = newY + BUTTON_HEIGHT + 2 * space;
    splitLineImageView.frame = CGRectMake(newX, newY , 306, 2);
    newY = newY + 2;
    [scrollView addSubview:splitLineImageView];
    [splitLineImageView release];
    
    
    //set website title
    UILabel *websiteTitleLabel = [[UILabel alloc] init];
    websiteTitleLabel.text = @"站点导航";
    websiteTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    websiteTitleLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    newX = 10;
    newY = newY + space;
    websiteTitleLabel.frame = CGRectMake(newX, newY, 90, TITLE_HEIGHT);
    [scrollView addSubview:websiteTitleLabel];
    [websiteTitleLabel release];
    
    
    newY = newY + TITLE_HEIGHT + space;
    
    //add website button
    int websiteCount = 0;
    for (NSString *website in siteNameArray) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:website forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [button setTag:categoryCount + websiteCount ];
        [button addTarget:self action:@selector(clickWebsiteButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonSelectImage forState:UIControlStateHighlighted];
        row = websiteCount % BUTTON_ROW;  //第几列
        newX = row * (space + BUTTON_WIDTH) + space;
        if (0 == row) {
            if (0 == websiteCount) 
                newY = newY;
            else
                newY = newY + BUTTON_HEIGHT + space;
        }
        button.frame = CGRectMake(newX, newY, BUTTON_WIDTH, BUTTON_HEIGHT);
        [scrollView addSubview:button];
        websiteCount++;
    }
    
    scrollView.contentSize = CGSizeMake(306, newY + BUTTON_HEIGHT + space);
    
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

- (void)clickWebsiteButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSString *websiteName = [self.siteNameArray objectAtIndex:button.tag - categoryArray.count];
    NSString *websiteId = [self.siteIdArray objectAtIndex:button.tag - categoryArray.count];
    
	CommonProductListController *websiteProductController = [[CommonProductListController alloc] init];
	websiteProductController.superController = self;
    
	websiteProductController.dataLoader = [[ProductWebsiteDataLoader alloc] initWithWebsiteId:websiteId];
    
	websiteProductController.navigationItem.title = [NSString stringWithFormat:@"%@", websiteName]; 
    [websiteProductController setGroupBuyNavigationBackButton];
    [websiteProductController setGroupBuyNavigationTitle:websiteProductController.navigationItem.title];
    [websiteProductController setBackgroundImageName:@"background.png"];
	[self.navigationController pushViewController:websiteProductController animated:YES];
	[websiteProductController release];
}

- (void)viewDidUnload
{        
    [self setSearchTextField:nil];
    [self setSearchButton:nil];
    [self setSearchBackgroundView:nil];
    [self setSearchTextFieldBackgroundView:nil];
    [self setScrollView:nil];
    [self setCategoryArray:nil];
    [self setSiteNameArray:nil];
    [self setSiteIdArray:nil];
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    int top = searchBackgroundView.frame.size.height + searchBackgroundView.frame.origin.y;
    [self addBlankView:top currentResponder:searchTextField];
    
    if (0 == self.categoryArray.count) {
        [self loadCategory];
    }
	
    [super viewDidAppear:animated];
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
    
	[self search:searchTextField.text];    
}




@end
