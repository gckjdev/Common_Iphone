//
//  ProductManager.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductManager.h"
#import "CoreDataUtil.h"
#import "Product.h"

@implementation ProductManager


+ (NSArray*)getAllProductsByUseFor:(int)useFor sortByKey:(NSString*)sortByKey
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllProductsByUseFor"
                         forKey:@"USE_FOR" 
                          value:[NSNumber numberWithInt:useFor]
                         sortBy:sortByKey
                      ascending:NO];    
    
}

+ (BOOL)deleteProductsByUseFor:(int)useFor
{
    NSArray* ProductArray = [ProductManager getAllProductsByUseFor:useFor sortByKey:@"deleteFlag"];
    for (Product* Product in ProductArray){
        Product.deleteFlag = [NSNumber numberWithBool:YES];
        Product.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    }
    
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return [dataManager save]; 
}



+ (void)cleanUpDeleteDataBefore:(int)timeStamp
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* dataArray = [dataManager execute:@"getAllProductsForDelete" 
                                       forKey:@"beforeTimeStamp" 
                                        value:[NSNumber numberWithInt:timeStamp]
                                       sortBy:@"createDate"
                                    ascending:NO];
    
    for (Product* Product in dataArray){
        [dataManager del:Product];
    }
    
    [dataManager save];     
    
} 

@end
