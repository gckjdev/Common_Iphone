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
#import "NetworkUtil.h"

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

+ (NSString*)appendVersion:(NSString*)url
{
	NSString* retUrl = url;
	
	retUrl = [retUrl stringByAddQueryParameter:PARA_VERSION	value:[CURRENT_VERSION encodedURLParameterString]];	
	
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
    urlString = [NetworkRequest appendVersion:urlString];
	
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

- (BOOL)setPostData:(NSMutableURLRequest*)request postData:(NSData*)postData {
    
    if (postData == nil){
        return YES;
    }    

	[request setHTTPMethod:@"POST"];

    
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
     
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    
    // add content type header
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"f\"; filename=\"1.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:postData];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    return YES;
}


- (BOOL)sendPostRequest:(NSObject*)input output:(NSObject*)output postData:(NSData*)postData
{
	NSString* urlString = [self getRequestUrlString:input];	
	if (urlString == nil){
		NSLog(@"send request, but getRequestUrlString failure");
		return NO;
	}
	
	urlString = [NetworkRequest appendTimeStampAndMacToURL:urlString];
    urlString = [NetworkRequest appendVersion:urlString];
	
	BOOL result = NO;	
	NSURL* url = [NSURL URLWithString:urlString];	
	if (url == nil){
		NSLog(@"send request, but URL(%@) incorrect", urlString);
		return NO;
	}
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[self setPostData:request postData:postData];
    
	[request addValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
	[request setValue:[NSString stringWithFormat:@"%llu", [postData length]] forHTTPHeaderField:@"Content-Length"];
    
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

@synthesize resultMessage, resultCode, jsonDataArray, jsonDataDict;

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
    [jsonDataArray release];
    [jsonDataDict release];
	[super dealloc];
}


@end

