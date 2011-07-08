//
//  ActionOnPost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface ActionOnPostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       postId;
    NSString*       actionType;
    double          longitude;
    double          latitude;
    NSString*       placeId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     postId;
@property (nonatomic, retain) NSString*     actionType;
@property (nonatomic, assign) double          longitude;
@property (nonatomic, assign) double          latitude;
@property (nonatomic, retain) NSString*       placeId;

@end

@interface ActionOnPostOutput : CommonOutput
{
}

@end

@interface ActionOnPostRequest : NetworkRequest {
	
}

+ (ActionOnPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId postId:(NSString*)postId actionType:(NSString*)actionType longitude:(double)longitude latitude:(double)latitude placeId:(NSString*)placeId
;

@end
