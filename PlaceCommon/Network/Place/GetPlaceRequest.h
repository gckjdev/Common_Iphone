//
//  GetPlaceRequest.h
//  Dipan
//
//  Created by penglzh on 11-5-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"


@interface GetPlaceInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       placeId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     placeId;

@end

@interface GetPlaceOutput : CommonOutput
{
    NSDictionary*   placeDict;
}

@property (nonatomic, retain) NSDictionary*   placeDict;

@end

@interface GetPlaceRequest : NetworkRequest {
	
}

+ (GetPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId  placeId:(NSString*)placeId appId:(NSString*)appId;

+ (void)test;

@end
