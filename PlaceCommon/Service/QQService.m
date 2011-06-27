//
//  QQService.m
//  Dipan
//
//  Created by penglzh on 11-5-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "QQService.h"
#import "OAuthCore.h"


#define qqAppKey                        @"7c78d5b42d514af8bb66f0200bc7c0fc"
#define qqAppSecret                     @"6340ae28094e66d5388b4eb127a2af43"
#define qqCreateWeiboUrl                @"http://open.t.qq.com/api/t/add"

@implementation QQService

+ (BOOL)createWeiboWith:(NSString *)content accessToken:(NSString *)token tokenSecret:(NSString *)tokenSecret
{
    NSURL *url = [NSURL URLWithString:qqCreateWeiboUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:content forKey:@"content"];
    [dict setObject:@"json" forKey:@"format"];
    NSString *queryString = [OAuthCore queryStringWithUrl:url
                                         method:@"POST"
                                     parameters:dict
                                    consumerKey:qqAppKey
                                 consumerSecret:qqAppSecret
                                          token:token
                                    tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"QQService create weibo result: %@", result);
    if (nil != data) {
        return YES;
    } else {
        return NO;
    }
}

@end
