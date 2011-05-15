//
//  DeliverReport.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "DeliverReport.h"
#import "TimeUtils.h"

@implementation DeliverReportInput

@synthesize smsId;
@synthesize userId;
@synthesize appId;
@synthesize deliveryDate;
@synthesize readDate;

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	str = [str stringByAddQueryParameter:METHOD value:METHOD_DELIVERREPORT];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_MESSAGEID value:smsId];
	
	if (deliveryDate)
		str = [str stringByAddQueryParameter:PARA_DELIVERYDATE value:dateToUTCStringByFormat(deliveryDate, DEFAULT_DATE_FORMAT)];

	if (readDate)
		str = [str stringByAddQueryParameter:PARA_READDATE value:dateToUTCStringByFormat(readDate, DEFAULT_DATE_FORMAT)];
	
	return str;
}

- (void)dealloc
{
	[deliveryDate release];
	[readDate release];
	[smsId	release];
	[userId release];
	[appId release];
	[super dealloc];	
}

@end

@implementation DeliverReportOutput

@synthesize	deliverDate;
@synthesize readDate;
@synthesize smsId;	
@synthesize hasLocation;
@synthesize from;
@synthesize to;
@synthesize latitude;
@synthesize clientStatus;
@synthesize submitDate;
@synthesize isSecure;
@synthesize deliverErrorCode;
@synthesize longtitude;
@synthesize smsText;
@synthesize smsType;
@synthesize status;

- (void)dealloc
{
	[smsId	release];
	[deliverDate release];
	[readDate release];
	[from release];
	[to release];
	[submitDate release];
	[smsText release];
	
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d", resultCode];
}

@end



@implementation DeliverReportRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[DeliverReportRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[DeliverReportInput class]]){
		DeliverReportInput* obj = (DeliverReportInput*)input;
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
	NSLog(@"DeliverReportRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[DeliverReportOutput class]]){
		
		DeliverReportOutput* obj = (DeliverReportOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			
//			NSDictionary* retDict = [obj dictionaryDataFromJSON:textData];			
//			obj.deliverDate = dateFromUTCStringByFormat([smsDict objectForKey:PARA_DELIVERYDATE], DEFAULT_DATE_FORMAT);			
			NSLog(@"DeliverReportRequest result=%d, data=%@", obj.resultCode, [obj description]);			
			
			return YES;
		}
		else {
			NSLog(@"DeliverReportRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

@end

