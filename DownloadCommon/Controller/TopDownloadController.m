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

@implementation TopDownloadController

@synthesize siteList;
@synthesize requestType;
@synthesize currentSelectItem;

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
    self.siteList = newDataList;
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
    
}

- (void)loadTopDownLoadItemFromServer
{
    [self showActivityWithText:NSLS(@"kLoadingData")];
    [[ResourceService defaultService] findAllTopDownloadItems:self requestType:self.requestType];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(loadTopDownLoadItemFromServer)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
    [self loadTopDownLoadItemFromServer];
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
	return [TopDownloadItemCell getCellHeight];
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
    
	if (indexPath.row > [dataList count] - 1)
		return;
    
    TopDownloadItem* item = [self.dataList objectAtIndex:indexPath.row];    
    self.currentSelectItem = item;
    [self askDownload];
}

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



@end
