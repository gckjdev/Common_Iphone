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
#import "GroupBuyNetworkConstants.h"
#import "TimeUtils.h"

@implementation ProductManager

+ (BOOL)createProduct:(NSDictionary*)productDict useFor:(int)useFor
{
    
//    @property (nonatomic, retain) NSString * data;
//    @property (nonatomic, retain) NSNumber * useFor;
//    @property (nonatomic, retain) NSString * productId;
//    @property (nonatomic, retain) NSDate * startDate;
//    @property (nonatomic, retain) NSDate * endDate;
//    @property (nonatomic, retain) NSNumber * latitude;
//    @property (nonatomic, retain) NSDate * longitude;
//    @property (nonatomic, retain) NSNumber * price;
//    @property (nonatomic, retain) NSNumber * value;
//    @property (nonatomic, retain) NSNumber * rebate;
//    @property (nonatomic, retain) NSString * title;
//    @property (nonatomic, retain) NSString * loc;
//    @property (nonatomic, retain) NSString * image;
//    @property (nonatomic, retain) NSNumber * deleteFlag;
//    @property (nonatomic, retain) NSNumber * deleteTimeStamp;    
    
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    Product* product = [dataManager insert:@"Product"];
    product.productId = [productDict objectForKey:PARA_ID];
    product.title = [productDict objectForKey:PARA_TITLE];
    product.price = [productDict objectForKey:PARA_PRICE];
    product.rebate = [productDict objectForKey:PARA_REBATE];
    product.bought = [productDict objectForKey:PARA_BOUGHT];
    product.value = [productDict objectForKey:PARA_VALUE];
    product.startDate = dateFromStringByFormat([productDict objectForKey:PARA_START_DATE], DEFAULT_DATE_FORMAT);
    product.endDate = dateFromStringByFormat([productDict objectForKey:PARA_END_DATE], DEFAULT_DATE_FORMAT);
    product.image = [productDict objectForKey:PARA_IMAGE];
    product.loc = [productDict objectForKey:PARA_LOC];
    product.siteName = [productDict objectForKey:PARA_SITE_NAME];
    product.siteURL = [productDict objectForKey:PARA_SITE_URL];
    
//    product.longitude = [NSNumber numberWithDouble:longitude];
//    product.latitude = [NSNumber numberWithDouble:latitude];
    product.useFor = [NSNumber numberWithInt:useFor];
    product.deleteFlag = [NSNumber numberWithBool:NO];
    product.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    
    NSLog(@"<createProduct> product=%@", [product description]);
    
    return [dataManager save];    
}

+ (NSArray*)getAllProductsByUseFor:(int)useFor sortByKey:(NSString*)sortByKey sortAsending:(BOOL)sortAsending
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllProductsByUseFor"
                         forKey:@"USE_FOR" 
                          value:[NSNumber numberWithInt:useFor]
                         sortBy:sortByKey
                      ascending:sortAsending];    
    
}

+ (BOOL)deleteProductsByUseFor:(int)useFor
{
    NSLog(@"<deleteProductsByUseFor> useFor=%d", useFor);
    NSArray* ProductArray = [ProductManager getAllProductsByUseFor:useFor sortByKey:@"deleteFlag"  sortAsending:YES];
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
                                       sortBy:@"startDate"
                                    ascending:NO];
    
    for (Product* Product in dataArray){
        [dataManager del:Product];
    }
    
    [dataManager save];     
    
} 

@end
