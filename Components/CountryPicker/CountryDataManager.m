//
//  CountryDataManager.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-2.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "CountryDataManager.h"
#import "LocaleUtils.h"
#import "JSON.h"
#import "StringUtil.h"

#define enName			@"enName"
#define cnName			@"cnName"
#define telPrefix		@"telPrefix"
#define kCountryCode	@"code"

CountryDataManager*	globalCountryDataManager;

@implementation CountryData

@synthesize name;
@synthesize jsonData;

- (void)dealloc
{
	[name release];
	[jsonData release];
	[super dealloc];
}

- (NSString*)stringForGroup
{
	return name;
}

@end


@implementation CountryDataManager

@synthesize dict;

+ (id)manager
{
	// not thread safe here
	if (globalCountryDataManager == nil){
		globalCountryDataManager = [[CountryDataManager alloc] init];
		NSString* path = [[NSBundle mainBundle] pathForResource:@"countryTelPrefix" ofType:@"plist" inDirectory:@""];
//		NSLog(@"<Debug> countryTelPrefix path=%@", path);
		globalCountryDataManager.dict = [NSDictionary dictionaryWithContentsOfFile:path];
	}
	
	return globalCountryDataManager;
}

- (NSDictionary*)getDataByCountryCode:(NSString*)countryCode
{
	NSString* countryData = [dict objectForKey:countryCode];
	if (countryData == nil)
		return nil;
	
	NSDictionary* jsonData = [countryData JSONValue];
	return jsonData;
}

- (NSString*)getChineseName:(NSString*)countryCode
{
	NSDictionary* countryData = [self getDataByCountryCode:countryCode];	
	return [countryData objectForKey:cnName];
}

- (NSString*)getEnglishName:(NSString*)countryCode
{
	NSDictionary* countryData = [self getDataByCountryCode:countryCode];	
	return [countryData objectForKey:enName];
}

- (NSString*)getCountryTelephonePrefx:(NSString*)countryCode
{
	NSDictionary* countryData = [self getDataByCountryCode:countryCode];	
	return [countryData objectForKey:telPrefix];
}

- (NSString*)localizedNameFromData:(NSString*)data
{
	NSString* countryCode = [LocaleUtils getCountryCode];
	NSDictionary* dataDict = [data JSONValue];
	
	if ([countryCode isEqualToString:@"CN"]){
		return [dataDict objectForKey:cnName];
	}
	else {
		return [dataDict objectForKey:enName];
	}
}

- (NSString*)countryTelPrefixFromData:(NSString*)data
{
	NSDictionary* dataDict = [data JSONValue];
	return [dataDict objectForKey:telPrefix];
}

- (NSString*)countryCodeFromData:(NSString*)data
{
	NSDictionary* dataDict = [data JSONValue];
	return [dataDict objectForKey:kCountryCode];
}


- (NSString*)getChineseNameByCurrentLocale
{
	return [self getChineseName:[LocaleUtils getCountryCode]];
}

- (NSString*)getEnglishNameByCurrentLocale
{
	return [self getEnglishName:[LocaleUtils getCountryCode]];
}

- (NSString*)getCountryTelephonePrefxByCurrentLocale
{
	return [self getCountryTelephonePrefx:[LocaleUtils getCountryCode]];
}

// return country code with + prefix, e.g. +86
- (NSString*)getCountryTelephonePrefxByCurrentLocaleWithPlus
{
	return [NSString stringWithFormat:@"+%@", [self getCountryTelephonePrefx:[LocaleUtils getCountryCode]]];
}

- (NSString*)getCountryNameByCurrentLocale
{
	NSString* countryCode = [LocaleUtils getCountryCode];
	if ([countryCode isEqualToString:@"CN"]){
		return [self getChineseName:countryCode];
	}
	else {
		return [self getEnglishName:countryCode];
	}

}

- (NSArray*)getAllData
{
	NSArray* allData = [[self.dict allValues] sortedArrayUsingComparator:^(id obj1, id obj2) {		
		return [obj1 compare:obj2]; 
	}];
	
	CountryDataManager* manager = [CountryDataManager manager];
	NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
	for (NSString* json in allData){
		CountryData* country = [[CountryData alloc] init];
		
		country.name = [manager localizedNameFromData:json];
		country.jsonData = json;
		
		[retArray addObject:country];
		
		[country release];
	}
	
	return [retArray sortedArrayUsingComparator:^(id obj1, id obj2) {					
		return [[((CountryData*)obj1).name pinyinFirstLetter] compare:[((CountryData*)obj2).name pinyinFirstLetter]]; 
	}];	
}

- (void)dealloc
{
	[dict release];
	[super dealloc];
}

@end
