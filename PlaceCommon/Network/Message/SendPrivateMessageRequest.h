//
//  SendPrivateMessage.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface SendPrivateMessageInput : NSObject
{
    NSString*		userId;
    NSString*       toUserId;
	NSString*		appId;
    int             contentType;
    NSString*       textContent;
    double          latitude;
    double          longitude;
    BOOL            syncSNS;
    UIImage*        image;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     toUserId;
@property (nonatomic, assign) int           contentType;
@property (nonatomic, retain) NSString*     textContent;
@property (nonatomic, assign) double        latitude;
@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) BOOL          syncSNS;
@property (nonatomic, retain) NSString*		appId;
@property (nonatomic, retain) UIImage*      image;

@end

@interface SendPrivateMessageOutput : CommonOutput
{
	NSString	*messageId;
	NSString	*imageURL;
    NSDate      *createDate;
    NSString    *avatar;
    NSString    *nickName;
}

@property (nonatomic, retain) NSString	  *messageId;
@property (nonatomic, retain) NSString	  *imageURL;
@property (nonatomic, retain) NSDate      *createDate;
@property (nonatomic, retain) NSString    *avatar;
@property (nonatomic, retain) NSString    *nickName;

@end

@interface SendPrivateMessageRequest : NetworkRequest {
	
}

+ (SendPrivateMessageOutput*)send:(NSString*)serverURL 
                       fromUserId:(NSString*)fromUserId
                         toUserId:(NSString*)toUserId
                            appId:(NSString*)appId 
                      contentType:(int)contentType 
                      textContent:(NSString*)textContent
                         latitude:(double)latitude 
                        longitude:(double)longitude
                          syncSNS:(BOOL)syncSNS
                            image:(UIImage*)image;

+ (SendPrivateMessageOutput*)send:(NSString*)serverURL 
                       fromUserId:(NSString*)fromUserId
                         toUserId:(NSString*)toUserId
                            appId:(NSString*)appId 
                      textContent:(NSString*)textContent;


@end
