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
@class UserShoppingItem;

@protocol UserShopItemServiceDelegate <NSObject>

@required
- (void)didBeginUpdateShoppingItem:(NSString *)message;

- (void)didEndUpdateShoppingItemWithResultCode:(NSInteger)code;

- (void)didBeginLoadMatchCount:(NSArray *)itemIds;
- (void)didLoadMatchCountSuccess:(NSString *)itemId matchCount:(NSNumber *)count;
- (void)refreshShoppingList;
- (void)didLoadMatchCountFailed:(NSArray *)itemIds errorCode:(NSInteger)code;

- (void)didBeginDeleteItem:(NSString *)message;
- (void)didEndDeleteItem:(NSString *)itemId Code:(NSInteger)code;

@optional
- (void)itemActionDone:(int)result;

@end

@interface UserShopItemService : CommonService {
    
    NSObject<UserShopItemServiceDelegate>   *userShopItemServiceDelegate;
}


+ (NSString*)generateItemId;

- (void)addUserShoppingItem:(NSString*)city
               categoryName:(NSString*)categoryName
              subCategories:(NSArray*)subCategories
                   keywords:(NSString*)keywords
                   maxPrice:(NSNumber*)maxPrice
                 expireDate:(NSDate*)expireDate 
                   latitude:(NSNumber *)latitude 
                  longitude:(NSNumber *)longitude 
                     radius:(NSNumber *)radius
                     rebate:(NSNumber *)rebate;

- (void)updateUserShoppingItem:(NSString *)itemId 
                          city:(NSString*)city
               categoryName:(NSString*)categoryName
              subCategories:(NSArray*)subCategories
                   keywords:(NSString*)keywords
                   maxPrice:(NSNumber*)maxPrice
                 expireDate:(NSDate*)expireDate 
                   latitude:(NSNumber *)latitude 
                  longitude:(NSNumber *)longitude 
                     radius:(NSNumber *)radius
                     rebate:(NSNumber *)rebate;

- (void)refreshUserShoppingItemMatchCount:(NSArray *)itemIds appId:(NSString *)appId userId:(NSString *)userId;

- (void)updateUserShoppingItemCountList;

- (void)deleteUserShoppingItem:(NSString*)itemId;

- (void)requestItemMatchCount:(NSString*)itemId;


@property (nonatomic,assign) NSObject<UserShopItemServiceDelegate>   *userShopItemServiceDelegate;


@end

extern UserShopItemService* GlobalGetUserShopItemService();