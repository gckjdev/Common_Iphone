//
//  ProductManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    USE_FOR_CATEGORY,
    USE_FOR_PRICE,
    USE_FOR_VALUE,
    USE_FOR_DISTANCE,
    USE_FOR_BOUGHT
};

@interface ProductManager : NSObject {
    
}

+ (BOOL)createProduct:(NSDictionary*)productDict useFor:(int)useFor;
+ (NSArray*)getAllProductsByUseFor:(int)useFor sortByKey:(NSString*)sortByKey;
+ (BOOL)deleteProductsByUseFor:(int)useFor;

+ (void)cleanUpDeleteDataBefore:(int)timeStamp;

@end
