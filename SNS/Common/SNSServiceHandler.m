//
//  SNSServiceHandler.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SNSServiceHandler.h"
#import "CommonSNSRequest.h"

@implementation SNSServiceHandler


- (BOOL)sendRequestToken:(CommonSNSRequest*)snsRequest
{
    BOOL result = YES;

    NSURL* url = [snsRequest getOAuthTokenAndSecretURL];    
    if (url == nil){
        NSLog(@"<sendRequestToken> but URL is nil");
        return NO;
    }
    
    NSLog(@"<sendRequestToken> send request URL:%@", [url description]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"<sendRequestToken> response : status = %d", [response statusCode]);
    if (200 == [response statusCode]) {
        // success
        if (data != nil){
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([snsRequest parseRequestTokenURLResult:text]){
                NSLog(@"<sendRequestToken> parse token URL response OK, oauth_token=%@, oauth_secret=%@",
                      snsRequest.oauthToken, snsRequest.oauthTokenSecret);
            }
            else{
                NSLog(@"<sendRequestToken> fail to parse token URL response, text=%@", text);                
                result = NO;
            }
            [text release];            
        }         
    }
    else{
        // failure
        NSLog(@"<sendRequestToken> response error=%@", [error description]);        
        if (data != nil){
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"<sendRequestToken> response data=%@", text); 
            [text release];            
        }         
        result = NO;
    }

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

@end
