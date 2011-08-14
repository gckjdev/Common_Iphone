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
#import "SBJsonWriter.h"

@implementation ProductManager

+ (NSString*)gpsFromDictionary:(NSDictionary*)dict
{
    SBJsonWriter *writer1 = [[SBJsonWriter alloc] init];            
    NSString* json = [writer1 stringWithObject:[dict objectForKey:PARA_GPS]]; 
    [writer1 release];
    return json;
}

+ (double)calcShortestDistance:(NSArray*)gpsArray currentLocation:(CLLocation*)currentLocation
{
    if (gpsArray && currentLocation){
        double distance = MAXFLOAT;
        for (CLLocation* location in gpsArray){
            double calc = [currentLocation distanceFromLocation:location];
            if (calc < distance){
                distance = calc; 
            }
        }
        
        return distance;
    }
    else{
        return MAXFLOAT;
    }
}

+ (NSArray*)gpsArray:(NSArray*)origArray
{
    NSArray* array = origArray;
    NSMutableArray* gpsArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSArray* valuePair in array){
        if (valuePair && [valuePair count] == 2){
            double latitude = [[valuePair objectAtIndex:0] doubleValue];
            double longitude = [[valuePair objectAtIndex:1] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];            
            [gpsArray addObject:location];
            [location release];
        }
    }
    
    if ([gpsArray count] > 0)
        return gpsArray;
    else
        return nil;
}

+ (Product*)createProduct:(NSDictionary*)productDict useFor:(int)useFor 
                   offset:(int)offset currentLocation:(CLLocation*)currentLocation
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
    NSString* productId = [productDict objectForKey:PARA_ID];
    
    if (useFor == USE_FOR_HISTORY){
        Product* productHistory = [ProductManager findProductHistoryById:productId];
        if (productHistory != nil){
            productHistory.browseDate = [NSDate date];
            productHistory.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
            [dataManager save];
            return productHistory;
        }
    }
    
    Product* product = [dataManager insert:@"Product"];
    product.productId = productId;
    product.title = [productDict objectForKey:PARA_TITLE];
    product.price = [productDict objectForKey:PARA_PRICE];
    product.rebate = [productDict objectForKey:PARA_REBATE];
    product.bought = [productDict objectForKey:PARA_BOUGHT];
    product.value = [productDict objectForKey:PARA_VALUE];
    product.startDate = dateFromUTCStringByFormat([productDict objectForKey:PARA_START_DATE], DEFAULT_DATE_FORMAT);
    product.endDate = dateFromUTCStringByFormat([productDict objectForKey:PARA_END_DATE], DEFAULT_DATE_FORMAT);
    product.image = [productDict objectForKey:PARA_IMAGE];
    product.loc = [productDict objectForKey:PARA_LOC];
    product.siteName = [productDict objectForKey:PARA_SITE_NAME];
    product.siteURL = [productDict objectForKey:PARA_SITE_URL];
    NSString* wapURL = [productDict objectForKey:PARA_WAP_URL];
    product.wapURL = wapURL;
    product.desc = [productDict objectForKey:PARA_DESC];
    product.offset = [NSNumber numberWithInt:offset];

    product.gps = [ProductManager gpsFromDictionary:productDict];
    
    SBJsonWriter *writer2 = [[SBJsonWriter alloc] init];                
    product.address = [writer2 stringWithObject:[productDict objectForKey:PARA_ADDRESS]];    
    [writer2 release];

    SBJsonWriter *writer3 = [[SBJsonWriter alloc] init];                
    product.tel = [writer3 stringWithObject:[productDict objectForKey:PARA_TEL]];    
    [writer3 release];
    
    NSArray* gpsArray = [ProductManager gpsArray:[productDict objectForKey:PARA_GPS]];
    product.distance = [NSNumber numberWithDouble:
                        [ProductManager calcShortestDistance:gpsArray
                                            currentLocation:currentLocation]];
    
//    product.longitude = [NSNumber numberWithDouble:longitude];
//    product.latitude = [NSNumber numberWithDouble:latitude];
    product.useFor = [NSNumber numberWithInt:useFor];
    product.deleteFlag = [NSNumber numberWithBool:NO];
    product.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    
//    NSLog(@"<createProduct> product=%@", [product description]);
    
    if ([dataManager save] == NO)
        return nil;
    else
        return product;
}

+ (BOOL)createProductForFavorite:(Product*)product
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    NSArray* array = [ProductManager getProductByIdUseFor:product.productId useFor:USE_FOR_FAVORITE];
    if (array != nil && [array count] > 0){
        Product* existProduct = [array objectAtIndex:0];
        existProduct.browseDate = [NSDate date];
        existProduct.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
        [dataManager save];
        return YES;
    }
    
    Product* favorProduct = [dataManager insert:@"Product"];
    [favorProduct copyFrom:product useFor:USE_FOR_FAVORITE];
    [dataManager save];
    
     NSLog(@"<createProductForFavorite> product=%@", [favorProduct description]);    
    return YES;
}

+ (BOOL)createProductHistory:(Product*)product
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    Product* productHistory = [ProductManager findProductHistoryById:product.productId];
    if (productHistory != nil){
        productHistory.browseDate = [NSDate date];
        productHistory.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
        [dataManager save];
        return YES;
    }
        
    productHistory = [dataManager insert:@"Product"];
    [productHistory copyFrom:product useFor:USE_FOR_HISTORY];    
    NSLog(@"<createProductHistory> product=%@", [productHistory description]);
    
    return [dataManager save];    
    
}

+ (NSArray*)getProductByIdUseFor:(NSString*)productId useFor:(int)useFor
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    NSArray* values = [NSArray arrayWithObjects:productId, [NSNumber numberWithInt:useFor], nil];
    NSArray* keys = [NSArray arrayWithObjects:@"PRODUCT_ID", @"USE_FOR", nil];
    NSDictionary* keyValues = [NSDictionary dictionaryWithObjects:values                                
                                                          forKeys:keys];
    
    return [dataManager execute:@"getProductByIdUseFor"
                      keyValues:keyValues
                         sortBy:@"useFor"
                      ascending:YES];    
        
    
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

+ (Product*)findProductHistoryById:(NSString*)productId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return (Product*)[dataManager execute:@"getProductHistoryById" 
                                       forKey:@"PRODUCT_ID" 
                                        value:productId];
}

+ (void)cleanData:(int)timeStamp
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* dataArray = [dataManager execute:@"getAllProductsForDelete" 
                                       forKey:@"beforeTimeStamp" 
                                        value:[NSNumber numberWithInt:timeStamp]
                                       sortBy:@"startDate"
                                    ascending:NO];
    
    for (Product* product in dataArray){
        [dataManager del:product];
    }
    
    [dataManager save];     
    
}

@end
