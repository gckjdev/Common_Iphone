//
//  PlaceSNSService.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSServiceHandler.h"
#import "SINAWeiboRequest.h"
#import "QQWeiboRequest.h"

@class PPViewController;

typedef void (^AuthorizationSuccessHandler)(NSDictionary*, PPViewController*);

@interface PlaceSNSService : SNSServiceHandler {
    
    SINAWeiboRequest    *sinaRequest;
    QQWeiboRequest      *qqRequest;
    dispatch_queue_t    workingQueue;

    PPViewController    *displayViewController;
    
    NSString *sinaAppkey;
    NSString *sinaAppSecret;
    NSString *qqAppKey;
    NSString *qqAppSecret;
    NSString *renrenAppKey;
    NSString *renrenAppSecret;
}

@property (nonatomic, retain) SINAWeiboRequest    *sinaRequest;
@property (nonatomic, retain) QQWeiboRequest      *qqRequest;
@property (nonatomic, retain) NSString *sinaAppkey;
@property (nonatomic, retain) NSString *sinaAppSecret;
@property (nonatomic, retain) NSString *qqAppKey;
@property (nonatomic, retain) NSString *qqAppSecret;
@property (nonatomic, retain) NSString *renrenAppKey;
@property (nonatomic, retain) NSString *renrenAppSecret;
//- (BOOL)hasQQCacheData;
//- (BOOL)hasSinaCacheData;

- (void)sinaInitiateLogin:(PPViewController*)viewController;
- (void)qqInitiateLogin:(PPViewController*)viewController;

//- (void)sinaParseAuthorizationResponseURL:(NSString *)query;
//- (void)qqParseAuthorizationResponseURL:(NSString *)query;

- (void)syncWeiboToAllSNS:(NSString*)text viewController:(PPViewController*)viewController;

- (void)setSinaAppKey: (NSString *)key Secret:(NSString *)secret;
- (void)setQQAppKey: (NSString *)key Secret:(NSString *)secret;
- (void)setRenrenAppKey: (NSString *)key Secret:(NSString *)secret;

@end

extern PlaceSNSService*   GlobalGetSNSService();
