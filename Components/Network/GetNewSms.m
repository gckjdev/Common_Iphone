//
//  GetNewSms.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetNewSms.h"
#import "TimeUtils.h"

@implementation GetNewSmsInput

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
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETNEWSMS];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	
	return str;
}

- (void)dealloc
{
	[userId release];
	[appId release];
	
	[super dealloc];	
}

@end

@implementation GetNewSmsOutput

@synthesize smsIdList;

- (void)dealloc
{
	[smsIdList release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, [smsIdList description]];
}

@end



@implementation GetNewSmsRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetNewSmsRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetNewSmsInput class]]){
		GetNewSmsInput* obj = (GetNewSmsInput*)input;
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
	NSLog(@"GetNewSmsRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetNewSmsOutput class]]){
		
		GetNewSmsOutput* obj = (GetNewSmsOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			obj.smsIdList = [obj arrayFromJSON:textData];
			NSLog(@"GetNewSmsRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetNewSmsRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (GetNewSmsOutput*)GetNewSms:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId
{
	int result = kResultSuccess;
	GetNewSmsInput* input = [[GetNewSmsInput alloc] init];
	GetNewSmsOutput* output = [[[GetNewSmsOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
	
	if ([[GetNewSmsRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = kErrorNetworkProblem;
	}
	
	[input release];
	
	return output;	
}



@end

