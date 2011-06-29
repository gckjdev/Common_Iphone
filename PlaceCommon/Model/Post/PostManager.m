//
//  PostManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import "PostManager.h"
#import "CoreDataUtil.h"
#import "Post.h"

@implementation PostManager

+ (NSArray*)getPostByPlace:(NSString*)placeId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getPostByPlace" forKey:@"placeId" value:placeId sortBy:@"createDate" ascending:NO];
}

+ (BOOL)deletePostByPlace:(NSString*)placeId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    NSArray* postArray = [dataManager execute:@"getPostByPlace" forKey:@"placeId" value:placeId sortBy:@"createDate" ascending:NO];
    
    for (Post* post in postArray){
        post.deleteFlag = [NSNumber numberWithBool:YES];
    }
    
    return [dataManager save];
}

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
            useFor:(int)useFor

{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    Post* post = [dataManager insert:@"Post"];
    post.postId = postId;
    post.placeId = placeId;
    post.userId = userId;
    post.textContent = textContent;
    post.imageURL = imageURL;
    post.contentType = [NSNumber numberWithInt:contentType];
    post.createDate = createDate;
    post.longitude = [NSNumber numberWithDouble:longitude];
    post.latitude = [NSNumber numberWithDouble:latitude];
    post.userLongitude = [NSNumber numberWithDouble:userLongitude];
    post.userLatitude = [NSNumber numberWithDouble:userLatitude];
    post.totalView = [NSNumber numberWithInt:totalView];
    post.totalForward = [NSNumber numberWithInt:totalForward];
    post.totalQuote = [NSNumber numberWithInt:totalQuote];
    post.totalReply = [NSNumber numberWithInt:totalReply];
    post.totalRelated = [NSNumber numberWithInt:totalRelated];
    post.useFor = [NSNumber numberWithInt:useFor];
    post.deleteFlag = [NSNumber numberWithBool:NO];
    post.userNickName = userNickName;
    post.srcPostId = srcPostId;
    post.userAvatar = userAvatar;
    post.replyPostId = replyPostId;
    post.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    post.placeName = placeName;
    post.userGender = userGender;
    
    NSLog(@"<createPost> post=%@", [post description]);
    
    return [dataManager save];
}

+ (NSArray*)getAllFollowPost:(NSString*)userId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getFollowPostByUser" 
                         sortBy:@"createDate" 
                      ascending:NO];
    
}

+ (BOOL)deleteUserFollowPost
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getFollowPostByUser" 
                                        sortBy:@"createDate" 
                                     ascending:NO]; 
    
    for (Post* post in placeArray){
        post.deleteFlag = [NSNumber numberWithBool:YES];
        post.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    }
    
    return [dataManager save];    
}

+ (NSArray*)getAllNearbyPost:(NSString*)userId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getNearbyPost" 
                         sortBy:@"createDate" 
                      ascending:NO];    
}

+ (BOOL)deleteAllNearbyPost
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getNearbyPost" 
                                        sortBy:@"createDate" 
                                     ascending:NO]; 
    
    for (Post* post in placeArray){
        post.deleteFlag = [NSNumber numberWithBool:YES];
        post.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    }
    
    return [dataManager save];     
}

+ (NSArray*)getAllAtMePost
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAtMePost" 
                         sortBy:@"createDate" 
                      ascending:NO];    
}

+ (BOOL)deleteAllAtMePost
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getAtMePost" 
                                        sortBy:@"createDate" 
                                     ascending:NO]; 
    
    for (Post* post in placeArray){
        post.deleteFlag = [NSNumber numberWithBool:YES];
        post.deleteTimeStamp = [NSNumber numberWithInt:time(0)];
    }
    
    return [dataManager save]; 
}


+ (void)cleanUpDeleteDataBefore:(int)timeStamp
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* dataArray = [dataManager execute:@"getAllPostsForDelete" 
                                        forKey:@"beforeTimeStamp" 
                                         value:[NSNumber numberWithInt:timeStamp]
                                        sortBy:@"createDate"
                                     ascending:NO];

    for (Post* post in dataArray){
        [dataManager del:post];
    }
    
    [dataManager save];     

}

@end
