//
//  SmsStatusQuery.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "SmsStatusQuery.h"
#import "TimeUtils.h"

@implementation SmsStatusQueryInput

@synthesize readSmsIdList;
@synthesize deliverSmsIdList;
@synthesize userId;
@synthesize appId;

- (NSString*)getSmsListString:(NSArray*)list
{
	if (list == nil || [list count] <= 0)
		return @"";
	
	NSString* retStr = [NSString stringWithString:@""];
	
	for (NSString* smsId in list){
		if (smsId == [list lastObject]){
			retStr = [retStr stringByAppendingString:smsId];
		}
		else {
			retStr = [retStr stringByAppendingString:smsId];
			retStr = [retStr stringByAppendingString:@";"];
		}
	}

	return retStr;
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	str = [str stringByAddQueryParameter:METHOD value:METHOD_SMSSTATUSQUERY];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	
	if (readSmsIdList != nil && [readSmsIdList count] > 0)
		str = [str stringByAddQueryParameter:PARA_READ_SMSIDLIST value:[self getSmsListString:readSmsIdList]];
	
	if (deliverSmsIdList != nil && [deliverSmsIdList count] > 0)	
		str = [str stringByAddQueryParameter:PARA_DELIVER_SMSIDLIST value:[self getSmsListString:deliverSmsIdList]];
	
	return str;
}

- (void)dealloc
{
	[readSmsIdList release];
	[deliverSmsIdList release];
	[userId release];
	[appId release];

	[super dealloc];	
}

@end

@implementation SmsStatusQueryOutput

@synthesize	smsStatusList;

- (void)dealloc
{
	[smsStatusList	release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, smsStatusList=%@", resultCode, [smsStatusList description]];
}

+ (NSDate*)deliverDateByOutputDict:(NSDictionary*)dict
{
	return dateFromUTCStringByFormat([dict objectForKey:PARA_DELIVERYDATE], DEFAULT_DATE_FORMAT);
}

+ (NSDate*)readDateByOutputDict:(NSDictionary*)dict
{
	return dateFromUTCStringByFormat([dict objectForKey:PARA_READDATE], DEFAULT_DATE_FORMAT);
}

+ (NSNumber*)statusByOutputDict:(NSDictionary*)dict
{
	return [dict objectForKey:PARA_STATUS];
}

+ (NSNumber*)clientStatusByOutputDict:(NSDictionary*)dict
{
	return [dict objectForKey:PARA_CLIENTSTATUS];
}


@end



@implementation SmsStatusQueryRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[SmsStatusQueryRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[SmsStatusQueryInput class]]){
		SmsStatusQueryInput* obj = (SmsStatusQueryInput*)input;
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
	NSLog(@"SmsStatusQueryRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[SmsStatusQueryOutput class]]){
		
		SmsStatusQueryOutput* obj = (SmsStatusQueryOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			
			obj.smsStatusList = [obj dictionaryDataFromJSON:textData];			
			NSLog(@"SmsStatusQueryRequest result=%d, data=%@", obj.resultCode, [obj description]);			
			
			return YES;
		}
		else {
			NSLog(@"SmsStatusQueryRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (SmsStatusQueryOutput*)smsStatusQuery:serverURL userId:(NSString*)userId appId:(NSString*)appId readSmsIdList:(NSArray*)readSmsIdList deliverSmsIdList:(NSArray*)deliverSmsIdList
{
	int result = kResultSuccess;
	SmsStatusQueryInput* input = [[SmsStatusQueryInput alloc] init];
	SmsStatusQueryOutput* output = [[[SmsStatusQueryOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
	input.readSmsIdList = readSmsIdList;
	input.deliverSmsIdList = deliverSmsIdList;
	
	if ([[SmsStatusQueryRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = kErrorNetworkProblem;
	}
	
	[input release];
	
	return output;	
}



@end

