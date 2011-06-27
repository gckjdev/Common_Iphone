//
//  BindUserRequest.h
//  Dipan
//
//  Created by penglzh on 11-5-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface BindUserInput : NSObject {
    NSString*       userId;
	NSString*		loginId;
	NSString*		appId;
	int				loginIdType;
	NSString*		deviceId;
	NSString*		deviceModel;	
	int				deviceOS;
	NSString*		countryCode;
	NSString*		language;
	NSString*		deviceToken;	
    NSString*       nickName;
    NSString*       avatar;
    NSString*       accessToken;
    NSString*       accessTokenSecret;
    int             province;
    int             city;
    NSString*       location;
    NSString*       gender;
    NSString*       birthday;
    NSString*       sinaNickName;
    NSString*       sinaDomain;
    NSString*       qqNickName;
    NSString*       qqDomain;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*		loginId;
@property (nonatomic, assign) int			loginIdType;
@property (nonatomic, assign) int			deviceOS;
@property (nonatomic, retain) NSString*		deviceId;
@property (nonatomic, retain) NSString*		deviceModel;
@property (nonatomic, retain) NSString*		countryCode;
@property (nonatomic, retain) NSString*		language;
@property (nonatomic, retain) NSString*		appId;
@property (nonatomic, retain) NSString*		deviceToken;
@property (nonatomic, retain) NSString*     nickName;
@property (nonatomic, retain) NSString*     avatar;
@property (nonatomic, retain) NSString*     accessToken;
@property (nonatomic, retain) NSString*     accessTokenSecret;
@property (nonatomic, assign) int           province;
@property (nonatomic, assign) int           city;
@property (nonatomic, retain) NSString*     location;
@property (nonatomic, retain) NSString*     gender;
@property (nonatomic, retain) NSString*     birthday;
@property (nonatomic, retain) NSString*     sinaNickName;
@property (nonatomic, retain) NSString*     sinaDomain;
@property (nonatomic, retain) NSString*     qqNickName;
@property (nonatomic, retain) NSString*     qqDomain;

@end

@interface BindUserOutput : CommonOutput {
}

@end

@interface BindUserRequest : NetworkRequest {
	
}

+ (BindUserOutput*)send:(NSString*)serverURL
                 userId:(NSString *)userId
                    loginId:(NSString*)loginId
                loginIdType:(int)loginIdType
                deviceToken:(NSString*)deviceToken
                   nickName:(NSString*)nickName
                     avatar:(NSString *)avatar
                accessToken:(NSString *)accessToken
          accessTokenSecret:(NSString *)accessTokenSecret
                      appId:(NSString*)appId
                   province:(int)province
                       city:(int)city
                   location:(NSString *)location
                     gender:(NSString *)gender
                   birthday:(NSString *)birthday
               sinaNickName:(NSString *)sinaNickName
                 sinaDomain:(NSString *)sinaDomain
                 qqNickName:(NSString *)qqNickName
                   qqDomain:(NSString *)qqDomain;

+ (BindUserOutput*)    send:(NSString*)serverURL
                     userId:(NSString *)userId
                    loginId:(NSString*)loginId
                loginIdType:(int)loginIdType
                deviceToken:(NSString*)deviceToken
                   nickName:(NSString*)nickName
                     avatar:(NSString *)avatar
                accessToken:(NSString *)accessToken
          accessTokenSecret:(NSString *)accessTokenSecret
                      appId:(NSString*)appId
                   province:(int)province
                       city:(int)city
                   location:(NSString *)location
                     gender:(NSString *)gender
                   birthday:(NSString *)birthday
                     domain:(NSString *)domain;
@end

