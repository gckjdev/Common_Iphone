//
//  CommonSNSRequest.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthCore.h"
#import "SNSConstants.h"
#import "SNSWebViewController.h"

@protocol CommonSNSProtocol <NSObject>

- (NSURL*)getOAuthTokenAndSecretURL;
- (BOOL)parseRequestTokenURLResult:(NSString*)resultData;
- (NSURL*)getAuthorizeURL;

- (NSString*)getAuthorizeURLMain;
- (NSString*)getRequestTokenURLMain;
- (NSString*)getAccessTokenURLMain;
- (NSString*)getUserInfoURLMain;

- (NSURL*)getSendTextURL;
- (NSString*)getSendTextBody:(NSString*)text;

- (NSMutableDictionary*)parseUserInfo:(NSDictionary*)origUserInfo;

@end

@interface CommonSNSRequest : NSObject <CommonSNSProtocol> {

    NSString*   callbackURL;
    NSString*   appKey;
    NSString*   appSecret;
    NSString*   oauthToken;
    NSString*   oauthTokenSecret;
    
    NSMutableDictionary* userInfoCache;
}

@property (nonatomic, retain) NSString*   callbackURL;
@property (nonatomic, retain) NSString*   appKey;
@property (nonatomic, retain) NSString*   appSecret;
@property (nonatomic, retain) NSString*   oauthToken;
@property (nonatomic, retain) NSString*   oauthTokenSecret;
@property (nonatomic, retain) NSMutableDictionary* userInfoCache;

- (id)initWithAppKey:(NSString*)key
           appSecret:(NSString*)secret
         callbackURL:(NSString*)callbackURL
          oauthToken:token
    oauthTokenSecret:tokenSecret;

- (void)safeSetKeyFrom:(NSDictionary*)fromDict toDict:(NSMutableDictionary*)toDict fromKey:(NSString*)fromKey toKey:(NSString*)toKey;

- (BOOL)hasUserInfoCache;

@end
