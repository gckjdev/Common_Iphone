//
//  GroupBuyNetworkRequest.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommonNetworkOutput;

@interface GroupBuyNetworkRequest : NSObject {
    
}

+ (CommonNetworkOutput*)deviceLogin:(NSString*)baseURL
                              appId:(NSString*)appId
                     needReturnUser:(BOOL)needReturnUser;


+ (CommonNetworkOutput*)findProducts:(NSString*)baseURL
                               appId:(NSString*)appId
                                city:(NSString*)city
                         hasLocation:(BOOL)hasLocation
                           longitude:(double)longitude
                            latitude:(double)latitude
                           todayOnly:(BOOL)todayOnly
                            category:(NSString*)category
                              sortBy:(int)sortBy
                         startOffset:(int)startOffset;


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
                                        startOffset:(int)startOffset;

+ (CommonNetworkOutput*)findAllProductsGroupByCategory:(NSString*)baseURL
                                                 appId:(NSString*)appId
                                                  city:(NSString*)city
                                             todayOnly:(BOOL)todayOnly;
@end
