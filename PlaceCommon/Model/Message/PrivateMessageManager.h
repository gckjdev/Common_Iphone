//
//  MessageManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PrivateMessage;
@class PrivateMessageUser;

@interface PrivateMessageManager : NSObject {
    
}

+ (BOOL)createInMessage:(NSString*)messageUserId 
                 avatar:(NSString*)messageUserAvatar
               nickName:(NSString*)messageUserNickName
              messageId:(NSString*)messageId
                content:(NSString*)content
             createDate:(NSDate*)createDate;

+ (BOOL)createOutMessage:(NSString*)messageUserId 
                  avatar:(NSString*)messageUserAvatar
                nickName:(NSString*)messageUserNickName
               messageId:(NSString*)messageId
                 content:(NSString*)content
              createDate:(NSDate*)createDate;

+ (NSArray*)getAllMessageUser;

+ (NSArray*)getAllMessageByUser:(NSString*)messageUserId;

+ (BOOL)deleteMessage:(PrivateMessage*)message;

+ (PrivateMessage*)getMessageById:(NSString*)messageId;

+ (PrivateMessageUser*)getMessageUserById:(NSString*)messageUserId;

+ (NSString*)getLatestMessageId;

@end
