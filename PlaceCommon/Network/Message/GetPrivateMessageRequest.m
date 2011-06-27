//
//  GetPrivateMessage.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetPrivateMessageRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetPrivateMessageInput

@synthesize userId;
@synthesize appId;
@synthesize afterTimeStamp;
@synthesize maxCount;

- (void)dealloc
{
	[appId release];
    [userId release];    
    [afterTimeStamp release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETMYMESSAGE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_AFTER_TIMESTAMP value:afterTimeStamp];
	str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:maxCount];
	
	return str;
}

@end

@implementation GetPrivateMessageOutput

@synthesize messageArray;

- (void)dealloc
{
    [messageArray release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, [messageArray description]];
}

@end

@implementation GetPrivateMessageRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetPrivateMessageRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetPrivateMessageInput class]]){
		GetPrivateMessageInput* obj = (GetPrivateMessageInput*)input;
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
	NSLog(@"GetPrivateMessageRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetPrivateMessageOutput class]]){
		
		GetPrivateMessageOutput* obj = (GetPrivateMessageOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO         
            obj.messageArray = [obj arrayFromJSON:textData];
			NSLog(@"GetPrivateMessageRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetPrivateMessageRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (GetPrivateMessageOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId afterTimeStamp:(NSString*)afterTimeStamp
{
    int result = ERROR_SUCCESS;
	GetPrivateMessageInput* input = [[GetPrivateMessageInput alloc] init];
	GetPrivateMessageOutput* output = [[[GetPrivateMessageOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.afterTimeStamp = afterTimeStamp;
    input.maxCount = kMaxMessageCount;
	
	if ([[GetPrivateMessageRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];	
	return output;	
}

@end

