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
@implementation ShoppingListController

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
    
    [self setNavigationRightButton:@"添加" action:@selector(clickAdd:)];
    [self setBackgroundImageName:@"background.png"];

    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    // reload data
    
    self.dataList = [UserShopItemManager getAllLocalShoppingItems];
    
    int i = 0;
    
    for (UserShoppingItem *item in dataList) {
        NSLog(@"data%d: item subscategory=%@",++i,item.keywords);
    }
    
    // reload table view
    [self.dataTableView reloadData];

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
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

- (void)setShoppingListCell:(ShoppingListCell*)cell UserShoppingItem:(UserShoppingItem *)item
{
    NSString *category = item.categoryName;
    
    NSArray *subCategories = [UserShopItemManager getSubCategoryArrayWithCategoryName:item.subCategoryName];
    
    NSString *subCategoryName = [subCategories componentsJoinedByString:@" "];

    NSString *keywords = item.keywords;

    NSInteger maxPrice = [item.maxPrice intValue];
    
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
    
    if (maxPrice < 0) {
        cell.priceLabel.text = @"可接受价格：不限";
    }else
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"可接受价格：%d",maxPrice];
    }
    
    if (item.expireDate == nil) {
        cell.validPeriodLabel.text = @"有效期：不限";
    }else{
        
        cell.validPeriodLabel.text = [NSString stringWithFormat:@"有效期：%@",dateToString(item.expireDate)];
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
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (section == 0 && row <[self.dataList count]) {
        UserShoppingItem *item = [dataList objectAtIndex:row];
        
        [UserShopItemManager removeItemForItemId:item.itemId];
        self.dataList = [UserShopItemManager getAllLocalShoppingItems];
        
        [self.dataTableView beginUpdates];        
        [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.dataTableView endUpdates];
    }
    
}

#pragma button actions
#pragma -

- (void)clickAdd:(id)sender {
    
    AddShoppingItemController* vc = [[AddShoppingItemController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)clickEdit:(id)sender atIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row >= [dataList count])
        return;
        
    UserShoppingItem *item = [dataList objectAtIndex:indexPath.row];
    AddShoppingItemController* vc = [[AddShoppingItemController alloc] initWithUserShoppingItem:item];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
@end
