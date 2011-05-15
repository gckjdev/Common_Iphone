
#import "RegisterUser.h"

@implementation RegisterUserInput

@synthesize userId;
@synthesize userType;
@synthesize appId;
@synthesize deviceId;
@synthesize deviceType;
@synthesize deviceModel;
@synthesize countryCode;
@synthesize password;
@synthesize language;
@synthesize deviceToken;
@synthesize defaultLoginType;

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	str = [str stringByAddQueryParameter:METHOD value:METHOD_REGISTRATION];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_DEFAULTLOGINTYPE intValue:defaultLoginType];
	str = [str stringByAddQueryParameter:PARA_DEVICEID value:deviceId];
	str = [str stringByAddQueryParameter:PARA_DEVICETYPE intValue:deviceType];
	str = [str stringByAddQueryParameter:PARA_DEVICEMODEL value:deviceModel];
	str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:countryCode];
	str = [str stringByAddQueryParameter:PARA_LANGUAGE value:language];
	str = [str stringByAddQueryParameter:PARA_DEVICETOKEN value:deviceToken];
	str = [str stringByAddQueryParameter:PARA_REQFROM intValue:FROM_APP];
	
	
	
	
	return str;
}

- (void)dealloc
{
	[password release];
	[appId release];
	[userId	release];
	[deviceId release];
	[deviceModel release];
	[countryCode release];
	[language release];
	[deviceToken release];
	[super dealloc];	
}

@end

@implementation RegisterUserOutput

@synthesize code;

- (void)dealloc
{
	[code release];
	[super dealloc];	
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
			NSLog(@"RegisterUserRequest result=%d", obj.resultCode);				
			obj.code = obj.resultMessage;
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

@end
