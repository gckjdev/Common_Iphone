//
//  UserManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "UserManager.h"
#import "CoreDataUtil.h"
#import "VariableConstants.h"

#define DEFAULT_USER_QUERY_ID	@"DEFAULT_USER_QUERY_ID"

UserManager* userManager;

@implementation UserManager

+ (BOOL)isUserRegistered
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	NSObject* user = [dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];	
	return ( user != nil );
}

+ (void)setUserLoginId:(User*)user 
               loginId:(NSString*)loginId 
                  type:(int)loginIdType
              nickName:(NSString *)nickName
                avatar:(NSString *)avatar
           accessToken:(NSString *)accessToken
     accessTokenSecret:(NSString *)accessTokenSecret

{
//    user.loginId = loginId;
//    user.loginIdType = [NSNumber numberWithInt:loginIdType];
    
    if (avatar != nil && [avatar length] > 0)
        user.avatar = avatar;
    
    if (nickName != nil && [nickName length] > 0)
        user.nickName = nickName;
    
    switch (loginIdType) {
        case LOGINID_OWN:
            user.userLoginId = loginId;
            break;
            
        case LOGINID_SINA:
        {
            user.sinaLoginId = loginId;
            user.sinaAccessToken = accessToken;
            user.sinaAccessTokenSecret = accessTokenSecret;
        }
            break;

        case LOGINID_QQ:
        {
            user.qqLoginId = loginId;
            user.qqAccessToken = accessToken;
            user.qqAccessTokenSecret = accessTokenSecret;
        }
            break;

        case LOGINID_RENREN:
        {
            user.renrenLoginId = loginId;
        }
            break;

        case LOGINID_FACEBOOK:
        {
            user.facebookLoginId = loginId;
        }
            break;

        case LOGINID_TWITTER:
        {
            user.twitterLoginId = loginId;
        }
            break;

        default:
            break;
    }
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
         qqAccessTokenSecret:(NSString *)qqAccessTokenSecret
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == user) {
        user = [dataManager insert:@"User"];
    }

    user.userLoginId = userLoginId;
    user.sinaLoginId = sinaLoginId;
    user.qqLoginId = qqLoginId;
    user.renrenLoginId = renrenLoginId;
    user.twitterLoginId = twitterLoginId;
    user.facebookLoginId = facebookLoginId;
    user.nickName = nickName;
    user.avatar = avatar;
    user.sinaAccessToken = sinaAccessToken;
    user.sinaAccessTokenSecret = sinaAccessTokenSecret;
    user.qqAccessToken = qqAccessToken;
    user.qqAccessTokenSecret = qqAccessTokenSecret;

    user.userId = userId;
    user.queryId = DEFAULT_USER_QUERY_ID;
    user.loginStatus = [NSNumber numberWithBool:YES];
    
    NSLog(@"<createUser> user=%@", [user description]);
    
    return [dataManager save];
}

+ (BOOL)createUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
              loginIdType:(int)loginIdType
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == user) {
        user = [dataManager insert:@"User"];
    }
    
    [UserManager setUserLoginId:user 
                        loginId:loginId 
                           type:loginIdType     
                       nickName:nickName
                         avatar:avatar 
                    accessToken:accessToken 
              accessTokenSecret:accessTokenSecret];
    
    user.userId = userId;
    user.queryId = DEFAULT_USER_QUERY_ID;
    user.loginStatus = [NSNumber numberWithBool:YES];    
    
    NSLog(@"<createUser> user=%@", [user description]);
    
	return [dataManager save];
}

+ (BOOL)bindUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
              loginIdType:(int)loginIdType
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret

{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == user) {
        // no user?
        NSLog(@"<bindUser> but userId(%@) record not found!", userId);
        return NO;
    }
    
//    user.queryId = DEFAULT_USER_QUERY_ID;
//    user.userId = userId;
    user.loginStatus = [NSNumber numberWithBool:YES];

    [UserManager setUserLoginId:user 
                        loginId:loginId 
                           type:loginIdType     
                       nickName:nickName
                         avatar:avatar 
                    accessToken:accessToken 
              accessTokenSecret:accessTokenSecret];
    
    NSLog(@"<bindUser> user=%@", [user description]);
    
	return [dataManager save];
}

+ (BOOL)setUser:(User *)user
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* u = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == u) {
        u = [dataManager insert:@"User"];
    }
    u.userId = user.userId;
    
//    u.loginId = user.loginId;
//    u.loginIdType = user.loginIdType;
    u.queryId = user.queryId;
    u.nickName = user.nickName;
    u.avatar = user.avatar;
    u.sinaAccessToken = user.sinaAccessToken;
    u.sinaAccessTokenSecret = user.sinaAccessTokenSecret;
    u.qqAccessToken = user.qqAccessToken;
    u.qqAccessTokenSecret = user.qqAccessTokenSecret;
    u.loginStatus = user.loginStatus;
    
    NSLog(@"<setUser> user=%@", [user description]);
    
	return [dataManager save];
}

+ (void)userLoginSuccess:(User*)user
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    user.loginStatus = [NSNumber numberWithBool:YES];
    [dataManager save];
}

+ (User*)getUser
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
	return user;
}

+ (BOOL)delUser
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil != user) {
        [dataManager del:user];
    }
    return [dataManager save]; 
}

+ (NSString*)getUserId
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
	return user.userId;    
}

+ (void)logoutUser:(User*)user
{
    NSLog(@"Logout User OK!");
    user.loginStatus = [NSNumber numberWithBool:NO];
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
    [dataManager save];    
}

@end
