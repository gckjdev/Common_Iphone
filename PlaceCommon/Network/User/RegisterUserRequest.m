//
//  RegisterUser.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "RegisterUserRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation RegisterUserInput

@synthesize loginId;
@synthesize loginIdType;
@synthesize deviceId;
@synthesize deviceOS;
@synthesize deviceModel;
@synthesize countryCode;
@synthesize language;
@synthesize appId;
@synthesize deviceToken;
@synthesize nickName;
@synthesize avatar;
@synthesize accessToken;
@synthesize accessTokenSecret;
@synthesize province;
@synthesize city;
@synthesize location;
@synthesize gender;
@synthesize birthday;
@synthesize sinaNickName;
@synthesize sinaDomain;
@synthesize qqNickName;
@synthesize qqDomain;

- (void)dealloc
{
    [loginId release];
	[deviceId release];
	[deviceModel release];
	[countryCode release];
	[language release];
    [appId release];
	[deviceToken release];
    [nickName release];
    [avatar release];
    [accessToken release];
    [accessTokenSecret release];
    [location release];
    [gender release];
    [birthday release];
    [sinaNickName release];
    [sinaDomain release];
    [qqNickName release];
    [qqDomain release];
    
	[super dealloc];
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_REGISTRATION];
	str = [str stringByAddQueryParameter:PARA_LOGINID value:loginId];
	str = [str stringByAddQueryParameter:PARA_LOGINIDTYPE intValue:loginIdType];
	str = [str stringByAddQueryParameter:PARA_DEVICEID value:deviceId];
	str = [str stringByAddQueryParameter:PARA_DEVICEMODEL value:deviceModel];
	str = [str stringByAddQueryParameter:PARA_DEVICEOS intValue:deviceOS];
	str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:countryCode];
	str = [str stringByAddQueryParameter:PARA_LANGUAGE value:language];
    str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_DEVICETOKEN value:deviceToken];
    str = [str stringByAddQueryParameter:PARA_NICKNAME value:nickName];
    str = [str stringByAddQueryParameter:PARA_AVATAR
                                   value:avatar];
    str = [str stringByAddQueryParameter:PARA_ACCESS_TOKEN
                                   value:accessToken];
    str = [str stringByAddQueryParameter:PARA_ACCESS_TOKEN_SECRET
                                   value:accessTokenSecret];
    str = [str stringByAddQueryParameter:PARA_PROVINCE
                                intValue:province];
    str = [str stringByAddQueryParameter:PARA_CITY
                                intValue:city];
    str = [str stringByAddQueryParameter:PARA_LOCATION
                                   value:location];
    str = [str stringByAddQueryParameter:PARA_GENDER
                                   value:gender];
    str = [str stringByAddQueryParameter:PARA_BIRTHDAY
                                   value:birthday];
    str = [str stringByAddQueryParameter:PARA_SINA_NICKNAME
                                   value:sinaNickName];
    str = [str stringByAddQueryParameter:PARA_SINA_DOMAIN
                                   value:sinaDomain];
    str = [str stringByAddQueryParameter:PARA_QQ_NICKNAME
                                   value:qqNickName];
    str = [str stringByAddQueryParameter:PARA_QQ_DOMAIN
                                   value:qqDomain];
    
	return str;
}

@end

@implementation RegisterUserOutput

@synthesize userId;

- (void)dealloc
{
	[userId release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, userId];
}

@end



@implementation RegisterUserRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[RegisterUserRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[RegisterUserInput class]]){
		RegisterUserInput* obj = (RegisterUserInput*)input;
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
	NSLog(@"RegisterUserRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[RegisterUserOutput class]]){
		
		RegisterUserOutput* obj = (RegisterUserOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			

			// TODO
            NSDictionary* data = [obj dictionaryDataFromJSON:textData];
			obj.userId = [data objectForKey:PARA_USERID];
			NSLog(@"RegisterUserRequest result=%d, data=%@", obj.resultCode, [data description]);						
			return YES;
		}
		else {
			NSLog(@"RegisterUserRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (RegisterUserOutput*)send:(NSString*)serverURL
                    loginId:(NSString*)loginId
                loginIdType:(int)loginIdType
                deviceToken:(NSString*)deviceToken
                   nickName:(NSString*)nickName
                     avatar:(NSString *)avatar
                accessToken:(NSString *)accessToken
          accessTokenSecret:(NSString *)accessTokenSecret
                      appId:(NSString*)appId
                   province:(int)province
                       city:(int)city
                   location:(NSString *)location
                     gender:(NSString *)gender
                   birthday:(NSString *)birthday
               sinaNickName:(NSString *)sinaNickName
                 sinaDomain:(NSString *)sinaDomain
                 qqNickName:(NSString *)qqNickName
                   qqDomain:(NSString *)qqDomain
{
	int result = ERROR_SUCCESS;
	RegisterUserInput* input = [[RegisterUserInput alloc] init];
	RegisterUserOutput* output = [[[RegisterUserOutput alloc] init] autorelease];
	
	// initlize all input data
	input.loginId = loginId;
	input.appId = appId;
	input.loginIdType = loginIdType;	
	input.deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	input.deviceModel = [[UIDevice currentDevice] model];
	input.deviceOS = [RegisterUserRequest getdeviceOS];
	input.countryCode = [LocaleUtils getCountryCode];
	input.language = [LocaleUtils getLanguageCode];
	input.deviceToken = deviceToken;
	input.nickName = nickName;
    input.avatar = avatar;
    input.accessToken = accessToken;
    input.accessTokenSecret = accessTokenSecret;
    input.province = province;
    input.city = city;
    input.location = location;
    input.gender = gender;
    input.birthday = birthday;
    input.sinaNickName = sinaNickName;
    input.sinaDomain = sinaDomain;
    input.qqNickName = qqNickName;
    input.qqDomain = qqDomain;
	
    // for test, to be removed
    //input.deviceId = [NSString stringWithInt:time(0)];
    
	if ([[RegisterUserRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}

+ (RegisterUserOutput*)send:(NSString*)serverURL
                    loginId:(NSString*)loginId
                loginIdType:(int)loginIdType
                deviceToken:(NSString*)deviceToken
                   nickName:(NSString*)nickName
                     avatar:(NSString *)avatar
                accessToken:(NSString *)accessToken
          accessTokenSecret:(NSString *)accessTokenSecret
                      appId:(NSString*)appId
                   province:(int)province
                       city:(int)city
                   location:(NSString *)location
                     gender:(NSString *)gender
                   birthday:(NSString *)birthday
                     domain:(NSString *)domain
{
    if (loginIdType == LOGINID_SINA){
        return [RegisterUserRequest send:serverURL loginId:loginId loginIdType:loginIdType deviceToken:deviceToken nickName:nickName avatar:avatar accessToken:accessToken accessTokenSecret:accessTokenSecret appId:appId province:province city:city location:location gender:gender birthday:birthday sinaNickName:nickName sinaDomain:domain qqNickName:nil qqDomain:nil];
    }
    else if (loginIdType == LOGINID_QQ){
        return [RegisterUserRequest send:serverURL loginId:loginId loginIdType:loginIdType deviceToken:deviceToken nickName:nickName avatar:avatar accessToken:accessToken accessTokenSecret:accessTokenSecret appId:appId province:province city:city location:location gender:gender birthday:birthday sinaNickName:nil sinaDomain:nil qqNickName:nickName qqDomain:domain];        
    }
    else{
        return [RegisterUserRequest send:serverURL loginId:loginId loginIdType:loginIdType deviceToken:deviceToken nickName:nickName avatar:avatar accessToken:accessToken accessTokenSecret:accessTokenSecret appId:appId province:province city:city location:location gender:gender birthday:birthday sinaNickName:nil sinaDomain:nil qqNickName:nil qqDomain:nil];                
    }
}

@end

