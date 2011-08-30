//
//  UserShoppItemManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserShopItemManager : NSObject {
    
}

+ (BOOL)createShoppingItem:(NSString*)itemId 
                      city:(NSString*)city 
              categoryName:(NSString*)categoryName                        
           subCategoryName:(NSString*)subCategoryName 
                  keywords:(NSString*)keywords
                  maxPrice:(NSNumber*)maxPrice 
                expireDate:(NSDate*)expireDate;


@end
