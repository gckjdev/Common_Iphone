//
//  SmsStatusQuery.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface SmsStatusQueryInput : NSObject
{
	NSArray*		readSmsIdList;
	NSArray*		deliverSmsIdList;
	NSString*		userId;
	NSString*		appId;
}

@property (nonatomic, retain) NSString*			userId;
@property (nonatomic, retain) NSString*			appId;
@property (nonatomic, retain) NSArray*			readSmsIdList;
@property (nonatomic, retain) NSArray*			deliverSmsIdList;

@end

@interface SmsStatusQueryOutput : CommonOutput
{
	NSDictionary*	smsStatusList;
}

@property (nonatomic, retain) NSDictionary*	smsStatusList;

+ (NSDate*)deliverDateByOutputDict:(NSDictionary*)dict;
+ (NSDate*)readDateByOutputDict:(NSDictionary*)dict;
+ (NSNumber*)statusByOutputDict:(NSDictionary*)dict;
+ (NSNumber*)clientStatusByOutputDict:(NSDictionary*)dict;

@end

@interface SmsStatusQueryRequest : NetworkRequest {
	
}

+ (SmsStatusQueryOutput*)smsStatusQuery:serverURL userId:(NSString*)userId appId:(NSString*)appId readSmsIdList:(NSArray*)readSmsIdList deliverSmsIdList:(NSArray*)deliverSmsIdList;

@end
