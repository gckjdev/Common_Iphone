//
//  SINAWeiboRequest.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SINAWeiboRequest.h"
#import "OAuthCore.h"

@implementation SINAWeiboRequest

- (id)init:(NSString*)callbackURLValue
{
    self = [super init];
    self.callbackURL = callbackURLValue;
    return self;
}

- (NSString*)getAuthorizeURLMain
{
    return SINA_AUTHORIZE_URL;
}

- (NSString*)getRequestTokenURLMain
{
    return SINA_REQUEST_TOKEN_URL;        
}

- (NSString*)getAccessTokenURLMain
{
    return SINA_ACCESS_TOKEN_URL;        
}

- (NSString*)getUserInfoURLMain
{
    return SINA_USER_INFO_URL;            
}

- (NSMutableDictionary*)parseUserInfo:(NSDictionary*)origUserInfo
{
    NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
        
    [retDict setObject:SNS_SINA_WEIBO forKey:SNS_NETWORK];
    
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"id" toKey:SNS_USER_ID];    
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"screen_name" toKey:SNS_NICK_NAME];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"domain" toKey:SNS_DOMAIN];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"gender" toKey:SNS_GENDER];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"province" toKey:SNS_PROVINCE];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"city" toKey:SNS_CITY];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"location" toKey:SNS_LOCATION];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"profile_image_url" toKey:SNS_USER_IMAGE_URL];
    
    return retDict;
}

- (NSURL*)getSendTextURL
{
    return [NSURL URLWithString:SINA_CREATE_WEIBO_URL];
}

- (NSString*)getSendTextBody:(NSString*)text
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:text forKey:@"status"];
    NSString *body = [OAuthCore queryStringWithUrl:[NSURL URLWithString:SINA_CREATE_WEIBO_URL]
                                                   method:@"POST"
                                               parameters:dict
                                              consumerKey:[self appKey]
                                           consumerSecret:[self appSecret]
                                                    token:[self oauthToken]
                                              tokenSecret:[self oauthTokenSecret]];
    
    return body;
}

@end
