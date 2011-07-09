//
//  SNSServiceHandler.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SNSServiceHandler.h"
#import "CommonSNSRequest.h"
#import "StringUtil.h"
#import "OAuthCore.h"
#import "NetworkUtil.h"
#import "JSON.h"

@implementation SNSServiceHandler


- (BOOL)sendRequestToken:(CommonSNSRequest*)snsRequest
{
    __block BOOL result = YES;

    NSURL* url = [snsRequest getOAuthTokenAndSecretURL];    
    if (url == nil){
        NSLog(@"<sendRequestToken> but URL is nil");
        return NO;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NetworkUtil sendRequest:request respnoseHandlerBlock:^(NSString* responseText){
        if ([snsRequest parseRequestTokenURLResult:responseText]){
            NSLog(@"<sendRequestToken> parse token URL response OK, oauth_token=%@, oauth_secret=%@",
                  snsRequest.oauthToken, snsRequest.oauthTokenSecret);
        }
        else{
            NSLog(@"<sendRequestToken> fail to parse token URL response, text=%@", responseText);                
            result = NO;
        }        
    }];
        
    return result;
}

- (BOOL)gotoToAuthorizeURL:(CommonSNSRequest*)snsRequest
{
    __block BOOL result = YES;
    
    NSURL* url = [snsRequest getAuthorizeURL];
    if (url == nil){
        NSLog(@"<gotoToAuthorizeURL> but URL is nil");
        return NO;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        result = [[UIApplication sharedApplication] openURL:url];
    });

    return result;
}

- (BOOL)loginForAuthorization:(CommonSNSRequest*)snsRequest
{
    BOOL result = YES;
    
    result = [self sendRequestToken:snsRequest];
    if (result == NO)
        return result;
    
    result = [self gotoToAuthorizeURL:snsRequest];  
    return result;
}

// handle the reponse redirection URL from WEIBO service
- (BOOL)parseAuthorizationResponseURL:(NSString*)responseURL snsRequest:(CommonSNSRequest*)snsRequest
{
    NSMutableDictionary *dict = [responseURL URLQueryStringToDictionary];
    if (dict == nil)
        return NO;
    
    [dict removeObjectForKey:@"oauth_token"]; // remove to avoid duplicate???      
    NSURL* url = [NSURL URLWithString:[snsRequest getAccessTokenURLMain]];
    NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                   method:@"POST"
                                               parameters:dict
                                              consumerKey:snsRequest.appKey
                                           consumerSecret:snsRequest.appSecret
                                                    token:snsRequest.oauthToken
                                              tokenSecret:snsRequest.oauthTokenSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"send access_token, POST data=%@", queryString);
    
    int result = [NetworkUtil sendRequest:request respnoseHandlerBlock:^(NSString* responseText) {
        NSDictionary* dict = [responseText URLQueryStringToDictionary];
        snsRequest.oauthToken = [dict objectForKey:@"oauth_token"];
        snsRequest.oauthTokenSecret = [dict objectForKey:@"oauth_token_secret"];
    }];
    
    if (result == 0)
        return YES;
    else
        return NO;    
}

- (NSDictionary*)getUserInfo:(CommonSNSRequest*)snsRequest
{
    __block NSMutableDictionary *userInfo = nil;
    NSURL *url = [NSURL URLWithString:[snsRequest getUserInfoURLMain]];
    NSString *queryString = [OAuthCore queryStringWithUrl:url
                                         method:@"POST"
                                     parameters:nil
                                    consumerKey:snsRequest.appKey
                                 consumerSecret:snsRequest.appSecret
                                          token:snsRequest.oauthToken
                                    tokenSecret:snsRequest.oauthTokenSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
    [NetworkUtil sendRequest:request respnoseHandlerBlock:^(NSString *responseText) {
        NSMutableDictionary* dict = [responseText JSONValue];
        if (dict == nil){                        
        }
        else{
            userInfo = [snsRequest parseUserInfo:dict];
            [userInfo setObject:snsRequest.oauthToken forKey:SNS_OAUTH_TOKEN];
            [userInfo setObject:snsRequest.oauthTokenSecret forKey:SNS_OAUTH_TOKEN_SECRET];
            
            snsRequest.userInfoCache = userInfo;            
            NSLog(@"<getUserInfo> userInfo=%@", [userInfo description]);
        }
    }];
    
    return userInfo;
}

- (int)sendText:(NSString*)text snsRequest:(CommonSNSRequest*)snsRequest
{
    int result;
    
    __block NSMutableDictionary *userInfo = nil;
    NSURL *url = [snsRequest getSendTextURL];    
    NSString *body = [snsRequest getSendTextBody:text];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [NetworkUtil sendRequest:request respnoseHandlerBlock:^(NSString *responseText) {
        NSMutableDictionary* dict = [responseText JSONValue];
        if (dict == nil){                        
            
        }
        else{
//            userInfo = [snsRequest parseUserInfo:dict];
//            [userInfo setObject:snsRequest.oauthToken forKey:SNS_OAUTH_TOKEN];
//            [userInfo setObject:snsRequest.oauthTokenSecret forKey:SNS_OAUTH_TOKEN_SECRET];
//            
//            snsRequest.userInfoCache = userInfo;            
//            NSLog(@"<getUserInfo> userInfo=%@", [userInfo description]);
        }
    }];
        
    return result;
}

@end
