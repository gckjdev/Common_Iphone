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
@implementation CommonNetworkOutput

@synthesize resultMessage, resultCode, jsonDataArray, jsonDataDict;

- (void)resultFromJSON:(NSString*)jsonString
{
	// get code and message
	NSDictionary* dict = [jsonString JSONValue];		
	self.resultCode = [[dict objectForKey:@"ret"] intValue];				
    //	self.resultMessage = [dict objectForKey:@"msg"];		
}

- (NSArray*)arrayFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSArray* retArray = [dict objectForKey:@"dat"];
	
	return retArray;
}

- (NSDictionary*)dictionaryDataFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSDictionary* retDict = [dict objectForKey:PARA_DATA];
	
	return retDict;
}

- (void)dealloc
{
	[resultMessage release];
    [jsonDataArray release];
    [jsonDataDict release];
	[super dealloc];
}


@end


@implementation GroupBuyNetworkRequest

+ (CommonNetworkOutput*)deviceLogin:(NSString*)baseURL
                              appId:(NSString*)appId
                     needReturnUser:(BOOL)needReturnUser
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
        
        return str;
    };
    
    PPNetworkResponseBlock responseHandler = ^(NSDictionary *dict, CommonNetworkOutput *output) {
        
        // parse response data and set into output object
        NSDictionary* data = [dict objectForKey:RET_DATA];
        NSLog(@"<deviceLogin> data=%@", [data description]);
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
    return [GroupBuyNetworkRequest findAllProducts:baseURL                                               
                                             appId:appId                                      
                                       startOffset:startOffset                                                                        
                                              city:city                                       
                                            method:METHOD_FINDPRODUCTWITHPRICE];
}

+ (CommonNetworkOutput*)findAllProductsWithBought:(NSString*)baseURL
                                           appId:(NSString*)appId
                                     startOffset:(int)startOffset
                                            city:(NSString*)city
{
    return [GroupBuyNetworkRequest findAllProducts:baseURL                                               
                                             appId:appId                                      
                                       startOffset:startOffset                                                                        
                                              city:city                                       
                                            method:METHOD_FINDPRODUCTWITHBOUGHT];
}

+ (CommonNetworkOutput*)findAllProductsWithRebate:(NSString*)baseURL
                                           appId:(NSString*)appId
                                     startOffset:(int)startOffset
                                            city:(NSString*)city
{
    return [GroupBuyNetworkRequest findAllProducts:baseURL                                               
                                             appId:appId                                      
                                       startOffset:startOffset                                                                        
                                              city:city                                       
                                            method:METHOD_FINDPRODUCTWITHREBATE];
}



+ (CommonNetworkOutput*)findAllProductsWithLocation:(NSString*)baseURL
                                              appId:(NSString*)appId
                                           latitude:(double)latitude
                                          longitude:(double)longitude
                                        startOffset:(int)startOffset
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    const int MAX_COUNT = 10;
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];       
        
        str = [str stringByAddQueryParameter:METHOD value:METHOD_FINDPRODUCTWITHLOCATION];
        str = [str stringByAddQueryParameter:PRAR_START_OFFSET intValue:startOffset];
        str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:MAX_COUNT];
        str = [str stringByAddQueryParameter:PARA_APPID value:appId];
        str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
        str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
        
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

@end
