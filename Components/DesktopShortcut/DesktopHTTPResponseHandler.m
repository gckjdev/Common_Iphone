//
//  DesktopHTTPResponseHandler.m
//  TouchIcon
//
//  Created by penglzh on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DesktopHTTPResponseHandler.h"
#import "HTTPServer.h"

NSMutableDictionary* httpDataDict;

@implementation DesktopHTTPResponseHandler

+ (BOOL)hasData
{
	return [[httpDataDict allKeys] count] > 0;
}

NSData *pageData;

+ (void)setPageData:(NSData *)data
{
	pageData = [data retain];
}

+ (NSData *)getPageData
{
	return pageData;
} 

+ (void)setPageData:(NSData *)data forKey:(NSString*)key
{
	if (httpDataDict == nil){
		httpDataDict = [[NSMutableDictionary alloc] init];
	}
	
	[httpDataDict setValue:data forKey:key];
}

+ (NSData *)getPageData:(NSString*)key
{		
	return [httpDataDict objectForKey:key];
}

+ (void)cleanAllData
{
	[httpDataDict removeAllObjects];
}

+ (void)load
{
	[HTTPResponseHandler registerHandler:self];
}

+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
				  method:(NSString *)requestMethod
					 url:(NSURL *)requestURL
			headerFields:(NSDictionary *)requestHeaderFields
{
	NSLog(@"request URL path=%@", requestURL.path);
	if ([requestURL.path hasPrefix:@"/"])
	{
		return YES;
	}
	
	return NO;
}

- (void)startResponse
{	
	NSLog(@"URL path=%@", url.path);
	if ([url.path length] == 0){
		NSLog(@"<startResponse> but URL path(%@) is zero", url.path);
		return;
	}
	
//	NSString* key = [url.path substringFromIndex:1];	
//	NSData* pageData = [httpDataDict objectForKey:key];
//	if (pageData == nil)
//		return;
	
	CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/html");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Length", (CFStringRef)[NSString stringWithFormat:@"%ld", [pageData length]]);

	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);		
	
	@try
	{
		[fileHandle writeData:(NSData *)headerData];
		[fileHandle writeData:pageData];
		
	}
	@catch (NSException *exception)
	{
		// Ignore the exception, it normally just means the client
		// closed the connection from the other end.
	}
	@finally
	{
		CFRelease(headerData);
		CFRelease(response);
		[server closeHandler:self];
	}
	
//	[DesktopHTTPResponseHandler setPageData:nil];
//	[[HTTPServer sharedHTTPServer] stop];
}



@end
