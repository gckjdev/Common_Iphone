//
//  UserShoppItemManager.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserShopItemManager.h"
#import "CoreDataUtil.h"
#import "UserShoppingItem.h"

#define SPLIT @" "

@implementation UserShopItemManager

+ (BOOL)createShoppingItem:(NSString*)itemId 
                      city:(NSString*)city 
              categoryName:(NSString*)categoryName                        
           subCategoryName:(NSString*)subCategoryName 
                  keywords:(NSString*)keywords
                  maxPrice:(NSNumber*)maxPrice 
                expireDate:(NSDate*)expireDate
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    UserShoppingItem *shoppingItem = [UserShopItemManager getShoppingItemById:itemId];
    if (shoppingItem == nil) {
        shoppingItem = [dataManager insert:@"UserShoppingItem"];
    }
        shoppingItem.status = [NSNumber numberWithInt: ShoppingItemCountLoading];
        shoppingItem.matchCount = [NSNumber numberWithInt:0];
        shoppingItem.itemId = itemId;
        shoppingItem.city = city;
        shoppingItem.categoryName = categoryName;
        shoppingItem.subCategoryName = subCategoryName;
        shoppingItem.keywords = keywords;
        shoppingItem.maxPrice = maxPrice;
        shoppingItem.expireDate = expireDate;
        shoppingItem.createDate = [NSDate date];  
    
    return [dataManager save];
}


+ (UserShoppingItem *)getShoppingItemById:(NSString *)itemId
{
    if (itemId == nil) {
        return nil;
    }
    CoreDataManager *dataManager  = GlobalGetCoreDataManager();
    UserShoppingItem *item = (UserShoppingItem *)[dataManager execute:@"getShoppingItemByItemId" forKey:@"ITEM_ID" value:itemId];
    return item;
}


+ (NSArray *)getAllLocalShoppingItems
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllShoppingItems"];
}

#pragma -mark deal with data method

+ (NSArray *)getSubCategoryArrayWithCategoryName:(NSString *)categoryName
{
    if(categoryName == nil)
        return nil;
    return [categoryName componentsSeparatedByString:SPLIT];
}

+ (NSString *)getSubCategoryNameWithArray:(NSArray *)categoryArray
{
    if (categoryArray == nil) {
        return nil;
    }
    return [categoryArray componentsJoinedByString:SPLIT];
}

+ (void)removeItemForItemId:(NSString *)itemId
{
    
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    
    UserShoppingItem *item = [UserShopItemManager getShoppingItemById:itemId];
    if (item != nil) {
        [dataManager del:item];
    }
    [dataManager save];
}


+ (void)updateItemMatchCount:(NSNumber *)count itemId:(NSString *)itemId
{

    if (count == nil) {
        return;
    }
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    UserShoppingItem *item = [UserShopItemManager getShoppingItemById:itemId];
    if (item != nil) {
        
        item.status = [NSNumber numberWithInt: ShoppingItemCountOld];
        
        if ([item.matchCount intValue]!= [count intValue]) {
            item.status = [NSNumber numberWithInt: ShoppingItemCountNew];
        }
        
        item.matchCount = count;
        [dataManager save];
    }
}

+ (void)updateItemMatchCountStatus:(ShoppingItemCountStatus)status itemId:(NSString *)itemId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    UserShoppingItem *item = [UserShopItemManager getShoppingItemById:itemId];
    if (item != nil) {
        item.status = [NSNumber numberWithInt: status];
        [dataManager save];
    }
}

@end
