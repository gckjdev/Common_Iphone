//
//  RefreshContact.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "RefreshContact.h"
#import "TimeUtils.h"

@implementation RefreshContactInput

@synthesize userId;
@synthesize appId;
@synthesize countryTelPrefix;

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
	str = [str stringByAddQueryParameter:METHOD value:METHOD_RFRESHCONTACT];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_COUNTRYTEL value:countryTelPrefix];
	
	return str;
}

- (void)dealloc
{
	[userId release];
	[appId release];
	[countryTelPrefix release];
	
	[super dealloc];	
}

@end

@implementation RefreshContactOutput

@synthesize contactList;

- (void)dealloc
{
	[contactList release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, [contactList description]];
}

+ (int)getContactId:(NSDictionary*)contactDict
{
	return [[contactDict objectForKey:PARA_CONTACTID] intValue];
}

+ (NSString*)getContactUserId:(NSDictionary*)contactDict
{
	return [contactDict objectForKey:PARA_CONTACTUSERID];
}

+ (int)getContactStatus:(NSDictionary*)contactDict
{
	return [[contactDict objectForKey:PARA_CONTACTSTATUS] intValue];	
}

@end

@implementation RefreshContactRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[RefreshContactRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[RefreshContactInput class]]){
		RefreshContactInput* obj = (RefreshContactInput*)input;
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
	NSLog(@"RefreshContactRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[RefreshContactOutput class]]){
		
		RefreshContactOutput* obj = (RefreshContactOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			obj.contactList = [obj arrayFromJSON:textData];
			NSLog(@"RefreshContactRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"RefreshContactRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

+ (RefreshContactOutput*)RefreshContact:serverURL userId:(NSString*)userId appId:(NSString*)appId countryTelPrefix:(NSString*)countryTelPrefix
{
	int result = kResultSuccess;
	RefreshContactInput* input = [[RefreshContactInput alloc] init];
	RefreshContactOutput* output = [[[RefreshContactOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
	input.countryTelPrefix = countryTelPrefix;
	
	if ([[RefreshContactRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = kErrorNetworkProblem;
	}
	
	[input release];
	
	return output;	
}



@end

