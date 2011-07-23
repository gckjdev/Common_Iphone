//
//  NetworkRequest.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "StringUtil.h"
#import "NetworkRequestResultCode.h"
#import "NetworkRequestParameter.h"
#import "VariableConstants.h"

#define kEncryptKey		@"kEncryptKey"
#define RET_DATA		@"dat"

// result= ret: msg: data:

@interface NetworkRequest : NSObject
{
	NSString*	serverURL;
}

@property (nonatomic, retain) NSString*	serverURL;

// create the Network Request object
+ (NetworkRequest*)requestWithURL:(NSString*)urlString;

- (BOOL)sendRequest:(NSObject*)input output:(NSObject*)output;
- (BOOL)sendPostRequest:(NSObject*)input output:(NSObject*)output postData:(NSData*)postData;

- (NSString*)getBaseUrlString;

+ (NSString*)appendTimeStampAndMacToURL:(NSString*)url;

// virtual method for sub class
- (NSString*)getRequestUrlString:(NSObject*)requestObj;

// virtual method for sub class
- (BOOL)parseToReponse:(NSData*)data output:(NSObject*)output;

@end

#pragma mark CommonOutput

@interface CommonOutput : NSObject
{
	int             resultCode;
	NSString*       resultMessage;
    
    NSArray*        jsonDataArray;
    NSDictionary*   jsonDataDict;
}

@property (nonatomic, assign) int			resultCode;
@property (nonatomic, retain) NSString*		resultMessage;
@property (nonatomic, retain) NSArray*        jsonDataArray;
@property (nonatomic, retain) NSDictionary*   jsonDataDict;

- (void)resultFromJSON:(NSString*)jsonString;
- (NSDictionary*)dictionaryDataFromJSON:(NSString*)jsonString;
- (NSArray*)arrayFromJSON:(NSString*)jsonString;

@end

