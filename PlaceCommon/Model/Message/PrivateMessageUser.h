//
//  MessageUser.h
//  Three20
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PrivateMessageUser : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSDate * latestModifyDate;
@property (nonatomic, retain) NSString * latestMessageContent;
@property (nonatomic, retain) NSString * latestMessageId;
@property (nonatomic, retain) NSString * userAvatar;
@property (nonatomic, retain) NSString * userNickName;

@end
