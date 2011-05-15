//
//  BasicSearch.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-2-28.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "BasicSearch.h"


@implementation BasicSearch

@synthesize jsonData, connection, apiKey, site, data;
@synthesize delegate, maxStart, maxStartPage;

- (NSString *)getLocationText:(CLLocation *)location
{
	return [NSString stringWithFormat:@"%.4f,%.4f", location.coordinate.latitude, location.coordinate.longitude];
}

- (BOOL)startSearch:(NSString *)searchText location:(CLLocation *)location
{
	return YES;
}

- (NSString *)getApiKey
{
	if (self.apiKey == nil){
		return kApiKey;
	}
	else {
		return self.apiKey;
	}
}

- (NSString *)getSite
{
	if (self.site == nil){
		return kDefaultSite;
	}
	else {
		return self.site;
	}

}

- (NSMutableURLRequest*)encodeURLReuqest:(NSString*)requestURLString
{
	// create URL object by string
	NSURL* url = [NSURL URLWithString:requestURLString];
	if (url == nil){
		return nil;
	}
	
	// create URL request object by URL
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];	
	if (request == nil)
		return nil;
	
	// set request header
	[request addValue:[self getSite] forHTTPHeaderField:@"Referer"];
	
	return request;
}

- (NSString *)getSearchURL
{
	return nil;
}

- (NSString*)encodeStandardUrl:(NSString*)searchText
{
	// encode URL correctly
	NSString*	encodeSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    // url  : http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=Paris%20Hilton&key=ABQIAAAAJdzN96RRUbxN4fP9XYUlhRQwZP1a_wydawaKMe3zeLz8jRvcXxSNt_fz33qs9P1AOxjtI_DvjMB2dw&userip=192.168.0.1	
	NSString*	requestURLString = [NSString stringWithFormat:@"%@?v=1.0&q=%@&key=%@&rsz=large&userip=%@",
									[self getSearchURL], encodeSearchText, [self getApiKey], kIpAddress];	
	
	return requestURLString;
}

- (NSString*)appendStart:(NSString*)requestURLString start:(int)start
{
	// add image search size parameter
	return [NSString stringWithFormat:@"%@&start=%d", requestURLString, start];	
}


- (NSHTTPURLResponse*)sendSyncRequest:(NSURLRequest*)request
{
	NSError* error = [[[NSError alloc] init] autorelease];
	NSURLResponse* response = [[[NSURLResponse alloc] init] autorelease];
	
	self.data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (self.data == nil) {
		NSLog(@"<Error> sendSynchronousRequest, return nil data, error is %@", [error localizedDescription]);
	}
	
	return (NSHTTPURLResponse *)response;
}

- (void)dealloc
{
	[jsonData release];
	[connection release];
	[apiKey release];
	[site release];
	[data release];
	
	[super dealloc];
}

@end

