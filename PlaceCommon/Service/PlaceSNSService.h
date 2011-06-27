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
}

@property (nonatomic, retain) SINAWeiboRequest    *sinaRequest;
@property (nonatomic, retain) QQWeiboRequest      *qqRequest;

- (BOOL)hasQQCacheData;
- (BOOL)hasSinaCacheData;

- (void)sinaInitiateLogin:(PPViewController*)viewController;
- (void)qqInitiateLogin:(PPViewController*)viewController;

- (void)sinaParseAuthorizationResponseURL:(NSString *)query;
- (void)qqParseAuthorizationResponseURL:(NSString *)query;

- (void)syncWeiboToAllSNS:(NSString*)text viewController:(PPViewController*)viewController;

@end

extern PlaceSNSService*   GlobalGetSNSService();
