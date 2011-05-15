//
//  SmsService.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-13.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendSms.h"

@interface SmsService : NSObject {

}

+ (SendSmsOutput*)sendSimpleSms:(NSString*)from to:(NSString*)to text:(NSString*)text appId:(NSString*)appId;

@end
