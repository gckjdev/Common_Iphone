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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)findAllSitesFinish:(int)resultCode
{
    [self hideActivity];
    if (resultCode == 0){
        self.dataList = [[TopSiteManager defaultManager] siteList];
        [self.dataTableView reloadData];
    }
    else{
        [self popupUnhappyMessage:NSLS(@"kFailLoadSite") title:@""];
    }
}

- (void)loadSiteFromServer
{
    [self showActivityWithText:NSLS(@"kLoadingData")];
    [[ResourceService defaultService] findAllSites:self];
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
    self.dataList = [[TopSiteManager defaultManager] siteList];
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
	
    TopSite* site = [self.dataList objectAtIndex:row];
    [cell setCellInfoWithSite:site atIndexPath:indexPath];    
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row > [dataList count] - 1)
		return;
    
    TopSite* site = [self.dataList objectAtIndex:indexPath.row];
    [DownloadWebViewController show:self url:site.siteURL];
}


@end
