//
//  SearchProductController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SearchProductController.h"
#import "SearchHistoryManager.h"
#import "SearchHistory.h"
#import "CommonProductListController.h"
#import "ProductPriceDataLoader.h"
#import "HotKeyword.h"
#import "HotKeywordManager.h"
#import "ProductManager.h"
#import "UIImageUtil.h"
#import "UIButtonExt.h"

//private methods
@interface SearchProductController()

-(void) refreshLatestSearchHistory;

@end

@implementation SearchProductController

@synthesize testButton;
@synthesize searchTextFieldBackgroundView;
@synthesize searchButton;
@synthesize searchTextField;
@synthesize searchBackgroundView;
@synthesize latestSearchButton1;
@synthesize latestSearchButton2;
@synthesize latestSearchButton3;

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
	[latestSearchButton1 release];
	[latestSearchButton2 release];
	[latestSearchButton3 release];
    [keywordSearchBar release];
    [searchTextField release];
    [searchButton release];
    [searchBackgroundView release];
    [searchTextFieldBackgroundView release];
    [testButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    keywordSearchBar.hidden = YES;    
    
//    [self.testButton setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 30, 0)];
//    [self.testButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 30)];
    
    [self setBackgroundImageName:@"background.png"];
    [self setGroupBuyNavigationTitle:self.tabBarItem.title];

    [super viewDidLoad];
    
    UIImage* searchTextFieldImage = [UIImage strectchableImageName:@"tu_46-18.png"];
    [self.searchTextFieldBackgroundView setImage:searchTextFieldImage];
    
    // set search button background
    UIImage* buttonBgImage = [UIImage strectchableImageName:@"tu_48.png"];
    [searchButton setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
    
//    [self setNavigationRightButton:@"语音搜索" action:@selector(speechSearch:)];
}

- (void)viewDidUnload
{        
    [self setSearchTextField:nil];
    [self setSearchButton:nil];
    [self setSearchBackgroundView:nil];
    [self setSearchTextFieldBackgroundView:nil];
    [self setTestButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.latestSearchButton1 = nil;
	self.latestSearchButton2 = nil;	
	self.latestSearchButton3 = nil;
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
	// Do any additional setup after loading the view from its nib.
	NSArray* latestSearchHistories = [SearchHistoryManager getLatestSearchHistories];
	latestSearchButton1.hidden = YES;
    latestSearchButton2.hidden = YES;
    latestSearchButton3.hidden = YES;
	if([latestSearchHistories count] >=1 ){
		[latestSearchButton1 setTitle:((SearchHistory*)[latestSearchHistories objectAtIndex:0]).keywords forState:UIControlStateNormal];
        latestSearchButton1.hidden = NO;
    }
	if([latestSearchHistories count] >=2 ){
		[latestSearchButton2 setTitle:((SearchHistory*)[latestSearchHistories objectAtIndex:1]).keywords forState:UIControlStateNormal];
        latestSearchButton2.hidden = NO;
    }
	if([latestSearchHistories count] >=3 ){
		[latestSearchButton3 setTitle:((SearchHistory*)[latestSearchHistories objectAtIndex:2]).keywords forState:UIControlStateNormal];
        latestSearchButton3.hidden = NO;
    }
	
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

- (IBAction) doSearch:(id)sender
{
	UIButton *button = (UIButton *)sender;    
    keywordSearchBar.text = button.currentTitle;  
    searchTextField.text = button.currentTitle;
    [self search:button.currentTitle];	
}


- (IBAction) speechSearch:(id)sender
{
    if ([keywordSearchBar isFirstResponder]){
        [keywordSearchBar resignFirstResponder];
    }
    
//    if (asrEngine == nil){
//        asrEngine = [[ASREngine alloc] init];
//    }
//    
//    [asrEngine showControl:self.view displayTextView:keywordSearchBar];    
}

@end
