//
//  User.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface User :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString *userId;
//@property (nonatomic, retain) NSString *loginId;
//@property (nonatomic, retain) NSNumber *loginIdType;
@property (nonatomic, retain) NSString *queryId;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *sinaAccessToken;
@property (nonatomic, retain) NSString *sinaAccessTokenSecret;
@property (nonatomic, retain) NSString *qqAccessToken;
@property (nonatomic, retain) NSString *qqAccessTokenSecret;
@property (nonatomic, assign) NSNumber *loginStatus;

@property (nonatomic, retain) NSString *userLoginId;
@property (nonatomic, retain) NSString *sinaLoginId;
@property (nonatomic, retain) NSString *qqLoginId;
@property (nonatomic, retain) NSString *renrenLoginId;
@property (nonatomic, retain) NSString *facebookLoginId;
@property (nonatomic, retain) NSString *twitterLoginId;

@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *gender;


- (BOOL)isLogin;

@end



