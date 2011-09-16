//
//  QQWeiboRequest.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "QQWeiboRequest.h"
#import "OAuthCore.h"

@implementation QQWeiboRequest

- (NSString*)getAuthorizeURLMain
{
    return QQ_AUTHORIZE_URL;
}

- (NSString*)getRequestTokenURLMain
{
    return QQ_REQUEST_TOKEN_URL;        
}

- (NSString*)getAccessTokenURLMain
{
    return QQ_ACCESS_TOKEN_URL;        
}

- (NSString*)getUserInfoURLMain
{
    return QQ_USER_INFO_URL;            
}


- (NSMutableDictionary*)parseUserInfo:(NSDictionary*)allUserInfo
{
    NSDictionary* origUserInfo = [allUserInfo objectForKey:@"data"];
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
    
    if ([[retDict allKeys] count] == 0)
        return nil;
    
    [retDict setObject:SNS_QQ_WEIBO forKey:SNS_NETWORK];
    
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"name" toKey:SNS_USER_ID];    
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"nick" toKey:SNS_NICK_NAME];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"province_code" toKey:SNS_PROVINCE];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"city_code" toKey:SNS_CITY];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"location" toKey:SNS_LOCATION];
    [self safeSetKeyFrom:origUserInfo toDict:retDict fromKey:@"name" toKey:SNS_DOMAIN];

    NSString *gender = [origUserInfo objectForKey:@"sex"];
    if (gender){
        NSString* genderValue = ([gender intValue] == 1) ? @"m" : @"f";
        [retDict setObject:genderValue forKey:SNS_GENDER];
    }
            
    int day = [[origUserInfo objectForKey:@"birth_day"] intValue];
    int month = [[origUserInfo objectForKey:@"birth_month"] intValue];
    int year = [[origUserInfo objectForKey:@"birth_year"] intValue];
    if (year && month && day){
        NSString *birthday = [NSString stringWithFormat:@"%d-%02d-%02d", year, month, day];
        [retDict setObject:birthday forKey:SNS_BIRTHDAY];
    }

    NSString *avatar = [origUserInfo objectForKey:@"head"];
    if (avatar && [avatar length] > 0){
        avatar = [NSString stringWithFormat:@"%@/%d", avatar, 100];
        [retDict setObject:avatar forKey:SNS_USER_IMAGE_URL];
    }
    
    return retDict;
}


- (NSURL*)getSendTextURL
{
    return [NSURL URLWithString:QQ_CREATE_WEIBO_URL];
}

- (NSString*)getSendTextBody:(NSString*)text
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:text forKey:@"content"];
    [dict setObject:@"json" forKey:@"format"];
    NSString *body = [OAuthCore queryStringWithUrl:[NSURL URLWithString:QQ_CREATE_WEIBO_URL]
                                            method:@"POST"
                                        parameters:dict
                                       consumerKey:[self appKey]
                                    consumerSecret:[self appSecret]
                                             token:[self oauthToken]
                                       tokenSecret:[self oauthTokenSecret]];
    
    return body;
}

@end
