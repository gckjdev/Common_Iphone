//
//  LocationService.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocationService.h"

#define kLocationUpdateTimeOut      120
#define kTimeOutObjectString		@"Location Update Time out"

@implementation LocationService

@synthesize locationManager, currentLocation, reverseGeocoder, currentPlacemark, waitLock;

- (id)init
{
	self = [super init];
    self.locationManager = [[CLLocationManager alloc] init];		
    self.waitLock = [[NSCondition alloc] init];
    refreshing = NO;
    workingQueue = dispatch_queue_create("location queue", NULL);
	return self;
}

- (void)refreshLocation
{
	if (refreshing){
		return;
	}
    
    NSLog(@"<startUpdatingLocation>");
    
	refreshing = YES;
	
	// start to update the location
	locationManager.delegate = self;		
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;	
	[locationManager startUpdatingLocation];		
	[self performSelector:@selector(stopUpdatingLocation:) withObject:kTimeOutObjectString afterDelay:kLocationUpdateTimeOut];    
	
    
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    NSLog(@"<didUpdateToLocation> New location is %@", [newLocation description]);

    // If the time interval is older than 10 seconds, then it's an older location.  Ignore it.
    if ([newLocation.timestamp timeIntervalSinceNow] < -10) {
        return;
    }
    
    // save to current location
    self.currentLocation = newLocation;
	    
	// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:kTimeOutObjectString];
	
	// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
	[self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
	
	// translate location to address
	[self reverseGeocodeCurrentLocation:self.currentLocation];    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
	
	refreshing = NO;
}

- (void)stopUpdatingLocation:(NSString *)state {
    
	NSLog(@"stopUpdatingLocation,state=%@", state);
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;    
}


#pragma mark reverseGeocoder

- (void)reverseGeocodeCurrentLocation:(CLLocation *)location
{
    self.reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"MKReverseGeocoder has failed.");    
	refreshing = NO;    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	refreshing = NO;
    
	self.currentPlacemark = placemark;
	NSLog(@"reverseGeocoder finish, placemark=%@", [placemark description] );
    //	NSLog(@"current country is %@, province is %@, city is %@, street is %@%@", self.currentPlacemark.country, currentPlacemark.administrativeArea, currentPlacemark.locality, placemark.thoroughfare, placemark.subThoroughfare);
		
}

- (void)dealloc
{
    dispatch_release(workingQueue);
    workingQueue = NULL;
    
	[locationManager release];
	[reverseGeocoder release];
	[currentLocation release];
	[currentPlacemark release];
    [waitLock release];
	
	[super dealloc];
}

+ (NSString*)locationToString:(CLLocation*)location
{
	return [NSString stringWithFormat:@"%f,%f", location.coordinate.longitude, location.coordinate.latitude];
}

+ (NSString*)getAddressString:(MKPlacemark*)currentPlacemark
{
	NSString* str = [NSString stringWithString:@""];	
	if (currentPlacemark == nil)
		return str;
	
	if (currentPlacemark.locality){
		str = [str stringByAppendingFormat:@"%@", currentPlacemark.locality];
	}
	
	if (currentPlacemark.subLocality){
		str = [str stringByAppendingFormat:@" %@", currentPlacemark.subLocality];
	}
	
	if (currentPlacemark.thoroughfare){
		str = [str stringByAppendingFormat:@" %@", currentPlacemark.thoroughfare];
	}
	
	if (currentPlacemark.subThoroughfare){
		str = [str stringByAppendingFormat:@" %@", currentPlacemark.subThoroughfare];
	}
	
	return str;
}

+ (NSString*)getMapURL:(CLLocation*)location
{
	NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?ll=%f,%f", location.coordinate.latitude, location.coordinate.longitude];
	return url;
}

+ (NSString*)getCity:(MKPlacemark*)placemark
{
	NSString* str = [NSString stringWithString:@""];
	if (placemark == nil){
		return str;
	}
	
	if (placemark.locality){
		str = [str stringByAppendingFormat:@"%@", placemark.locality];
	}
	
	if (placemark.subLocality){
		str = [str stringByAppendingFormat:@" %@", placemark.subLocality];
	}
	
	return str;
}

- (CLLocationCoordinate2D)asyncGetLocation
{
    __block CLLocationCoordinate2D coordinate;    
    
    needGetAddress = NO;
    [self refreshLocation];        
    
    return coordinate;
}

- (CLLocationCoordinate2D)syncGetLocationAndAddress
{
    CLLocationCoordinate2D coordinate;
    return coordinate;    
}

- (CLLocationCoordinate2D)getLatestLocation
{
    CLLocationCoordinate2D coordinate;
    return coordinate;
}

- (void)updateLocationAndAddress
{
    
}

@end
