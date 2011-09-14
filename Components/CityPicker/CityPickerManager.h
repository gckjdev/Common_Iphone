//
//  CityPickerManager.h
//  CityPicker
//
//  Created by qqn_pipi on 11-7-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface CityPickerManager : NSObject {
    NSDictionary *cityDict;
    NSDictionary *provinceDict;
    NSArray *sortedProvince;
}


- (NSInteger) getProviceCount;
- (NSInteger) getCityCountWithProvince:(NSString *)province;
- (NSInteger) getCityCountWithProvinceIndex:(NSInteger)index;
- (NSInteger) indexInProvince:(NSString *)province ForCity:(NSString *)city;
- (NSInteger ) indexForProvince:(NSString *)province;
- (NSString *) getProvince:(NSInteger)index;
- (NSString *) getCityWithProvince:(NSString *)province cityIndex:(NSInteger)index;
- (NSString *) getCityWithProvinceIndex:(NSInteger)pIndex cityIndex:(NSInteger)cIndex;  
- (NSString *) getProvinceWithCity:(NSString *)cityName;
- (NSArray *) getProvinceArray;
- (NSArray *) getCityArrayWithProvince:(NSString *)province;

@property (nonatomic, retain) NSDictionary *cityDict;
@property (nonatomic, retain) NSDictionary *provinceDict;
@property (nonatomic, retain) NSArray *sortedProvince;
@end

extern CityPickerManager* GlobalCityPickerManager();