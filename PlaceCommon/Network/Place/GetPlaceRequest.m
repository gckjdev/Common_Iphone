//
//  GetPlaceRequest.m
//  Dipan
//
//  Created by penglzh on 11-5-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GetPlaceRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"


@implementation GetPlaceInput

@synthesize userId;
@synthesize appId;
@synthesize placeId;

- (void)dealloc 
{
	[appId release];
    [userId release];  
    [placeId release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETPLACE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_PLACEID value:placeId];
	
	return str;
}

@end

@implementation GetPlaceOutput

@synthesize placeDict;

- (void)dealloc
{
    [placeDict release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d", resultCode];
}

@end



@implementation GetPlaceRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetPlaceRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetPlaceInput class]]){
		GetPlaceInput* obj = (GetPlaceInput*)input;
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
	NSLog(@"GetPlaceRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetPlaceOutput class]]){
		
		GetPlaceOutput* obj = (GetPlaceOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
            obj.placeDict = [obj dictionaryDataFromJSON:textData]; 
			NSLog(@"GetPlaceRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetPlaceRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (GetPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId  placeId:(NSString*)placeId appId:(NSString*)appId
{
	int result = ERROR_SUCCESS;
	GetPlaceInput* input = [[GetPlaceInput alloc] init];
	GetPlaceOutput* output = [[[GetPlaceOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.placeId = placeId;
	
	if ([[GetPlaceRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[GetPlaceRequest send:SERVER_URL userId:@"test_user" placeId:@"place_id" appId:@"test_app"];
}

@end
