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
#import "LogUtil.h"
#import "SSZipArchive.h"
#import "FileUtil.h"
#import "Unrar4iOS.h"
#import "DecompressManager.h"
#import "ViewDecompressItemController.h"
#import "DownloadResource.h"

@implementation DownloadManageController

@synthesize currentSelection;
@synthesize actionController;
@synthesize lastPlayingItem;
@synthesize filterAllButton;
@synthesize filterCompleteButton;
@synthesize filterDownloadingButton;
@synthesize filterStarredButton;
@synthesize viewDecompressItemController;
@synthesize lastSelectedButton;
@synthesize filterBackgroundView;
@synthesize underlineView;

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
    [lastPlayingItem release];
    [filterAllButton release];
    [filterCompleteButton release];
    [filterDownloadingButton release];
    [filterStarredButton release];
    [viewDecompressItemController release];
    [filterBackgroundView release];
    [lastSelectedButton release];
    [underlineView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadDataBySelectType
{
    switch (currentSelection) {
        case SELECT_COMPLETE_ITEM:
            self.dataList = [[DownloadItemManager defaultManager] findAllCompleteItems];
            break;
            
        case SELECT_ALL_ITEM:
            self.dataList = [[DownloadItemManager defaultManager] findAllItems];
            break;
            
        case SELECT_DOWNLOADING_ITEM:
            self.dataList = [[DownloadItemManager defaultManager] findAllDownloadingItems];
            break;
            
        case SELECT_STARRED_ITEM:
            self.dataList = [[DownloadItemManager defaultManager] findAllStarredItems];
            break;            
            
        default:
            break;
    }
}

- (void)viewDidLoad
{   
    [self setDownloadNavigationTitle:NSLS(@"kFourthViewTitle")];

    [self.filterBackgroundView setImage:DOWNLOAD_FILTER_BG_IMAGE];
    
    [self.filterAllButton setTitle:NSLS(@"kFilterAllButtonTitle") forState:UIControlStateNormal];
    
    [self.filterAllButton setImage:FILETER_ALL_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.filterAllButton setImage:FILETER_ALL_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.filterCompleteButton setTitle:NSLS(@"kFilterCompleteButtonTitle") forState:UIControlStateNormal];
    [self.filterCompleteButton setImage:FILETER_COMPLETE_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.filterCompleteButton setImage:FILETER_COMPLETE_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.filterDownloadingButton setTitle:NSLS(@"kFilterDownloadingButtonTitle") forState:UIControlStateNormal];
    [self.filterDownloadingButton setImage:FILETER_DOWNLOADING_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.filterDownloadingButton setImage:FILETER_DOWNLOADING_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.filterStarredButton setTitle:NSLS(@"kFilterStarredButtonTitle") forState:UIControlStateNormal];
    [self.filterStarredButton setImage:FILETER_STARRED_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.filterStarredButton setImage:FILETER_STARRED_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgressTimer) userInfo:nil repeats:YES];
    
    [filterAllButton setSelected:YES];
    lastSelectedButton = filterAllButton;
    
    underlineView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 38, 55, 2)];
    [underlineView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:78/255.0 blue:0 alpha:1.0]];
    [filterBackgroundView addSubview:underlineView];
    
    [super viewDidLoad];
        
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
    
}

- (void) clickNowPlaying:(id) sender
{
    DownloadService * service = [DownloadService defaultService];
   // [service playItem:lastPlayingItem viewController:self];
    
    NSArray *imageList = [self filterDownloadItemByImage];
    int indexValue = [imageList indexOfObject:lastPlayingItem];
    [service playItem:imageList index:indexValue viewController:self];
}

- (void) updateNowPlayingButton
{
//    if (lastPlayingItem != nil) {
//        if ([lastPlayingItem canPlay] ) {
//            [self setNavigationRightButton:NSLS(@"kNowPlaying") action:@selector(clickNowPlaying:)];
//        } else if ([lastPlayingItem canView]) {
//            [self setNavigationRightButton:NSLS(@"kNowViewing") action:@selector(clickNowPlaying:)];
//        }
//        else{
//            self.navigationItem.rightBarButtonItem = nil;
//        }
//    }
    
    [self setNavigationRightButton:nil imageName:NOWPLAYING_ICON action:@selector(clickNowPlaying:)];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadDataBySelectType];
    [self.dataTableView reloadData];
    [super viewDidAppear:animated];
    
//    [self updateNowPlayingButton];

}

- (void)viewDidUnload
{
    [self setFilterAllButton:nil];
    [self setFilterCompleteButton:nil];
    [self setFilterDownloadingButton:nil];
    [self setFilterStarredButton:nil];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
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
	[cell resetCellColor];
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
	if (indexPath.row > [dataList count] - 1)
		return;
    
    DownloadItemCell *cell = (DownloadItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setCellSelectedColor];
    
    DownloadItem* item = [self.dataList objectAtIndex:indexPath.row];
    if ([item isDownloadFinished] == NO){
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

- (NSArray*)filterDownloadItemByImage
{
    NSArray *allList = [[DownloadItemManager defaultManager]findAllCompleteItems];
    NSMutableArray *retList = [[[NSMutableArray alloc] init] autorelease];

    for (DownloadItem *item in allList) {
        if ([item canView]) {
            [retList addObject:item];
        }
    }
    
    return retList;
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
        lastPlayingItem = [self.dataList objectAtIndex:row];
        [self updateNowPlayingButton];
    }
    else if([item canView]){        
        NSArray *imageList = [self filterDownloadItemByImage];
        int indexValue = [imageList indexOfObject:item];
        [service playItem:imageList index:indexValue viewController:self];
        
        lastPlayingItem = [self.dataList objectAtIndex:row];
        [self updateNowPlayingButton];
    }
    else if([item isZipFile] || [item isRarFile]){
        NSArray *itemList = [[DecompressManager defaultManager] decompressDownloadItem:item];
        
        //go to ViewDirectoryController
        if (self.viewDecompressItemController == nil){
            self.viewDecompressItemController = [[[ViewDecompressItemController alloc] init] autorelease];
        }
        [viewDecompressItemController setDecompressItemList:itemList];

        [self.navigationController pushViewController:viewDecompressItemController animated:YES];
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
    [filterCompleteButton setSelected:YES];
    [lastSelectedButton setSelected:NO];
    lastSelectedButton = filterCompleteButton;
    
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:0.5];
    [UIImageView setAnimationBeginsFromCurrentState:YES];
    [underlineView setFrame:CGRectMake(65, 38, 70, 2)];
    [UIImageView commitAnimations];
    
    self.dataList = [[DownloadItemManager defaultManager] findAllCompleteItems];
    [self.dataTableView reloadData];    
}

- (IBAction)clickFilterDownloading:(id)sender
{
    if (currentSelection == SELECT_DOWNLOADING_ITEM){
        return;
    }

    currentSelection = SELECT_DOWNLOADING_ITEM;
    [filterDownloadingButton setSelected:YES];
    [lastSelectedButton setSelected:NO];
    lastSelectedButton = filterDownloadingButton;
    
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:0.5];
    [UIImageView setAnimationBeginsFromCurrentState:YES];
    [underlineView setFrame:CGRectMake(150, 38, 90, 2)];
    [UIImageView commitAnimations];

    self.dataList = [[DownloadItemManager defaultManager] findAllDownloadingItems];
    [self.dataTableView reloadData];    
}

- (IBAction)clickFilterStarred:(id)sender
{
    if (currentSelection == SELECT_STARRED_ITEM){
        return;
    }

    currentSelection = SELECT_STARRED_ITEM;
    [filterStarredButton setSelected:YES];
    [lastSelectedButton setSelected:NO];
    lastSelectedButton = filterStarredButton;
    
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:0.5];
    [UIImageView setAnimationBeginsFromCurrentState:YES];
    [underlineView setFrame:CGRectMake(248, 38, 70, 2)];
    [UIImageView commitAnimations];

    self.dataList = [[DownloadItemManager defaultManager] findAllStarredItems];
    [self.dataTableView reloadData];    

}

- (IBAction)clickFilterAll:(id)sender
{
    if (currentSelection == SELECT_ALL_ITEM){
        return;
    }
    
    currentSelection = SELECT_ALL_ITEM;    
    [filterAllButton setSelected:YES];
    [lastSelectedButton setSelected:NO];
    lastSelectedButton = filterAllButton;
    
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:0.5];
    [UIImageView setAnimationBeginsFromCurrentState:YES];
    [underlineView setFrame:CGRectMake(8, 38, 50, 2)];
//    [underlineView.layer setPosition:CGPointMake(28, 38)];
    [UIImageView commitAnimations];
    
    self.dataList = [[DownloadItemManager defaultManager] findAllItems];
    [self.dataTableView reloadData];    
    
}



@end
