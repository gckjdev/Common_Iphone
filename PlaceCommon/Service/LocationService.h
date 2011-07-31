//
//  LocationService.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CityPickerViewController.h"

@interface LocationService : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate, CityPickerDelegate> {
    
	CLLocationManager		*locationManager;
	CLLocation				*currentLocation;
	MKReverseGeocoder		*reverseGeocoder;
	MKPlacemark				*currentPlacemark;

    BOOL                    needGetAddress;
    BOOL                    refreshing;
    
    NSCondition             *waitLock;
    dispatch_queue_t        workingQueue;
}
@property (nonatomic, retain) CLLocationManager		*locationManager;
@property (nonatomic, copy)	  CLLocation			*currentLocation;
@property (nonatomic, retain) MKReverseGeocoder		*reverseGeocoder;
@property (nonatomic, retain) MKPlacemark			*currentPlacemark;
@property (nonatomic, retain) NSCondition           *waitLock;

// public methods
- (CLLocationCoordinate2D)asyncGetLocation;
- (CLLocationCoordinate2D)syncGetLocationAndAddress;
- (CLLocationCoordinate2D)getLatestLocation;
- (void)updateLocationAndAddress;


// private methods
- (void)stopUpdatingLocation:(NSString *)state;
- (void)reverseGeocodeCurrentLocation:(CLLocation *)location;

+ (NSString*)locationToString:(CLLocation*)location;
+ (NSString*)getAddressString:(MKPlacemark*)currentPlacemark;
+ (NSString*)getMapURL:(CLLocation*)location;
+ (NSString*)getCity:(MKPlacemark*)placemark;
- (NSString*)getDefaultCity;
- (void)setDefaultCity:(NSString *)city;

@end

extern LocationService*   GlobalGetLocationService();

