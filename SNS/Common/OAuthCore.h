//
//  OAuthCore.h
//
//  Created by Lizhang Peng on 5/16/11.
//  Copyright 2010 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@interface NSString (OAuthCore)

- (NSString *)urlencodeWithUTF8;

@end

@interface OAuthCore : NSObject {

    
}

+ (NSData *)hmacSHA1WithString:(NSString *)value key:(NSString *)key;
+ (NSString *)GUID;
+ (NSString *)queryStringWithUrl:(NSURL *)url
                          method:(NSString *)method
                      parameters:(NSDictionary *)parameters
                     consumerKey:(NSString *)consumerKey
                  consumerSecret:(NSString *)consumerSecret
                           token:(NSString *)token
                     tokenSecret:(NSString *)tokenSecret;

@end