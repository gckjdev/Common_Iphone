//
//  PostService.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPViewController;

@protocol PostServiceDelegate <NSObject>

- (void)createPostFinish:(int)result;

@end

@interface PostService : NSObject {
    dispatch_queue_t  workingQueue;

    NSString          *postTextContent;
    UIImage           *postImage;
    NSString          *placeName;
    NSString          *placeId;
}

@property (nonatomic, retain) NSString     *postTextContent;
@property (nonatomic, retain) UIImage      *postImage;
@property (nonatomic, retain) NSString          *placeName;
@property (nonatomic, retain) NSString          *placeId;

- (void)createPost:(PPViewController<PostServiceDelegate>*)viewController;
- (void)createPost:(int)contentType textContent:(NSString*)textContent
          latitude:(double)latitude longitude:(double)longitude
      userLatitude:(double)userLatitude userLongitude:(double)userLongitude
           syncSNS:(BOOL)syncSNS placeId:(NSString*)placeId
             image:(UIImage*)image
         srcPostId:(NSString*)srcPostIdVal
       replyPostId:(NSString*)replyPostIdVal
         placeName:(NSString*)placeName
    viewController:(PPViewController<PostServiceDelegate>*)viewController;

@end

extern PostService* GlobalGetPostService();