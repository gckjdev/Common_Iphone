//
//  LocaleUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-3-20.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "LocaleUtils.h"


@implementation LocaleUtils

+ (NSString *)getCountryCode
{
	NSLocale *currentLocale = [NSLocale currentLocale];
	
//	NSLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);	
	return [currentLocale objectForKey:NSLocaleCountryCode];
}

+ (NSString *)getLanguageCode
{
	NSLocale *currentLocale = [NSLocale currentLocale];
	
	NSLog(@"Language Code is %@", [currentLocale objectForKey:NSLocaleLanguageCode]);	
	
	return [currentLocale objectForKey:NSLocaleLanguageCode];
}

+ (BOOL)isChina
{
	NSLocale *currentLocale = [NSLocale currentLocale];

	NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
	if ([countryCode isEqualToString:@"CN"])
		return YES;	
	
	return NO;
}

@end
