//
//  LocalDataService.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-16.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPViewController.h"

@protocol LocalDataServiceDelegate <NSObject>

@optional

- (void)followPlaceDataRefresh:(int)result;
- (void)placePostDataRefresh:(int)result;
- (void)nearbyPlaceDataRefresh:(int)result;
- (void)followPostDataRefresh:(int)result;
- (void)nearbyPostDataRefresh:(int)result;
- (void)atMePostDataRefresh:(int)result;

// common method now!!! we can refactor all to this method 
- (void)postDataRefresh:(int)result;

@end

@interface LocalDataService : NSObject {
    
    dispatch_queue_t                workingQueue;
    id<LocalDataServiceDelegate>    defaultDelegate;
}

@property (nonatomic, assign) dispatch_queue_t workingQueue;
@property (nonatomic, assign) id<LocalDataServiceDelegate>    defaultDelegate;

- (id)initWithDelegate:(id<LocalDataServiceDelegate>)delegate;
- (void)requestPlaceData;
- (void)requestNearbyPlaceData:(id<LocalDataServiceDelegate>)delegate
               beforeTimeStamp:(NSString*)beforeTimeStamp
                     longitude:(double)longitude 
                      latitude:(double)latitude
                     cleanData:(BOOL)cleanData;

- (void)requestUserFollowPlaceData:(id<LocalDataServiceDelegate>)delegate;

- (void)requestLatestPlacePostData:(id<LocalDataServiceDelegate>)delegateObject 
                           placeId:(NSString*)placeId;

- (void)requestAppPublicTimelinePostData:(id<LocalDataServiceDelegate>)delegateObject
                         beforeTimeStamp:(NSString*)beforeTimeStamp
                               cleanData:(BOOL)cleanData;

- (void)requestNearbyPostData:(id<LocalDataServiceDelegate>)delegateObject
              beforeTimeStamp:(NSString*)beforeTimeStamp
                    longitude:(double)longitude 
                     latitude:(double)latitude
                    cleanData:(BOOL)cleanData;

- (void)requestUserFollowPostData:(id<LocalDataServiceDelegate>)delegateObject
              beforeTimeStamp:(NSString*)beforeTimeStamp
                    cleanData:(BOOL)cleanData;

- (void)requestUserAtMePostData:(id<LocalDataServiceDelegate>)delegateObject
                  beforeTimeStamp:(NSString*)beforeTimeStamp
                        cleanData:(BOOL)cleanData;


- (void)requestDataWhileEnterForeground;
- (void)requestDataWhileLaunch;

- (void)userFollowPlace:(NSString*)placeId placeName:(NSString*)placeName viewController:(PPViewController*)viewController;

@end

extern LocalDataService* GlobalGetLocalDataService();
