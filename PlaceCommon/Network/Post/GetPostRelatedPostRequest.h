//
//  GetPostRelatedPost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetPostRelatedPostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       postId;
    NSString*       excludePostId;
    NSString*       beforeTimeStamp;
    int             maxCount;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     postId;
@property (nonatomic, retain) NSString*     excludePostId;
@property (nonatomic, retain) NSString*     beforeTimeStamp;
@property (nonatomic, assign) int           maxCount;

@end

@interface GetPostRelatedPostOutput : CommonOutput
{
    NSArray*        postArray;
}

@property (nonatomic, retain) NSArray* postArray;

@end 

@interface GetPostRelatedPostRequest : NetworkRequest {
	
}

+ (GetPostRelatedPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId postId:(NSString*)postId excludePostId:(NSString*)excludePostId beforeTimeStamp:(NSString*)beforeTimeStamp;

+ (void)test;

@end
