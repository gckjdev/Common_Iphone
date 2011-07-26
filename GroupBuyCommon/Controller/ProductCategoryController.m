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
    [productService requestProductDataByCategory:self];
    return;
}

- (void)productDataRefresh:(int)result jsonArray:(NSArray *)jsonArray
{    
    if (result == ERROR_SUCCESS){        
        self.dataList = jsonArray;
        [self.dataTableView reloadData];
    }
    
    if ([self isReloading]){
        [self dataSourceDidFinishLoadingNewData];
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
    supportRefreshHeader = YES;
    
    [self initDataList];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.dataList == nil || [self.dataList count] == 0){
        [self requestProductListFromServer:YES];
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
	    
	NSDictionary* product = [self getProductData:indexPath.section row:indexPath.row];
    [cell setCellInfoWithProductDictionary:product indexPath:indexPath];    
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	   
    if ([self isMoreRowAtIndexPath:indexPath]){
        // last row, it's more row
        // TODO : goto to view category product list
        return;
    }

    NSDictionary* productDict = [self getProductData:indexPath.section row:indexPath.row];
    if (productDict == nil)
        return;
    
    // write to browse history
    Product* product = [ProductManager createProduct:productDict useFor:USE_FOR_HISTORY];
    
    ProductDetailController* vc = [[ProductDetailController alloc] init];
    vc.product = product;
    if (self.superController)
        [self.superController.navigationController pushViewController:vc animated:YES];
    else   
        [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}

@end


