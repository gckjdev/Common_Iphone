//
//  PostManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PostManager : NSObject {
    
}

+ (NSArray*)getPostByPlace:(NSString*)placeId;
+ (BOOL)deletePostByPlace:(NSString*)placeId;
+ (BOOL)createPost:(NSString*)postId placeId:(NSString*)placeId userId:(NSString*)userId
       textContent:(NSString*)textContent imageURL:(NSString*)imageURL 
       contentType:(int)contentType createDate:(NSDate*)createDate
         longitude:(double)longitude latitude:(double)latitude
     userLongitude:(double)userLongitude userLatitude:(double)userLatitude
         totalView:(int)totalView totalForward:(int)totalForward
        totalQuote:(int)totalQuote totalReply:(int)totalReply
      totalRelated:(int)totalRelated
      userNickName:(NSString*)userNickName
         placeName:(NSString*)placeName
         srcPostId:(NSString*)srcPostId
       replyPostId:(NSString*)replyPostId
         userAvatar:(NSString*)userAvatar
            useFor:(int)useFor;


+ (NSArray*)getAllNearbyPost:(NSString*)userId;
+ (BOOL)deleteAllNearbyPost;


+ (NSArray*)getAllFollowPost:(NSString*)userId;
+ (BOOL)deleteUserFollowPost;


+ (NSArray*)getAllAtMePost;
+ (BOOL)deleteAllAtMePost;


+ (void)cleanUpDeleteDataBefore:(int)timeStamp;

@end
