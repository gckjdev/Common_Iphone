//
//  PPApplication.h
//  ___PROJECTNAME___
//
//  Created by Peng Lingzhe on 9/29/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocaleUtils.h"
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "HJObjManager.h"

#define kKeyDeviceToken				@"kPushDeviceToken"

#define kAppLocationUpdateTimeOut	60.0
#define kAppTimeOutObjectString		@"Time out"

extern NSString* GlobalGetAppName();
extern dispatch_queue_t GlobalGetWorkingQueue();
extern HJObjManager* GlobalGetImageCache();
extern BOOL isFree();

@interface PPApplication : UIResponder <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {

	dispatch_queue_t	workingQueue;
	ABAddressBookRef	addressBook;
	AVAudioPlayer		*player;
	
	CLLocationManager		*locationManager;
	CLLocation				*currentLocation;
	MKReverseGeocoder		*reverseGeocoder;
	MKPlacemark				*currentPlacemark;
    
    HJObjManager            *imageCacheManager;
}

@property (nonatomic, assign) dispatch_queue_t		workingQueue;
@property (nonatomic, retain) AVAudioPlayer			*player;

@property (nonatomic, retain) CLLocationManager		*locationManager;
@property (nonatomic, copy)	  CLLocation			*currentLocation;
@property (nonatomic, retain) MKReverseGeocoder		*reverseGeocoder;
@property (nonatomic, retain) MKPlacemark			*currentPlacemark;

@property (nonatomic, retain) HJObjManager          *imageCacheManager;

- (void)releaseResourceForAllViewControllers;

- (void)bindDevice;
- (BOOL)isPushNotificationEnable;
- (void)saveDeviceToken:(NSData*)deviceToken;
- (NSString*)getDeviceToken;

- (void)initAudioPlayer:(NSString*)soundFile;
- (void)handleRemoteNotification:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

- (void)initLocationManager;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation:(NSString *)state;

- (void)initImageCacheManager;

+ (NSString*)getAppVersion;

@end
