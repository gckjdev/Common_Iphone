//
//  ProductManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Product;

enum {
    USE_FOR_CATEGORY,
    USE_FOR_PRICE,
    USE_FOR_VALUE,
    USE_FOR_DISTANCE,
    USE_FOR_BOUGHT,
    USE_FOR_REBATE,
    USE_FOR_HISTORY,
    USE_FOR_KEYWORD,
    USE_FOR_FAVORITE,
    USE_FOR_TOPSCORE_BELOW_TEN,
    USE_FOR_TOPSCORE_ABOVE_TEN,
    USE_FOR_STARTDATE,
    USE_FOR_END_DATE,
    USE_FOR_SITE_ID,
    USE_FOR_CATEGORY_TOPSCORE_BELOW_TEN = 100,
    USE_FOR_CATEGORY_TOPSCORE_ABOVE_TEN = 500,
    USE_FOR_CATEGORY_STARTDATE = 1000,
    USE_FOR_CATEGORY_DISTANCE = 1500,
    USE_FOR_CATEGORY_ENDDATE = 2000,
    USE_FOR_PER_CATEGORY = 5000,
    USE_FOR_PER_SHOPPINGITEM = 100000000
};

@interface ProductManager : NSObject {
    
}

+ (Product*)createProduct:(NSDictionary*)productDict useFor:(int)useFor offset:(int)offset currentLocation:(CLLocation*)currentLocation;
+ (BOOL)createProductHistory:(Product*)product;
+ (BOOL)createProductForFavorite:(Product*)product;

+ (NSArray*)getAllProductsByUseFor:(int)useFor sortByKey:(NSString*)sortByKey sortAsending:(BOOL)sortAsending;
+ (NSArray*)getProductByIdUseFor:(NSString*)productId useFor:(int)useFor;
+ (BOOL)deleteProductsByUseFor:(int)useFor;

+ (void)cleanUpDeleteDataBefore:(int)timeStamp;

+ (Product*)findProductHistoryById:(NSString*)productId;

+ (NSString*)gpsFromDictionary:(NSDictionary*)dict;
+ (NSArray*)gpsArray:(NSArray*)origArray;
+ (double)calcShortestDistance:(NSArray*)gpsArray currentLocation:(CLLocation*)currentLocation;

+ (void)cleanData:(int)timeStamp;


@end
