//
//  ResourceCategoryController.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ResourceCategoryController.h"
#import "TopSite.h"
#import "TopSiteManager.h"
#import "ResourceCell.h"
#import "DownloadWebViewController.h"

@implementation ResourceCategoryController

@synthesize requestType;
@synthesize latestList;
@synthesize topList;
@synthesize hotList;
@synthesize starredList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.requestType = SITE_REQUEST_TYPE_TOP;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [starredList release];
    [hotList release];
    [topList release];
    [latestList release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)updateDataListByType:(NSArray*)newDataList requestType:(int)requestTypeValue
{
    switch (requestTypeValue) {
        case SITE_REQUEST_TYPE_TOP:
        {
            self.topList = newDataList;
        }
            break;

        case SITE_REQUEST_TYPE_HOT:
        {
            self.hotList = newDataList;
        }
            break;
            
        case SITE_REQUEST_TYPE_NEW:
        {
            self.latestList = newDataList;
        }
            break;
            
        default:
            break;
    }
}

- (void)reloadData
{
    switch (self.requestType) {
        case SITE_REQUEST_TYPE_TOP:
        {
            self.dataList = self.topList;
        }
            break;
            
        case SITE_REQUEST_TYPE_HOT:
        {
            self.dataList = self.hotList;
        }
            break;
            
        case SITE_REQUEST_TYPE_NEW:
        {
            self.dataList = self.latestList;
        }
            break;
        
        case SITE_REQUEST_TYPE_NONE:
        {
            self.dataList = self.starredList;
        }
            break;            
        
        default:
            break;
    }

    [self.dataTableView reloadData];
}

- (void)findAllSitesFinish:(int)resultCode requestType:(int)requestTypeValue newDataList:(NSArray*)newDataList
{
    [self hideActivity];
    if (resultCode == 0){
        [self updateDataListByType:newDataList requestType:requestTypeValue];
        if (requestType == requestTypeValue){
            [self reloadData];
        }
    }
    else{
        [self popupUnhappyMessage:NSLS(@"kFailLoadSite") title:@""];
    }
}

- (void)loadSiteFromServer
{    
    if (self.requestType == SITE_REQUEST_TYPE_NONE)
        return;
    
    [self showActivityWithText:NSLS(@"kLoadingData")];
    [[ResourceService defaultService] findAllSites:self requestType:self.requestType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(loadSiteFromServer)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
    [self loadSiteFromServer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadData];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [ResourceCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [ResourceCell getCellIdentifier];
	ResourceCell *cell = (ResourceCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [ResourceCell createCell:self];
	}
    
    cell.indexPath = indexPath;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    if (requestType == SITE_REQUEST_TYPE_NONE){
        Site* site = [self.dataList objectAtIndex:row];
        [cell setCellInfoWithSite:site atIndexPath:indexPath];    
    }
    else{
        TopSite* site = [self.dataList objectAtIndex:row];
        [cell setCellInfoWithTopSite:site atIndexPath:indexPath];    
    }
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row > [dataList count] - 1)
		return;
    
    TopSite* site = [self.dataList objectAtIndex:indexPath.row];
    [DownloadWebViewController show:self url:site.siteURL];
}

- (IBAction)clickHot:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_HOT;
    if ([self.hotList count] == 0){
        [self loadSiteFromServer];
    }
    else{
        [self reloadData];
    }    
}

- (IBAction)clickTop:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_TOP;
    if ([self.topList count] == 0){
        [self loadSiteFromServer];
    }
    else{
        [self reloadData];
    }    
    
}

- (IBAction)clickNew:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_NEW;
    if ([self.latestList count] == 0){
        [self loadSiteFromServer];
    }
    else{
        [self reloadData];
    }    
    
}

- (IBAction)clickStarred:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_NONE;
    self.starredList = [[TopSiteManager defaultManager] findAllFavoriteSites];
    [self reloadData];    
}


@end
