//
//  UserFollowPlace.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface UserFollowPlaceInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       placeId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     placeId;

@end

@interface UserFollowPlaceOutput : CommonOutput
{
}

@end

@interface UserFollowPlaceRequest : NetworkRequest {
	
}

+ (UserFollowPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId  placeId:(NSString*)placeId appId:(NSString*)appId;

+ (void)test;

@end
