//
//  ArrayOfCharacters.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-9.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "ArrayOfCharacters.h"


@implementation ArrayOfCharacters

+ (NSArray*)getArray
{
	NSMutableArray* arrayOfCharacters = [[[NSMutableArray alloc] init] autorelease];
	for (char c='A'; c<='Z'; c++){
		NSString* s = [NSString stringWithFormat:@"%c", c];
		[arrayOfCharacters addObject:s];
	}	
	
	return arrayOfCharacters;
}

@end
