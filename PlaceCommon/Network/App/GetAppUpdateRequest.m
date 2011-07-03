//
//  GetAppUpdate.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetAppUpdateRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetAppUpdateInput

@synthesize userId;
@synthesize appId;

- (void)dealloc
{
	[appId release];
    [userId release];    
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETAPPUPDATE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	
	return str;
}

@end

@implementation GetAppUpdateOutput

@synthesize version;    // new app version
@synthesize appURL;     // new app download URL
@synthesize sinaAppKey;
@synthesize sinaAppSecret;
@synthesize qqAppKey;
@synthesize qqAppSecret;
@synthesize renrenAppKey;
@synthesize renrenAppSecret;

- (void)dealloc
{
    [version release];
    [appURL release];
    [sinaAppKey release];
    [sinaAppSecret release];
    [qqAppKey release];
    [qqAppSecret release];
    [renrenAppKey release];
    [renrenAppSecret release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d", resultCode];
}

@end

@implementation GetAppUpdateRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetAppUpdateRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetAppUpdateInput class]]){
		GetAppUpdateInput* obj = (GetAppUpdateInput*)input;
		NSString* url = [obj createUrlString:[self getBaseUrlString]];		
		return [url stringByURLEncode];
	}
	else {
		return nil;
	}
	
}

// virtual method
- (BOOL)parseToReponse:(NSData*)data output:(NSObject*)output
{
	const void* bytes = [data bytes];
	NSString* textData = [[[NSString alloc] initWithBytes:bytes length:[data length] encoding:NSUTF8StringEncoding] autorelease];		
	NSLog(@"GetAppUpdateRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetAppUpdateOutput class]]){
		
		GetAppUpdateOutput* obj = (GetAppUpdateOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO       
            NSDictionary* dict = [obj dictionaryDataFromJSON:textData];
            obj.version = [dict objectForKey:PARA_VERSION];
            obj.appURL = [dict objectForKey:PARA_APPURL];
            obj.sinaAppKey = [dict objectForKey:PARA_SINA_APPKEY];
            obj.sinaAppSecret = [dict objectForKey:PARA_SINA_APPSECRET];
            obj.qqAppKey = [dict objectForKey:PARA_QQ_APPKEY];
            obj.qqAppSecret = [dict objectForKey:PARA_QQ_APPSECRET];
            obj.renrenAppKey = [dict objectForKey:PARA_RENREN_APPKEY];
            obj.renrenAppSecret = [dict objectForKey:PARA_RENREN_APPSECRET];
			NSLog(@"GetAppUpdateRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetAppUpdateRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (GetAppUpdateOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId
{
    int result = ERROR_SUCCESS;
	GetAppUpdateInput* input = [[GetAppUpdateInput alloc] init];
	GetAppUpdateOutput* output = [[[GetAppUpdateOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
	
	if ([[GetAppUpdateRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];	
	return output;	
}

@end

