//
//  GroupBuyUserService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserService.h"

@interface UserService (GroupBuyUserService) 

- (void)groupBuyCheckDevice;
- (void)updateGroupBuyUserDeviceToken:(NSString*)deviceToken;

@end
