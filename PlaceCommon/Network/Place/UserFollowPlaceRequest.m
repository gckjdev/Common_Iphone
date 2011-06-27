//
//  UserFollowPlace.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UserFollowPlaceRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation UserFollowPlaceInput

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
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_USERFOLLOWPLACE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_PLACEID value:placeId];
	
	return str;
}

@end

@implementation UserFollowPlaceOutput


- (void)dealloc
{
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d", resultCode];
}

@end



@implementation UserFollowPlaceRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[UserFollowPlaceRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[UserFollowPlaceInput class]]){
		UserFollowPlaceInput* obj = (UserFollowPlaceInput*)input;
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
	NSLog(@"UserFollowPlaceRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[UserFollowPlaceOutput class]]){
		
		UserFollowPlaceOutput* obj = (UserFollowPlaceOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
			// obj.placeId = xxxx	
            // obj.createUser = xxx
			NSLog(@"UserFollowPlaceRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"UserFollowPlaceRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (UserFollowPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId  placeId:(NSString*)placeId appId:(NSString*)appId
{
	int result = ERROR_SUCCESS;
	UserFollowPlaceInput* input = [[UserFollowPlaceInput alloc] init];
	UserFollowPlaceOutput* output = [[[UserFollowPlaceOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.placeId = placeId;
	
	if ([[UserFollowPlaceRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[UserFollowPlaceRequest send:SERVER_URL userId:@"test_user" placeId:@"place_id" appId:@"test_app"];
}

@end

