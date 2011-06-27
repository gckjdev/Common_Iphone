//
//  CreatePlace.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface CreatePlaceInput : NSObject
{
	NSString*		userId;
	NSString*		name;
	NSString*		description;
    double          longtitude;
    double          latitude;
    NSString*       appId;
    int             radius;
    int             postType;
        
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*		name;
@property (nonatomic, retain) NSString*		description;
@property (nonatomic, assign) double        longtitude;
@property (nonatomic, assign) double        latitude;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, assign) int           radius;
@property (nonatomic, assign) int           postType;

@end

@interface CreatePlaceOutput : CommonOutput
{
	NSString	*placeId;
//    NSString    *createUser;
}

@property (nonatomic, retain) NSString	*placeId;
//@property (nonatomic, retain) NSString	*createUser;


@end

@interface CreatePlaceRequest : NetworkRequest {
	
}

+ (CreatePlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId name:(NSString*)name description:(NSString*)description longtitude:(double)longtitude latitude:(double)latitude;

+ (void)test;

@end
