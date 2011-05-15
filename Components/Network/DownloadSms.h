//
//  DownloadSms.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface DownloadSmsInput : NSObject
{
	NSString*		smsId;
	NSString*		userId;
	NSString*		appId;
}

@property (nonatomic, retain) NSString*		smsId;
@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*		appId;

@end

@interface DownloadSmsOutput : CommonOutput
{
	NSDate*	deliverDate;
	NSDate* readDate;
	NSString* smsId;	
	BOOL hasLocation;
	NSString * from;
	NSString * to;
	double latitude;
	int clientStatus;
	NSDate * submitDate;
	BOOL isSecure;
	int deliverErrorCode;
	double longtitude;
	NSString * smsText;
	int smsType;
	int status;	
}

@property (nonatomic, retain) NSDate * deliverDate;
@property (nonatomic, retain) NSDate * readDate;
@property (nonatomic, retain) NSString * smsId;
@property (nonatomic, assign) BOOL hasLocation;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) int clientStatus;
@property (nonatomic, retain) NSDate * submitDate;
@property (nonatomic, assign) BOOL isSecure;
@property (nonatomic, assign) int deliverErrorCode;
@property (nonatomic, assign) double longtitude;
@property (nonatomic, retain) NSString * smsText;
@property (nonatomic, assign) int smsType;
@property (nonatomic, assign) int status;

@end

@interface DownloadSmsRequest : NetworkRequest {
	
}

@end
