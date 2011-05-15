//
//  BasicSearch.h
//  MyPhoneService
//
//  Created by qqn_pipi on 10-2-28.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocalSearchURL		@"http://ajax.googleapis.com/ajax/services/search/local"
#define kImageSearchURL		@"http://ajax.googleapis.com/ajax/services/search/images"

#define kIpAddress			@"192.168.0.1"
#define kApiKey				@"ABQIAAAAJdzN96RRUbxN4fP9XYUlhRQwZP1a_wydawaKMe3zeLz8jRvcXxSNt_fz33qs9P1AOxjtI_DvjMB2dw"
#define kDefaultSite		@"http://www.mapledance.com"

@protocol BasicSearchDelegate;

@interface BasicSearch : NSObject {

	NSURLConnection			*connection;
	NSString				*jsonData;	
	NSString				*apiKey;
	NSString				*site;
	
	BOOL					active;
	
	id<BasicSearchDelegate>	delegate;
	
	NSData					*data;
	int						maxStart;
	int						maxStartPage;
		
}

@property (retain) NSURLConnection				*connection;
@property (retain) NSString						*jsonData;
@property (retain) NSString						*apiKey;
@property (retain) NSString						*site;
@property (retain) id<BasicSearchDelegate>		delegate;
@property (retain) NSData						*data;
@property (nonatomic) int						maxStart;
@property (nonatomic) int						maxStartPage;

- (BOOL)startSearch:(NSString *)searchText location:(CLLocation *)location;

// below is the share implementation methods

// print the location into text
- (NSString *)getLocationText:(CLLocation *)location;

// get Google Site string
- (NSString *)getSite;

// get Google API key string
- (NSString *)getApiKey;

// generate the standard common URL string
- (NSString*)encodeStandardUrl:(NSString*)searchText;

// append start page parameter in the URL string
- (NSString*)appendStart:(NSString*)requestURLString start:(int)start;

// covert the URL string to URL boject
- (NSMutableURLRequest*)encodeURLReuqest:(NSString*)requestURLString;

// send the HTTP request
- (NSHTTPURLResponse*)sendSyncRequest:(NSURLRequest*)request;

// sub class methods

// the sub class need to implement its own URL
- (NSString *)getSearchURL;


@end

@protocol BasicSearchProtocol

//- (NSArray *)syncStartSearch:(NSString *)searchText location:(CLLocation *)location maxResult:(int)maxResult;
- (NSArray *)syncStartSearch:(NSString *)searchText location:(CLLocation *)location startPage:(int)startPage maxResult:(int)maxResult;

@end

@protocol BasicSearchDelegate

- (void)searchDidStart;
- (void)searchDidFinishWithStatus:(int)status;

@end

