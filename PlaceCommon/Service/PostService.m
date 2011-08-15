//
//  PostService.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostService.h"
#import "PPViewController.h"

#import "UserService.h"
#import "PlaceSNSService.h"
#import "LocationService.h"

#import "AppManager.h"
#import "PostManager.h"
#import "Post.h"

#import "CreatePostRequest.h"
#import "ActionOnPostRequest.h"

@implementation PostService

@synthesize postImage;
@synthesize postTextContent;
@synthesize placeName;
@synthesize placeId;

- (id)init
{
    self = [super init];    
    workingQueue = dispatch_queue_create("user service queue", NULL);
    return self;
}

- (void)dealloc
{
    dispatch_release(workingQueue);
    workingQueue = NULL;
    [postTextContent release];
    [postImage release];
    [placeName release];
    [placeId release];
    [super dealloc];
}

- (void)createPost:(int)contentType textContent:(NSString*)textContent
          latitude:(double)latitude longitude:(double)longitude
      userLatitude:(double)userLatitude userLongitude:(double)userLongitude
           syncSNS:(BOOL)syncSNS placeId:(NSString*)placeIdVal
             image:(UIImage*)image
         srcPostId:(NSString*)srcPostIdVal
       replyPostId:(NSString*)replyPostIdVal
         placeName:(NSString*)placeNameVal
    viewController:(PPViewController<PostServiceDelegate>*)viewController

{
    UserService* userService = GlobalGetUserService();
    User* user = [userService user];
    NSString* appId = [AppManager getPlaceAppId];        
            
    [viewController showActivityWithText:NSLS(@"kCreatingPost")];
    dispatch_async(workingQueue, ^{
        
        CreatePostOutput* output = [CreatePostRequest send:SERVER_URL 
                                                    userId:user.userId 
                                                     appId:appId 
                                               contentType:contentType 
                                               textContent:textContent 
                                                  latitude:latitude 
                                                 longitude:longitude 
                                              userLatitude:userLatitude 
                                             userLongitude:userLongitude 
                                                   syncSNS:syncSNS 
                                                   placeId:placeIdVal
                                                     image:image
                                                 srcPostId:srcPostIdVal
                                               replyPostId:replyPostIdVal];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // save post data locally
                [PostManager createPost:output.postId placeId:placeIdVal userId:user.userId textContent:textContent imageURL:output.imageURL contentType:contentType createDate:output.createDate longitude:longitude latitude:latitude userLongitude:userLongitude userLatitude:userLatitude totalView:output.totalView totalForward:output.totalForward totalQuote:output.totalQuote totalReply:output.totalReply totalRelated:0
                           userNickName:user.nickName 
                              placeName:placeNameVal
                              srcPostId:srcPostIdVal
                            replyPostId:replyPostIdVal
                             userAvatar:user.avatar
                             userGender:user.gender
                                 useFor:POST_FOR_PLACE];
                
            }
            else if (output.resultCode == ERROR_NETWORK){
                [UIUtils alert:NSLS(@"kSystemFailure")];
            }
            else{
                [UIUtils alert:NSLS(@"kUnknowFailure")];
                // other error TBD
            }

            if ([viewController respondsToSelector:@selector(createPostFinish:)]){
                [viewController createPostFinish:output.resultCode];
            }
        });        
    });    
    
    if (syncSNS){            
        PlaceSNSService* snsService = GlobalGetSNSService();
        [snsService syncWeiboToAllSNS:textContent viewController:viewController];
    }
    
}


- (void)createPost:(PPViewController<PostServiceDelegate>*)viewController
{
    // get location;
    LocationService *locationService = GlobalGetLocationService();
    double latitude = locationService.currentLocation.coordinate.latitude;
    double longitude = locationService.currentLocation.coordinate.longitude;    
    
    [self createPost:CONTENT_TYPE_TEXT_PHOTO 
         textContent:self.postTextContent 
            latitude:latitude
           longitude:longitude
        userLatitude:latitude
       userLongitude:longitude
             syncSNS:NO
             placeId:placeId
               image:self.postImage
           srcPostId:nil
         replyPostId:nil
           placeName:placeName
      viewController:viewController];
}

- (void)actionOnPost:(NSString*)postId              
          actionName:(NSString*)actionName
             placeId:(NSString*)placeIdValue
      viewController:(PPViewController<PostServiceDelegate>*)viewController
{
    UserService* userService = GlobalGetUserService();
    User* user = [userService user];
    NSString* appId = [AppManager getPlaceAppId];        
    
    // get location;
    LocationService *locationService = GlobalGetLocationService();
    double latitude = locationService.currentLocation.coordinate.latitude;
    double longitude = locationService.currentLocation.coordinate.longitude;    
    
    [viewController showActivity];
    dispatch_async(workingQueue, ^{
        
        ActionOnPostOutput* output = [ActionOnPostRequest send:SERVER_URL 
                                                        userId:[user userId] 
                                                         appId:appId
                                                        postId:postId
                                                    actionType:actionName
                                                     longitude:longitude
                                                      latitude:latitude
                                                       placeId:placeIdValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // update post action value in DB
            }
            else if (output.resultCode == ERROR_NETWORK){
                [viewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else{
                [viewController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
            }
            
            if ([viewController respondsToSelector:@selector(actionOnPostFinish:count:)]){
                long count = [[output.jsonDataDict objectForKey:POST_ACTION_LIKE] longValue];
                [viewController actionOnPostFinish:output.resultCode count:count];
            }
        });        
    });    

}


@end
