//
//  ActionOnPost.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "ActionOnPostRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation ActionOnPostInput

@synthesize userId;
@synthesize appId;
@synthesize actionType;
@synthesize postId;

- (void)dealloc
{
	[appId release];
    [userId release];    
    [actionType release];
    [postId release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_ACTIONONPOST];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_POST_ACTION_TYPE value:actionType];
	str = [str stringByAddQueryParameter:PARA_POSTID value:postId];
	
	return str;
}

@end

@implementation ActionOnPostOutput

- (void)dealloc
{
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d", resultCode];
}

@end

@implementation ActionOnPostRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[ActionOnPostRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[ActionOnPostInput class]]){
		ActionOnPostInput* obj = (ActionOnPostInput*)input;
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
	NSLog(@"ActionOnPostRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[ActionOnPostOutput class]]){
		
		ActionOnPostOutput* obj = (ActionOnPostOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			NSLog(@"ActionOnPostRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"ActionOnPostRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (ActionOnPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId postId:(NSString*)postId actionType:(NSString*)actionType;
{
    
	int result = ERROR_SUCCESS;
	ActionOnPostInput* input = [[ActionOnPostInput alloc] init];
	ActionOnPostOutput* output = [[[ActionOnPostOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.actionType = actionType;
    input.postId = postId;
	
	if ([[ActionOnPostRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}


@end

