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
        userGender:(NSString*)userGender
            useFor:(int)useFor;

// TODO, refactor by using getAllPostByUseFor/deletePostByUseFor later
+ (NSArray*)getAllNearbyPost:(NSString*)userId;
+ (BOOL)deleteAllNearbyPost;

// TODO, refactor by using getAllPostByUseFor/deletePostByUseFor later
+ (NSArray*)getAllFollowPost:(NSString*)userId;
+ (BOOL)deleteUserFollowPost;

// TODO, refactor by using getAllPostByUseFor/deletePostByUseFor later
+ (NSArray*)getAllAtMePost;
+ (BOOL)deleteAllAtMePost;

+ (NSArray*)getAllPostByUseFor:(int)useFor;
+ (BOOL)deletePostByUseFor:(int)useFor;

+ (void)cleanUpDeleteDataBefore:(int)timeStamp;

@end
