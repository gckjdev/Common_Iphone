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
#import "DownloadResource.h"
#import "DownloadItem.h"
#import "GADBannerView.h"
#import "DownloadAd.h"

@implementation TopDownloadController

@synthesize toplist;
@synthesize requestType;
@synthesize currentSelectItem;
@synthesize startOffset;
@synthesize lastSelectedCell;
@synthesize bannerView;

- (void)dealloc
{
    [toplist release];
    [currentSelectItem release];
    [lastSelectedCell release];
    [bannerView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.requestType = SITE_REQUEST_TYPE_TOP;
        self.toplist = [[[NSMutableArray alloc] init] autorelease];
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
        [self.toplist removeAllObjects];
        [self.toplist addObjectsFromArray:newDataList];
    } else {
        [self.toplist addObjectsFromArray:newDataList];
    }
    
    if ([toplist count] == 0){
        [self showTipsOnTableView:NSLS(@"kNoTopDownloadData")];
        self.tipsLabel.textColor = CELL_TEXT_COLOR;
    } else {
        [self hideTipsOnTableView];
    }
}

- (void)reloadData
{
    self.dataList = toplist;    
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

- (void)setRightBarButton
{
    float buttonHigh = 27.5;
    float refeshButtonLen = 32.5;
    
    UIButton *refleshButton = [[UIButton alloc]initWithFrame:CGRectMake(125, 0, refeshButtonLen, buttonHigh)];
    [refleshButton setBackgroundImage:DOWNLOAD_REFRESH_ICON_IMAGE forState:UIControlStateNormal];
    [refleshButton setTitle:@"" forState:UIControlStateNormal];
    [refleshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refleshButton addTarget:self action:@selector(clickRefresh) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:refleshButton];    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}


- (void)clickRefresh
{
    [self loadTopDownLoadItemFromServer:YES];
}

- (void)viewDidLoad
{
    [self setBackgroundImageName:DOWNLOAD_BG];
    [self setDownloadNavigationTitle:NSLS(@"kTopDownload")];
     
    supportRefreshHeader = YES;
    [self setRefreshHeaderViewFrame:CGRectMake(0, 0 - self.dataTableView.bounds.size.height, 320, self.dataTableView.bounds.size.width)];
    
    [self setRightBarButton];
//    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickRefresh:)];
    
    [super viewDidLoad];
    
    [self setRefreshHeaderViewFrame:CGRectMake(0, 0-self.dataTableView.bounds.size.height, 320, self.dataTableView.bounds.size.height)];
    
    // Do any additional setup after loading the view from its nib.
    [self loadTopDownLoadItemFromServer:YES];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    if (bannerView == nil){ 
        bannerView = [DownloadAd allocAdMobView:self];
        if (bannerView != nil){
            CGRect rect = self.dataTableView.frame;
            rect.size.height -= 50;
            self.dataTableView.frame = rect;
        }
    }
    
    
    if (self.dataList == nil || [dataList count] == 0){                        
        [self showActivityWithText:NSLS(@"kLoadingData")];
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
        return [TopDownloadItemCell getCellHeight];
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
        
        moreCell.textLabel.textColor = [UIColor colorWithRed:101/255.0 green:134/255.0 blue:156/255.0 alpha:1.0];
        moreCell.textLabel.font = [UIFont systemFontOfSize:15];
        moreCell.textLabel.shadowColor = [UIColor colorWithRed:241/255.0 green:246/255.0 blue:249/255.0 alpha:1.0];
        
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:RESOURCE_CELL_BG_IMAGE];
        [moreCell setBackgroundView:imageView];
        [imageView release];
        
        moreCell.loadingView.hidesWhenStopped = YES;
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
    [cell resetCellColor];

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
    
    if (lastSelectedCell != nil) {
        [lastSelectedCell resetCellColor];
    }
    TopDownloadItemCell *cell = (TopDownloadItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setCellSelectedColor];
    lastSelectedCell = cell;

    
    TopDownloadItem* item = [self.dataList objectAtIndex:indexPath.row];    
    self.currentSelectItem = item;
    [self askDownload];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
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
            [self hasDownloaded:currentSelectItem];
        }
            break;
        case CLICK_CANCEL:    
        default:
            break;
    }
}

- (void) hasDownloaded:(TopDownloadItem*) topDownloadItem
{
    BOOL exist = [[DownloadService defaultService] hasDownloaded:topDownloadItem];
    if (exist) {
        NSLog(@"item downloaded before!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLS(@"kDownloaded_Before")   
                                                       message:NSLS(@"kRedownload")   
                                                      delegate:self   
                                             cancelButtonTitle:NSLS(@"NO")  
                                             otherButtonTitles:NSLS(@"YES"),nil];
        [alert show];  
        [alert release];  
    } else {
        [[DownloadService defaultService] downloadFile:self.currentSelectItem.url 
                                              fileType:[self.currentSelectItem.fileType intValue]
                                               webSite:self.currentSelectItem.webSite
                                           webSiteName:self.currentSelectItem.webSiteName             
                                               origUrl:nil];
    }
    
}

#pragma mark  -- UIAlertViewDelegate --  
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {  
    NSLog(@"clickedButtonAtIndex:%d",buttonIndex);
    enum BUTTON_INDEX {
        CLICK_CANCEL = 0,
        CLICK_DOWNLOAD = 1

    };
    switch (buttonIndex) {
        case CLICK_DOWNLOAD:
        {
            int fileType = [DownloadItem isImage:currentSelectItem.fileType] 
                                ? FILE_TYPE_IMAGE : FILE_TYPE_UNKNOWN;
            
            [[DownloadService defaultService] downloadFile:self.currentSelectItem.url 
                                                  fileType:fileType
                                                   webSite:self.currentSelectItem.webSite
                                               webSiteName:self.currentSelectItem.webSiteName             
                                                   origUrl:nil];
        }
            break;
            
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
