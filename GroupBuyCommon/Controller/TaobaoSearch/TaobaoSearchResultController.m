//
//  TaobaoSearchResultController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TaobaoSearchResultController.h"
#import "ProductService.h"
#import "PPApplication.h"
#import "TaobaoSearchResultCell.h"
#import "PPWebViewController.h"

@implementation TaobaoSearchResultController

@synthesize searchKeyword;
@synthesize price;
@synthesize value;

+ (TaobaoSearchResultController*)showController:(UIViewController*)superController 
                                        keyword:(NSString*)keyword
                                          price:(double)price
                                          value:(double)value

{
    TaobaoSearchResultController* vc = [[[TaobaoSearchResultController alloc] 
                                         initWithSearchKeyword:keyword] autorelease];    
    vc.price = price;
    vc.value = value;
    [superController.navigationController pushViewController:vc animated:YES];
    return vc;    
}

- (id)initWithSearchKeyword:(NSString*)keyword
{
    self = [super init];
    self.searchKeyword = keyword;
    return self;
}

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
    [searchKeyword release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)doSearch
{
    [self showActivityWithText:@"查询数据中，请稍候..."];
    ProductService* service = GlobalGetProductService();
    [service taobaoSearch:searchKeyword delegate:self];
}

- (void)taobaoSearchFinish:(int)result jsonArray:(NSArray *)jsonArray
{
    [self hideActivity];
    self.dataList = jsonArray;
    [[self dataTableView] reloadData];
    
    if ([self.dataList count] == 0){
        [UIUtils alert:@"没有找到对应的淘宝商品，可以尝试其他搜索关键字重新搜索一下？"];
    }
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"淘宝比价结果";
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [self setBackgroundImageName:@"background.png"];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self doSearch];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TaobaoSearchResultCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaobaoSearchResultCell";
	TaobaoSearchResultCell *cell = (TaobaoSearchResultCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [TaobaoSearchResultCell createCell:self];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *taobaoProduct = [self.dataList objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    [cell setCellInfoWithProduct:taobaoProduct 
                       indexPath:indexPath
                           price:price
                           value:value];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *taobaoProduct = [self.dataList objectAtIndex:indexPath.row];
    NSString* url = [taobaoProduct objectForKey:@"product_site"];
    [self.navigationController pushViewController:GlobalGetPPWebViewController() animated:YES];
    [GlobalGetPPWebViewController() openURL:url];
}


@end
