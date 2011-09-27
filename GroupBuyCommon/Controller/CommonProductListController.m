//
//  CommonProductListController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonProductListController.h"
#import "PPTableViewController.h"
#import "GroupBuyNetworkRequest.h"
#import "GroupBuyNetworkConstants.h"
#import "PPNetworkRequest.h"
#import "LocationService.h"
#import "MoreTableViewCell.h"
#import "ProductTextCell.h"
#import "ProductManager.h"
#import "Product.h"
#import "ProductService.h"
#import "ProductPriceDataLoader.h"
#import "ProductDetailController.h"
#import "CoreDataUtil.h"
#import "GroupBuyReport.h"

@implementation CommonProductListController

@synthesize superController;
@synthesize dataLoader;
@synthesize categoryId;
@synthesize type;

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
    [superController release];
    [dataLoader release];
    [categoryId release];
    [type release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// to be override
- (NSArray*)requestProductListFromDB
{
    return [dataLoader requestProductListFromDB];
}

// to be override
- (void)requestProductListFromServer:(BOOL)isRequestLastest
{    
    if (isRemoteRequest){
        return;
    }
    
    isRemoteRequest = YES;
    return [dataLoader requestProductListFromServer:isRequestLastest controller:self];
}

- (void)productDataRefresh:(int)result
{    
    isRemoteRequest = NO;    
    [self hideActivity];
    
    [GroupBuyReport reportDataRefreshResult:result];

    if (result == ERROR_SUCCESS){                
        self.dataList = [self requestProductListFromDB];        
        [self.dataTableView reloadData];
    }
    else if (result == ERROR_NETWORK){
        [self popupUnhappyMessage:@"无法连接到互联网，请检查网络是否可用？" title:@"网络错误"];
    }
    
    if ([self isReloading]){
        [self dataSourceDidFinishLoadingNewData];
    }
}

- (void)initDataList
{
    self.dataList = [self requestProductListFromDB];
    [self requestProductListFromServer:YES];            
}

#pragma Pull Refresh Delegate
- (void) reloadTableViewDataSource
{
    [GroupBuyReport reportPullRefresh:categoryId type:type];
    [self requestProductListFromServer:YES];
}


- (void)viewDidLoad
{    
    
    [self setBackgroundImageName:@"background.png"];
    
    if ([dataLoader supportRemote])
        supportRefreshHeader = YES;
    
    if ([dataLoader canDelete]){
        [self setNavigationRightButton:@"全部删除" action:@selector(clickDeleteAll:)];
    }
    
    [self requestProductListFromServer:YES];    
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.dataList = [self requestProductListFromDB]; 
    if (self.dataList == nil || [dataList count] == 0){
        [self showActivityWithText:@"获取团购数据中..."];
        [self requestProductListFromServer:YES];
    }
    else{
        [self.dataTableView reloadData];
    }
    
    [super viewDidAppear:YES];
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
#pragma mark Table View Delegate

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
//{
//	NSMutableArray* array = [NSMutableArray arrayWithArray:[ArrayOfCharacters getArray]];
//	[array addObject:kSectionNull];
//	return array;
//	
////		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
////		return nil;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [groupData sectionForLetter:title];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	
	
	//	switch (section) {
	//		case <#constant#>:
	//			<#statements#>
	//			break;
	//		default:
	//			break;
	//	}
	
	return sectionHeader;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	return [self getSectionView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return sectionImageHeight;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//	return [self getFooterView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return footerImageHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
    if ([self isMoreRow:indexPath.row]){
        return [MoreTableViewCell getRowHeight];
    }
    
	return [ProductTextCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
	
	// return [groupData totalSectionCount];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataLoader supportRemote])
        return [self dataListCountWithMore];
    else   
        return [dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isMoreRow:indexPath.row]){
        // check if it's last row - to load more
        MoreTableViewCell* moreCell = [MoreTableViewCell createCell:theTableView];
        self.moreLoadingView = moreCell.loadingView;
        return moreCell;
    }
    
    
    NSString *CellIdentifier = [ProductTextCell getCellIdentifier];
	ProductTextCell *cell = (ProductTextCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [ProductTextCell createCell:self];
	}

    cell.indexPath = indexPath;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    //	[self setCellBackground:cell row:row count:count];        
	
	Product* product = [dataList objectAtIndex:row];
    [cell setCellInfoWithProduct:product indexPath:indexPath];    
	
	return cell;
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	    
    if ([self isMoreRow:indexPath.row]){
        [self.moreLoadingView startAnimating];
        [self requestProductListFromServer:NO];
        [GroupBuyReport reportClickMore:categoryId type:type];
        return;
    }
     
	if (indexPath.row > [dataList count] - 1)
		return;
    
    BOOL isCreateHistory = NO;
    if ([dataLoader isKindOfClass:[ProductHistoryDataLoader class]] == NO){
        isCreateHistory = YES;
    }

    Product* product = [dataList objectAtIndex:indexPath.row];  
    UINavigationController* navigationController;
    if (self.superController)
        navigationController = self.superController.navigationController;
    else   
        navigationController = self.navigationController;
        
    [ProductDetailController showProductDetail:product 
                          navigationController:navigationController
                               isCreateHistory:isCreateHistory];
	

    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row > [dataList count] - 1)
			return;
		
        if ([dataLoader canDelete] == NO)
            return;
        
        Product* product = [dataList objectAtIndex:indexPath.row];    
        CoreDataManager* dataManager = GlobalGetCoreDataManager();
        [dataManager del:product];
        [self reloadTableViewDataSource];
	}
	
}


- (void)clickDeleteAll:(id)sender{

   UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除所有数据吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlertView show];
    [deleteAlertView release];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        return;
    }
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    for (int i=0; i < [dataList count] ; ++i) {
        [dataManager del:[dataList objectAtIndex:i]];
    }
    
    [self reloadTableViewDataSource];
}
@end
