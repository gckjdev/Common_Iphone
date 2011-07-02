//
//  GetPublicTimelinePost.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetPublicTimelinePostRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetPublicTimelinePostInput

@synthesize userId;
@synthesize appId;
@synthesize beforeTimeStamp;
@synthesize maxCount;

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
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETPUBLICTIMELINE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_BEFORE_TIMESTAMP value:beforeTimeStamp];
	str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:maxCount];
	
	return str;
}

@end

@implementation GetPublicTimelinePostOutput

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

@implementation GetPublicTimelinePostRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetPublicTimelinePostRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetPublicTimelinePostInput class]]){
		GetPublicTimelinePostInput* obj = (GetPublicTimelinePostInput*)input;
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
	NSLog(@"GetPublicTimelinePostRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetPublicTimelinePostOutput class]]){
		
		GetPublicTimelinePostOutput* obj = (GetPublicTimelinePostOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO         
            obj.postArray = [obj arrayFromJSON:textData];
			NSLog(@"GetPublicTimelinePostRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetPublicTimelinePostRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (GetPublicTimelinePostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId beforeTimeStamp:(NSString*)beforeTimeStamp
{
    
	int result = ERROR_SUCCESS;
	GetPublicTimelinePostInput* input = [[GetPublicTimelinePostInput alloc] init];
	GetPublicTimelinePostOutput* output = [[[GetPublicTimelinePostOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.beforeTimeStamp = beforeTimeStamp;
    input.maxCount = kMaxCount;
	
	if ([[GetPublicTimelinePostRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}


@end

