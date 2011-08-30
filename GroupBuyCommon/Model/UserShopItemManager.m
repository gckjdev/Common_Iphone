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
    
    UserShoppingItem *shoppingItem = [dataManager insert:@"UserShoppingItem"];
    
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


@end
