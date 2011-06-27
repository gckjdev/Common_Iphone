//
//  GetUserPlace.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetUserPlaceInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;

@end

@interface GetUserPlaceOutput : CommonOutput
{
    NSArray*        placeArray;
}

@property (nonatomic, retain) NSArray* placeArray;


@end

@interface GetUserPlaceRequest : NetworkRequest {
	
}

+ (GetUserPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId;

+ (void)test;

@end
