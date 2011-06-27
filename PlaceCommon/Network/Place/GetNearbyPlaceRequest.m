//
//  GetNearbyPlace.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetNearbyPlaceRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetNearbyPlaceInput

@synthesize userId;
@synthesize appId;
@synthesize longitude;
@synthesize latitude;
@synthesize beforeTimeStamp;
@synthesize maxCount;

- (void)dealloc
{
	[appId release];
    [userId release];   
    [beforeTimeStamp release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETNEARBYPLACE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
	str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
	
    if (beforeTimeStamp != nil){
        str = [str stringByAddQueryParameter:PARA_BEFORE_TIMESTAMP value:beforeTimeStamp];
    }
    
	return str;
}

@end

@implementation GetNearbyPlaceOutput

@synthesize placeArray;

- (void)dealloc
{
    [placeArray release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, [placeArray description]];
}

@end



@implementation GetNearbyPlaceRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetNearbyPlaceRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetNearbyPlaceInput class]]){
		GetNearbyPlaceInput* obj = (GetNearbyPlaceInput*)input;
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
	NSLog(@"GetNearbyPlaceRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetNearbyPlaceOutput class]]){
		
		GetNearbyPlaceOutput* obj = (GetNearbyPlaceOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
            obj.placeArray = [obj arrayFromJSON:textData];
			NSLog(@"GetNearbyPlaceRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetNearbyPlaceRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (GetNearbyPlaceOutput*)send:(NSString*)serverURL 
                       userId:(NSString*)userId 
                        appId:(NSString*)appId 
                    longitude:(double)longitude
                     latitude:(double)latitude
              beforeTimeStamp:(NSString*)beforeTimeStamp
{
	int result = ERROR_SUCCESS;
	GetNearbyPlaceInput* input = [[GetNearbyPlaceInput alloc] init];
	GetNearbyPlaceOutput* output = [[[GetNearbyPlaceOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.latitude = latitude;
    input.longitude = longitude;
    input.beforeTimeStamp = beforeTimeStamp;
    input.maxCount = kMaxCount;
	
	if ([[GetNearbyPlaceRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}

+ (void)test
{
}

@end

