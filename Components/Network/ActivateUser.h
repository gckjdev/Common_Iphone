//
//  ActivateUser.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

// m=reg&uid=13802538605&utype=0&did=xxx&dtype=xxx&dm=xxx&pwd=xxx&cc=CN&lang=zh_Hans&ts=xxxx&mac=xxx&app=xxx
// ts=xxxx&mac=xxxx

#define kActivateUserMethod		@"reg"

typedef enum kReqUserType {
	kMobileUser,
	kEmailUser	
} kReqUserType;

typedef enum kDeviceType {
	kDevice_iPhone,
	kDevice_iPodTouch,
	kDevice_iPad,
	kDevice_Android
} kDeviceType;

@interface ActivateUserInput : NSObject
{
	NSString*		userId;
	kReqUserType	userType;
	NSString*		deviceId;
	NSString*		deviceModel;	
	kDeviceType		deviceType;
	NSString*		countryCode;
	NSString*		password;
	NSString*		language;
	NSString*		appId;
	NSString*		deviceToken;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, assign) kReqUserType	userType;
@property (nonatomic, assign) kDeviceType	deviceType;
@property (nonatomic, retain) NSString*		deviceId;
@property (nonatomic, retain) NSString*		deviceModel;
@property (nonatomic, retain) NSString*		countryCode;
@property (nonatomic, retain) NSString*		language;
@property (nonatomic, retain) NSString*		password;
@property (nonatomic, retain) NSString*		appId;
@property (nonatomic, retain) NSString*		deviceToken;

@end

@interface ActivateUserOutput : CommonOutput
{
	NSString* code;
}

@property (nonatomic, retain) NSString* code;

@end

@interface ActivateUserRequest : NetworkRequest {
	
}

@end

@interface ActivateCode : NetworkRequest {
	
}

@end
