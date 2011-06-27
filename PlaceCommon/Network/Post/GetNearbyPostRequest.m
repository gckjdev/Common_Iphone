//
//  GetNearbyPost.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetNearbyPostRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetNearbyPostInput

@synthesize userId;
@synthesize appId;
@synthesize beforeTimeStamp;
@synthesize maxCount;
@synthesize longitude;
@synthesize latitude;

- (void)dealloc
{
	[appId release];
    [userId release];    
    [beforeTimeStamp release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETNEARBYPOSTS];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_BEFORE_TIMESTAMP value:beforeTimeStamp];
	str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:maxCount];
    str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
    str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
	
	return str;
}

@end

@implementation GetNearbyPostOutput

@synthesize postArray;

- (void)dealloc
{
    [postArray release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, [postArray description]];
}

@end

@implementation GetNearbyPostRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetNearbyPostRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetNearbyPostInput class]]){
		GetNearbyPostInput* obj = (GetNearbyPostInput*)input;
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
	NSLog(@"GetNearbyPostRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetNearbyPostOutput class]]){
		
		GetNearbyPostOutput* obj = (GetNearbyPostOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO         
            obj.postArray = [obj arrayFromJSON:textData];
			NSLog(@"GetNearbyPostRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetNearbyPostRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}


+ (int)getdeviceOS
{
	return OS_IOS;
}

+ (GetNearbyPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId beforeTimeStamp:(NSString*)beforeTimeStamp longitude:(double)longitude latitude:(double)latitude
{
    
	int result = ERROR_SUCCESS;
	GetNearbyPostInput* input = [[GetNearbyPostInput alloc] init];
	GetNearbyPostOutput* output = [[[GetNearbyPostOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.beforeTimeStamp = beforeTimeStamp;
    input.maxCount = kMaxCount;
    input.latitude = latitude;
    input.longitude = longitude;
	
	if ([[GetNearbyPostRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}

+ (void)test
{
	[GetNearbyPostRequest send:SERVER_URL userId:@"test_user_id" appId:@"test_app"
               beforeTimeStamp:@"" longitude:113.22 latitude:333.22];
}

@end

