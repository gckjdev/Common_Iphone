//
//  Message.h
//  Three20
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

enum {
    MESSAGE_TYPE_IN,
    MESSAGE_TYPE_OUT
};

@interface PrivateMessage : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * messageUserId;

@end
