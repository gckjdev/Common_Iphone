//
//  TestSearch.m
//  three20test
//
//  Created by qqn_pipi on 10-4-10.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "TestSearch.h"
#import "LocalSearch.h"
#import "ImageSearch.h"

@implementation TestSearch

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
	STFail(@"fail here");
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void) testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
 
//	STFail(@"Fail here");
}

- (void)testLocalSearch 
{
	return;
	
	LocalSearch* search = [[LocalSearch alloc] init];
	search.delegate = self;

	CLLocationDegrees latitude = 113.14f;
	CLLocationDegrees longtitude = 23.8F;
	
	CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
	
	NSArray* resultSet = [search syncStartSearch:@"KFC" location:nil];
	
	STAssertTrue(resultSet != nil, @"Search Result is NULL");
	
	[location release];
	[search release];
}

- (void)testImageSearch
{
	ImageSearch* search = [[ImageSearch alloc] init];
	search.delegate = self;
	
	NSArray* resultSet = [search syncStartSearch:@"Hello Kitty" location:nil];
	
	STAssertTrue(resultSet != nil, @"Search Result is NULL");
	
	[search release];
}

- (void)searchDidStart
{
	NSLog(@"Search did start");
}

- (void)searchDidFinishWithStatus:(int)status
{
	NSLog(@"Search did start finished with status (%d)", status);
}

#endif


@end
