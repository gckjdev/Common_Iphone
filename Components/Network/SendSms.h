//
//  SendSms.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-16.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface SendSmsInput : NSObject
{
	NSString*		userId;
	NSString*		receiverUserId;
	NSString*		text;
	NSDate*			sendDate;
	BOOL			isSecure;
	BOOL			isSendLocation;
	double			latitude;
	double			longtitude;
	NSString*		appId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*		receiverUserId;
@property (nonatomic, retain) NSString*		text;
@property (nonatomic, retain) NSDate*		sendDate;
@property (nonatomic, assign) BOOL			isSecure;
@property (nonatomic, assign) BOOL			isSendLocation;
@property (nonatomic, assign) double		latitude;
@property (nonatomic, assign) double		longtitude;
@property (nonatomic, retain) NSString*		appId;

- (NSString*)createUrlString:(NSString*)baseURL;

@end

@interface SendSmsOutput : CommonOutput
{
	NSString*		messsageId;
}

@property (nonatomic, retain) NSString*		messsageId;

@end

@interface SendSmsRequest : NetworkRequest {
	
}

@end

