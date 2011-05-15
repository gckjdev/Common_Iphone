//
//  OnlineStatus.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

enum kOnlineStatus {
	kStatusOnline = 0,
	kStatusOffline = 1
};

@interface OnlineStatusInput : NSObject
{
	NSString*		userId;
	NSString*		deviceId;
	int				status;
	NSString*		appId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, assign) int			status;
@property (nonatomic, retain) NSString*		deviceId;
@property (nonatomic, retain) NSString*		appId;

@end

@interface OnlineStatusOutput : CommonOutput
{
}

@end

@interface OnlineStatusRequest : NetworkRequest {
	
}

@end
