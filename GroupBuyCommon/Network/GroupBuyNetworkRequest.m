//
//  GroupBuyNetworkRequest.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupBuyNetworkRequest.h"
#import "GroupBuyNetworkConstants.h"
#import "PPNetworkRequest.h"
#import "StringUtil.h"
#import "JSON.h"
#import "LocaleUtils.h"

@implementation GroupBuyNetworkRequest

+ (CommonNetworkOutput *)getAllCategory:(NSString *)baseURL
                                  appId:(NSString *)appId
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_GETALLCATEGORY];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        NSLog(@"<getAllCategory> data=%@", [output.jsonDataArray description]);
        return;
    };
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput*)deviceLogin:(NSString*)baseURL
                              appId:(NSString*)appId
                     needReturnUser:(BOOL)needReturnUser
                        deviceToken:(NSString*)deviceToken
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    NSString* deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:METHOD
                                       value:METHOD_DEVICELOGIN];
        str = [str stringByAddQueryParameter:PARA_APPID
                                       value:appId];
        str = [str stringByAddQueryParameter:PARA_DEVICEID
                                       value:deviceId];
        str = [str stringByAddQueryParameter:PARA_NEED_RETURN_USER
                                    intValue:needReturnUser];

        if (deviceToken != nil)
            str = [str stringByAddQueryParameter:PARA_DEVICETOKEN
                                           value:deviceToken];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataDict = [dict objectForKey:RET_DATA];
        NSLog(@"<deviceLogin> data=%@", [output.jsonDataDict description]);
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}



+ (CommonNetworkOutput*)findAllProducts:(NSString*)baseURL
                                  appId:(NSString*)appId
                            startOffset:(int)startOffset
                                   city:(NSString*)city
                                 method:(NSString*)method

{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    const int MAX_COUNT = 10;
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
                
        str = [str stringByAddQueryParameter:METHOD value:method];
        str = [str stringByAddQueryParameter:PRAR_START_OFFSET intValue:startOffset];
        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:MAX_COUNT];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_CITY value:city];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}

+ (CommonNetworkOutput*)findAllProductsWithPrice:(NSString*)baseURL
                                           appId:(NSString*)appId
                                     startOffset:(int)startOffset
                                            city:(NSString*)city
{
    
    return [GroupBuyNetworkRequest findProducts:baseURL appId:appId city:city 
                                    hasLocation:NO longitude:0.0 latitude:0.0 
                                    maxDistance:DEFAULT_MAX_DISTANCE
                                      todayOnly:NO category:nil sortBy:SORT_BY_PRICE 
                                    startOffset:startOffset maxCount:DEFAULT_MAX_COUNT];
    
//    return [GroupBuyNetworkRequest findAllProducts:baseURL                                               
//                                             appId:appId                                      
//                                       startOffset:startOffset                                                                        
//                                              city:city                                       
//                                            method:METHOD_FINDPRODUCTWITHPRICE];
}

+ (CommonNetworkOutput*)findAllProductsWithBought:(NSString*)baseURL
                                           appId:(NSString*)appId
                                     startOffset:(int)startOffset
                                            city:(NSString*)city
{
    return [GroupBuyNetworkRequest findProducts:baseURL appId:appId city:city hasLocation:NO longitude:0.0 latitude:0.0
                                    maxDistance:DEFAULT_MAX_DISTANCE
                                      todayOnly:NO category:nil sortBy:SORT_BY_BOUGHT startOffset:startOffset
                                       maxCount:DEFAULT_MAX_COUNT];
}

+ (CommonNetworkOutput*)findAllProductsWithRebate:(NSString*)baseURL
                                           appId:(NSString*)appId
                                     startOffset:(int)startOffset
                                            city:(NSString*)city
{
    return [GroupBuyNetworkRequest findProducts:baseURL appId:appId city:city hasLocation:NO longitude:0.0 latitude:0.0
                                    maxDistance:DEFAULT_MAX_DISTANCE
                                      todayOnly:NO category:nil sortBy:SORT_BY_REBATE startOffset:startOffset
            maxCount:DEFAULT_MAX_COUNT];
}

+ (CommonNetworkOutput*)findAllProductsWithStartDate:(NSString*)baseURL
                                            appId:(NSString*)appId
                                      startOffset:(int)startOffset
                                             city:(NSString*)city
                                            category:(NSString *)category
{
    return [GroupBuyNetworkRequest findProducts:baseURL appId:appId city:city hasLocation:NO longitude:0.0 latitude:0.0
                                    maxDistance:DEFAULT_MAX_DISTANCE
                                      todayOnly:NO category:category sortBy:SORT_BY_START_DATE startOffset:startOffset
                                       maxCount:DEFAULT_MAX_COUNT];
}

+ (CommonNetworkOutput*)findAllProductsWithLocation:(NSString*)baseURL
                                              appId:(NSString*)appId
                                               city:(NSString*)city
                                           latitude:(double)latitude
                                          longitude:(double)longitude
                                        startOffset:(int)startOffset
                                           category:(NSString *)category
{
//    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
//    
//    const int MAX_COUNT = 10;
//    
//    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
//        
//        // set input parameters
//        NSString* str = [NSString stringWithString:baseURL];       
//        
//        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDPRODUCTWITHLOCATION];
//        str = [str stringByAddQueryParameter:PRAR_START_OFFSET intValue:startOffset];
//        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:MAX_COUNT];
//        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
//        str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
//        str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
//        
//        return str;
//    };
//    
//    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
//        
//        // parse response data and set into output object
//        output.jsonDataArray = [dict objectForKey:RET_DATA];
//        return;
//    }; 
//    
//    return [PPNetworkRequest sendRequest:baseURL
//                     constructURLHandler:constructURLHandler
//                         responseHandler:responseHandler
//                                  output:output];
    
    return [GroupBuyNetworkRequest findProducts:baseURL appId:appId city:city hasLocation:YES 
                                      longitude:longitude  latitude:latitude  
                                    maxDistance:DEFAULT_MAX_DISTANCE todayOnly:NO category:category 
                                         sortBy:SORT_BY_START_DATE startOffset:startOffset
                                       maxCount:DEFAULT_MAX_COUNT];

}

+ (CommonNetworkOutput*)findAllProductsGroupByCategory:(NSString*)baseURL
                                                 appId:(NSString*)appId
                                                  city:(NSString*)city
                                             todayOnly:(BOOL)todayOnly
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    const int MAX_COUNT = 5;
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDPRODUCTSGROUPBYCATEGORY];
        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:MAX_COUNT];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_CITY value:city];
        
        if (todayOnly){
            str = [str stringByAddQueryParameter:PARA_TODAY_ONLY intValue:todayOnly];            
        }

        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
//    return [GroupBuyNetworkRequest findProducts:baseURL appId:appId city:city hasLocation:NO longitude:0.0 latitude:0.0 todayOnly:NO category:nil sortBy:SORT_BY_START_DATE startOffset:0];
}

+ (CommonNetworkOutput *)findAllProductsByScore:(NSString *)baseURL
                                            appId:(NSString *)appId
                                      startOffset:(int)startOffset
                                             city:(NSString *)city
                                       startPrice:(NSNumber *)startPrice
                                         endPrice:(NSNumber *)endPrice
                                       category:(NSString *)category
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDPRODUCTSBYSCORE];
        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:DEFAULT_MAX_COUNT];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_CITY value:city];
        str = [str stringByAddQueryParameter:PARA_START_OFFSET intValue:startOffset];
        if (nil != startPrice) {
            str = [str stringByAddQueryParameter:PARA_START_PRICE intValue:[startPrice intValue]];
        }
        if (nil != endPrice) {
            str = [str stringByAddQueryParameter:PARA_END_PRICE intValue:[endPrice intValue]];
        }
        if ([category length] > 0) {
            str = [str stringByAddQueryParameter:PARA_CATEGORIES value:category];
        }
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    };
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput*)findProducts:(NSString*)baseURL
                               appId:(NSString*)appId
                                city:(NSString*)city
                         hasLocation:(BOOL)hasLocation
                           longitude:(double)longitude
                            latitude:(double)latitude
                         maxDistance:(double)maxDistance
                           todayOnly:(BOOL)todayOnly
                            category:(NSString*)category
                              sortBy:(int)sortBy
                         startOffset:(int)startOffset
                            maxCount:(int)maxCount
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDPRODUCTS];
        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:maxCount];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_CITY value:city];
        
        if (hasLocation){
            str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
            str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
            str = [str stringByAddQueryParameter:PARA_MAX_DISTANCE intValue:maxDistance];
        }
        
        if (todayOnly){
            str = [str stringByAddQueryParameter:PARA_TODAY_ONLY intValue:1];
        }
        
        if ([category length] > 0){
            str = [str stringByAddQueryParameter:PARA_CATEGORIES value:category];            
        }
        
        str = [str stringByAddQueryParameter:PARA_START_OFFSET intValue:startOffset];
        str = [str stringByAddQueryParameter:PARA_SORT_BY intValue:sortBy];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}


+ (CommonNetworkOutput*)getShoppingItemProducts:(NSString*)baseURL 
                            userId:(NSString*)userId
                               appId:(NSString*)appId
                                itemId:(NSString*)itemId
                         startOffset:(int)startOffset
                            maxCount:(int)maxCount
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDPRODUCTSBYSHOPPINGITEMID];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_ITEMID value:itemId];
        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:maxCount];        
        str = [str stringByAddQueryParameter:PARA_START_OFFSET intValue:startOffset];
        str = [str stringByAddQueryParameter:PARA_REQUIRE_MATCH intValue:1];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}


+ (CommonNetworkOutput*)registerUserDevice:(NSString*)baseURL
                                     appId:(NSString*)appId
                               deviceToken:(NSString*)deviceToken
{
    static const int OS_IOS = 1;
    
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_REGISTERDEVICE];
        str = [str stringByAddQueryParameter:PARA_DEVICEID value:[[UIDevice currentDevice] uniqueIdentifier]];
        str = [str stringByAddQueryParameter:PARA_DEVICEMODEL value:[[UIDevice currentDevice] model]];
        str = [str stringByAddQueryParameter:PARA_DEVICEOS intValue:OS_IOS];
        str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:[LocaleUtils getCountryCode]];
        str = [str stringByAddQueryParameter:PARA_LANGUAGE value:[LocaleUtils getLanguageCode]];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_DEVICETOKEN value:deviceToken];        
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataDict = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}

+ (CommonNetworkOutput*)findAllProductsByKeyword:(NSString*)baseURL
										   appId:(NSString*)appId
                                            city:(NSString*)city
										 keyword:(NSString*)keyword
									 startOffset:(int)startOffset
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    const int MAX_COUNT = 10;
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDPRODUCTSBYKEYWORD];
        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:MAX_COUNT];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_CITY value:city];
        str = [str stringByAddQueryParameter:PARA_KEYWORD value:keyword];
        str = [str stringByAddQueryParameter:PARA_DEVICEID value:[[UIDevice currentDevice] uniqueIdentifier]];        
        str = [str stringByAddQueryParameter:PARA_START_OFFSET intValue:startOffset];
		
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}

+ (CommonNetworkOutput*)updateKeywords:(NSString*)baseURL
                           appId:(NSString*)appId
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_UPDATEKEYWORD];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
		
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];    
}

+ (CommonNetworkOutput*)actionOnProduct:(NSString*)baseURL
                                  appId:(NSString*)appId
                                 userId:(NSString*)userId
                              productId:(NSString*)productId
                             actionName:(NSString*)actionName
                            actionValue:(int)value
                            hasLocation:(BOOL)hasLocation
                               latitude:(double)latitude
                              longitude:(double)longitude
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_ACTIONONPRODUCT];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_ACTION_NAME value:actionName];
        str = [str stringByAddQueryParameter:PARA_ACTION_VALUE intValue:value];
        str = [str stringByAddQueryParameter:PARA_ID value:productId];
        
        if (hasLocation){
            str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
            str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
        }
                
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataDict = [dict objectForKey:PARA_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput *)writeCommentWithContent:(NSString *)content
                                        nickName:(NSString *)nickName
                                           appId:(NSString *)appId
                                          userId:(NSString *)userId
                                       productId:(NSString *)productId
                                     hasLocation:(BOOL)hasLocation
                                        latitude:(double)latitude
                                       longitude:(double)longitude
                                         baseURL:(NSString *)baseURL
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_WRITEPRODUCTCOMMENT];
        str = [str stringByAddQueryParameter:PARA_COMMENT_CONTENT value:content];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_NICKNAME value:nickName];
        str = [str stringByAddQueryParameter:PARA_ID value:productId];
        
        if (hasLocation){
            str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
            str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
        }
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput *)getCommentsWithProductId:(NSString *)productId
                                            appId:(NSString*)appId
                                          baseURL:(NSString *)baseURL
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_GETPRODUCTCOMMENTS];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_ID value:productId];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataArray = [dict objectForKey:PARA_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}


+ (CommonNetworkOutput*)addUserShoppingItem:(NSString*)baseURL
                                      appId:(NSString*)appId
                                     userId:(NSString*)userId
                                     itemId:(NSString*)itemId
                                       city:(NSString*)city
                               categoryName:(NSString*)categoryName
                            subCategoryName:(NSString*)subCategoryName
                                   keywords:(NSString*)keywords
                                 expireDate:(NSString *)expireDate
                                   maxPrice:(NSNumber*)maxPrice 
                                   latitude:(NSNumber *)latitude 
                                  longitude:(NSNumber *)longitude 
                                     radius:(NSNumber *)radius
                                  minRebate:(NSNumber*)minRebate
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_ADDSHOPPINGITEM];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_ITEMID value:itemId];
        
        if (city){
            str = [str stringByAddQueryParameter:PARA_CITY value:city];
        }
        
        if (categoryName){
            str = [str stringByAddQueryParameter:PARA_CATEGORY_NAME value:categoryName];            
        }
        
        if (subCategoryName){
            str = [str stringByAddQueryParameter:PARA_SUB_CATEGORY_NAME value:subCategoryName];                        
        }
        
        if (keywords){
            str = [str stringByAddQueryParameter:PARA_KEYWORD value:keywords];                        
        }
        
        if (expireDate) {
            str = [str stringByAddQueryParameter:PARA_EXPIRE_DATE value:expireDate];
        }
        
        if (maxPrice){
            str = [str stringByAddQueryParameter:PARA_PRICE doubleValue:[maxPrice doubleValue]];
        }
        
        if (latitude) {
            
            str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:[latitude doubleValue]];
        }
        
        if (longitude) {
            
            str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:[longitude doubleValue]];
        }
        
        if (radius) {
            
            str = [str stringByAddQueryParameter:PARA_RADIUS doubleValue:[radius doubleValue]];
        }
        
        if (minRebate){
            str = [str stringByAddQueryParameter:PARA_REBATE doubleValue:[minRebate doubleValue]];
        }
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];

}


+ (CommonNetworkOutput*)updateUserShoppingItem:(NSString*)baseURL
                                         appId:(NSString*)appId
                                        userId:(NSString*)userId
                                        itemId:(NSString*)itemId
                                          city:(NSString*)city
                                  categoryName:(NSString*)categoryName
                               subCategoryName:(NSString*)subCategoryName
                                      keywords:(NSString*)keywords
                                    expireDate:(NSString *)expireDate
                                      maxPrice:(NSNumber*)maxPrice
                                      latitude:(NSNumber *)latitude 
                                     longitude:(NSNumber *)longitude 
                                        radius:(NSNumber *)radius
                                     minRebate:(NSNumber*)minRebate
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_UPDATESHOPPINGITEM];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_ITEMID value:itemId];
        
        if (categoryName){
            str = [str stringByAddQueryParameter:PARA_CATEGORY_NAME value:categoryName];            
        }
        
        if (subCategoryName){
            str = [str stringByAddQueryParameter:PARA_SUB_CATEGORY_NAME value:subCategoryName];                        
        }
        
        if (keywords){
            str = [str stringByAddQueryParameter:PARA_KEYWORD value:keywords];                        
        }
        
        if (expireDate) {
            str = [str stringByAddQueryParameter:PARA_EXPIRE_DATE value:expireDate];
        }
        
        if (maxPrice){
            str = [str stringByAddQueryParameter:PARA_PRICE doubleValue:[maxPrice doubleValue]];
        }
        
        if (latitude) {
            
            str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:[latitude doubleValue]];
        }
        
        if (longitude) {
            
            str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:[longitude doubleValue]];
        }
        
        if (radius) {
            
            str = [str stringByAddQueryParameter:PARA_RADIUS doubleValue:[radius doubleValue]];
        }
        
        if (minRebate){
            str = [str stringByAddQueryParameter:PARA_REBATE doubleValue:[minRebate doubleValue]];
        }
        
        if (city){
            str = [str stringByAddQueryParameter:PARA_CITY value:city];
        }
        
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput*)deleteUserShoppingItem:(NSString*)baseURL
                                         appId:(NSString*)appId
                                        userId:(NSString*)userId
                                        itemId:(NSString*)itemId
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_DELETESHOPPINGITEM];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_ITEMID value:itemId];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}


+ (CommonNetworkOutput*)getUserShoppingItemCount:(NSString*)baseURL
                                         appId:(NSString*)appId
                                          userId:(NSString*)userId
                                     itemIdArray:(NSArray*)itemIdArray 
                                   requiredMatch:(BOOL)requireMatch
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_GETITEMMATCHCOUNT];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        if (itemIdArray != nil) {
            NSString *itemIdsString = [itemIdArray componentsJoinedByString:@" "];
            if (itemIdsString) {
                str = [str stringByAddQueryParameter:PARA_ITEMIDARRAY value:itemIdsString];
            }
        }
        if (requireMatch) {
            str = [str stringByAddQueryParameter:PARA_REQUIRE_MATCH value:@"1"];
        }
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}

+ (CommonNetworkOutput*)updateUser:(NSString*)baseURL
                                         appId:(NSString*)appId
                                        userId:(NSString*)userId
                                        deviceToken:(NSString*)deviceToken
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_UPDATEUSER];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_DEVICETOKEN value:deviceToken];
        
        return str;
    };
    
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}

+ (CommonNetworkOutput*)registerUserByEmail:(NSString*)baseURL
                                      appId:(NSString*)appId
                                      email:(NSString*)email
                                   password:(NSString*)password
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_REGISTEREMAIL];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_EMAIL value:email];
        str = [str stringByAddQueryParameter:PARA_PASSWORD value:password];
        
        return str;
    };
    
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataDict = [dict objectForKey:RET_DATA];                        
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
    
}

+ (CommonNetworkOutput*)bindUserEmail:(NSString*)baseURL
                                appId:(NSString*)appId
                               userId:(NSString*)userId
                                email:(NSString*)email
                             password:(NSString*)password
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_BINDUSER];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_EMAIL value:email];
        str = [str stringByAddQueryParameter:PARA_PASSWORD value:password];        
        str = [str stringByAddQueryParameter:PARA_REGISTER_TYPE intValue:REGISTER_TYPE_EMAIL];
        
        return str;
    };
    
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataDict = [dict objectForKey:RET_DATA];                
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
    
}

+ (CommonNetworkOutput*)loginUserByEmail:(NSString*)baseURL
                                   appId:(NSString*)appId
                                   email:(NSString*)email
                                password:(NSString*)password
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_LOGIN];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_EMAIL value:email];
        str = [str stringByAddQueryParameter:PARA_PASSWORD value:password];
        
        return str;
    };
    
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataDict = [dict objectForKey:RET_DATA];        
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}

+ (CommonNetworkOutput*)registerUserBySNS:(NSString*)baseURL
                                    snsId:(NSString*)snsId
                             registerType:(int)registerType                                      
                                    appId:(NSString*)appId
                              deviceToken:(NSString*)deviceToken
                                 nickName:(NSString*)nickName
                                   avatar:(NSString*)avatar
                              accessToken:(NSString*)accessToken
                        accessTokenSecret:(NSString*)accessTokenSecret
                                 province:(int)province
                                     city:(int)city
                                 location:(NSString*)location
                                   gender:(NSString*)gender
                                 birthday:(NSString*)birthday
                                   domain:(NSString*)domain
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_REGISTERSNS];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_SNS_ID value:snsId];
        str = [str stringByAddQueryParameter:PARA_REGISTER_TYPE intValue:registerType];
        str = [str stringByAddQueryParameter:PARA_DEVICETOKEN value:deviceToken];
        str = [str stringByAddQueryParameter:PARA_NICKNAME value:nickName];
        str = [str stringByAddQueryParameter:PARA_AVATAR value:avatar];
        str = [str stringByAddQueryParameter:PARA_ACCESS_TOKEN value:accessToken];
        str = [str stringByAddQueryParameter:PARA_ACCESS_TOKEN_SECRET value:accessTokenSecret];
        str = [str stringByAddQueryParameter:PARA_PROVINCE intValue:province];
        str = [str stringByAddQueryParameter:PARA_CITY intValue:city];
        str = [str stringByAddQueryParameter:PARA_LOCATION value:location];
        str = [str stringByAddQueryParameter:PARA_GENDER value:gender];
        str = [str stringByAddQueryParameter:PARA_BIRTHDAY value:birthday];
        str = [str stringByAddQueryParameter:PARA_DOMAIN value:domain];
        
        return str;
    };
    
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataDict = [dict objectForKey:RET_DATA];                        
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];    
}

+ (CommonNetworkOutput*)bindUserBySNS:(NSString*)baseURL
                               userId:(NSString*)userId
                                snsId:(NSString*)snsId
                         registerType:(int)registerType                                      
                                appId:(NSString*)appId
                             nickName:(NSString*)nickName
                               avatar:(NSString*)avatar
                          accessToken:(NSString*)accessToken
                    accessTokenSecret:(NSString*)accessTokenSecret
                             province:(int)province
                                 city:(int)city
                             location:(NSString*)location
                               gender:(NSString*)gender
                             birthday:(NSString*)birthday
                               domain:(NSString*)domain
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_BINDUSER];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_USERID value:userId];
        str = [str stringByAddQueryParameter:PARA_SNS_ID value:snsId];
        str = [str stringByAddQueryParameter:PARA_REGISTER_TYPE intValue:registerType];
        str = [str stringByAddQueryParameter:PARA_NICKNAME value:nickName];
        str = [str stringByAddQueryParameter:PARA_AVATAR value:avatar];
        str = [str stringByAddQueryParameter:PARA_ACCESS_TOKEN value:accessToken];
        str = [str stringByAddQueryParameter:PARA_ACCESS_TOKEN_SECRET value:accessTokenSecret];
        str = [str stringByAddQueryParameter:PARA_PROVINCE intValue:province];
        str = [str stringByAddQueryParameter:PARA_CITY intValue:city];
        str = [str stringByAddQueryParameter:PARA_LOCATION value:location];
        str = [str stringByAddQueryParameter:PARA_GENDER value:gender];
        str = [str stringByAddQueryParameter:PARA_BIRTHDAY value:birthday];
        str = [str stringByAddQueryParameter:PARA_DOMAIN value:domain];
        
        return str;
    };
    
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        output.jsonDataDict = [dict objectForKey:RET_DATA];                        
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];    
}

+ (CommonNetworkOutput*)segmentText:(NSString*)baseURL
                              appId:(NSString*)appId
                               text:(NSString*)text
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:METHOD
                                       value:METHOD_SEGMENTTEXT];
        str = [str stringByAddQueryParameter:PARA_APPID
                                       value:appId];
        str = [str stringByAddQueryParameter:PARA_TEXT_CONTENT
                                       value:text];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        NSLog(@"<segmentText> data=%@", [output.jsonDataDict description]);
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}

+ (CommonNetworkOutput*)taobaoSearch:(NSString*)baseURL
                              appId:(NSString*)appId
                               keyword:(NSString*)keyword
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:METHOD
                                       value:METHOD_COMPAREPRODUCT];
        str = [str stringByAddQueryParameter:PARA_APPID
                                       value:appId];
        str = [str stringByAddQueryParameter:PARA_KEYWORD
                                       value:keyword];
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        output.jsonDataArray = [dict objectForKey:RET_DATA];
        NSLog(@"<taobaoSearch> data=%@", [output.jsonDataArray description]);
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
    
}


@end

