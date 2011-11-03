//
//  ShoppingListController.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "ShoppingListController.h"
#import "AddShoppingItemController.h"
#import "ShoppingListCell.h"
#import "UserShopItemManager.h"
#import "UserShoppingItem.h"
#import "TimeUtils.h"
#import "ShoppingValidPeriodCell.h"
#import "UserShopItemService.h"
#import "ProductManager.h"
#import "CommonProductListController.h"
#import "ProductPriceDataLoader.h"
#import "groupbuyAppDelegate.h"
#import "NetworkRequestResultCode.h"


@implementation ShoppingListController

@synthesize helpLabel;
@synthesize tabIndex;
@synthesize addShoppingItemController;
@synthesize service;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.service = GlobalGetUserShopItemService();
    [self.service setUserShopItemServiceDelegate:self];

    [self setNavigationLeftButton:nil imageName:@"tu_66.png" action:@selector(clickRefresh:) hasEdgeInSet:YES];
    [self setNavigationRightButton:nil imageName:@"tu_80.png" action:@selector(clickAdd:) hasEdgeInSet:YES];
    
    [self setBackgroundImageName:@"background.png"];

    self.helpLabel.hidden = YES;
    self.helpLabel.text = @"团购通知可以帮助您找到您想要购买的商品是否有对应团购。操作如下：\n\n\
1）添加一个或者多个近期想要购买的商品的信息；\n\n\
2）系统实时匹配找到您所需要的团购商品并且显示；\n\n\
3）如果当前没有找到匹配的团购商品，系统会自动发现有满足您的团购新商品时，以消息推送的方式告知您。\n\n\
注：消息推送请确认打开了应用程序的推送通知功能。\n\n\
点击右上角的按钮，马上添加你感兴趣的团购项吧！";
        
    [super viewDidLoad];
    [self clickRefresh:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    // reload data
    
    self.dataList = [UserShopItemManager getAllLocalShoppingItems];
    // reload table view
    [self.dataTableView reloadData];
    
    if ([self.dataList count] == 0){
        [self popupMessage:@"您还没有添加任何你感兴趣的团购目标，点击右上角的按钮添加一个你想要团购的物品信息吧！" title:@""];
        
        self.helpLabel.hidden = NO;
    }
    else{
        self.helpLabel.hidden = YES;
    }

    [super viewDidAppear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setHelpLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [helpLabel release];
    [addShoppingItemController release];
    [super dealloc];
}

#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ShoppingListCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [dataList count];
    }
    return 0;
}

- (void)updateTabBadge:(NSString*)value
{
    [[[[self.tabBarController tabBar] items] objectAtIndex:tabIndex] setBadgeValue:value];
}

- (void)setShoppingListCell:(ShoppingListCell*)cell UserShoppingItem:(UserShoppingItem *)item
{
    NSString *category = item.categoryName;
    
    NSArray *subCategories = [UserShopItemManager getSubCategoryArrayWithCategoryName:item.subCategoryName];
    
    NSString *subCategoryName = [subCategories componentsJoinedByString:@" "];

    NSString *keywords = item.keywords;

    NSInteger maxPrice = [item.maxPrice intValue];
    
    NSInteger matchCount = [item.matchCount intValue];

    if (category == nil) {
        category = NOT_LIMIT;
    }
    if (subCategoryName == nil) {
        subCategoryName = @"";
    }
    if (keywords == nil) {
        keywords = @"";
    }
                
    cell.keyWordsLabel.text = [NSString stringWithFormat:@"%@ %@ %@",keywords,category,subCategoryName];

    switch ([item.status intValue]) {
        case ShoppingItemCountLoading:
        {
            [cell.loadingIndicator setHidden:NO];
            [cell.loadingIndicator startAnimating];
            [cell.matchCountLabel setHidden:YES];
        }
            break;
            
        case ShoppingItemCountNew:
        {    
            [cell.loadingIndicator stopAnimating];
            cell.matchCountLabel.text = [NSString stringWithFormat:@"团 (%d)",matchCount];
            cell.matchCountLabel.textColor = [UIColor redColor];
            [cell.matchCountLabel setHidden:NO];
            
            [self updateTabBadge:@"新"];
        }
            break;
        case ShoppingItemCountOld:
        {
            [cell.loadingIndicator stopAnimating];
            cell.matchCountLabel.text = [NSString stringWithFormat:@"团 (%d)",matchCount];
            cell.matchCountLabel.textColor = [UIColor blackColor];
            [cell.matchCountLabel setHidden:NO];
            
        }
            break;
            
        default:
            break;
    }
    
    
    if (maxPrice <= 0) {
        cell.priceLabel.text = @"可接受价格：不限";
    }else
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"可接受价格：%d",maxPrice];
    }
    
    if (item.expireDate == nil) {
        cell.validPeriodLabel.text = @"有效期：不限";
    }else{
        
        cell.validPeriodLabel.text = [NSString stringWithFormat:@"有效期：%@",dateToChineseString(item.expireDate)];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    

    NSString *CellIdentifier = [ShoppingListCell getCellIdentifier];
	ShoppingListCell *cell = (ShoppingListCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [ShoppingListCell createCell:self];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    cell.indexPath = indexPath;
	
    NSInteger row = [indexPath row];
    if (row >= [dataList count] || [indexPath section] > 0) {
        return nil;
    }
    
    UserShoppingItem *item = [dataList objectAtIndex:indexPath.row];
    [self setShoppingListCell:cell UserShoppingItem:item];
    
    
     return cell;	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
	if (indexPath.row > [dataList count] - 1)
		return;
    
   // [ProductManager deleteProductsByUseFor:USE_FOR_KEYWORD];
	
    
    UserShoppingItem *item = [self.dataList objectAtIndex:indexPath.row];
    if (item == nil) {
        return;
    }
    
    [UserShopItemManager updateItemMatchCountStatus:ShoppingItemCountOld itemId:item.itemId];
    
	CommonProductListController *shoppingItemProductsController = [[CommonProductListController alloc] init];
	shoppingItemProductsController.superController = self;
	shoppingItemProductsController.dataLoader = [[ProductShoppingItemDataLoader alloc] initWithShoppingItemId:[item itemId]];
	shoppingItemProductsController.navigationItem.title = @"团购推荐结果列表"; 
	[shoppingItemProductsController setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
	[self.navigationController pushViewController:shoppingItemProductsController animated:YES];
	[shoppingItemProductsController release];
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (section == 0 && row <[self.dataList count]) {
        UserShoppingItem *item = [dataList objectAtIndex:row];
        
        //UserShopItemService *service = GlobalGetUserShopItemService();
        [self.service deleteUserShoppingItem:item.itemId];
        
    }
    
}

#pragma button actions
#pragma -

- (void)clickAdd:(id)sender {
    
    if (self.addShoppingItemController == nil) {
        self.addShoppingItemController = [[AddShoppingItemController alloc]init];
    }else{
        [self.addShoppingItemController updateCellWithItem:nil];
    }
    self.addShoppingItemController.navigationItem.title = @"添加感兴趣的团购";
    [self.navigationController pushViewController:self.addShoppingItemController animated:YES];
}

- (void)clickEdit:(id)sender atIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row >= [dataList count])
        return;
    UserShoppingItem *item = [dataList objectAtIndex:indexPath.row];
    
    if (self.addShoppingItemController == nil) {
        self.addShoppingItemController = [[AddShoppingItemController alloc]initWithUserShoppingItem:item];
    }else{
        [self.addShoppingItemController updateCellWithItem:item];
    }
    self.addShoppingItemController.navigationItem.title = @"编辑团购项";
    [self.navigationController pushViewController:self.addShoppingItemController animated:YES];
}


-(void)clickRefresh:(id)sender
{
    [self.service updateUserShoppingItemCountList];
}

#pragma delegate


- (void)didBeginUpdateShoppingItem:(NSString *)message
{
    [self.addShoppingItemController showActivityWithText:message];
}

- (void)didEndUpdateShoppingItemWithResultCode:(NSInteger)code
{
    [self.addShoppingItemController hideActivity];
    NSLog(@"end hide activity");
    if (code == ERROR_SUCCESS) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (code == ERROR_NETWORK){
        [self.addShoppingItemController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
    }else{
        [self.addShoppingItemController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
    }
}

- (void)didBeginLoadMatchCount:(NSArray *)itemIds
{
    for(NSString *itemId in itemIds){
        [UserShopItemManager updateItemMatchCountStatus:ShoppingItemCountLoading itemId:itemId];
    }
    [self.dataTableView reloadData];
}
- (void)didLoadMatchCountSuccess:(NSString *)itemId matchCount:(NSNumber *)count
{
    [UserShopItemManager updateItemMatchCount:count itemId:itemId];
    self.dataList = [UserShopItemManager getAllLocalShoppingItems];
    [self.dataTableView reloadData];

}
- (void)didLoadMatchCountFailed:(NSArray *)itemIds errorCode:(NSInteger)code
{
    if (code == ERROR_NETWORK){
        [self.addShoppingItemController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
    }else{
        [self.addShoppingItemController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
    }
}

- (void)didEndDeleteItem:(NSString *)itemId Code:(NSInteger)code
{
    [self hideActivity];
    if (code == ERROR_SUCCESS) {
        [self.navigationController popViewControllerAnimated:YES];
        [self refreshShoppingList];
    }else if (code == ERROR_NETWORK){
        [self.addShoppingItemController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
    }else{
        [self.addShoppingItemController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
    }
}

- (void)didBeginDeleteItem:(NSString *)message
{
    [self showActivityWithText:message];
}

- (void)refreshShoppingList
{
    self.dataList = [UserShopItemManager getAllLocalShoppingItems];
    [self.dataTableView reloadData];
    
}

@end
