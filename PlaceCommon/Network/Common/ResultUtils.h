//
//  ResultUtils.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResultUtils : NSObject {
    
}

+ (NSString*)postId:(NSDictionary*)post;
+ (NSString*)userId:(NSDictionary*)post;
+ (double)longitude:(NSDictionary*)post;
+ (double)latitude:(NSDictionary*)post;
+ (double)userLongitude:(NSDictionary*)post;
+ (double)userLatitude:(NSDictionary*)post;
+ (NSString*)textContent:(NSDictionary*)post;
+ (NSString*)imageURL:(NSDictionary*)post;
+ (int)contentType:(NSDictionary*)post;
+ (NSDate*)createDate:(NSDictionary*)post;
+ (int)totalView:(NSDictionary*)post;
+ (int)totalForward:(NSDictionary*)post;
+ (int)totalQuote:(NSDictionary*)post;
+ (int)totalReply:(NSDictionary*)post;
+ (int)totalRelated:(NSDictionary*)post;
+ (NSString*)placeId:(NSDictionary*)post;
+ (NSString*)nickName:(NSDictionary*)post;
+ (NSString*)srcPostId:(NSDictionary*)post;
+ (NSString*)replyPostId:(NSDictionary*)post;
+ (NSString*)userAvatar:(NSDictionary*)post;
+ (NSString*)placeName:(NSDictionary*)post;
+ (NSString*)gender:(NSDictionary*)post;

+ (NSString*)name:(NSDictionary*)place;
+ (NSString*)description:(NSDictionary*)place;
+ (NSString*)createUserId:(NSDictionary*)place;

+ (NSString*)messageId:(NSDictionary*)msg;
+ (NSString*)toUserId:(NSDictionary*)msg;
+ (NSString*)fromUserId:(NSDictionary*)msg;


@end
