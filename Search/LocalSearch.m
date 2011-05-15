//
//  LocalSearch.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-2-28.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "LocalSearch.h"
#import "../JSON/JSON.h"
#import "LocalSearchResult.h"

@implementation LocalSearch

- (NSString *)getSearchURL
{
	return kLocalSearchURL;
}

// start to send the request to Google to search
// location can be nil then there is no location information in request
- (BOOL)startSearch:(NSString *)searchText location:(CLLocation *)location
{
	if (self.connection != nil)	// if the connection is not nil, then it's running, cannot start new search!
		return NO;	
	
    NSURL *					url;
    NSMutableURLRequest *   request;
    
	NSString*	encodeSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// site : http://www.mapledance.com
	// key  : ABQIAAAAJdzN96RRUbxN4fP9XYUlhRQwZP1a_wydawaKMe3zeLz8jRvcXxSNt_fz33qs9P1AOxjtI_DvjMB2dw
    //url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=Paris%20Hilton&key=ABQIAAAAJdzN96RRUbxN4fP9XYUlhRQwZP1a_wydawaKMe3zeLz8jRvcXxSNt_fz33qs9P1AOxjtI_DvjMB2dw&userip=192.168.0.1"];    
	
	NSString*	requestURLString = [NSString stringWithFormat:@"%@?v=1.0&q=%@&key=%@&userip=%@",
												[self getSearchURL], encodeSearchText, [self getApiKey], kIpAddress];
	if (location != nil){
		// add location parameter
		requestURLString = [NSString stringWithFormat:@"%@&sll=%@", requestURLString, [self getLocationText:location]];
	}
		
	// need to set right language, hl=fr later	
	// need to set location, sll=48.8565,2.3509
	// need to set result set size, rsz=small/large
	// "http://www.mapledance.com"
	url = [NSURL URLWithString:requestURLString];
	
	// Open a connection for the URL.	
	request = [NSMutableURLRequest requestWithURL:url];	
	if (request == nil)
		return NO;

	// set header
	[request addValue:[self getSite] forHTTPHeaderField:@"Referer"];

	// Send request by the connection
	NSLog(@"Send request");
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	if (connection == nil)
		return NO;

	NSLog(@"Request on-going, URL=%@", requestURLString);
	
	// Initialize JSON data object
	if (self.jsonData != nil){
		[self.jsonData release];
		self.jsonData = nil;
	}
	
	self.jsonData = [NSString stringWithString:@""];

	// tell the delegate that search start...
	if (self.delegate != nil){
		[delegate searchDidStart];
	}	
	
	return YES;
}

- (NSArray *)syncStartSearch:(NSString *)searchText location:(CLLocation *)location startPage:(int)startPage maxResult:(int)maxResult
{
	BOOL					result = NO;	
	NSMutableArray *		returnArray = [[[NSMutableArray alloc] init] autorelease];

	// encode URL correctly
	NSString*	encodeSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// site : http://www.mapledance.com
	// key  : ABQIAAAAJdzN96RRUbxN4fP9XYUlhRQwZP1a_wydawaKMe3zeLz8jRvcXxSNt_fz33qs9P1AOxjtI_DvjMB2dw
    // url  : http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=Paris%20Hilton&key=ABQIAAAAJdzN96RRUbxN4fP9XYUlhRQwZP1a_wydawaKMe3zeLz8jRvcXxSNt_fz33qs9P1AOxjtI_DvjMB2dw&userip=192.168.0.1	
	NSString*	requestURLString = [NSString stringWithFormat:@"%@?v=1.0&q=%@&key=%@&rsz=large&userip=%@",
									[self getSearchURL], encodeSearchText, [self getApiKey], kIpAddress];

	// add location parameter if location is not nil
	if (location != nil){
		// add location parameter
		requestURLString = [NSString stringWithFormat:@"%@&sll=%@", requestURLString, [self getLocationText:location]];
	}

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
	
	NSError* error = [[[NSError alloc] init] autorelease];
	NSURLResponse* response = [[[NSURLResponse alloc] init] autorelease];
	
	// Send request by the connection
	NSLog(@"Send http request=%@", requestURLString);
	self.data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;;	
	if (httpResponse == nil || (httpResponse.statusCode / 100) != 2) {
		result = NO;
	} 
	else
	{
		const void* bytes = [data bytes];
		NSString* textData = [[NSString alloc] initWithBytes:bytes length:[data length] encoding:NSUTF8StringEncoding];		
		NSLog(@"receive data=%@", textData);

		// covert data to array
		NSDictionary* dict = [textData JSONValue];
		
				
		NSDictionary* responseData = [dict objectForKey:@"responseData"];				
		if (responseData){
			NSLog(@"result=%@", responseData);
			
			NSString* cursor = [responseData objectForKey:@"cursor"];
			NSDictionary* results = [responseData objectForKey:@"results"];
			
			NSLog(@"cursor=%@, result=%@", cursor, results);	

			
			if (cursor){
				//NSString* moreResultsUrl = [cursor objectForKey:@"moreResultsUrl"];
				//NSLog(@"moreResultsUrl is %@", moreResultsUrl);
			}
			
			if (results){
				for (NSDictionary* result in results){
					
					LocalSearchResult* resultRecord = [[[LocalSearchResult alloc] init] autorelease];			
					
					resultRecord.country = [result objectForKey:@"country"];
					resultRecord.city = [result objectForKey:@"city"];
					//NSDictionary* addressLines = [result objectForKey:@"addressLines"];										
					//for (NSString* address in addressLines)
					//	NSLog(@"address=%@", address);
					resultRecord.address = [result objectForKey:@"streetAddress"];
					NSArray* phoneNumbers = [result objectForKey:@"phoneNumbers"];
					if (phoneNumbers != nil && [phoneNumbers count] > 0){
						resultRecord.phoneNumber = [[phoneNumbers objectAtIndex:0] objectForKey:@"number"];
						resultRecord.phoneNumber = [resultRecord.phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
						resultRecord.phoneNumber = [resultRecord.phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@" "];
					}
					/*
					for (NSDictionary* phoneNumber in phoneNumbers){
						NSString* phone = [phoneNumber objectForKey:@"number"];
						NSLog(@"phone=%@", phone);
					}
					*/
					resultRecord.name = [result objectForKey:@"title"];
					resultRecord.name = [resultRecord.name stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
					resultRecord.name = [resultRecord.name stringByReplacingOccurrencesOfString:@"</b>" withString:@""];

					//NSString* titleNoFormatting = [result objectForKey:@"titleNoFormatting"];
					
					NSLog(@"%@", resultRecord);
					
					// if phone number exist then add the record, otherwize it's useless
					if (resultRecord.phoneNumber != nil && [resultRecord.phoneNumber length] > 0){
						[returnArray addObject:resultRecord];
					}
				}
			}
			
		}
		
		//{"responseData": {"results":[{"GsearchResultClass":"GlocalSearch","listingType":"local","addressLookupResult":"/maps","lat":"48.856667","lng":"2.350987","accuracy":"4","title":"Paris","titleNoFormatting":"Paris","ddUrl":"http://www.google.com/maps?source\u003duds\u0026daddr\u003dParis%2C+Paris%2C+%C3%8Ele-de-France+%28Paris%29+%4048.856667%2C2.350987\u0026saddr\u003d2133327436%2C-1067548169","ddUrlToHere":"http://www.google.com/maps?source\u003duds\u0026daddr\u003dParis%2C+Paris%2C+%C3%8Ele-de-France+%28Paris%29+%4048.856667%2C2.350987\u0026iwstate1\u003ddir%3Ato","ddUrlFromHere":"http://www.google.com/maps?source\u003duds\u0026saddr\u003dParis%2C+Paris%2C+%C3%8Ele-de-France+%28Paris%29+%4048.856667%2C2.350987\u0026iwstate1\u003ddir%3Afrom","streetAddress":"Paris","city":"Paris","region":"Île-de-France","country":"FR","staticMapUrl":"http://mt.google.com/mapdata?cc\u003dus\u0026tstyp\u003d5\u0026Point\u003db\u0026Point.latitude_e6\u003d48856667\u0026Point.longitude_e6\u003d2350987\u0026Point.iconid\u003d15\u0026Point\u003de\u0026w\u003d150\u0026h\u003d100\u0026zl\u003d4","url":"http://www.google.com/maps?source\u003duds\u0026q\u003dparis","postalCode":"","maxAge":604800,"addressLines":["Paris","France"]}],"cursor":{"moreResultsUrl":"http://www.google.com/local?oe\u003dutf8\u0026ie\u003dutf8\u0026num\u003d4\u0026mrt\u003dyp%2Cloc\u0026sll\u003d2133327436%2C-1067548169\u0026start\u003d0\u0026hl\u003den\u0026q\u003dparis"},"viewport":{"center":{"lat":"48.856667","lng":"2.350987"},"span":{"lat":"0.11753","lng":"0.256119"},"sw":{"lat":"48.7979","lng":"2.2229276"},"ne":{"lat":"48.915432","lng":"2.4790463"}}}, "responseDetails": null, "responseStatus": 200}

		
		[textData release];		
		
		result = YES;
	}

	if (result == YES){
		return returnArray;
	}
	else{
		return nil;
	}
						
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{	
    NSHTTPURLResponse * httpResponse;
	
    assert(theConnection == self.connection);
    
    httpResponse = (NSHTTPURLResponse *) response;
	
	NSLog(@"HTTP response status code is %d", httpResponse.statusCode);
	
	// if failure, need to notice the delegate, to be added	
	if ((httpResponse.statusCode / 100) != 2) {
//		[self.delegate stopReceiveWithStatus:[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode]];
	}   
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)recvData
// A delegate method called by the NSURLConnection as data arrives.  We just 
// write the data to the file.
{
    assert(theConnection == self.connection);
    
	// append string
	const void* bytes = [recvData bytes];
	
	if (bytes != nil){		
		NSString* textData = [[NSString alloc] initWithBytes:bytes length:[recvData length] encoding:NSUTF8StringEncoding];		
		
		self.jsonData = [self.jsonData stringByAppendingString:textData];
		
		NSLog(@"receive data=%@", textData);
		
		[textData release];
//		NSLog(@"json data=%@", jsonData);		
	}
	else {		
		NSLog(@"0 bytes received");
	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been 
// done successfully.  We shut down the connection with a nil status, which 
// causes the image to be displayed.
{
    assert(theConnection == self.connection);
    
	NSLog(@"connectionDidFinishLoading");
	NSLog(@"final data=%@", self.jsonData);
	
	//NSDictionary* dict = [self.jsonData JSONValue];

	// notice delegate the data result
    [self stopReceiveConnection:theConnection status:nil];
}

- (void)stopReceiveConnection:(NSURLConnection *)theConnection status:(NSString *)statusString
// Shuts down the connection and displays the result (statusString == nil) 
// or the error status (otherwise).
{
	assert(theConnection == self.connection);
	
    if (self.connection != nil) {
        [self.connection cancel];
		[self.connection release];		
        self.connection = nil;
    }
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
// A delegate method called by the NSURLConnection if the connection fails. 
// We shut down the connection and display the failure.  Production quality code 
// would either display or log the actual error.
{
	assert(theConnection == self.connection);    
    [self stopReceiveConnection:theConnection status:@"Connection failed"];
}


@end
