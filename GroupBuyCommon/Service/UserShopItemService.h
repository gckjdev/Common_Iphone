//
//  UserShopItemService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "GroupBuyNetworkRequest.h"
#import "PPViewController.h"
#import "PPTableViewController.h"

typedef enum {
    CreateShoppingItem = 0,    // shows glow when pressed
    UpdateShoppingItem = 1
} ShoppingItemHandleType;

@class AddShoppingItemController;

@protocol UserShopItemServiceDelegate <NSObject>

- (void)itemActionDone:(int)result;

@end

@interface UserShopItemService : CommonService {
    
    NSObject<UserShopItemServiceDelegate>   *delegate;
}

+ (NSString*)generateItemId;
- (void)addUserShoppingItem:(NSString*)city
               categoryName:(NSString*)categoryName
            subCategories:(NSArray*)subCategories
                   keywords:(NSString*)keywords
                   maxPrice:(NSNumber*)maxPrice
                 expireDate:(NSDate*)expireDate 
                     rebate:(NSNumber *)rebate 
             viewController:(AddShoppingItemController *)viewController;


- (void)updateUserShoppingItem:(NSString*)itemId
                       city:(NSString*)city
               categoryName:(NSString*)categoryName
            subCategories:(NSArray*)subCategories
                   keywords:(NSString*)keywords
                   maxPrice:(NSNumber*)maxPrice
                 expireDate:(NSDate*)expireDate 
                        rebate:(NSNumber *)rebate 
                viewController:(AddShoppingItemController *)viewController;


- (void)handleUserShoppingItem:(NSString*)itemId
                          city:(NSString*)city
                  categoryName:(NSString*)categoryName
                 subCategories:(NSArray*)subCategories
                      keywords:(NSString*)keywords
                      maxPrice:(NSNumber*)maxPrice
                    expireDate:(NSDate*)expireDate 
                        rebate:(NSNumber *)rebate 
                viewController:(AddShoppingItemController *)viewController 
                    handleType:(ShoppingItemHandleType)handleType;

- (void)updateUserShoppingItemCountList:(PPTableViewController *)tableViewController;

- (void)deleteUserShoppingItem:(NSString*)itemId viewController:(PPViewController *)viewController indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, assign) NSObject<UserShopItemServiceDelegate>   *delegate;

@end

extern UserShopItemService* GlobalGetUserShopItemService();