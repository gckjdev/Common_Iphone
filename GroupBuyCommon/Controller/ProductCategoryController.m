//
//  ProductCategoryController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductCategoryController.h"
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


@implementation ProductCategoryController

@synthesize superController;
@synthesize todayOnly;
@synthesize indexNameArray;
@synthesize categoryControllerList;

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
    [indexNameArray release];
    [categoryControllerList release];
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
- (void)requestProductListFromServer:(BOOL)isRequestLastest
{    
    ProductService* productService = GlobalGetProductService();
    [productService requestProductDataByCategory:self todayOnly:todayOnly];
    return;
}

- (void)initIndexNameArray
{
    if (self.indexNameArray == nil) {
        self.indexNameArray = [[NSMutableArray alloc] init];
    }
    
    [self.indexNameArray removeAllObjects];
    
    if (dataList == nil || [dataList count] == 0) {
        return;
    }
    for(int i = 0; i < [dataList count]; ++i){
        NSDictionary* dict = [dataList objectAtIndex:i];
        NSString* name = [dict objectForKey:PARA_CATEGORY_NAME];
//        NSString* extName = @"";
//        int len = [name length];
//        for (int i=0; i<len; i++){
//            unichar chars[1]; 
//            chars[0] = [name characterAtIndex:i];
//            extName = [extName stringByAppendingString:[NSString stringWithCharacters:chars length:1]];
//            
//            if (i != len-1){
//                extName = [extName stringByAppendingString:@"\r\n"];
//            }
//        }

        [indexNameArray addObject:name];
    }
}
- (void)productDataRefresh:(int)result jsonArray:(NSArray *)jsonArray
{    
    [self hideActivity];
    
    if (result == ERROR_SUCCESS){        
        
        self.dataList = jsonArray;        
        [self initIndexNameArray];        
        [self.dataTableView reloadData];
        
    } 
    
    if ([self isReloading]){
        [self dataSourceDidFinishLoadingNewData];
    }
    
    if (result == ERROR_NETWORK){
        [self popupUnhappyMessage:@"无法连接到互联网，请检查网络是否可用？" title:@"网络错误"];
    }
}

- (void)initDataList
{
    [self requestProductListFromServer:YES];            
}

#pragma Pull Refresh Delegate
- (void) reloadTableViewDataSource
{
    [self requestProductListFromServer:YES];
}


- (void)viewDidLoad
{    
    
    self.categoryControllerList = [[NSDictionary alloc] init];
        
    [self setBackgroundImageName:@"background.png"];
//    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.dataTableView.backgroundColor = [UIColor whiteColor];
    
    supportRefreshHeader = YES;
    
    [super viewDidLoad];            
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.dataList == nil || [self.dataList count] == 0){
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

- (NSDictionary*)getProductData:(int)section row:(int)row
{
    if (section < [dataList count]){
        NSDictionary* dict = [dataList objectAtIndex:section];
        NSArray* dataArray = [dict objectForKey:PARA_PRODUCT];
        if (row >=0  && row < [dataArray count])
            return [dataArray objectAtIndex:row];
    }
    
    return nil;    
}

- (NSString*)getCategoryName:(int)section
{
    if (section < [dataList count]){
        NSDictionary* dict = [dataList objectAtIndex:section];
        return [dict objectForKey:PARA_CATEGORY_NAME];
    }
    
    return nil;        
}

- (NSString*)getCategoryId:(int)section
{
    if (section < [dataList count]){
        NSDictionary* dict = [dataList objectAtIndex:section];
        return [dict objectForKey:PARA_CATEGORY_ID];
    }
    
    return nil;        
}

- (BOOL)isMoreRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary* dict = [dataList objectAtIndex:indexPath.section];
    NSArray* dataArray = [dict objectForKey:PARA_PRODUCT];
    if (indexPath.row == [dataArray count]){
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark Table View Delegate

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
//{
//
//    return self.indexNameArray;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//
//    NSInteger count = 0;
//    for(NSString *character in self.indexNameArray)
//    {
//        if([character isEqualToString:title])
//        {
//            return count;
//        }
//        count ++;
//    }
//    return 0;
//    
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [self getCategoryName:section];
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
    if ([self isMoreRowAtIndexPath:indexPath])
        return 44;
    else
        return [ProductTextCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataList count];		
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < [dataList count]){
        NSDictionary* dict = [dataList objectAtIndex:section];
        NSArray* dataArray = [dict objectForKey:PARA_PRODUCT];
        if ([dataArray count] > 0){
            return [dataArray count] + 1;
        }
        else{
            return 0;
        }
    }
    else{
        return 0;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    

    if ([self isMoreRowAtIndexPath:indexPath]){
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
	    
	NSDictionary* product = [self getProductData:indexPath.section row:indexPath.row];
    [cell setCellInfoWithProductDictionary:product indexPath:indexPath];    
	
	return cell;
	
}

- (void)showProductByCategory:(int)section
{
    NSString* categoryId = [self getCategoryId:section];
    NSString* categoryName = [self getCategoryName:section];
    
    CommonProductListController* controller = [categoryControllerList objectForKey:categoryId];
    if (controller == nil){    
        controller = [[CommonProductListController alloc] init];        
        controller.categoryId = categoryId;
        controller.navigationItem.title = categoryName;
        controller.dataLoader = [[ProductCategoryDataLoader alloc] initWithCategoryId:categoryId];
    }
    
    [self.superController.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	   
    if ([self isMoreRowAtIndexPath:indexPath]){
        // last row, it's more row
        [self showProductByCategory:indexPath.section];
        [[self moreLoadingView] stopAnimating];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }

    NSDictionary* productDict = [self getProductData:indexPath.section row:indexPath.row];
    if (productDict == nil)
        return;
    
    // write to browse history
    Product* product = [ProductManager createProduct:productDict useFor:USE_FOR_HISTORY 
                                              offset:0 currentLocation:nil];
    
    BOOL isCreateHistory = NO;
    UINavigationController* navigationController;
    if (self.superController)
        navigationController = self.superController.navigationController;
    else   
        navigationController = self.navigationController;
    
    [ProductDetailController showProductDetail:product 
                          navigationController:navigationController
                               isCreateHistory:isCreateHistory];
    
}

@end


