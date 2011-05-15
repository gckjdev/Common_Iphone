//
//  ActivateUser.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "ActivateUser.h"

@implementation ActivateUserInput

@synthesize userId;
@synthesize userType;
@synthesize appId;
@synthesize deviceId;
@synthesize deviceType;
@synthesize deviceModel;
@synthesize countryCode;
@synthesize password;
@synthesize language;
@synthesize deviceToken;

- (void)dealloc
{
	[password release];
	[appId release];
	[userId	release];
	[deviceId release];
	[deviceModel release];
	[countryCode release];
	[language release];
	[deviceToken release];
	[super dealloc];	
}

@end

@implementation ActivateUserOutput

@synthesize code;

- (void)dealloc
{
	[code release];
	[super dealloc];	
}


@end



@implementation ActivateUserRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[ActivateUserRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{
	// m=reg&uid=13802538605&utype=0&dm=xxx&did=xxx&dtype=xxx&pwd=xxx&date=xxx&cc=CN&lang=zh_Hans&ts=xxxx&mac=xxx&app=xxx
	if ([input isKindOfClass:[ActivateUserInput class]]){
		ActivateUserInput* obj = (ActivateUserInput*)input;
		NSString* url = [NSString stringWithFormat:@"%@m=reg&uid=%@&utype=%d&dm=%@&did=%@&dtype=%d&pwd=%@&cc=%@&lang=%@&app=%@&dt=%@",
						 [self getBaseUrlString],
						 obj.userId,
						 obj.userType,
						 obj.deviceModel,
						 obj.deviceId,
						 obj.deviceType,
						 obj.password,					
						 obj.countryCode,
						 obj.language,
						 obj.appId,
						 obj.deviceToken];

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
	NSLog(@"ActivateUserRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[ActivateUserOutput class]]){
		
		ActivateUserOutput* obj = (ActivateUserOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			NSLog(@"ActivateUserRequest result=%d", obj.resultCode);				
			obj.code = obj.resultMessage;
			return YES;
		}
		else {
			NSLog(@"ActivateUserRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

@end

@implementation ActivateCode

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[ActivateCode alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{
	if ([input isKindOfClass:[ActivateUserInput class]]){
		ActivateUserInput* obj = (ActivateUserInput*)input;
		NSString* url = [NSString stringWithFormat:@"%@method=activateUser&userId=%@&appId=%@&deviceId=%@&deviceModel=%@&countryCode=%@&language=%@",
						 [self getBaseUrlString],
						 obj.userId,
						 obj.appId,
						 obj.deviceId,
						 obj.deviceModel,
						 obj.countryCode,
						 obj.language];
		
		return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	else {
		return nil;
	}
	
}

@end
