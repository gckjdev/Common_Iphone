//
//  GroupBuyNetworkRequest.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_MAX_COUNT       12          // 20 RECORDS
#define DEFAULT_MAX_DISTANCE    3           // 3 km

@class CommonNetworkOutput;

@interface GroupBuyNetworkRequest : NSObject {
    
}

+ (CommonNetworkOutput*)deviceLogin:(NSString*)baseURL
                              appId:(NSString*)appId
                     needReturnUser:(BOOL)needReturnUser
                        deviceToken:(NSString*)deviceToken;


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
                            maxCount:(int)maxCount;


+ (CommonNetworkOutput*)findAllProductsWithPrice:(NSString*)baseURL
                                           appId:(NSString*)appId
                                     startOffset:(int)startOffset
                                            city:(NSString*)city;

+ (CommonNetworkOutput*)findAllProductsWithBought:(NSString*)baseURL
                                            appId:(NSString*)appId
                                      startOffset:(int)startOffset
                                             city:(NSString*)city;

+ (CommonNetworkOutput*)findAllProductsWithRebate:(NSString*)baseURL
                                            appId:(NSString*)appId
                                      startOffset:(int)startOffset
                                             city:(NSString*)city;

+ (CommonNetworkOutput*)findAllProductsWithLocation:(NSString*)baseURL
                                              appId:(NSString*)appId
                                               city:(NSString*)city
                                           latitude:(double)latitude
                                          longitude:(double)longitude
                                        startOffset:(int)startOffset
                                           category:(NSString *)category;

+ (CommonNetworkOutput*)findAllProductsWithStartDate:(NSString*)baseURL
                                               appId:(NSString*)appId
                                         startOffset:(int)startOffset
                                                city:(NSString*)city
                                            category:(NSString *)category;

+ (CommonNetworkOutput*)findAllProductsGroupByCategory:(NSString*)baseURL
                                                 appId:(NSString*)appId
                                                  city:(NSString*)city
                                             todayOnly:(BOOL)todayOnly;

+ (CommonNetworkOutput *)findAllProductsByScore:(NSString *)baseURL
                                          appId:(NSString *)appId
                                    startOffset:(int)startOffset
                                           city:(NSString *)city
                                     startPrice:(NSNumber *)startPrice
                                       endPrice:(NSNumber *)endPrice
                                       category:(NSString *)category;

+ (CommonNetworkOutput*)registerUserDevice:(NSString*)baseURL
                                                 appId:(NSString*)appId
                               deviceToken:(NSString*)deviceToken;

+ (CommonNetworkOutput*)findAllProductsByKeyword:(NSString*)baseURL
										   appId:(NSString*)appId
                                            city:(NSString*)city
										 keyword:(NSString*)keyword
									 startOffset:(int)startOffset;

+ (CommonNetworkOutput*)updateKeywords:(NSString*)baseURL
                           appId:(NSString*)appId;


+ (CommonNetworkOutput*)actionOnProduct:(NSString*)baseURL
                                 appId:(NSString*)appId
                                 userId:(NSString*)userId
                              productId:(NSString*)productId
                             actionName:(NSString*)actionName
                            actionValue:(int)value
                            hasLocation:(BOOL)hasLocation
                               latitude:(double)latitude
                              longitude:(double)longitude;

+ (CommonNetworkOutput *)writeCommentWithContent:(NSString *)content
                                        nickName:(NSString *)nickName
                                           appId:(NSString *)appId
                                          userId:(NSString *)userId
                                       productId:(NSString *)productId
                                     hasLocation:(BOOL)hasLocation
                                        latitude:(double)latitude
                                       longitude:(double)longitude
                                         baseURL:(NSString *)baseURL;

+ (CommonNetworkOutput *)getCommentsWithProductId:(NSString *)productId
                                            appId:(NSString*)appId
                                          baseURL:(NSString *)baseURL;

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
                                  minRebate:(NSNumber*)minRebate;

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
                                  minRebate:(NSNumber*)minRebate;

+ (CommonNetworkOutput*)deleteUserShoppingItem:(NSString*)baseURL
                                         appId:(NSString*)appId
                                        userId:(NSString*)userId
                                        itemId:(NSString*)itemId;

+ (CommonNetworkOutput*)updateUser:(NSString*)baseURL
                             appId:(NSString*)appId
                            userId:(NSString*)userId
                       deviceToken:(NSString*)deviceToken;

+ (CommonNetworkOutput*)getUserShoppingItemCount:(NSString*)baseURL
                                           appId:(NSString*)appId
                                          userId:(NSString*)userId
                                     itemIdArray:(NSArray*)itemIdArray 
                                   requiredMatch:(BOOL)requireMatch;

+ (CommonNetworkOutput*)getShoppingItemProducts:(NSString*)baseURL 
                                         userId:(NSString*)userId
                                          appId:(NSString*)appId
                                         itemId:(NSString*)itemId
                                    startOffset:(int)startOffset
                                       maxCount:(int)maxCount;

+ (CommonNetworkOutput*)registerUserByEmail:(NSString*)baseURL
                                      appId:(NSString*)appId
                                      email:(NSString*)email
                                   password:(NSString*)password;

+ (CommonNetworkOutput*)bindUserEmail:(NSString*)baseURL
                                appId:(NSString*)appId
                               userId:(NSString*)userId
                                email:(NSString*)email
                             password:(NSString*)password;

+ (CommonNetworkOutput*)loginUserByEmail:(NSString*)baseURL
                                      appId:(NSString*)appId
                                      email:(NSString*)email
                                   password:(NSString*)password;

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
                                   domain:(NSString*)domain;

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
                               domain:(NSString*)domain;

@end
