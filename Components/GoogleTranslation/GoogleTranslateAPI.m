//
//  GoogleTranslateAPI.m
//  FreeSMS
//
//  Created by Peng Lingzhe on 1/11/11.
//  Copyright 2011 Ericsson. All rights reserved.
//

#import "GoogleTranslateAPI.h"
#import "StringUtil.h"
#import "JSON.h"

#define kGoogleTranslateApiKey @"AIzaSyCkOzZA64NuWVp2ketUtMtjls-uO4C0GEQ"

@implementation GoogleTranslateAPI

+ (NSString*)translateFrom:(NSString*)sourceLang targetLang:(NSString*)targetLang text:(NSString*)text apiKey:(NSString*)apiKey
{
	
	// https://www.googleapis.com/language/translate/v2?key=INSERT-YOUR-KEY&source=en&target=de&q=Hello%20world
	NSString* urlString = [[NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&source=%@&target=%@&q=%@",
						   apiKey, sourceLang, targetLang, text] stringByURLEncode];
	
	if (urlString == nil || [urlString length] == 0){
		NSLog(@"send google translation request, but urlString is nil");
		return nil;
	}

	NSURL* url = [NSURL URLWithString:urlString];	
	if (url == nil){
		NSLog(@"send google translation, but URL(%@) incorrect", urlString);
		return nil;
	}
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];	
	[request addValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  	
	if (request == nil){
		NSLog(@"send google translation, but NSMutableURLRequest is nil");
		return nil;
	}
	
	NSError* error = nil;
	NSURLResponse* response = nil;
	
	// Send request by the connection
	NSLog(@"Send http request=%@", urlString);
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;	
	if (error != nil) {
		NSLog(@"Send http request error, error=%@", [error localizedDescription]);
	}
	else if (httpResponse == nil || (httpResponse.statusCode / 100) != 2) {
		NSLog(@"HTTP response failure, code=%d", httpResponse.statusCode);
		return NO;
	} 
	else {		
		if (data != nil){
			NSString* textData = [[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding] autorelease];		
			NSLog(@"response data=%@", textData);			
			
			NSString* transText = nil;
			NSDictionary* dataDict = [[textData JSONValue] objectForKey:@"data"];
			NSArray* transArray = [dataDict objectForKey:@"translations"];
			if (transArray != nil && [transArray count] > 0){
				transText = [[transArray objectAtIndex:0] objectForKey:@"translatedText"];
			}	
			
			NSLog(@"Translation %@ from %@ to %@, result=%@",
				  text, sourceLang, targetLang, transText);
			
			return transText;
		}
		else {
			NSLog(@"HTTP response success but no data");
		}

	}	
	
	return nil;
	
}

+ (NSString*)translateFrom:(NSString*)sourceLang targetLang:(NSString*)targetLang text:(NSString*)text
{
	return [GoogleTranslateAPI translateFrom:sourceLang targetLang:targetLang text:text apiKey:kGoogleTranslateApiKey];
}

+ (NSString*)translateCnToTw:(NSString*)text
{
	return [GoogleTranslateAPI translateFrom:@"zh-CN" targetLang:@"zh-TW" text:text];
}

@end
