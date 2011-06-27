//
//  GetPlacePost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetPlacePostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       placeId;
    NSString*       beforeTimeStamp;
    int             maxCount;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     placeId;
@property (nonatomic, retain) NSString*     beforeTimeStamp;
@property (nonatomic, assign) int           maxCount;

@end

@interface GetPlacePostOutput : CommonOutput
{
    NSArray*        postArray;
}

@property (nonatomic, retain) NSArray* postArray;

@end

@interface GetPlacePostRequest : NetworkRequest {
	
}

+ (GetPlacePostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId placeId:(NSString*)placeId beforeTimeStamp:(NSString*)beforeTimeStamp;

+ (void)test;

@end
