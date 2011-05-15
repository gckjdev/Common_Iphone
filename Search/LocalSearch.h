//
//  LocalSearch.h
//  MyPhoneService
//
//  Created by qqn_pipi on 10-2-28.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicSearch.h"
#import <CoreLocation/CoreLocation.h>

@interface LocalSearch : BasicSearch <BasicSearchProtocol> {
	
}

- (BOOL)startSearch:(NSString *)searchText location:(CLLocation *)location;

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data;

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection;

- (void)stopReceiveConnection:(NSURLConnection *)theConnection status:(NSString *)statusString;

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error;


@end
