//
//  GetUserFollowPlace.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetUserFollowPlaceRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetUserFollowPlaceInput

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
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETUSERFOLLOWPLACES];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	
	return str;
}

@end

@implementation GetUserFollowPlaceOutput

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



@implementation GetUserFollowPlaceRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetUserFollowPlaceRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetUserFollowPlaceInput class]]){
		GetUserFollowPlaceInput* obj = (GetUserFollowPlaceInput*)input;
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
	NSLog(@"GetUserFollowPlaceRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetUserFollowPlaceOutput class]]){
		
		GetUserFollowPlaceOutput* obj = (GetUserFollowPlaceOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
			// obj.placeId = xxxx	
            // obj.createUser = xxx
            obj.placeArray = [obj arrayFromJSON:textData];
			NSLog(@"GetUserFollowPlaceRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetUserFollowPlaceRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (GetUserFollowPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId
{
	int result = ERROR_SUCCESS;
	GetUserFollowPlaceInput* input = [[GetUserFollowPlaceInput alloc] init];
	GetUserFollowPlaceOutput* output = [[[GetUserFollowPlaceOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
	
	if ([[GetUserFollowPlaceRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[GetUserFollowPlaceRequest send:SERVER_URL userId:@"test_user" appId:@"test_app"];
}

@end

