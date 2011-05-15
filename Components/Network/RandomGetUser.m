//
//  RandomGetUser.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "RandomGetUser.h"


@implementation RandomGetUserInput

@synthesize facetimeId;
@synthesize deviceId;

- (void)dealloc
{
	[facetimeId	release];
	[deviceId release];
	[super dealloc];	
}

@end

@implementation RandomGetUserOutput

@synthesize facetimeId;
@synthesize state;

- (void)dealloc
{
	[facetimeId	release];
	[super dealloc];	
}

@end



@implementation RandomGetUserRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[RandomGetUserRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{
	if ([input isKindOfClass:[RandomGetUserInput class]]){
		RandomGetUserInput* obj = (RandomGetUserInput*)input;
		NSString* url = [NSString stringWithFormat:@"%@method=randomGetUser&facetimeId=%@&deviceId=%@",
						 [self getBaseUrlString],
						 obj.facetimeId,
						 obj.deviceId];
		
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
	NSString* textData = [[NSString alloc] initWithBytes:bytes length:[data length] encoding:NSUTF8StringEncoding];		
	NSLog(@"RandomGetUserRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[RandomGetUserOutput class]]){
		
		RandomGetUserOutput* obj = (RandomGetUserOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			NSLog(@"RandomGetUserRequest result=%d", obj.resultCode);						
			
			// assign user data
			NSDictionary* dataInfo = [[textData JSONValue] objectForKey:@"data"];
			if (dataInfo != nil){
				obj.state = [[dataInfo objectForKey:@"status"] intValue];
				obj.facetimeId = [dataInfo objectForKey:@"facetimeId"];
				
				NSLog(@"RandomGetUserRequest status=%d, facetimeId=%@", obj.state, obj.facetimeId);
			}						
			
			return YES;
		}
		else {
			NSLog(@"RandomGetUserRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

@end

