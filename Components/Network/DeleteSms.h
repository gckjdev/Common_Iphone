//
//  DeleteSms.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface DeleteSmsInput : NSObject
{
	NSString*		userId;
	NSString*		appId;
	NSString*		smsId;
}

@property (nonatomic, retain) NSString*			userId;
@property (nonatomic, retain) NSString*			appId;
@property (nonatomic, retain) NSString*			smsId;

@end

@interface DeleteSmsOutput : CommonOutput
{
}

@end

@interface DeleteSmsRequest : NetworkRequest {
	
}

+ (DeleteSmsOutput*)DeleteSms:serverURL userId:(NSString*)userId appId:(NSString*)appId smsId:(NSString*)smsId;

@end
