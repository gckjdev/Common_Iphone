//
//  CreatePlace.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "CreatePlaceRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation CreatePlaceInput

@synthesize userId;
@synthesize name;
@synthesize description;
@synthesize longtitude;
@synthesize latitude;
@synthesize appId;
@synthesize radius;
@synthesize postType;


- (void)dealloc
{
	[appId release];
	[name release];
    [description release];
    [userId release];    
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_CREATEPLACE];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longtitude];
	str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
	str = [str stringByAddQueryParameter:PARA_RADIUS intValue:radius];
	str = [str stringByAddQueryParameter:PARA_POSTTYPE intValue:postType];
	str = [str stringByAddQueryParameter:PARA_NAME value:name];
	str = [str stringByAddQueryParameter:PARA_DESC value:description];
	
	return str;
}

@end

@implementation CreatePlaceOutput

@synthesize placeId;
//@synthesize createUser;

- (void)dealloc
{
	[placeId release];
//    [createUser release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, placeId];
}

@end



@implementation CreatePlaceRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[CreatePlaceRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[CreatePlaceInput class]]){
		CreatePlaceInput* obj = (CreatePlaceInput*)input;
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
	NSLog(@"CreatePlaceRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[CreatePlaceOutput class]]){
		
		CreatePlaceOutput* obj = (CreatePlaceOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
			// obj.placeId = xxxx	
            // obj.createUser = xxx
            NSDictionary* data = [obj dictionaryDataFromJSON:textData];
            obj.placeId = [data objectForKey:PARA_PLACEID];
            
			NSLog(@"CreatePlaceRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"CreatePlaceRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (CreatePlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId name:(NSString*)name description:(NSString*)description longtitude:(double)longtitude latitude:(double)latitude
{
	int result = ERROR_SUCCESS;
	CreatePlaceInput* input = [[CreatePlaceInput alloc] init];
	CreatePlaceOutput* output = [[[CreatePlaceOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.name = name;
    input.description = description;
    input.longtitude = longtitude;
    input.latitude = latitude;
    input.radius = DEFAULT_PLACE_RADIUS;
    input.postType = PLACE_POST_TYPE_OPEN;
	
	if ([[CreatePlaceRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[CreatePlaceRequest send:SERVER_URL userId:@"test_user" appId:@"test_app" name:@"my_place1" description:@"my place desc" longtitude:111.44f latitude:444.33f];
}

@end

