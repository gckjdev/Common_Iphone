//
//  UserShoppItemManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserShoppingItem.h"


@interface UserShopItemManager : NSObject {
    
}

+ (BOOL)createShoppingItem:(NSString*)itemId 
                      city:(NSString*)city 
              categoryName:(NSString*)categoryName                        
           subCategoryName:(NSString*)subCategoryName 
                  keywords:(NSString*)keywords
                  maxPrice:(NSNumber*)maxPrice 
                expireDate:(NSDate*)expireDate;

+ (UserShoppingItem *)getShoppingItemById:(NSString *)itemId;

+ (NSString *)getSubCategoryNameWithArray:(NSArray *)categoryArray;

+ (NSArray *)getSubCategoryArrayWithCategoryName:(NSString *)categoryName;

+ (NSArray *)getAllLocalShoppingItems;

+ (void)removeItemForItemId:(NSString *)itemId;
+ (void)updateItemMatchCount:(NSNumber *)count itemId:(NSString *)itemId;

+ (void)updateItemMatchCountStatus:(ShoppingItemCountStatus)status itemId:(NSString *)itemId;
@end
