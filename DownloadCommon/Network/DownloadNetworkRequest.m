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
#import "LogUtil.h"

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
        PPDebug(@"<deviceLogin> data=%@", [output.jsonDataDict description]);
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
                                type:(NSNumber*)type
                              sortBy:(NSNumber*)sortBy
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDTOPSITES];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:countryCode];
        
        if (type){
            str = [str stringByAddQueryParameter:PARA_TYPE intValue:[type intValue]];
        }
        
        if (sortBy){
            str = [str stringByAddQueryParameter:PARA_SORT_BY intValue:[sortBy intValue]];            
        }        
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {        
        // parse response data and set into output object
        output.jsonDataDict = [dict objectForKey:RET_DATA];
        output.jsonDataArray = [output.jsonDataDict objectForKey:PARA_DATA];
        PPDebug(@"<findAllSites> data=%@", [output.jsonDataDict description]);
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput*)findAllTopDownloadItems:(NSString*)baseURL
                               appId:(NSString*)appId
                            startOffset:(int)startOffset
                         countryCode:(NSString*)countryCode
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDTOPDOWNLOAD];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:countryCode];
        str = [str stringByAddQueryParameter:PARA_START_OFFSET intValue:startOffset];
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {        
        // parse response data and set into output object
        output.jsonDataDict = [dict objectForKey:RET_DATA];
        output.jsonDataArray = [output.jsonDataDict objectForKey:PARA_DATA];
        PPDebug(@"<findAllTopDownloadItems> data=%@", [output.jsonDataDict description]);
        return;
    }; 
    
    return [PPNetworkRequest sendRequest:baseURL
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput*)reportDownload:(NSString*)baseURL 
                                 appId:(NSString*)appId
                              fileType:(NSString*)fileType
                              fileName:(NSString*)fileName
                                   url:(NSString*)url
                               webSite:(NSString*)webSite
                           webSiteName:(NSString*)webSiteName
                              fileSize:(long)fileSize
                           countryCode:(NSString*)countryCode
                              language:(NSString*)language
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_REPORTDOWNLOAD];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:countryCode];        
        str = [str stringByAddQueryParameter:PARA_LANGUAGE value:language];        
        str = [str stringByAddQueryParameter:PARA_FILE_TYPE value:fileType];        
        str = [str stringByAddQueryParameter:PARA_FILE_URL value:url];        
        str = [str stringByAddQueryParameter:PARA_FILE_NAME value:fileName];        
        str = [str stringByAddQueryParameter:PARA_SITE_URL value:webSite];        
        str = [str stringByAddQueryParameter:PARA_SITE_NAME value:webSiteName];        
        str = [str stringByAddQueryParameter:PARA_FILE_SIZE intValue:fileSize];        
        str = [str stringByAddQueryParameter:PARA_DEVICEID value:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
        
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

@end
