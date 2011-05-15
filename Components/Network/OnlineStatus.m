//
//  OnlineStatus.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "OnlineStatus.h"

@implementation OnlineStatusInput

@synthesize userId;
@synthesize status;
@synthesize deviceId;
@synthesize appId;

- (void)dealloc
{
	[userId	release];
	[deviceId release];
	[appId release];
	[super dealloc];	
}

@end

@implementation OnlineStatusOutput

@end



@implementation OnlineStatusRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[OnlineStatusRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{
	// m=srpt&uid=+8613802538605&s=1
	
	if ([input isKindOfClass:[OnlineStatusInput class]]){
		OnlineStatusInput* obj = (OnlineStatusInput*)input;
		NSString* url = [NSString stringWithFormat:@"%@m=srpt&uid=%@&s=%d&app=%@",
						 [self getBaseUrlString],
						 obj.userId,
						 obj.status,
						 obj.appId];
		
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
	NSLog(@"OnlineStatusRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[OnlineStatusOutput class]]){
		
		OnlineStatusOutput* obj = (OnlineStatusOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			NSLog(@"OnlineStatusRequest result=%d", obj.resultCode);						
			return YES;
		}
		else {
			NSLog(@"OnlineStatusRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

@end

