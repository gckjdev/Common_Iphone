//
//  UpdateUser.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UpdateUserRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation UpdateUserInput

@synthesize appId;
@synthesize userId;
@synthesize mobile;
@synthesize email;
@synthesize nickName;
@synthesize password;
@synthesize avatar;

- (void)dealloc
{
	[appId release];
    [userId release];
    [mobile release];
    [email release];
    [nickName release];
    [password release];
    [avatar release];
	[super dealloc];
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
    str = [str stringByAddQueryParameter:METHOD
                                   value:METHOD_UPDATEUSER];
    
	str = [str stringByAddQueryParameter:PARA_APPID
                                   value:appId];
	
    str = [str stringByAddQueryParameter:PARA_USERID
                                   value:userId];
    

    if ([mobile length] > 0){
        str = [str stringByAddQueryParameter:PARA_MOBILE value:mobile];
    }

    if ([email length] > 0){
        str = [str stringByAddQueryParameter:PARA_EMAIL value:email];
    }

    if ([nickName length] > 0){
        str = [str stringByAddQueryParameter:PARA_NICKNAME value:nickName];
    }

    if ([password length] > 0){
        str = [str stringByAddQueryParameter:PARA_PASSWORD value:password];
    }
    
    if (avatar != nil){
        NSString* HAS_AVATAR = @"1";
        str = [str stringByAddQueryParameter:PARA_AVATAR value:HAS_AVATAR];
    }

	return str;
}

@end

@implementation UpdateUserOutput

@synthesize avatarURL;

- (void)dealloc
{
	[avatarURL release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, avatarURL];
}

@end



@implementation UpdateUserRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[UpdateUserRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[UpdateUserInput class]]){
		UpdateUserInput* obj = (UpdateUserInput*)input;
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
	NSLog(@"UpdateUserRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[UpdateUserOutput class]]){
		
		UpdateUserOutput* obj = (UpdateUserOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
            NSDictionary* data = [obj dictionaryDataFromJSON:textData];
            obj.avatarURL = [data objectForKey:PARA_AVATAR];
            
			NSLog(@"UpdateUserRequest result=%d, data=%@", obj.resultCode, [data description]);						
			return YES;
		}
		else {
			NSLog(@"UpdateUserRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (UpdateUserOutput*)send:(NSString*)serverURL
                   userId:(NSString*)userId
                    appId:(NSString*)appId
                   mobile:(NSString*)mobile
                    email:(NSString*)email                 
                 password:(NSString*)password                
                 nickName:(NSString*)nickName
                   avatar:(NSData*)avatar
{
	int result = ERROR_SUCCESS;
	UpdateUserInput* input = [[UpdateUserInput alloc] init];
	UpdateUserOutput* output = [[[UpdateUserOutput alloc] init] autorelease];
	
	input.appId = appId;	
	input.userId = userId;
    input.mobile = mobile;
    input.email = email;
    input.password = password;
    input.nickName = nickName;
    input.avatar = avatar;
    
	if ([[UpdateUserRequest requestWithURL:serverURL] sendPostRequest:input output:output postData:avatar]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}


@end

