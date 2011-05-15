//
//  LocalSearchResult.h
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-2.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalSearchResult : NSObject {

	NSString*	name;
	NSString*	country;
	NSString*	city;
	NSString*	phoneNumber;
	NSString*	address;
}

@property (retain) NSString* name;
@property (retain) NSString* country;
@property (retain) NSString* city;
@property (retain) NSString* phoneNumber;
@property (retain) NSString* address;

@end
