//
//  DeleteSms.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "DeleteSms.h"
#import "TimeUtils.h"

@implementation DeleteSmsInput

@synthesize smsId;
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
	str = [str stringByAddQueryParameter:METHOD value:METHOD_DELETESMS];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_MESSAGEID value:smsId];
	
	return str;
}

- (void)dealloc
{
	[smsId release];
	[userId release];
	[appId release];
	
	[super dealloc];	
}

@end

@implementation DeleteSmsOutput


- (void)dealloc
{
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d", resultCode];
}

@end



@implementation DeleteSmsRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[DeleteSmsRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[DeleteSmsInput class]]){
		DeleteSmsInput* obj = (DeleteSmsInput*)input;
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
	NSLog(@"DeleteSmsRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[DeleteSmsOutput class]]){
		
		DeleteSmsOutput* obj = (DeleteSmsOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			
			NSLog(@"DeleteSmsRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"DeleteSmsRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (DeleteSmsOutput*)DeleteSms:serverURL userId:(NSString*)userId appId:(NSString*)appId smsId:(NSString*)smsId
{
	int result = kResultSuccess;
	DeleteSmsInput* input = [[DeleteSmsInput alloc] init];
	DeleteSmsOutput* output = [[[DeleteSmsOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
	input.smsId = smsId;
	
	if ([[DeleteSmsRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = kErrorNetworkProblem;
	}
	
	[input release];
	
	return output;	
}



@end

