//
//  MessageService.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageService.h"
#import "PPViewController.h"
#import "SendPrivateMessageRequest.h"
#import "UserService.h"
#import "AppManager.h"
#import "PrivateMessageManager.h"
#import "PrivateMessage.h"
#import "GetPrivateMessageRequest.h"
#import "DeletePrivateMessageRequest.h"
#import "ResultUtils.h"

@implementation MessageService

- (id)init
{
    self = [super init];    
    workingQueue = dispatch_queue_create("Message Service Queue", NULL);    
    return self;
}

- (void)dealloc
{
    
    dispatch_release(workingQueue);
    workingQueue = NULL;
    
    [super dealloc];
}

- (void)sendMessage:(PPViewController*)viewController
           toUserId:(NSString*)toUserId 
        textContent:(NSString*)textContent
{
    UserService* userService = GlobalGetUserService();
    NSString *userId = [userService userId];
    NSString *appId = [AppManager getPlaceAppId];
    
    [viewController showActivityWithText:NSLS(@"kSendingMessage")];
    dispatch_async(workingQueue, ^{
        SendPrivateMessageOutput* output = [SendPrivateMessageRequest send:SERVER_URL
                                                                fromUserId:userId
                                                                  toUserId:toUserId
                                                                     appId:appId 
                                                               textContent:textContent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // save data locally
                [PrivateMessageManager createOutMessage:toUserId 
                                                 avatar:output.avatar  
                                               nickName:output.nickName 
                                              messageId:output.messageId 
                                                content:textContent 
                                             createDate:output.createDate];
                
                // return to prev window
                [viewController.navigationController popViewControllerAnimated:YES];
            }
            else if (output.resultCode == ERROR_NETWORK){
                [UIUtils alert:NSLS(@"kSystemFailure")];
            }
            else{
                [UIUtils alert:NSLS(@"kUnknowFailure")];
                // other error TBD
            }
        });        

    });
}

- (void)downloadNewMessage:(PPViewController<MessageServiceDelegate>*)viewController
{
    UserService* userService = GlobalGetUserService();
    NSString *userId = [userService userId];
    NSString *appId = [AppManager getPlaceAppId];
    NSString *latestMessageId = [PrivateMessageManager getLatestMessageId];
    
//    [viewController showActivityWithText:NSLS(@"kSendingMessage")];
    dispatch_async(workingQueue, ^{
        GetPrivateMessageOutput* output = [GetPrivateMessageRequest send:SERVER_URL userId:userId appId:appId afterTimeStamp:latestMessageId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){                               
                
                // save to DB
                for (NSDictionary* message in output.messageArray){
                    
                    int type = MESSAGE_TYPE_IN;
                    
                    NSString* from = [ResultUtils fromUserId:message];
                    NSString* to = [ResultUtils toUserId:message];
                    NSString* content = [ResultUtils textContent:message];
                    NSString* avatar = [ResultUtils userAvatar:message];
                    NSString* nickName = [ResultUtils nickName:message];
                    NSString* messageId = [ResultUtils messageId:message];
                    NSDate* createDate = [ResultUtils createDate:message];
                    
                    if ([from isEqualToString:userId]){
                        type = MESSAGE_TYPE_OUT;
                        [PrivateMessageManager createOutMessage:to avatar:avatar nickName:nickName messageId:messageId content:content createDate:createDate];
                    }
                    else if ([to isEqualToString:userId]){
                        type = MESSAGE_TYPE_IN;
                        [PrivateMessageManager createInMessage:from avatar:avatar nickName:nickName messageId:messageId content:content createDate:createDate];
                    }
                    
                    
                    
                }
                
            }
            else if (output.resultCode == ERROR_NETWORK){
                [UIUtils alert:NSLS(@"kSystemFailure")];
            }
            else{
                [UIUtils alert:NSLS(@"kUnknowFailure")];
                // other error TBD
            }
            
            if ([viewController respondsToSelector:@selector(downloadMessageFinish:)]){
                [viewController downloadMessageFinish:output.resultCode];
            }
        });        
        
    });

}

- (void)deleteMessage:(PrivateMessage*)message
       viewController:(PPViewController<MessageServiceDelegate>*)viewController
{
    UserService* userService = GlobalGetUserService();
    NSString *userId = [userService userId];
    NSString *appId = [AppManager getPlaceAppId];
    
    [viewController showActivityWithText:NSLS(@"kDeletingMessage")];
    dispatch_async(workingQueue, ^{
        DeletePrivateMessageOutput* output = [DeletePrivateMessageRequest send:SERVER_URL userId:userId appId:appId messageId:message.messageId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){                                               
                // remove from DB                
                [PrivateMessageManager deleteMessage:message];
            }
            else if (output.resultCode == ERROR_NETWORK){
                [UIUtils alert:NSLS(@"kSystemFailure")];
            }
            else{
                [UIUtils alert:NSLS(@"kUnknowFailure")];
                // other error TBD
            }
            
            if ([viewController respondsToSelector:@selector(deleteMessageFinish:)]){
                [viewController deleteMessageFinish:output.resultCode];
            }
        });        
        
    });
    

}

@end
