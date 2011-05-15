//
//  GetNewSms.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetNewSmsInput : NSObject
{
	NSString*		userId;
	NSString*		appId;
}

@property (nonatomic, retain) NSString*			userId;
@property (nonatomic, retain) NSString*			appId;

@end

@interface GetNewSmsOutput : CommonOutput
{
	NSArray*		smsIdList;
}

@property (nonatomic, retain) NSArray*		smsIdList;

@end

@interface GetNewSmsRequest : NetworkRequest {
	
}

+ (GetNewSmsOutput*)GetNewSms:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId;

@end
