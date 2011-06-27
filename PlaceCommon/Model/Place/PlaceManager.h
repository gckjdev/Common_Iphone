//
//  PlaceManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import <CoreLocation/CoreLocation.h>

@interface PlaceManager : NSObject {
    
}

+ (BOOL)createPlace:(NSString*)placeId name:(NSString*)name desc:(NSString*)desc
          longitude:(double)longitude latitude:(double)latitude 
         createUser:(NSString*)createUser followUserId:(NSString*)followUserId
             useFor:(int)useFor;

+ (NSArray*)getAllFollowPlaces;
+ (BOOL)deleteAllFollowPlaces;

+ (BOOL)deleteAllPlacesNearby;
+ (NSArray*)getAllPlacesNearby;

+ (BOOL)isPlaceFollowByUser:(NSString*)placeId;
+ (BOOL)userFollowPlace:(NSString*)userId place:(Place*)place;
+ (BOOL)userUnfollowPlace:(NSString*)userId placeId:(NSString*)placeId;

+ (void)cleanUpDeleteDataBefore:(int)timeStamp;

+ (NSArray*)getPlaceListForCreatePost:(CLLocation*)currentLocation;

@end
