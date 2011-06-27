//
//  PlaceManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import "PlaceManager.h"
#import "Place.h"
#import "CoreDataUtil.h"
#import <CoreLocation/CoreLocation.h>

@implementation PlaceManager

+ (BOOL)createPlace:(NSString*)placeId name:(NSString*)name desc:(NSString*)desc
          longitude:(double)longitude latitude:(double)latitude 
         createUser:(NSString*)createUser  followUserId:(NSString*)followUserId
             useFor:(int)useFor
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    
    Place *place = [dataManager insert:@"Place"];
    place.placeId = placeId;
    place.name = name;
    place.desc = desc;
    place.longitude = [NSNumber numberWithDouble:longitude];
    place.latitude = [NSNumber numberWithDouble:latitude];
    place.createUser = createUser;
    place.followUser = followUserId;
    place.useFor = [NSNumber numberWithInt:useFor];
    place.deleteFlag = [NSNumber numberWithBool:NO];
    place.deleteTimeStamp = [NSNumber numberWithInt:0];
    
    NSLog(@"Create Place: %@", [place name]);
    
    return [dataManager save];
}

+ (NSArray*)getAllFollowPlaces
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllFollowPlaces" 
                         sortBy:@"name" 
                      ascending:YES];
}

+ (BOOL)deleteAllFollowPlaces
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [PlaceManager getAllFollowPlaces];
    
    for (Place* place in placeArray){
        place.deleteFlag = [NSNumber numberWithBool:YES];
        place.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    }
    
    return [dataManager save];
}

+ (BOOL)deleteAllPlacesNearby
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [PlaceManager getAllPlacesNearby];
    
    for (Place* place in placeArray){
        place.deleteFlag = [NSNumber numberWithBool:YES];
        place.deleteTimeStamp = [NSNumber numberWithInt:time(0)];

    }
    
    return [dataManager save];
}

+ (NSArray*)getAllPlacesNearby
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getAllPlacesNearby" 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    return placeArray;
}

+ (BOOL)isPlaceFollowByUser:(NSString*)placeId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getPlaceUseForFollow"
                                        forKey:@"placeId" 
                                         value:placeId 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    if (placeArray != nil && [placeArray count] > 0)
        return YES;
    else    
        return NO;
}

+ (BOOL)userFollowPlace:(NSString*)userId place:(Place*)place
{
    if (place == nil)
        return YES;
    
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getPlaceUseForFollow"
                                        forKey:@"placeId" 
                                         value:place.placeId 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    if (placeArray != nil && [placeArray count] > 0)
        return YES;
    
    // not exist, copy place to follow list
    [PlaceManager createPlace:place.placeId
                         name:place.name 
                         desc:place.desc 
                    longitude:[place.longitude doubleValue]
                     latitude:[place.latitude doubleValue]
                   createUser:userId 
                 followUserId:nil 
                       useFor:PLACE_USE_FOLLOW];    
    
    return YES;    
}

+ (BOOL)userUnfollowPlace:(NSString*)userId placeId:(NSString*)placeId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getPlaceUseForFollow"
                                        forKey:@"placeId" 
                                         value:placeId 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    if (placeArray != nil && [placeArray count] > 0){
        for (Place* place in placeArray){
            place.deleteFlag = [NSNumber numberWithBool:YES];
            place.deleteTimeStamp = [NSNumber numberWithInt:time(0)];            
        }
        [dataManager save];
    }
    
    return YES;
}

+ (void)cleanUpDeleteDataBefore:(int)timeStamp
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getAllPlacesForDelete" 
                                        forKey:@"beforeTimeStamp" 
                                         value:[NSNumber numberWithInt:timeStamp]
                                        sortBy:@"placeId"
                                     ascending:YES];
    
    for (Place* place in placeArray){
        [dataManager del:place];
    }
    
    [dataManager save];     
    
}



+ (NSArray*)getPlaceListForCreatePost:(CLLocation*)currentLocation
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getAllPlacesFollowNearby" 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    NSMutableArray* newPlaceArray = [[[NSMutableArray alloc] init] autorelease];
    int count = [placeArray count];
    for (int i=0; i<count; ){
        Place* place = [placeArray objectAtIndex:i];
        NSString* placeId1 = [[placeArray objectAtIndex:i] placeId];
        int j;
        for (j=i+1; j<count;){
            Place* place2 = [placeArray objectAtIndex:j];
            NSString* placeId2 = [place2 placeId];
            if ([placeId1 isEqualToString:placeId2]){

                if ([place2.useFor intValue] == PLACE_USE_FOLLOW){
                    place = place2; // use for follow place has higher priority for sorting purpose
                }
                
                j++; // skip same place
                
            }
            else{
                break;
            }
        }
        
        // add place
        [newPlaceArray addObject:place];

        // new index for removing duplicate place
        i = j;
    }
    
    return [newPlaceArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Place* place1 = obj1;
        Place* place2 = obj2;
        if ([place1.useFor intValue] > [place2.useFor intValue])    // follow has higher priority
            return NSOrderedAscending;
        else if ([place1.useFor intValue] == [place2.useFor intValue]){

            CLLocation* location1 = [[CLLocation alloc] initWithLatitude:[place1.latitude doubleValue] 
                                                               longitude:[place1.longitude doubleValue]];
            
            CLLocation* location2 = [[CLLocation alloc] initWithLatitude:[place2.latitude doubleValue] 
                                                               longitude:[place2.longitude doubleValue]];
            
            double distance1 = [currentLocation distanceFromLocation:location1];
            double distance2 = [currentLocation distanceFromLocation:location2];
            
            if (distance1 < distance2)          // more close has higher priority
                return NSOrderedAscending;
            else if (distance1 == distance2)
                return NSOrderedSame;
            else
                return NSOrderedDescending;
        }
        else{
            return NSOrderedDescending;
        }
        
    }];
     
    
}


@end
