//
//  DeletePrivateMessage.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "DeletePrivateMessageRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation DeletePrivateMessageInput

@synthesize userId;
@synthesize appId;
@synthesize messageId;

- (void)dealloc
{
	[appId release];
    [userId release];    
    [messageId release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_DELETEMESSAGE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_MESSAGE_ID value:messageId];
	
	return str;
}

@end

@implementation DeletePrivateMessageOutput

- (void)dealloc
{
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d", resultCode];
}

@end

@implementation DeletePrivateMessageRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[DeletePrivateMessageRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[DeletePrivateMessageInput class]]){
		DeletePrivateMessageInput* obj = (DeletePrivateMessageInput*)input;
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
	NSLog(@"DeletePrivateMessageRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[DeletePrivateMessageOutput class]]){
		
		DeletePrivateMessageOutput* obj = (DeletePrivateMessageOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			NSLog(@"DeletePrivateMessageRequest result=%d, data=%@", 
                  obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"DeletePrivateMessageRequest result=%d, message=%@", 
                  obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (DeletePrivateMessageOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId messageId:(NSString*)messageId
{
    int result = ERROR_SUCCESS;
	DeletePrivateMessageInput* input = [[DeletePrivateMessageInput alloc] init];
	DeletePrivateMessageOutput* output = [[[DeletePrivateMessageOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.messageId = messageId;
	
	if ([[DeletePrivateMessageRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];	
	return output;	
}

@end

