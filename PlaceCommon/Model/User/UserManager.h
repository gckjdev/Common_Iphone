//
//  UserManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject {

}

+ (BOOL)createUserWithUserId:(NSString *)userId
                 userLoginId:(NSString *)userLoginId
                 sinaLoginId:(NSString *)sinaLoginId
                   qqLoginId:(NSString *)qqLoginId
               renrenLoginId:(NSString *)renrenLoginId
              twitterLoginId:(NSString *)twitterLoginId
             facebookLoginId:(NSString *)facebookLoginId
                    nickName:(NSString *)nickName
                      avatar:(NSString *)avatar
             sinaAccessToken:(NSString *)sinaAccessToken
       sinaAccessTokenSecret:(NSString *)sinaAccessTokenSecret                
               qqAccessToken:(NSString *)qqAccessToken               
         qqAccessTokenSecret:(NSString *)qqAccessTokenSecret;

+ (BOOL)createUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
              loginIdType:(int)loginIdType
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
              accessToken:(NSString *)accessToken
           accessTokenSecret:(NSString *)accessTokenSecret;

+ (BOOL)createUserWithUserId:(NSString *)userId
                     loginId:(NSString *)loginId
                 loginIdType:(int)loginIdType
                    nickName:(NSString *)nickName
                      avatar:(NSString *)avatar
                 accessToken:(NSString *)accessToken
           accessTokenSecret:(NSString *)accessTokenSecret;


+ (BOOL)bindUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
              loginIdType:(int)loginIdType
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
               accessToken:(NSString *)accessToken
         accessTokenSecret:(NSString *)accessTokenSecret;


// TODO to be improved
+ (BOOL)isUserRegistered;

// get user
+ (User*)getUser;

// return userId
+ (NSString*)getUserId;

// user login locally
+ (void)userLoginSuccess:(User*)user;

+ (void)logoutUser:(User*)user;

@end
