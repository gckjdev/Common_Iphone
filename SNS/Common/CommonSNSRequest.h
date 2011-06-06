//
//  CommonSNSRequest.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthCore.h"

@protocol CommonSNSProtocol <NSObject>

- (NSURL*)getOAuthTokenAndSecretURL;
- (BOOL)parseRequestTokenURLResult:(NSString*)resultData;
- (NSURL*)getAuthorizeURL;

- (NSString*)getAuthorizeURLMain;
- (NSString*)getRequestTokenURLMain;


@end

@interface CommonSNSRequest : NSObject <CommonSNSProtocol> {

    NSString*   callbackURL;
    NSString*   appKey;
    NSString*   appSecret;
    NSString*   oauthToken;
    NSString*   oauthTokenSecret;
}

@property (nonatomic, retain) NSString*   callbackURL;
@property (nonatomic, retain) NSString*   appKey;
@property (nonatomic, retain) NSString*   appSecret;
@property (nonatomic, retain) NSString*   oauthToken;
@property (nonatomic, retain) NSString*   oauthTokenSecret;

- (id)initWithAppKey:(NSString*)key
           appSecret:(NSString*)secret
         callbackURL:(NSString*)callbackURL
          oauthToken:token
    oauthTokenSecret:tokenSecret;



@end
