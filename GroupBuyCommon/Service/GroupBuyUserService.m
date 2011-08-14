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

//#import "DeviceLoginRequest.h"

@implementation UserService (GroupBuyUserService)

- (void)registerUserByDevice
{
    dispatch_async(workingQueue, ^{
        CommonNetworkOutput* output = [GroupBuyNetworkRequest registerUserDevice:SERVER_URL appId:GlobalGetPlaceAppId() deviceToken:nil];
        
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
    
    if (userCurrentStatus != USER_EXIST_LOCAL_STATUS_LOGIN){
        dispatch_async(workingQueue, ^{
            CommonNetworkOutput* output = [GroupBuyNetworkRequest deviceLogin:SERVER_URL appId:GlobalGetPlaceAppId() needReturnUser:YES];
            
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
    
    
    if (delegate && [delegate respondsToSelector:@selector(checkDeviceResult:)]){
        [delegate checkDeviceResult:userCurrentStatus];        
    }    
}

@end
