//
//  ImageSearch.m
//  three20test
//
//  Created by qqn_pipi on 10-4-11.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "ImageSearch.h"
#import "../JSON/JSON.h"
#import "ImageSearchResult.h"
#import "StringUtil.h"

@implementation ImageSearch

- (NSString*)getImageSizeString
{
//	if (imageSize == kSearchImageSizeIcon)
//		return SearchImageSizeIcon;
//	else {
		return SearchImageSizeLarge;
//	}

}

- (NSString *)getSearchURL
{
	return kImageSearchURL;
}




- (NSString*)appendLocation:(NSString*)requestURLString location:(CLLocation*)location
{
	if (location != nil){
		return [NSString stringWithFormat:@"%@&sll=%@", requestURLString, [self getLocationText:location]];	
	}
	else {
		return requestURLString;
	}

}

- (NSString*)appendImageSize:(NSString*)requestURLString
{
	// add image search size parameter
	return [NSString stringWithFormat:@"%@&%@", requestURLString, [self getImageSizeString]];	
}

- (NSString*)appendSafeParameter:(NSString*)requestURLString
{
	// add image search size parameter
	return [NSString stringWithFormat:@"%@&safe=active", requestURLString];	
}

- (int)getMaxStart:(NSDictionary*)cursor
{
	NSDictionary* pages = [cursor objectForKey:@"pages"];
	int max = 0;
	for (NSDictionary* pageInfo in pages){
		
		max = [[pageInfo objectForKey:@"start"] intValue];
		
//		NSLog(@"page=%@, start=%@", 
//			  [pageInfo objectForKey:@"label"],
//			  [pageInfo objectForKey:@"start"]);
	}
	
	return max;
}




- (NSObject*)getSearchResultRecord:(NSDictionary*)result
{
	
	ImageSearchResult* resultRecord = [[[ImageSearchResult alloc] init] autorelease];			
	
	resultRecord.titleNoFormatting = [result objectForKey:@"titleNoFormatting"];
	resultRecord.unescapedUrl = [result objectForKey:@"unescapedUrl"];
	resultRecord.url = [result objectForKey:@"url"];
	resultRecord.visibleUrl = [result objectForKey:@"visibleUrl"];
	
	resultRecord.width = [[result objectForKey:@"width"] intValue];
	resultRecord.height = [[result objectForKey:@"height"] intValue];
	resultRecord.tbWidth = [[result objectForKey:@"tbWidth"] intValue];
	resultRecord.tbHeight = [[result objectForKey:@"tbHeight"] intValue];					
	
	resultRecord.tbUrl = [result objectForKey:@"tbUrl"];	
	
	return resultRecord;
}

- (NSDictionary*)getResponseData:(NSData*)theData
{
	const void* bytes = [theData bytes];
	NSString* textData = [[NSString alloc] initWithBytes:bytes length:[theData length] encoding:NSUTF8StringEncoding];		
//	NSLog(@"receive data=%@", textData);
	
	// covert data to JSON
	NSDictionary* dict = [textData JSONValue];				
	NSDictionary* responseData = [dict objectForKey:@"responseData"];				

	[textData release];		
	
	return responseData;
}

//- (BOOL)parseResponseData:(NSData*)theData 

+ (NSString*)getFlickrPhotoMediumURL:(NSDictionary*)photoDict
{
	return [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_z.jpg",
			[photoDict objectForKey:@"farm"],
			[photoDict objectForKey:@"server"],
			[photoDict objectForKey:@"id"],
			[photoDict objectForKey:@"secret"]];	
}

+ (NSString*)getFlickrPhotoBigURL:(NSDictionary*)photoDict
{
	return [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_b.jpg",
			[photoDict objectForKey:@"farm"],
			[photoDict objectForKey:@"server"],
			[photoDict objectForKey:@"id"],
			[photoDict objectForKey:@"secret"]];	
}

+ (NSString*)getFlickrPhotoThumURL:(NSDictionary*)photoDict
{
	return [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
			[photoDict objectForKey:@"farm"],
			[photoDict objectForKey:@"server"],
			[photoDict objectForKey:@"id"],
			[photoDict objectForKey:@"secret"]];
			
}

- (NSDictionary*)getFlickrResponseJSON:(NSData*)theData
{
	NSString* start = @"jsonFlickrApi(";
	NSString* end = @")";
	
	int totalLen = [start length] + [end length];
	if (theData == nil || [theData length] <= totalLen)
		return nil;

	const void* bytes = [theData bytes];
	NSString* textData = [[NSString alloc] initWithBytes:bytes length:[theData length] encoding:NSUTF8StringEncoding];		
//	NSLog(@"receive data=%@", textData);
			
	NSRange range;
	range.length = [textData length] - totalLen;
	range.location = [start length];
	NSString* jsonStr = [textData substringWithRange:range];

	[textData release];		
	
	return [jsonStr JSONValue];
}

- (NSMutableArray*)searchFlickrImage:(NSString*)searchText 
{
	NSString	*flickrApiKey = @"9cdea3e579e0386e0dbf52d4a2dc0de9";
	NSString	*flickrMethod = @"flickr.photos.search";
	
	NSMutableArray *		returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	int			recordPerPage = 40;
	BOOL		result = NO;
	
	NSString* requestURLString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=%@&api_key=%@&text=%@&per_page=%d&format=json",
						flickrMethod, flickrApiKey, [searchText encodedURLParameterString], recordPerPage];
	
//	requestURLString = [requestURLString encodedURLParameterString];	
	NSLog(@"request URL=%@", requestURLString);
	
	NSURLRequest* request = [self encodeURLReuqest:requestURLString];		
	NSHTTPURLResponse * httpResponse = [self sendSyncRequest:request];	
	if ((httpResponse.statusCode / 100) != 2) {
		result = NO;
	} 
	else
	{								
		NSDictionary* responseData = [self getFlickrResponseJSON:self.data];				
		if (responseData != nil && [responseData respondsToSelector:@selector(objectForKey:)]){			
			NSLog(@"result=%@", responseData);
			
			NSDictionary* dict = [responseData objectForKey:@"photos"];
			NSArray* photos = [dict objectForKey:@"photo"];
			for (NSDictionary* photo in photos){
//				NSLog(@"photo thumb URL=%@", [ImageSearch getFlickrPhotoThumURL:photo]);
//				NSLog(@"photo big URL=%@", [ImageSearch getFlickrPhotoMediumURL:photo]);
				
				ImageSearchResult* resultRecord = [[ImageSearchResult alloc] init];							
				resultRecord.titleNoFormatting = [photo objectForKey:@"title"];
				resultRecord.url = [ImageSearch getFlickrPhotoMediumURL:photo];
				resultRecord.tbUrl = [ImageSearch getFlickrPhotoThumURL:photo];								
				[returnArray addObject:resultRecord];
				[resultRecord release];
			}
		}
	}
		
	return returnArray;
}

- (NSMutableArray*)searchImageBySize:(CGSize)size searchText:(NSString *)searchText location:(CLLocation *)location searchSite:(NSString*)searchSite startPage:(int)startPage maxResult:(int)maxResult
{
//	NSArray* remoteData = (NSArray*)[self syncStartSearch:searchText location:nil startPage:0 maxResult:maxResult];
//	NSMutableArray* finalData = [[[NSMutableArray alloc] init] autorelease];
//	for (ImageSearchResult* result in remoteData){
//		if (result.width == size.width && result.height == size.height){
//			[finalData addObject:result];
//		}
//	}
//
//	return finalData;
	
	BOOL					result = YES;	
	NSMutableArray *		returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	// encode URL correctly
	NSString* requestURLString = nil;
	
	requestURLString = [self encodeStandardUrl:searchText];
	requestURLString = [self appendImageSize:requestURLString];	
	
	if (searchSite != nil){
		requestURLString = [requestURLString stringByAppendingFormat:@"&as_sitesearch=%@", searchSite];
	}
	//	requestURLString = [self appendSafeParameter:requestURLString];
	
	const int RESULT_PER_PAGE = 8;	// define by Google
	int page; 
	
	if (maxResult % RESULT_PER_PAGE == 0){
		page = startPage + maxResult / RESULT_PER_PAGE;
	}
	else {
		page = startPage + maxResult / RESULT_PER_PAGE + 1;		
	}
	
	int recordCount = 0;
	for (int start = startPage; ; start++){
		
		int startValue = start * RESULT_PER_PAGE;		
		NSString* finalRequestURLString = [self appendStart:requestURLString start:startValue];	// just change the start
		
		NSLog(@"HTTP request=%@", finalRequestURLString);
		
		NSURLRequest* request = [self encodeURLReuqest:finalRequestURLString];		
		NSHTTPURLResponse * httpResponse = [self sendSyncRequest:request];	
		if ((httpResponse.statusCode / 100) != 2) {
			result = NO;
			break;
		} 
		else
		{								
			NSDictionary* responseData = [self getResponseData:self.data];				
			if (responseData != nil && [responseData respondsToSelector:@selector(objectForKey:)]){
				
//				NSLog(@"result=%@", responseData);
				
				NSDictionary* cursor = [responseData objectForKey:@"cursor"];
				if (cursor != nil){
					maxStart = [self getMaxStart:cursor];
					maxStartPage = maxStart / RESULT_PER_PAGE;
//					NSLog(@"maxStart=%d, maxStartPage=%d", maxStart, maxStartPage);	
				}
				
				NSDictionary* results = [responseData objectForKey:@"results"];
				if (results != nil){
					for (NSDictionary* result in results){							
						
						if (recordCount >= maxResult)
							break;
						
						ImageSearchResult* resultRecord = (ImageSearchResult*)[self getSearchResultRecord:result];					
						if ((resultRecord.width == size.width && resultRecord.height == size.height) ||
							(resultRecord.width == size.width * 2 && resultRecord.height == size.height * 2)){
							[returnArray addObject:resultRecord];						
							recordCount ++;
						}
					}
				}
				
				
			}
			else {
				// error, quit
				break;
			}			
		}				
		
		NSLog(@"recordCount=%d", recordCount);
		if (recordCount >= maxResult){
			// reach max result, quit
			break;
		}		
	}
	
	if (result == YES){
		return returnArray;
	}
	else{
		return nil;
	}
	
}

- (NSArray *)syncStartSearch:(NSString *)searchText location:(CLLocation *)location startPage:(int)startPage maxResult:(int)maxResult
{
	BOOL					result = YES;	
	NSMutableArray *		returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	// encode URL correctly
	NSString* requestURLString = nil;
	
	requestURLString = [self encodeStandardUrl:searchText];
	requestURLString = [self appendImageSize:requestURLString];	
//	requestURLString = [self appendSafeParameter:requestURLString];
	
	const int RESULT_PER_PAGE = 8;	// define by Google
	int page; 
	
	if (maxResult % RESULT_PER_PAGE == 0){
		page = startPage + maxResult / RESULT_PER_PAGE;
	}
	else {
		page = startPage + maxResult / RESULT_PER_PAGE + 1;		
	}

	int recordCount = 0;
	for (int start = startPage; start < page; start++){
	
		int startValue = start * RESULT_PER_PAGE;		
		NSString* finalRequestURLString = [self appendStart:requestURLString start:startValue];	// just change the start
		
		NSLog(@"HTTP request=%@", finalRequestURLString);
		
		NSURLRequest* request = [self encodeURLReuqest:finalRequestURLString];		
		NSHTTPURLResponse * httpResponse = [self sendSyncRequest:request];	
		if ((httpResponse.statusCode / 100) != 2) {
			result = NO;
		} 
		else
		{								
			NSDictionary* responseData = [self getResponseData:self.data];				
			if (responseData != nil){
				
				NSLog(@"result=%@", responseData);
				
				NSDictionary* cursor = [responseData objectForKey:@"cursor"];
				if (cursor != nil){
					maxStart = [self getMaxStart:cursor];
					maxStartPage = maxStart / RESULT_PER_PAGE;
					NSLog(@"maxStart=%d, maxStartPage=%d", maxStart, maxStartPage);	
				}
				
				NSDictionary* results = [responseData objectForKey:@"results"];
				if (results != nil){
					for (NSDictionary* result in results){							
						
						if (recordCount >= maxResult)
							break;
						
						NSObject* resultRecord = [self getSearchResultRecord:result];					
						[returnArray addObject:resultRecord];
						
						recordCount ++;
					}
				}
				
			}
			
		}
	}
	
	if (result == YES){
		return returnArray;
	}
	else{
		return nil;
	}
	
}


@end
