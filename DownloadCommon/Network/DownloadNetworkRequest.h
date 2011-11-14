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

+ (CommonNetworkOutput*)reportDownload:(NSString*)baseURL 
                                 appId:(NSString*)appId
                              fileType:(NSString*)fileType
                              fileName:(NSString*)fileName
                                   url:(NSString*)url
                               webSite:(NSString*)webSite
                           webSiteName:(NSString*)webSiteName
                              fileSize:(long)fileSize
                           countryCode:(NSString*)countryCode
                              language:(NSString*)language;

@end
