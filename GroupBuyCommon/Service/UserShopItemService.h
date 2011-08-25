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

@protocol UserShopItemServiceDelegate <NSObject>

- (void)itemActionDone:(int)result;

@end

@interface UserShopItemService : CommonService {
    
    NSObject<UserShopItemServiceDelegate>   *delegate;
}

- (void)addUserShoppingItem:(NSString*)itemId
                                       city:(NSString*)city
                               categoryName:(NSString*)categoryName
                            subCategoryName:(NSString*)subCategoryName
                                   keywords:(NSString*)keywords
                                   maxPrice:(NSNumber*)maxPrice
                                  minRebate:(NSNumber*)minRebate;

@property (nonatomic, assign) NSObject<UserShopItemServiceDelegate>   *delegate;

@end

extern UserShopItemService* GlobalGetUserShopItemService();