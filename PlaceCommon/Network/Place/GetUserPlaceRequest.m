//
//  GetUserPlace.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetUserPlaceRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetUserPlaceInput

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
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETUSERPLACES];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	
	return str;
}

@end

@implementation GetUserPlaceOutput

@synthesize placeArray;

- (void)dealloc
{
    [placeArray release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, [placeArray description]];
}

@end



@implementation GetUserPlaceRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetUserPlaceRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetUserPlaceInput class]]){
		GetUserPlaceInput* obj = (GetUserPlaceInput*)input;
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
	NSLog(@"GetUserPlaceRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetUserPlaceOutput class]]){
		
		GetUserPlaceOutput* obj = (GetUserPlaceOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
			// obj.placeId = xxxx	
            // obj.createUser = xxx
			NSLog(@"GetUserPlaceRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetUserPlaceRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (GetUserPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId
{
	int result = ERROR_SUCCESS;
	GetUserPlaceInput* input = [[GetUserPlaceInput alloc] init];
	GetUserPlaceOutput* output = [[[GetUserPlaceOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
	
	if ([[GetUserPlaceRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[GetUserPlaceRequest send:SERVER_URL userId:@"test_user" appId:@"test_app"];
}

@end

