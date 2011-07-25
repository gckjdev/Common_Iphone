//
//  ProductManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;

enum {
    USE_FOR_CATEGORY,
    USE_FOR_PRICE,
    USE_FOR_VALUE,
    USE_FOR_DISTANCE,
    USE_FOR_BOUGHT,
    USE_FOR_REBATE,
    USE_FOR_HISTORY = 6
};

@interface ProductManager : NSObject {
    
}

+ (BOOL)createProduct:(NSDictionary*)productDict useFor:(int)useFor;
+ (BOOL)createProductHistory:(Product*)product;
+ (NSArray*)getAllProductsByUseFor:(int)useFor sortByKey:(NSString*)sortByKey sortAsending:(BOOL)sortAsending;
+ (BOOL)deleteProductsByUseFor:(int)useFor;

+ (void)cleanUpDeleteDataBefore:(int)timeStamp;

+ (Product*)findProductHistoryById:(NSString*)productId;

@end
