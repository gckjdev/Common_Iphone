//
//  GroupBuyUserService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserService.h"

@protocol GroupBuyUserServiceDelegate <NSObject>

@optional

- (void)actionDone:(int)result;

@end

@interface UserService (GroupBuyUserService) 

- (void)groupBuyCheckDevice;

- (void)updateGroupBuyUserDeviceToken:(NSString*)deviceToken;

- (void)registerUser:(NSString*)email 
            password:(NSString*)password 
      viewController:(PPViewController*)viewController;


- (void)loginUserWithEmail:(NSString*)email 
                  password:(NSString*)password 
            viewController:(PPViewController<GroupBuyUserServiceDelegate>*)viewController;


- (void)groupBuyRegisterUserWithSNSUserInfo:(NSDictionary*)userInfo 
                             viewController:(PPViewController<GroupBuyUserServiceDelegate>*)viewController;

@end
