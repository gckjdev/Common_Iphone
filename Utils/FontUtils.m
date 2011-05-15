//
//  FontUtils.m
//  Quick Idea Notes
//
//  Created by qqn_pipi on 10-10-6.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "FontUtils.h"


@implementation FontUtils

+ (void)logFontName
{
	// List all fonts on iPhone
	NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
	NSArray *fontNames;
	NSInteger indFamily, indFont;
	for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
	{
		NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
		fontNames = [[NSArray alloc] initWithArray:
					 [UIFont fontNamesForFamilyName:
					  [familyNames objectAtIndex:indFamily]]];
		for (indFont=0; indFont<[fontNames count]; ++indFont)
		{
			NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
		}
		[fontNames release];
	}
	[familyNames release];
}

@end
