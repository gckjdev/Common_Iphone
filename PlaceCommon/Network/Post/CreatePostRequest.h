//
//  CreatePost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface CreatePostInput : NSObject
{
    NSString*		userId;
    int             contentType;
    NSString*       textContent;
    double          latitude;
    double          longitude;
    double          userLatitude;
    double          userLongitude;
    BOOL            syncSNS;
    NSString*       placeId;        
	NSString*		appId;
    NSString*       srcPostId;
    NSString*       replyPostId;
    UIImage*        image;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, assign) int           contentType;
@property (nonatomic, retain) NSString*     textContent;
@property (nonatomic, assign) double        latitude;
@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) double        userLatitude;
@property (nonatomic, assign) double        userLongitude;
@property (nonatomic, assign) BOOL          syncSNS;
@property (nonatomic, retain) NSString*     placeId;        
@property (nonatomic, retain) NSString*		appId;
@property (nonatomic, retain) NSString*     srcPostId;
@property (nonatomic, retain) NSString*     replyPostId;
@property (nonatomic, retain) UIImage*      image;

@end

@interface CreatePostOutput : CommonOutput
{
	NSString	*postId;
	NSString	*imageURL;
    int         totalView;
    int         totalReply;
    int         totalQuote;
    int         totalForward;
    NSDate      *createDate;
}

@property (nonatomic, retain) NSString	  *postId;
@property (nonatomic, retain) NSString	  *imageURL;
@property (nonatomic, assign) int         totalView;
@property (nonatomic, assign) int         totalReply;
@property (nonatomic, assign) int         totalQuote;
@property (nonatomic, assign) int         totalForward;
@property (nonatomic, retain) NSDate      *createDate;

@end

@interface CreatePostRequest : NetworkRequest {
	
}

+ (CreatePostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId 
              contentType:(int)contentType textContent:(NSString*)textContent
                 latitude:(double)latitude longitude:(double)longitude
                 userLatitude:(double)userLatitude userLongitude:(double)userLongitude
                  syncSNS:(BOOL)syncSNS placeId:(NSString*)placeId
                    image:(UIImage*)image
                srcPostId:(NSString*)srcPostId
              replyPostId:(NSString*)replyPostId;

+ (void)test;

@end
