//
//  DownloadNetworkRequest.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommonNetworkOutput;


@interface DownloadNetworkRequest : NSObject

+ (CommonNetworkOutput*)deviceLogin:(NSString*)baseURL
                              appId:(NSString*)appId
                     needReturnUser:(BOOL)needReturnUser
                        deviceToken:(NSString*)deviceToken;

+ (CommonNetworkOutput*)findAllSites:(NSString*)baseURL
                               appId:(NSString*)appId
                         countryCode:(NSString*)countryCode;


@end
