//
//  GetPublicTimelinePost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetPublicTimelinePostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       beforeTimeStamp;
    int             maxCount;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     beforeTimeStamp;
@property (nonatomic, assign) int           maxCount;

@end

@interface GetPublicTimelinePostOutput : CommonOutput
{
    NSArray*        postArray;
}

@property (nonatomic, retain) NSArray* postArray;

@end

@interface GetPublicTimelinePostRequest : NetworkRequest {
	
}

+ (GetPublicTimelinePostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId beforeTimeStamp:(NSString*)beforeTimeStamp;

@end
