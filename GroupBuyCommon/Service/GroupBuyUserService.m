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
        CommonNetworkOutput* output = [GroupBuyNetworkRequest updateUser:SERVER_URL appId:GlobalGetPlaceAppId() userId:user.userId deviceToken:deviceToken];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS) {
            }
            else{
                [UIUtils alert:@"推送通知注册失败"];
            }
        });
        
    });
    
}

@end
