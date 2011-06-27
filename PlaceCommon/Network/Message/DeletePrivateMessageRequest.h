//
//  DeletePrivateMessage.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface DeletePrivateMessageInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       messageId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     messageId;

@end

@interface DeletePrivateMessageOutput : CommonOutput
{
}

@end

@interface DeletePrivateMessageRequest : NetworkRequest {
	
}

+ (DeletePrivateMessageOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId messageId:(NSString*)messageId;

@end
