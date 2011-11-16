//
//  DownloadManageController.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadManageController.h"
#import "DownloadItemCell.h"
#import "DownloadItem.h"
#import "DownloadItemManager.h"
#import "DownloadService.h"
#import "ItemActionController.h"

@implementation DownloadManageController

@synthesize currentSelection;
@synthesize actionController;

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

- (void)dealloc
{
    [actionController release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.dataList = [[DownloadItemManager defaultManager] findAllItems];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgressTimer) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
        
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataTableView.backgroundColor = [UIColor whiteColor];

    [self setNavigationRightButton:NSLS(@"kNowPlaying") action:@selector(clickNowPlaying:)];
}

- (void)viewDidAppear:(BOOL)animated
{
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
	return [DownloadItemCell getCellHeight];
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
    
    NSString *CellIdentifier = [DownloadItemCell getCellIdentifier];
	DownloadItemCell *cell = (DownloadItemCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [DownloadItemCell createCell:self];
	}
    
    cell.indexPath = indexPath;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    DownloadItem* downloadItem = [self.dataList objectAtIndex:row];
    [cell setCellInfoWithItem:downloadItem indexPath:indexPath];    
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
	if (indexPath.row > [dataList count] - 1)
		return;
    
    DownloadItem* item = [self.dataList objectAtIndex:indexPath.row];
    if ([item canPlay] == NO){
        return;
    }
    
    if (self.actionController == nil){
        self.actionController = [[[ItemActionController alloc] init] autorelease];
    }

    [self.navigationController pushViewController:actionController animated:YES];
    [actionController showItem:item];

}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {		
	}	
}

- (void)updateProgressTimer
{
    [self.dataTableView reloadRowsAtIndexPaths:[self.dataTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma Download Cell Delegate

- (void)clickPause:(id)sender atIndexPath:(NSIndexPath*)indexPath
{
    int row = [indexPath row];
    if (row >= [self.dataList count])
        return;
    
    DownloadService* service = [DownloadService defaultService];

    DownloadItem* item = [self.dataList objectAtIndex:row];
    if ([item canPause]){
        [service pauseDownloadItem:item];
    }
    else if ([item canResume]){
        [service resumeDownloadItem:item];
    }
    else if ([item canPlay]){
        [service playItem:item viewController:self];
    }
}

- (void)clickStar:(id)sender atIndexPath:(NSIndexPath*)indexPath
{
    int row = [indexPath row];
    if (row >= [self.dataList count])
        return;

    DownloadItem* item = [self.dataList objectAtIndex:row];
    [[DownloadItemManager defaultManager] starItem:item];
    
    if (self.currentSelection == SELECT_STARRED_ITEM){
        self.dataList = [[DownloadItemManager defaultManager] findAllStarredItems];
        [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];    
    }
    else{
        [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)clickFilterComplete:(id)sender
{
    if (currentSelection == SELECT_COMPLETE_ITEM){
        return;
    }
    
    currentSelection = SELECT_COMPLETE_ITEM;
    
    self.dataList = [[DownloadItemManager defaultManager] findAllCompleteItems];
    [self.dataTableView reloadData];    
}

- (IBAction)clickFilterDownloading:(id)sender
{
    if (currentSelection == SELECT_DOWNLOADING_ITEM){
        return;
    }

    currentSelection = SELECT_DOWNLOADING_ITEM;

    self.dataList = [[DownloadItemManager defaultManager] findAllDownloadingItems];
    [self.dataTableView reloadData];    
}

- (IBAction)clickFilterStarred:(id)sender
{
    if (currentSelection == SELECT_STARRED_ITEM){
        return;
    }

    currentSelection = SELECT_STARRED_ITEM;
    self.dataList = [[DownloadItemManager defaultManager] findAllStarredItems];
    [self.dataTableView reloadData];    

}

- (IBAction)clickFilterAll:(id)sender
{
    if (currentSelection == SELECT_ALL_ITEM){
        return;
    }
    
    currentSelection = SELECT_ALL_ITEM;
    self.dataList = [[DownloadItemManager defaultManager] findAllItems];
    [self.dataTableView reloadData];    
    
}

@end
