//
//  UserService.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserManager.h"

@class PPViewController;

#define AVATAR_SIZE         CGSizeMake(180, 180)
#define DEFAULT_AVATAR      @"user_bg@2x.png"
#define FEMALE_AVATAR       @"girl1.png"
#define MALE_AVATAR         @"boy1.png"
#define TEMP_AVATAR_DIR     @"avatar_temp"

enum{
    USER_STATUS_UNKNOWN = 0,    
    USER_NOT_EXIST_LOCAL = 810001,
    USER_EXIST_LOCAL_STATUS_LOGIN,
    USER_EXIST_LOCAL_STATUS_LOGOUT,
    
    
};

enum{
    LOGIN_RESULT_SUCCESS = 0,
    LOGIN_RESULT_UNKNOWN = 820001,
    LOGIN_RESULT_ID_NOT_MATCH,  
    LOGIN_RESULT_NETWORK_ERROR,
};

@protocol UserServiceDelegate <NSObject>

- (void)checkDeviceResult:(int)result;
- (void)loginUserResult:(int)result;


@end

typedef void (^SaveUserSuccessHandler)(PPViewController*);
typedef void (^UpdateUserSuccessHandler)(PPViewController*, int);

@interface UserService : NSObject {
    
    NSString                *gender;            // for temp save
    User                    *user;              // save and cache current user
    id<UserServiceDelegate> delegate;           
    dispatch_queue_t        workingQueue;
    int                     userCurrentStatus;    
    
}

@property (nonatomic, retain) User        *user;
@property (nonatomic, retain) NSString    *gender;
@property (nonatomic, assign) id<UserServiceDelegate> delegate; 
@property (nonatomic, assign) int                     userCurrentStatus;    
@property (nonatomic, retain) NSString    *newPassword;

- (id)init;

- (NSString*)userId;

- (void)updateUserCache;

- (void)checkDevice;
- (void)loginUserWithLoginId:(NSString*)loginId gender:(NSString*)gender viewController:(PPViewController*)viewController;
- (void)loginUserWithLoginId:(NSString*)loginId viewController:(PPViewController*)viewController;
- (void)loginUserWithSNSUserInfo:(NSDictionary*)userInfo viewController:(PPViewController*)viewController;
- (void)logoutUser;

- (NSString*)getLoginIdForDisplay;
- (BOOL)hasUserBindSina;
- (BOOL)hasUserBindQQ;
- (BOOL)hasUserBindRenren;
- (BOOL)hasBindSNS;

- (NSURL*)getUserAvatarURL;
- (NSData*)getUserAvatarData;

- (void)updateUserNickName:(NSString*)value;
- (void)updateUserMobile:(NSString*)value;
- (void)updateUserAvatar:(UIImage*)image;
- (void)updateUserGender:(NSString*)value;
- (void)updateUserPasswordByNewPassword;

- (void)updateUserToServer:(PPViewController*)viewController successHandler:(SaveUserSuccessHandler)saveSuccessHandler;

+ (NSString*)defaultAvatarByGender:(NSString*)gender;

- (BOOL)hasBindAccount;
- (BOOL)hasBindEmail;

@end

extern UserService*       GlobalGetUserService();


