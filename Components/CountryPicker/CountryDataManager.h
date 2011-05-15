//
//  CountryDataManager.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-2.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// for testing
//	NSLog(@"%@", [[CountryDataManager manager] getChineseName:@"CN"]);
//	NSLog(@"%@", [[CountryDataManager manager] getEnglishName:@"CN"]);
//	NSLog(@"%@", [[CountryDataManager manager] getCountryTelephonePrefx:@"CN"]);
//	NSLog(@"%@", [[CountryDataManager manager] getChineseNameByCurrentLocale]);
//	NSLog(@"%@", [[CountryDataManager manager] getEnglishNameByCurrentLocale]);
//	NSLog(@"%@", [[CountryDataManager manager] getCountryTelephonePrefxByCurrentLocale]);	


@interface CountryData : NSObject
{
	NSString*	jsonData;
	NSString*	name;	
}

@property (nonatomic, retain) NSString*	jsonData;
@property (nonatomic, retain) NSString*	name;	

- (NSString*)stringForGroup;

@end


@interface CountryDataManager : NSObject {
	
	NSDictionary*	dict;
}

@property (nonatomic, retain) NSDictionary*	dict;

+ (id)manager;

- (NSString*)getChineseName:(NSString*)countryCode;
- (NSString*)getEnglishName:(NSString*)countryCode;
- (NSString*)getCountryTelephonePrefx:(NSString*)countryCode;

- (NSString*)getChineseNameByCurrentLocale;
- (NSString*)getEnglishNameByCurrentLocale;
- (NSString*)getCountryNameByCurrentLocale;
- (NSString*)getCountryTelephonePrefxByCurrentLocale;
- (NSString*)getCountryTelephonePrefxByCurrentLocaleWithPlus;
- (NSArray*)getAllData;

- (NSString*)localizedNameFromData:(NSString*)jsonData;
- (NSString*)countryTelPrefixFromData:(NSString*)jsonData;
- (NSString*)countryCodeFromData:(NSString*)jsonData;

@end
