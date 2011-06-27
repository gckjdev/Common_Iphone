// 
//  User.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "User.h"


@implementation User 

@dynamic userId;
//@dynamic loginId;
//@dynamic loginIdType;
@dynamic queryId;
@dynamic nickName;
@dynamic avatar;
@dynamic sinaAccessToken;
@dynamic sinaAccessTokenSecret;
@dynamic qqAccessToken;
@dynamic qqAccessTokenSecret;
@dynamic loginStatus;
@dynamic userLoginId;
@dynamic sinaLoginId;
@dynamic qqLoginId;
@dynamic renrenLoginId;
@dynamic facebookLoginId;
@dynamic twitterLoginId;
@dynamic mobile;
@dynamic email;
@dynamic password;


- (BOOL)isLogin
{
    return [self.loginStatus boolValue];
}

@end
