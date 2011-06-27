//
//  MessageManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PrivateMessageManager.h"
#import "PrivateMessage.h"
#import "PrivateMessageUser.h"
#import "CoreDataUtil.h"

@implementation PrivateMessageManager

+ (BOOL)createOrUpdateMessageUser:(NSString*)messageUserId 
                           avatar:(NSString*)messageUserAvatar
                         nickName:(NSString*)messageUserNickName
                        messageId:(NSString*)messageId                        
                          content:(NSString*)content                        
                       createDate:(NSDate*)createDate                       
                             type:(int)type
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    BOOL newUser = NO;    
    PrivateMessageUser* user = [PrivateMessageManager getMessageUserById:messageUserId];
    if (user == nil){
        user = [dataManager insert:@"PrivateMessageUser"];
        user.userId = messageUserId;
        newUser = YES;
    }
    
    user.userAvatar = messageUserAvatar;
    user.userNickName = messageUserNickName;
    user.latestMessageContent = content;
    user.latestMessageId = messageId;
    user.latestModifyDate = createDate;    
    
    if (newUser)
        NSLog(@"<createOrUpdateMessageUser> new user=%@", [user description]);
    else
        NSLog(@"<createOrUpdateMessageUser> update user=%@", [user description]);
    
    [dataManager save];
    
    return YES;
}

+ (BOOL)createMessage:(NSString*)messageUserId 
               avatar:(NSString*)messageUserAvatar
             nickName:(NSString*)messageUserNickName
              messageId:(NSString*)messageId
                content:(NSString*)content
             createDate:(NSDate*)createDate
                   type:(int)type

{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    // check if message exist
    if ([PrivateMessageManager getMessageById:messageId]){
        NSLog(@"<createMessage> but messageId(%@) exist", messageId);
        return YES;
    }
    
    [PrivateMessageManager createOrUpdateMessageUser:messageUserId
                                       avatar:messageUserAvatar 
                                     nickName:messageUserNickName
                                   messageId:messageId
                                     content:content
                                  createDate:createDate
                                        type:type];
    
    PrivateMessage* message = [dataManager insert:@"PrivateMessage"];
    message.messageId = messageId;
    message.messageUserId = messageUserId;
    message.createDate = createDate;
    message.content = content;
    message.type = [NSNumber numberWithInt:type];
    
    NSLog(@"<createMessage> message=%@", [message description]);
    
    [dataManager save];    
    return YES;
}

+ (BOOL)createInMessage:(NSString*)messageUserId 
                 avatar:(NSString*)messageUserAvatar
               nickName:(NSString*)messageUserNickName
               messageId:(NSString*)messageId
                 content:(NSString*)content
              createDate:(NSDate*)createDate
{
    return [PrivateMessageManager createMessage:messageUserId
                                  avatar:messageUserAvatar 
                                nickName:messageUserNickName
                               messageId:messageId
                                 content:content
                              createDate:createDate
                                    type:MESSAGE_TYPE_IN];
}

+ (BOOL)createOutMessage:(NSString*)messageUserId 
                  avatar:(NSString*)messageUserAvatar
                nickName:(NSString*)messageUserNickName
               messageId:(NSString*)messageId
                 content:(NSString*)content
              createDate:(NSDate*)createDate
{
    return [PrivateMessageManager createMessage:messageUserId
                                  avatar:messageUserAvatar 
                                nickName:messageUserNickName
                               messageId:messageId
                                 content:content
                              createDate:createDate
                                    type:MESSAGE_TYPE_OUT];
}

+ (NSArray*)getAllMessageUser
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();    
    return [dataManager execute:@"getAllMessageUser" sortBy:@"latestModifyDate" ascending:NO];
}


+ (NSArray*)getAllMessageByUser:(NSString*)messageUserId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();    
    return [dataManager execute:@"getAllMessageByUser" 
                         forKey:@"MESSAGE_USER_ID" 
                          value:messageUserId 
                         sortBy:@"createDate" 
                      ascending:NO];
}


+ (BOOL)deleteMessage:(PrivateMessage*)message
{    
    CoreDataManager* dataManager = GlobalGetCoreDataManager();    
    [dataManager del:message];
    [dataManager save];
    return YES;
}

+ (PrivateMessage*)getMessageById:(NSString*)messageId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();    
    return (PrivateMessage*)[dataManager execute:@"getMessageById" forKey:@"MESSAGE_ID" value:messageId];
}

+ (PrivateMessageUser*)getMessageUserById:(NSString*)messageUserId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();    
    return (PrivateMessageUser*)[dataManager execute:@"getMessageUserById" forKey:@"MESSAGE_USER_ID" value:messageUserId];
}

+ (NSString*)getLatestMessageId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();    
    NSArray* list = [dataManager execute:@"getLatestMessage" 
                         sortBy:@"createDate" 
                      ascending:NO];
    
    if ([list count] > 0){
        return ((PrivateMessage*)[list objectAtIndex:0]).messageId;
    }
    else{
        return nil;
    }
}

@end
