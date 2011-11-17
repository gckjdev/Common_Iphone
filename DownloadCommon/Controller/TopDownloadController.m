//
//  TopDownloadController.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopDownloadController.h"
#import "TopDownloadItem.h"
#import "TopDownloadItemCell.h"
#import "TopDownloadManager.h"
#import "DownloadWebViewController.h"
#import "DownloadService.h"
#import "MoreTableViewCell.h"

@implementation TopDownloadController

@synthesize siteList;
@synthesize requestType;
@synthesize currentSelectItem;
@synthesize startOffset;

- (void)dealloc
{
    [siteList release];
    [currentSelectItem release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.requestType = SITE_REQUEST_TYPE_TOP;
        self.siteList = [[[NSMutableArray alloc] init] autorelease];
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

- (void)updateDataList:(NSArray*)newDataList 
{
    if (startOffset == 0) {
        [self.siteList removeAllObjects];
        [self.siteList addObjectsFromArray:newDataList];
    } else {
        [self.siteList addObjectsFromArray:newDataList];
    }
}

- (void)reloadData
{
    self.dataList = siteList;    
    [self.dataTableView reloadData];
}

- (void)findAllSitesFinish:(int)resultCode requestType:(int)requestTypeValue newDataList:(NSArray*)newDataList
{
    [self hideActivity];
    if (resultCode == 0){
        [self updateDataList:newDataList];
        [self reloadData];
    }
    if ([self isReloading]){
        [self dataSourceDidFinishLoadingNewData];
    }
    
}

- (void)loadTopDownLoadItemFromServer:(BOOL)isRequestLastest
{
    [self showActivityWithText:NSLS(@"kLoadingData")];
    if (isRequestLastest) {
        startOffset = 0;
    } else {
        startOffset = [self.dataList count];
    }
    [[ResourceService defaultService] findAllTopDownloadItems:self startOffset:startOffset requestType:self.requestType];
}


- (void)viewDidLoad
{
    supportRefreshHeader = YES;
    [super viewDidLoad];
    
    [self setRefreshHeaderViewFrame:CGRectMake(0, 0 - self.dataTableView.bounds.size.height, 320, self.dataTableView.bounds.size.height)];
    
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(loadTopDownLoadItemFromServer)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
    
    
    // Do any additional setup after loading the view from its nib.
    [self loadTopDownLoadItemFromServer:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.dataList == nil || [dataList count] == 0){
        [self showActivityWithText:@"获取数据中..."];
        [self loadTopDownLoadItemFromServer:YES];                
    }
    else{
        [self reloadData];
    }
    
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
    if ([self isMoreRow:indexPath.row]){
        return [MoreTableViewCell getRowHeight];
    }
    
	return [TopDownloadItemCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.dataList count];
    return [self dataListCountWithMore];

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isMoreRow:indexPath.row]){
        // check if it's last row - to load more
        MoreTableViewCell* moreCell = [MoreTableViewCell createCell:theTableView];
        self.moreLoadingView = moreCell.loadingView;
        moreCell.textLabel.textColor = [self getDefaultTextColor];
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return moreCell;
    }
    
    NSString *CellIdentifier = [TopDownloadItemCell getCellIdentifier];
	TopDownloadItemCell *cell = (TopDownloadItemCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [TopDownloadItemCell createCell:self];
	}
    
    cell.indexPath = indexPath;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    TopDownloadItem* downloadItem = [self.dataList objectAtIndex:row];
	[cell setCellInfoWithTopDownloadItem:downloadItem atIndexPath:indexPath];
    
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([self isMoreRow:indexPath.row]){
        [self showActivityWithText:NSLS(@"kLoadingData")];
        [self.moreLoadingView startAnimating];
        [self loadTopDownLoadItemFromServer:NO];
        return;
    }
    
	if (indexPath.row > [dataList count] - 1)
		return;
    
    TopDownloadItem* item = [self.dataList objectAtIndex:indexPath.row];    
    self.currentSelectItem = item;
    [self askDownload];
}

#pragma mark - askDownload
- (void)askDownload
{
    
    NSString* title = [NSString stringWithFormat:NSLS(@"kDownloadURL"), self.currentSelectItem.url];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLS(@"Cancel") destructiveButtonTitle:NSLS(@"kYesDownload") otherButtonTitles:nil, nil];    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    enum BUTTON_INDEX {
        CLICK_DOWNLOAD = 0,
        CLICK_CANCEL = 1
    };
    
    switch (buttonIndex) {
        case CLICK_DOWNLOAD:
        {
            [[DownloadService defaultService] downloadFile:self.currentSelectItem.url 
                                                  fileType:[self.currentSelectItem.fileType intValue]
                                                   webSite:self.currentSelectItem.webSite
                                               webSiteName:self.currentSelectItem.webSiteName             
                                                   origUrl:nil];
        }
            break;
        case CLICK_CANCEL:    
        default:
            break;
    }
}

#pragma Pull Refresh Delegate
- (void) reloadTableViewDataSource
{
    [self loadTopDownLoadItemFromServer:YES];
}

- (void)dataSourceDidFinishLoadingNewData{
    _reloading = NO;
    [super dataSourceDidFinishLoadingNewData];
}

- (UIColor*)getDefaultTextColor
{
    return [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
}

@end
