//
//  SendSms.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-16.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "SendSms.h"
#import "StringUtil.h"
#import "TimeUtils.h"
#import "GTMBase64.h"

@implementation SendSmsInput

@synthesize userId;
@synthesize receiverUserId;
@synthesize text;
@synthesize sendDate;
@synthesize isSecure;
@synthesize isSendLocation;
@synthesize latitude;
@synthesize longtitude;
@synthesize appId;

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	str = [str stringByAddQueryParameter:METHOD value:METHOD_SUBMITSMS];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_RUSERID value:receiverUserId];
	
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	if (sendDate){
		str = [str stringByAddQueryParameter:PARA_SENDDATE value:dateToUTCStringByFormat(sendDate, DEFAULT_DATE_FORMAT)];
	}
	if (isSecure){
		str = [str stringByAddQueryParameter:PARA_ISSECURE boolValue:isSecure];
	}
	if (isSendLocation){
		str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longtitude];		
		str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];				
	}
	
	if (isSecure){
		str = [str stringByAddQueryParameter:PARA_SMSTEXT value:[text encode3DESBase64:kEncryptKey]];
	}
	else {
		str = [str stringByAddQueryParameter:PARA_SMSTEXT value:text];
	}

	
	return str;
}

- (void)dealloc
{
	[userId	release];
	[receiverUserId release];
	[text release];
	[sendDate release];		
	[appId release];
	[super dealloc];	
}

@end

@implementation SendSmsOutput

@synthesize messsageId;

- (void)dealloc
{
	[messsageId	release];
	[super dealloc];	
}

@end



@implementation SendSmsRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[SendSmsRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{
	// m=ss&t=xxx&uid=xxx&ruid=xxx&ti=xxx&su=0&lat=xxx&long=xxx
	
	if ([input isKindOfClass:[SendSmsInput class]]){
		SendSmsInput* obj = (SendSmsInput*)input;
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
	NSLog(@"SendSmsRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[SendSmsOutput class]]){
		
		SendSmsOutput* obj = (SendSmsOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			
			obj.messsageId = [[obj dictionaryDataFromJSON:textData] objectForKey:PARA_MESSAGEID];
			
			NSLog(@"SendSmsRequest result=%d, messageId=%@", obj.resultCode, obj.messsageId);						
			return YES;
		}
		else {
			NSLog(@"SendSmsRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

@end


