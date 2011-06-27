//
//  GetNearbyPlace.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetNearbyPlaceInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    double          longitude;
    double          latitude;
    NSString*       beforeTimeStamp;
    int             maxCount;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) double        latitude;
@property (nonatomic, retain) NSString*     beforeTimeStamp;
@property (nonatomic, assign) int           maxCount;
@end

@interface GetNearbyPlaceOutput : CommonOutput
{
    NSArray*        placeArray;
}

@property (nonatomic, retain) NSArray* placeArray;

@end

@interface GetNearbyPlaceRequest : NetworkRequest {
	
}

+ (GetNearbyPlaceOutput*)send:(NSString*)serverURL 
                       userId:(NSString*)userId 
                        appId:(NSString*)appId 
                    longitude:(double)longitude
                     latitude:(double)latitude
              beforeTimeStamp:(NSString*)beforeTimeStamp;

+ (void)test;

@end
