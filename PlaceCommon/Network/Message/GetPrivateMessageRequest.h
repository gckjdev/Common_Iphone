//
//  GetPrivateMessage.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetPrivateMessageInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       afterTimeStamp;
    int             maxCount;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     afterTimeStamp;
@property (nonatomic, assign) int           maxCount;

@end

@interface GetPrivateMessageOutput : CommonOutput
{
    NSArray*        messageArray;
}

@property (nonatomic, retain) NSArray* messageArray;

@end

@interface GetPrivateMessageRequest : NetworkRequest {
	
}

+ (GetPrivateMessageOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId afterTimeStamp:(NSString*)afterTimeStamp;

@end
