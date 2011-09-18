//
//  ShoppingListController.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ShoppingListCell.h"
#import "UserShopItemService.h"

@class AddShoppingItemController;

@interface ShoppingListController : PPTableViewController <ShoppingListCellDelegate, UserShopItemServiceDelegate> {

    UILabel *helpLabel;
    int     tabIndex;
    AddShoppingItemController *addShoppingItemController;
    UserShopItemService *service;
}

@property (nonatomic, retain) IBOutlet UILabel *helpLabel;
@property (nonatomic, assign) int               tabIndex;
@property (nonatomic, retain) AddShoppingItemController *addShoppingItemController;
@property (nonatomic, assign) UserShopItemService *service;
- (void)updateTabBadge:(NSString*)value;

@end
