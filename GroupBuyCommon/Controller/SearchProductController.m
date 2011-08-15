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
#import "qisr.h"
#import "CommonProductListController.h"
#import "ProductPriceDataLoader.h"

//private methods
@interface SearchProductController()

-(void) refreshLatestSearchHistory;

@end

@implementation SearchProductController

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
	[latestSearchButton1 release];
	[latestSearchButton2 release];
	[latestSearchButton3 release];
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
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	latestSearchButton1 = nil;
	latestSearchButton2 = nil;	
	latestSearchButton3 = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
	[self refreshLatestSearchHistory];
	[super viewDidAppear:animated];
}

-(void) refreshLatestSearchHistory
{
	// Do any additional setup after loading the view from its nib.
	NSArray* latestSearchHistories = [SearchHistoryManager getLatestSearchHistories];
	
	if([latestSearchHistories count] >=1 )
		[latestSearchButton1 setTitle:((SearchHistory*)[latestSearchHistories objectAtIndex:0]).keywords forState:UIControlStateNormal];
	if([latestSearchHistories count] >=2 )
		[latestSearchButton2 setTitle:((SearchHistory*)[latestSearchHistories objectAtIndex:1]).keywords forState:UIControlStateNormal];
	if([latestSearchHistories count] >=3 )
		[latestSearchButton3 setTitle:((SearchHistory*)[latestSearchHistories objectAtIndex:2]).keywords forState:UIControlStateNormal];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -  
#pragma mark UISearchBarDelegate Methods  

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {  
    
	
	[searchBar resignFirstResponder];
	[SearchHistoryManager createSearchHistory:searchBar.text];
	
	[self refreshLatestSearchHistory];
	
	CommonProductListController *searchResultController = [[CommonProductListController alloc] init];
	searchResultController.superController = self;
	searchResultController.dataLoader = [[[ProductKeywordDataLoader alloc] 
                                          initWithKeyword:searchBar.text] autorelease];
	[self.navigationController pushViewController:searchResultController animated:NO];
	[searchResultController release];
	
}  

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];

}

#pragma mark -
#pragma mark do Search


- (IBAction) doSearch:(id)sender
{
	UIButton *button = (UIButton *)sender;
	//TODO
	NSLog(@"Submitting search : %@",  button.currentTitle);

}


- (IBAction) speechSearch:(id)sender
{
	//CGPoint origin = CGPointMake(20.0,20.0);	
	//[IFlyRecognizeControl initWithOrigin:origin theInitParam:@"appid=4e3dff54"];
	//[IFlyRecognize initWithOrigin:origin theInitParam:@"appid=4e3dff54"];
}

@end
