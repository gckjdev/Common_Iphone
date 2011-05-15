//
//  LocalSearchResult.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-2.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "LocalSearchResult.h"


@implementation LocalSearchResult

@synthesize name, country, city, phoneNumber, address;

- (NSString *)description
{
	return [NSString stringWithFormat:@"name=%@\ncountry=%@\ncity=%@\nphoneNumber=%@\naddress=%@", name, country, city, phoneNumber, address];
}

- (void)dealloc
{
	[name release];
	[city release];
	[country release];
	[phoneNumber release];
	[address release];
	
	[super dealloc];
}

@end
