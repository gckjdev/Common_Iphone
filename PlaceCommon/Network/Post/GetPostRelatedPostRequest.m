//
//  GetPostRelatedPost.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetPostRelatedPostRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetPostRelatedPostInput

@synthesize userId;
@synthesize appId;
@synthesize postId;
@synthesize beforeTimeStamp;
@synthesize maxCount;
@synthesize excludePostId;

- (void)dealloc
{
	[appId release];
    [userId release];    
    [beforeTimeStamp release];
    [postId release];
    [excludePostId release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETPOSTRELATEDPOST];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_POSTID value:postId];
	str = [str stringByAddQueryParameter:PARA_BEFORE_TIMESTAMP value:beforeTimeStamp];
	str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:maxCount];
	
    if (excludePostId != nil){
        str = [str stringByAddQueryParameter:PARA_EXCLUDE_POSTID value:excludePostId];
    }
    
	return str;
}

@end

@implementation GetPostRelatedPostOutput

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

@implementation GetPostRelatedPostRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetPostRelatedPostRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetPostRelatedPostInput class]]){
		GetPostRelatedPostInput* obj = (GetPostRelatedPostInput*)input;
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
	NSLog(@"GetPostRelatedPostRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetPostRelatedPostOutput class]]){
		
		GetPostRelatedPostOutput* obj = (GetPostRelatedPostOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO         
            obj.postArray = [obj arrayFromJSON:textData];
			NSLog(@"GetPostRelatedPostRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetPostRelatedPostRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (GetPostRelatedPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId postId:(NSString*)postId excludePostId:(NSString*)excludePostId beforeTimeStamp:(NSString*)beforeTimeStamp
{
    
	int result = ERROR_SUCCESS;
	GetPostRelatedPostInput* input = [[GetPostRelatedPostInput alloc] init];
	GetPostRelatedPostOutput* output = [[[GetPostRelatedPostOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.postId = postId;
    input.excludePostId = excludePostId;
    input.beforeTimeStamp = beforeTimeStamp;
    input.maxCount = kMaxCountForPostRelatedPost;
	
	if ([[GetPostRelatedPostRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[GetPostRelatedPostRequest send:SERVER_URL userId:@"test_user_id" appId:@"test_app"
                             postId:@"test_postId" excludePostId:nil beforeTimeStamp:@""];
}

@end

