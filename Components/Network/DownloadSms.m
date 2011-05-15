//
//  DownloadSms.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "DownloadSms.h"
#import "TimeUtils.h"

@implementation DownloadSmsInput

@synthesize smsId;
@synthesize userId;
@synthesize appId;

- (void)dealloc
{
	[smsId	release];
	[userId release];
	[appId release];
	[super dealloc];	
}

@end

@implementation DownloadSmsOutput

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
	return [NSString stringWithFormat:@"deliverDate=%@, readDate=%@, smsId=%@, hasLocation=%d, from=%@, to=%@,\
			latitude=%f, longtitude=%f, clientStatus=%d, submitDate=%@, isSecure=%d, smsText=%@, smsType=%d, status=%d",
			deliverDate, readDate, smsId, hasLocation, from, to, latitude, longtitude,
			clientStatus, submitDate, isSecure, smsText, smsType, status];
}

@end



@implementation DownloadSmsRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[DownloadSmsRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{
	// m=srpt&uid=+8613802538605&s=1
	
	if ([input isKindOfClass:[DownloadSmsInput class]]){
		DownloadSmsInput* obj = (DownloadSmsInput*)input;
		NSString* url = [NSString stringWithFormat:@"%@m=ds&mid=%@&uid=%@&app=%@",
						 [self getBaseUrlString],
						 obj.smsId,
						 obj.userId,
						 obj.appId];
		
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
	NSLog(@"DownloadSmsRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[DownloadSmsOutput class]]){
		
		DownloadSmsOutput* obj = (DownloadSmsOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
			
			NSDictionary* smsDict = [obj dictionaryDataFromJSON:textData];
			
			obj.deliverDate = dateFromUTCStringByFormat([smsDict objectForKey:PARA_DELIVERYDATE], DEFAULT_DATE_FORMAT);
			obj.readDate = dateFromUTCStringByFormat([smsDict objectForKey:PARA_READDATE], DEFAULT_DATE_FORMAT);
			obj.smsId = [smsDict objectForKey:PARA_MESSAGEID];
			obj.from = [smsDict objectForKey:PARA_FROM];
			obj.to = [smsDict objectForKey:PARA_TO];
			obj.latitude = [[smsDict objectForKey:PARA_LATITUDE] doubleValue];
			obj.clientStatus = [[smsDict objectForKey:PARA_CLIENTSTATUS] intValue];
			obj.submitDate = dateFromUTCStringByFormat([smsDict objectForKey:PARA_SUBMITDATE],DEFAULT_DATE_FORMAT);
			obj.isSecure = [[smsDict objectForKey:PARA_ISSECURE] boolValue];
			obj.deliverErrorCode = [[smsDict objectForKey:PARA_DELIVERERRORCODE] intValue];
			obj.longtitude = [[smsDict objectForKey:PARA_LONGTITUDE] doubleValue];
			if (obj.isSecure){
				obj.smsText = [[smsDict objectForKey:PARA_SMSTEXT] decodeBase643DES:kEncryptKey];
			}
			else {
				obj.smsText = [smsDict objectForKey:PARA_SMSTEXT];				
			}

			obj.smsType = [[smsDict objectForKey:PARA_SMSTYPE] intValue];
			obj.status = [[smsDict objectForKey:PARA_SMSSTATUS] intValue];
			
			if ([smsDict objectForKey:PARA_LONGTITUDE] != nil && [smsDict objectForKey:PARA_LATITUDE] != nil){
				obj.hasLocation = YES;
			}
			else {
				obj.hasLocation = NO;
			}

			NSLog(@"DownloadSmsRequest result=%d, data=%@", obj.resultCode, [obj description]);			
			
			return YES;
		}
		else {
			NSLog(@"DownloadSmsRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}

@end

