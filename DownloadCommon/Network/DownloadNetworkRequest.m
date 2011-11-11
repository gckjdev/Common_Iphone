//
//  DownloadNetworkRequest.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadNetworkConstants.h"
#import "DownloadNetworkRequest.h"
#import "PPNetworkRequest.h"
#import "StringUtil.h"
#import "JSON.h"
#import "LocaleUtils.h"
#import "UIDevice+IdentifierAddition.h"

@implementation DownloadNetworkRequest

+ (CommonNetworkOutput*)deviceLogin:(NSString*)baseURL
                              appId:(NSString*)appId
                     needReturnUser:(BOOL)needReturnUser
                        deviceToken:(NSString*)deviceToken
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    NSString* deviceId = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    
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

+ (CommonNetworkOutput*)findAllSites:(NSString*)baseURL
                               appId:(NSString*)appId
                         countryCode:(NSString*)countryCode
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDTOPSITES];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:countryCode];        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {        
        // parse response data and set into output object
        output.jsonDataDict = [dict objectForKey:RET_DATA];
        output.jsonDataArray = [output.jsonDataDict objectForKey:PARA_DATA];
        NSLog(@"<findAllSites> data=%@", [output.jsonDataDict description]);
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}


@end
