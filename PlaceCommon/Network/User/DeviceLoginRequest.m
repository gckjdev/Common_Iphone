//
//  DeviceLogin.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "DeviceLoginRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"
#import "UIDevice+IdentifierAddition.h"

@implementation DeviceLoginInput

@synthesize appId;
@synthesize deviceId;
@synthesize needReturnUser;

- (void)dealloc
{
	[appId release];
	[deviceId release];
	[super dealloc];
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
    str = [str stringByAddQueryParameter:METHOD
                                   value:METHOD_DEVICELOGIN];
	str = [str stringByAddQueryParameter:PARA_APPID
                                   value:appId];
	str = [str stringByAddQueryParameter:PARA_DEVICEID
                                   value:deviceId];
    str = [str stringByAddQueryParameter:PARA_NEED_RETURN_USER
                                intValue:needReturnUser];
    
	return str;
}

@end

@implementation DeviceLoginOutput

@synthesize userId;
@synthesize loginId;
@synthesize nickName;
@synthesize sinaAccessToken;
@synthesize sinaAccessTokenSecret;
@synthesize qqAccessToken;
@synthesize qqAccessTokenSecret;
@synthesize userAvatar;
@synthesize sinaId;
@synthesize qqId;
@synthesize renrenId;
@synthesize facebookId;
@synthesize twitterId; 

- (void)dealloc
{
	[userId release];
    [loginId release];
    [sinaId release];
    [qqId release];
    [renrenId release];
    [facebookId release];
    [twitterId release];
    [nickName release];
    [sinaAccessToken release];
    [sinaAccessTokenSecret release];
    [qqAccessToken release];
    [qqAccessTokenSecret release];
    [userAvatar release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, userId];
}

@end



@implementation DeviceLoginRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[DeviceLoginRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[DeviceLoginInput class]]){
		DeviceLoginInput* obj = (DeviceLoginInput*)input;
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
	NSLog(@"DeviceLoginRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[DeviceLoginOutput class]]){
		
		DeviceLoginOutput* obj = (DeviceLoginOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
            NSDictionary* data = [obj dictionaryDataFromJSON:textData];
			obj.userId = [data objectForKey:PARA_USERID];
            obj.loginId = [data objectForKey:PARA_LOGINID];
            obj.sinaId = [data objectForKey:PARA_SINAID];
            obj.qqId = [data objectForKey:PARA_QQID];
            obj.facebookId = [data objectForKey:PARA_FACEBOOKID];
            obj.twitterId = [data objectForKey:PARA_TWITTERID];
            obj.renrenId = [data objectForKey:PARA_RENRENID];
            obj.nickName = [data objectForKey:PARA_NICKNAME];
            obj.sinaAccessToken = [data objectForKey:PARA_SINA_ACCESS_TOKEN];
            obj.sinaAccessTokenSecret = [data objectForKey:PARA_SINA_ACCESS_TOKEN_SECRET];
            obj.qqAccessToken = [data objectForKey:PARA_QQ_ACCESS_TOKEN];
            obj.qqAccessTokenSecret = [data objectForKey:PARA_QQ_ACCESS_TOKEN_SECRET];
            obj.userAvatar = [data objectForKey:PARA_AVATAR];
            
			NSLog(@"DeviceLoginRequest result=%d, data=%@", obj.resultCode, [data description]);						
			return YES;
		}
		else {
			NSLog(@"DeviceLoginRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (DeviceLoginOutput*)send:(NSString*)serverURL
                     appId:(NSString*)appId
                  deviceId:(NSString *)deviceId
            needReturnUser:(BOOL)needReturnUser
{
	int result = ERROR_SUCCESS;
	DeviceLoginInput* input = [[DeviceLoginInput alloc] init];
	DeviceLoginOutput* output = [[[DeviceLoginOutput alloc] init] autorelease];
	
	input.appId = appId;	
	input.deviceId = deviceId;
    input.needReturnUser = needReturnUser;
    
	if ([[DeviceLoginRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}

+ (DeviceLoginOutput*)send:(NSString*)serverURL
                     appId:(NSString*)appId
            needReturnUser:(BOOL)needReturnUser
{
	int result = ERROR_SUCCESS;
	DeviceLoginInput* input = [[DeviceLoginInput alloc] init];
	DeviceLoginOutput* output = [[[DeviceLoginOutput alloc] init] autorelease];
	
	input.appId = appId;	
	input.deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    input.needReturnUser = needReturnUser;
    
	if ([[DeviceLoginRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}


@end

