//
//  NetworkRequest.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "NetworkRequest.h"
#import "JSON.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "StringUtil.h"

@implementation NetworkRequest

@synthesize serverURL;

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[NetworkRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{
	return nil;
}

// virtual method
- (BOOL)parseToReponse:(NSData*)data output:(NSObject*)output
{
	return NO;
}

- (NSString*)getBaseUrlString
{
	return [NSString stringWithString:serverURL];
}

+ (NSString*)appendTimeStampAndMacToURL:(NSString*)url
{
	NSString* retUrl = url;
	
	NSString* dateString = [NSString stringWithInt:[[NSDate date] timeIntervalSince1970]];
	NSString* macString = [dateString encodeMD5Base64:SHARE_KEY];
	
	retUrl = [retUrl stringByAddQueryParameter:PARA_TIMESTAMP value:dateString];
	retUrl = [retUrl stringByAddQueryParameter:PARA_MAC	value:[macString encodedURLParameterString]];
	
	
	return retUrl;
}

- (BOOL)sendRequest:(NSObject*)input output:(NSObject*)output
{
	NSString* urlString = [self getRequestUrlString:input];	
	if (urlString == nil){
		NSLog(@"send request, but getRequestUrlString failure");
		return NO;
	}
	
	urlString = [NetworkRequest appendTimeStampAndMacToURL:urlString];
	
	BOOL result = NO;	
	NSURL* url = [NSURL URLWithString:urlString];	
	if (url == nil){
		NSLog(@"send request, but URL(%@) incorrect", urlString);
		return NO;
	}
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];	
	//	[request addValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];
	//	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
	if (request == nil){
		NSLog(@"send request, but NSMutableURLRequest is nil");
		return NO;
	}
	
	NSError* error = nil;
	NSURLResponse* response = nil;
	
	// Send request by the connection
	NSLog(@"Send http request=%@", urlString);
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;	
	if (error != nil) {
		NSLog(@"Send http request error, error=%@", [error localizedDescription]);
		return NO;
	}
	else if (httpResponse == nil || (httpResponse.statusCode / 100) != 2) {
		NSLog(@"HTTP response failure, code=%d", httpResponse.statusCode);
		return NO;
	} 
	else {
		
		result = [self parseToReponse:data output:output];
	}	
	
	return YES;
}

- (void)dealloc
{
	[serverURL release];
	[super dealloc];
}

@end

@implementation CommonOutput

@synthesize resultMessage, resultCode;

- (void)resultFromJSON:(NSString*)jsonString
{
	// get code and message
	NSDictionary* dict = [jsonString JSONValue];		
	self.resultCode = [[dict objectForKey:@"ret"] intValue];				
//	self.resultMessage = [dict objectForKey:@"msg"];		
}

- (NSArray*)arrayFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSArray* retArray = [dict objectForKey:@"dat"];
	
	return retArray;
}

- (NSDictionary*)dictionaryDataFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSDictionary* retDict = [dict objectForKey:PARA_DATA];
	
	return retDict;
}

- (void)dealloc
{
	[resultMessage release];
	[super dealloc];
}


@end
