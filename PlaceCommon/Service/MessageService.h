//
//  MessageService.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPViewController;
@class PrivateMessage;

@protocol MessageServiceDelegate <NSObject>

- (void)downloadMessageFinish:(int)result;

@optional
- (void)deleteMessageFinish:(int)result;

@end

@interface MessageService : NSObject {
    dispatch_queue_t    workingQueue;
}

- (void)sendMessage:(PPViewController*)viewController
           toUserId:(NSString*)toUserId 
        textContent:(NSString*)textContent;

- (void)downloadNewMessage:(PPViewController<MessageServiceDelegate>*)viewController;

- (void)deleteMessage:(PrivateMessage*)message
       viewController:(PPViewController<MessageServiceDelegate>*)viewController;
@end

extern MessageService*   GlobalGetMessageService();