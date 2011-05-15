//
//  PPLoationManager.h
//  Calloc
//
//  Created by Peng Lingzhe on 6/12/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define kLocationUpdateTimeOut		60.0
#define kTimeOutObjectString		@"Time out"

@protocol PPLocationManagerDelegate <NSObject>

- (void)refreshLocationDone:(CLLocation*)location;
- (void)refreshLocationAddressDone:(MKPlacemark*)placemark;

@end


@interface PPLoationManager : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {

	CLLocationManager		*locationManager;
	CLLocation				*currentLocation;
	MKReverseGeocoder		*reverseGeocoder;
	MKPlacemark				*currentPlacemark;
	BOOL					refreshing;

	id<PPLocationManagerDelegate>	delegate;
	
}

@property (nonatomic, retain) CLLocationManager		*locationManager;
@property (nonatomic, copy)	  CLLocation			*currentLocation;
@property (nonatomic, retain) MKReverseGeocoder		*reverseGeocoder;
@property (nonatomic, retain) MKPlacemark			*currentPlacemark;
@property (nonatomic, assign) id<PPLocationManagerDelegate>	delegate;

// public methods
- (void)refreshLocation:(id)sender;

// private methods
- (void)stopUpdatingLocation:(NSString *)state;
- (void)reverseGeocodeCurrentLocation:(CLLocation *)location;

+ (NSString*)locationToString:(CLLocation*)location;
+ (NSString*)getAddressString:(MKPlacemark*)currentPlacemark;
+ (NSString*)getMapURL:(CLLocation*)location;
+ (NSString*)getCity:(MKPlacemark*)placemark;


@end
