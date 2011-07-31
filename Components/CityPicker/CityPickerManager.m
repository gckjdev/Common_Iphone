//
//  CityPickerManager.m
//  CityPicker
//
//  Created by qqn_pipi on 11-7-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CityPickerManager.h"


@implementation CityPickerManager
@synthesize cityDict;
@synthesize provinceDict;
@synthesize sortedProvince;


- (id)init{
    self = [super init];
    if (self) {
        NSString *cityPlistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        self.cityDict = [NSDictionary dictionaryWithContentsOfFile:cityPlistPath];
        
        NSString *provincePlistPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"]; 
        self.provinceDict = [NSDictionary dictionaryWithContentsOfFile:provincePlistPath];
        
        self.sortedProvince = [NSArray arrayWithObjects:@"直辖", @"安徽", @"福建", @"广东", @"广西", @"甘肃", @"贵州", @"海南", @"河南", @"河北", @"湖南", @"湖北", @"吉林", @"江西", @"江苏", @"辽宁", @"宁夏", @"内蒙", @"青海", @"四川", @"陕西", @"山东", @"山西", @"新疆", @"云南", @"浙江", @"黑龙江", nil];
        
        return self;
        
    }
    return nil;
}

- (NSInteger) getProviceCount{
    return [self.sortedProvince count];
}

- (NSInteger) getCityCountWithProvince:(NSString *)province{
    return [[self.provinceDict objectForKey:province] count];
}

- (NSInteger) getCityCountWithProvinceIndex:(NSInteger)index{
    return [self getCityCountWithProvince:[self getProvince:index]];
}

- (NSString *)getProvince:(NSInteger)index{
    NSString *province = [self.sortedProvince objectAtIndex:index];
    return province;
}


- (NSString *)getCityWithProvince:(NSString *)province cityIndex:(NSInteger)index{
    return [[self.provinceDict objectForKey:province] objectAtIndex:index];
}

- (NSInteger )indexForProvince:(NSString *)province{
    return [self.sortedProvince indexOfObject:province];
}

- (NSInteger) indexInProvince:(NSString *)province ForCity:(NSString *)city{
    return [[self getCityArrayWithProvince:province] indexOfObject:city];
}

- (NSArray *) getCityArrayWithProvince:(NSString *)province{
    return [self.provinceDict objectForKey:province];
}

- (NSString *) getCityWithProvinceIndex:(NSInteger)pIndex cityIndex:(NSInteger)cIndex{
    return [self getCityWithProvince:[self getProvince:pIndex] cityIndex:cIndex];
}

- (NSArray *) getProvinceArray{
    return self.sortedProvince;
}

- (NSString *)getProvinceWithCity:(NSString *)cityName{
    for (NSString *province in [provinceDict allKeys]) {
        NSArray *cityArray = [provinceDict objectForKey:province];
        for (NSString *city in cityArray) {
            if ([city isEqualToString:cityName]) {
                return province;
            }
        }
    }
    return nil;
}

- (void)dealloc
{
    [cityDict release];
    [provinceDict release];
    [sortedProvince release];
    [super dealloc];
}
@end

CityPickerManager *cityPickerManager;

CityPickerManager * GlobalCityPickerManager(){
    if(cityPickerManager == nil){
        cityPickerManager = [[CityPickerManager alloc] init];
    }
    return cityPickerManager;
}
