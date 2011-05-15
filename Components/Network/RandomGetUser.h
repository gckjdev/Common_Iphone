//
//  RandomGetUser.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

enum ReturnStateAction {
	kStateNoCall = 0,
	kStateActionMakeCall = 1,
	kStateActionWaitCall = 2
};

@interface RandomGetUserInput : NSObject
{
	NSString*		facetimeId;
	NSString*		deviceId;
}

@property (nonatomic, retain) NSString*		facetimeId;
@property (nonatomic, retain) NSString*		deviceId;

@end

@interface RandomGetUserOutput : CommonOutput
{
	int			state;
	NSString*	facetimeId;
}

@property (nonatomic, retain) NSString*		facetimeId;
@property (nonatomic, assign) int			state;

@end

@interface RandomGetUserRequest : NetworkRequest {
	
}

@end
