//
//  GroupBuyUserService.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupBuyUserService.h"
#import "GroupBuyNetworkRequest.h"
#import "PPNetworkRequest.h"
#import "GroupBuyNetworkConstants.h"
#import "AppManager.h"
#import "CommonManager.h"
#import "PPApplication.h"
#import "UIUtils.h"
#import "PPViewController.h"
#import "SNSConstants.h"

//#import "DeviceLoginRequest.h"

@implementation UserService (GroupBuyUserService)

- (void)registerUserByDevice
{
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyDeviceToken];
    
    dispatch_async(workingQueue, ^{
        CommonNetworkOutput* output = [GroupBuyNetworkRequest registerUserDevice:SERVER_URL appId:GlobalGetPlaceAppId() deviceToken:deviceToken];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS) {
                // save return User ID locally
                NSString* userId = [output.jsonDataDict objectForKey:PARA_USERID]; 
                [UserManager createUserWithUserId:userId loginId:nil loginIdType:0 nickName:nil avatar:nil accessToken:nil accessTokenSecret:nil];
                [self updateUserCache];
            }
            else{
                // TODO, need to handle different error code
            }
        });
        
    });
}

- (void)groupBuyCheckDevice
{
    NSLog(@"current user Id is %@", user.userId);
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyDeviceToken];
    
    if (userCurrentStatus != USER_EXIST_LOCAL_STATUS_LOGIN){
        dispatch_async(workingQueue, ^{
            CommonNetworkOutput* output = [GroupBuyNetworkRequest deviceLogin:SERVER_URL appId:GlobalGetPlaceAppId() needReturnUser:YES deviceToken:deviceToken];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (output.resultCode == ERROR_SUCCESS) {
                    // save return User ID locally
                    NSString* userId = [output.jsonDataDict objectForKey:PARA_USERID]; 
                    [UserManager createUserWithUserId:userId loginId:nil loginIdType:0 nickName:nil avatar:nil accessToken:nil accessTokenSecret:nil];

                    [self updateUserCache];
                }
                else if (output.resultCode == ERROR_DEVICE_NOT_BIND){
                    // send registration request
                    [self registerUserByDevice];
                }
                else{
                    // TODO, need to handle different error code
                }
            });
            
        });
    }
    else{
        dispatch_async(workingQueue, ^{
            [GroupBuyNetworkRequest deviceLogin:SERVER_URL appId:GlobalGetPlaceAppId() needReturnUser:NO deviceToken:deviceToken];        
        });
    }
    
    
    if (delegate && [delegate respondsToSelector:@selector(checkDeviceResult:)]){
        [delegate checkDeviceResult:userCurrentStatus];        
    }    
}

- (void)updateGroupBuyUserDeviceToken:(NSString*)deviceToken
{
    dispatch_async(workingQueue, ^{
        CommonNetworkOutput* output = [GroupBuyNetworkRequest updateUser:SERVER_URL appId:GlobalGetPlaceAppId() userId:user.userId deviceToken:deviceToken nickName:nil password:nil newPassword:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS) {
            }
            else{
                [UIUtils alert:@"推送通知注册失败"];
            }
        });
        
    });
    
}

- (void)groupBuyUpdateUser:(PPViewController*)viewController successHandler:(UpdateUserSuccessHandler)successHandler
{
    
    dispatch_async(workingQueue, ^{
                                
        CommonNetworkOutput* output = [GroupBuyNetworkRequest updateUser:SERVER_URL 
                                                                   appId:GlobalGetPlaceAppId() 
                                                                  userId:user.userId                                        
                                                             deviceToken:nil
                                                                nickName:user.nickName
                                                                password:user.password
                                                             newPassword:self.newPassword];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            successHandler(viewController, output.resultCode);
        });
        
    });
}

- (void)registerUser:(NSString*)email 
            password:(NSString*)password 
      viewController:(PPViewController<GroupBuyUserServiceDelegate>*)viewController
{
    NSString* userId = [[self user] userId];
    NSString* appId = GlobalGetPlaceAppId();
    
    [viewController showActivityWithText:@"注册帐号中......"];    
    dispatch_async(workingQueue, ^{

        CommonNetworkOutput* output = nil;        
        if (userId == nil){
            output = [GroupBuyNetworkRequest registerUserByEmail:SERVER_URL 
                                                           appId:appId 
                                                           email:email 
                                                        password:password];
        }
        else{
            output = [GroupBuyNetworkRequest bindUserEmail:SERVER_URL 
                                                     appId:appId 
                                                    userId:userId 
                                                     email:email 
                                                  password:password];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS) {
                if (userId == nil){
                    // save return User ID locally
                    NSString* userId = [output.jsonDataDict objectForKey:PARA_USERID]; 
                    [UserManager createUserWithUserId:userId email:email password:password];
                    [self updateUserCache];
                }
                else{
                    [UserManager updateUserWithEmail:email password:password];
                    [self updateUserCache];
                }
                
                if ([viewController respondsToSelector:@selector(actionDone:)]){
                    [viewController actionDone:output.resultCode];                    
                }
            }
            else if (output.resultCode == ERROR_NETWORK) {
                [viewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else if (output.resultCode == ERROR_USERID_NOT_FOUND) {
                [viewController popupUnhappyMessage:@"对不起，用户注册无法完成，请联系我们的技术支持以便解决问题" title:nil];
            }
            else if (output.resultCode == ERROR_EMAIL_EXIST) {
                [viewController popupUnhappyMessage:@"对不起，该电子邮件已经被注册" title:nil];
            }
            else if (output.resultCode == ERROR_EMAIL_NOT_VALID) {
                [viewController popupUnhappyMessage:@"对不起，该电子邮件格式不正确，请重新输入" title:nil];
            }
            else {
                [viewController popupUnhappyMessage:@"对不起，注册失败，请稍候再试" title:nil];
            }
        });
        
    });    
}

- (void)loginUserWithEmail:(NSString*)email 
                  password:(NSString*)password 
            viewController:(PPViewController<GroupBuyUserServiceDelegate>*)viewController
{
    NSString* appId = GlobalGetPlaceAppId();
    
    [viewController showActivityWithText:@"用户登录中......"];    
    dispatch_async(workingQueue, ^{
        
        CommonNetworkOutput* output = nil;        
        output = [GroupBuyNetworkRequest loginUserByEmail:SERVER_URL 
                                                    appId:appId 
                                                    email:email 
                                                 password:password];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS) {
                NSString* userId = [output.jsonDataDict objectForKey:PARA_USERID];
                if (userId != nil){
                    // save return User ID locally
                    [UserManager createUserWithUserId:userId email:email password:password];
                    [self updateUserCache];
                    
                    // TODO : need to update user shopping list item later
                    
                }
                else{
                    NSLog(@"<loginUserWithEmail> warning, user login success but no user id!");
                }
            }
            else if (output.resultCode == ERROR_NETWORK) {
                [viewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else if (output.resultCode == ERROR_USER_EMAIL_NOT_FOUND) {
                [viewController popupUnhappyMessage:@"对不起，邮件未注册，请重新输入" title:nil];
            }
            else if (output.resultCode == ERROR_PASSWORD_NOT_MATCH) {
                [viewController popupUnhappyMessage:@"对不起，密码不正确，请检查后重新输入，注意密码字母大小写" title:nil];
            }
            else if (output.resultCode == ERROR_EMAIL_NOT_VALID ||
                     output.resultCode == ERROR_PARAMETER_EMAIL_EMPTY || 
                     output.resultCode == ERROR_PARAMETER_EMAIL_NULL ||
                     output.resultCode == ERROR_PARAMETER_PASSWORD_EMPTY ||
                     output.resultCode == ERROR_PARAMETER_PASSWORD_NULL ) {
                [viewController popupUnhappyMessage:@"对不起，邮件或者密码输入不正确，请重新输入" title:nil];
            }
            else {
                [viewController popupUnhappyMessage:@"对不起，登录失败，请稍候再试" title:nil];
            }
        });
        
    });    
    
}

- (int)getRegisterType:(NSDictionary*)userInfo
{
    NSString* networkName = [userInfo objectForKey:SNS_NETWORK];
    if ([networkName isEqualToString:SNS_SINA_WEIBO]){
        return REGISTER_TYPE_SINA;
    }
    else if ([networkName isEqualToString:SNS_QQ_WEIBO]){
        return REGISTER_TYPE_QQ;
    }
    
    NSLog(@"<getRegisterType> cannot find SNS type for network name = %@", networkName);
    return -1;
}

- (void)registerUserWithSNSUserInfo:(NSDictionary*)userInfo viewController:(PPViewController*)viewController
{
    NSString* appId = [AppManager getPlaceAppId];
    NSString* deviceToken = @""; // TODO get device token here!    
    
    NSString* loginId = [userInfo objectForKey:SNS_USER_ID];
    int loginIdType = [self getRegisterType:userInfo];
    
    [viewController showActivityWithText:NSLS(@"kRegisteringUser")];    
    dispatch_async(workingQueue, ^{            
        
        CommonNetworkOutput* output = 
              [GroupBuyNetworkRequest registerUserBySNS:SERVER_URL
                                                  snsId:loginId
                                           registerType:loginIdType                                       
                                                  appId:appId
                                            deviceToken:deviceToken
                                              nickName:[userInfo objectForKey:SNS_NICK_NAME]
                                                avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                           accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                                     accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]
                                              province:[[userInfo objectForKey:SNS_PROVINCE] intValue]
                                                  city:[[userInfo objectForKey:SNS_CITY] intValue]
                                              location:[userInfo objectForKey:SNS_LOCATION]
                                                gender:[userInfo objectForKey:SNS_GENDER]
                                              birthday:[userInfo objectForKey:SNS_BIRTHDAY]                                      
                                                domain:[userInfo objectForKey:SNS_DOMAIN]];                
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                NSString* userId = [output.jsonDataDict objectForKey:PARA_USERID];
                [UserManager createUserWithUserId:userId
                                          loginId:loginId
                                      loginIdType:loginIdType
                                         nickName:[userInfo objectForKey:SNS_NICK_NAME]
                                           avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                      accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                                accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]];
                [self updateUserCache];                 // MUST call this!!!
            }
            
            [delegate loginUserResult:output.resultCode];
        }); 
    });
    
}

- (void)bindUserWithSNSUserInfo:(NSDictionary*)userInfo 
                 viewController:(PPViewController<GroupBuyUserServiceDelegate>*)viewController
{
    NSString* userId = user.userId;
    NSString* appId = [AppManager getPlaceAppId];
    
    NSString* loginId = [userInfo objectForKey:SNS_USER_ID];
    int loginIdType = [self getRegisterType:userInfo];
    
    
    NSString* nickName = (user.nickName == nil || [user.nickName length] == 0) ? [userInfo objectForKey:SNS_NICK_NAME] : user.nickName;
    
    [viewController showActivityWithText:NSLS(@"kRegisteringUser")];    
    dispatch_async(workingQueue, ^{        
        
        CommonNetworkOutput* output = 
                [GroupBuyNetworkRequest bindUserBySNS:SERVER_URL 
                                        userId:userId
                                        snsId:loginId
                                        registerType:loginIdType
                                        appId:appId
                                        nickName:nickName
                                        avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                        accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                                        accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]
                                        province:[[userInfo objectForKey:SNS_PROVINCE] intValue]
                                        city:[[userInfo objectForKey:SNS_CITY] intValue]
                                        location:[userInfo objectForKey:SNS_LOCATION]
                                        gender:[userInfo objectForKey:SNS_GENDER]
                                        birthday:[userInfo objectForKey:SNS_BIRTHDAY]                                      
                                        domain:[userInfo objectForKey:SNS_DOMAIN]];        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                [UserManager bindUserWithUserId:userId
                                        loginId:loginId
                                    loginIdType:loginIdType
                                       nickName:nickName
                                         avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                    accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                              accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]];
                [self updateUserCache];                 // MUST call this!!!
            }
            
            [delegate loginUserResult:output.resultCode];
        });
    });
    
}

- (void)groupBuyRegisterUserWithSNSUserInfo:(NSDictionary*)userInfo 
                             viewController:(PPViewController*)viewController
{
    switch (userCurrentStatus) {
        case USER_STATUS_UNKNOWN:
        case USER_NOT_EXIST_LOCAL:
            [self registerUserWithSNSUserInfo:userInfo viewController:viewController];
            break;
            
        case USER_EXIST_LOCAL_STATUS_LOGIN:            
            // it's strange here, we just treat this as login locally again
            [self bindUserWithSNSUserInfo:userInfo viewController:viewController];
            break;
            
        case USER_EXIST_LOCAL_STATUS_LOGOUT:
            [self bindUserWithSNSUserInfo:userInfo viewController:viewController];            
            break;
            
        default:
            break;
    }
    
}

@end
