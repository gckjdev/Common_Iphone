//
//  GetNearbyPost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetNearbyPostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       beforeTimeStamp;
    int             maxCount;
    double          longitude;
    double          latitude;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     beforeTimeStamp;
@property (nonatomic, assign) int           maxCount;
@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) double        latitude;

@end

@interface GetNearbyPostOutput : CommonOutput
{
    NSArray*        postArray;
}

@property (nonatomic, retain) NSArray* postArray;

@end

@interface GetNearbyPostRequest : NetworkRequest {
	
}

+ (GetNearbyPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId beforeTimeStamp:(NSString*)beforeTimeStamp longitude:(double)longitude latitude:(double)latitude;

+ (void)test;

@end
