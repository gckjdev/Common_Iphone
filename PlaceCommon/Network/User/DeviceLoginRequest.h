//
//  DeviceLogin.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface DeviceLoginInput : NSObject {

	NSString*		appId;
	NSString*		deviceId;
    BOOL            needReturnUser;
	
}

@property (nonatomic, retain) NSString*		deviceId;
@property (nonatomic, retain) NSString*		appId;
@property (nonatomic, assign) BOOL          needReturnUser;

@end

@interface DeviceLoginOutput : CommonOutput {
    NSString*           userAvatar;
	NSString*           userId;
    NSString*           loginId;
    NSString*           sinaId;
    NSString*           qqId;
    NSString*           renrenId;
    NSString*           facebookId;
    NSString*           twitterId;    
    NSString*           nickName;
    NSString*           sinaAccessToken;
    NSString*           sinaAccessTokenSecret;
    NSString*           qqAccessToken;
    NSString*           qqAccessTokenSecret;
}

@property (nonatomic, retain) NSString	*userId;
@property (nonatomic, retain) NSString	*loginId;
@property (nonatomic, retain) NSString  *sinaId;
@property (nonatomic, retain) NSString  *qqId;
@property (nonatomic, retain) NSString  *renrenId;
@property (nonatomic, retain) NSString  *facebookId;
@property (nonatomic, retain) NSString  *twitterId;    
@property (nonatomic, retain) NSString	*nickName;
@property (nonatomic, retain) NSString  *userAvatar;
@property (nonatomic, retain) NSString	*sinaAccessToken;
@property (nonatomic, retain) NSString	*sinaAccessTokenSecret;
@property (nonatomic, retain) NSString	*qqAccessToken;
@property (nonatomic, retain) NSString	*qqAccessTokenSecret;

@end

@interface DeviceLoginRequest : NetworkRequest {
	
}

+ (DeviceLoginOutput*)send:(NSString*)serverURL
                     appId:(NSString*)appId
            needReturnUser:(BOOL)needReturnUser;
@end
