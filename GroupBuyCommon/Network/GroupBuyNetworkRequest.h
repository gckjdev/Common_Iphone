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

@end
