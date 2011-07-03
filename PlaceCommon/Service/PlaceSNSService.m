//
//  PlaceSNSService.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlaceSNSService.h"
#import "PPViewController.h"
#import "UserService.h"

#define SINA_APP_KEY                    @"1528146353"
#define SINA_APP_SECRET                 @"4815b7938e960380395e6ac1fe645a5c"
#define SINA_CALLBACK_URL               @"dipan://sina"

#define QQ_APP_KEY                      @"7c78d5b42d514af8bb66f0200bc7c0fc"
#define QQ_APP_SECRET                   @"6340ae28094e66d5388b4eb127a2af43"
#define QQ_CALLBACK_URL                 @"dipan://qq"

@implementation PlaceSNSService

@synthesize sinaRequest;
@synthesize qqRequest;

- (id)init
{
    self = [super init];
    
    workingQueue = dispatch_queue_create("sns service queue", NULL);
    
    self.sinaRequest = [[SINAWeiboRequest alloc] initWithAppKey:SINA_APP_KEY
                                                      appSecret:SINA_APP_SECRET
                                                    callbackURL:SINA_CALLBACK_URL
                                                     oauthToken:nil
                                               oauthTokenSecret:nil];
    
    self.qqRequest = [[QQWeiboRequest alloc] initWithAppKey:QQ_APP_KEY
                                                      appSecret:QQ_APP_SECRET
                                                    callbackURL:QQ_CALLBACK_URL
                                                     oauthToken:nil
                                               oauthTokenSecret:nil];
    
    return self;
}

- (void)dealloc
{
    
    dispatch_release(workingQueue);
    workingQueue = NULL;
    
    [sinaRequest release];
    [qqRequest release];
    [super dealloc];
        
}

#pragma mark - Cache Handling

- (BOOL)hasQQCacheData
{
    return [qqRequest hasUserInfoCache];
}

- (BOOL)hasSinaCacheData
{
    return [sinaRequest hasUserInfoCache];    
}

#pragma mark - Handle Authroization Response

- (void)handleParseAuthorizationResponseURL:(CommonSNSRequest*)snsRequest 
                                      query:(NSString*)query 
                             viewController:(PPViewController*)viewController 
                             successHandler:(AuthorizationSuccessHandler)successHandler
{
    [viewController showActivityWithText:NSLS(@"kCheckAuthorizationResponse")];
    dispatch_async(workingQueue, ^{                
        BOOL finalResult = YES;
        // parse authorization response
        int result = [self parseAuthorizationResponseURL:query snsRequest:snsRequest];
        if (result != 0)
            finalResult = NO;
        
        // get user info
        NSDictionary* userInfo = [self getUserInfo:snsRequest];
        if (userInfo != nil){            
            
            // success
            finalResult = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                successHandler(userInfo, viewController);
            });            
            
        }
        else{
            finalResult = NO;
        }                
        
        if (finalResult == NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                [viewController hideActivity]; 
                [UIUtils alert:NSLS(@"kAuthorizationFailure")];
            });            
        }                
    });
}

- (void)sinaParseAuthorizationResponseURL:(NSString *)query viewController:(PPViewController*)viewController successHandler:(AuthorizationSuccessHandler)successHandler
{
    [self handleParseAuthorizationResponseURL:sinaRequest query:query viewController:viewController successHandler:successHandler];    
}

- (void)qqParseAuthorizationResponseURL:(NSString *)query viewController:(PPViewController*)viewController successHandler:(AuthorizationSuccessHandler)successHandler
{
    [self handleParseAuthorizationResponseURL:qqRequest query:query viewController:viewController successHandler:successHandler];    
}

#pragma mark - Initate Login Request

- (void)snsInitiateLogin:(PPViewController*)viewController snsRequest:(CommonSNSRequest*)snsRequest
{
    displayViewController = viewController; // save the view controller to parse reponse URL
    
    [viewController showActivityWithText:NSLS(@"kInitiateAuthorization")];
    dispatch_async(workingQueue, ^{        
        BOOL result = [self loginForAuthorization:snsRequest];
        dispatch_async(dispatch_get_main_queue(), ^{                
            [viewController hideActivity];  
            if (result == NO){
                [UIUtils alert:NSLS(@"kFailInitAuthorization")];                
            }
        });        
    });        
}

- (void)sinaInitiateLogin:(PPViewController*)viewController
{
    [self snsInitiateLogin:viewController snsRequest:sinaRequest];
}

- (void)qqInitiateLogin:(PPViewController*)viewController
{
    [self snsInitiateLogin:viewController snsRequest:qqRequest];
}

AuthorizationSuccessHandler snsAuthorizeSuccess = ^(NSDictionary* userInfo, PPViewController* viewController){
    UserService* userService = GlobalGetUserService();
    [userService loginUserWithSNSUserInfo:userInfo viewController:viewController];            
    
};

- (void)sinaParseAuthorizationResponseURL:(NSString *)query
{
    [self sinaParseAuthorizationResponseURL:query viewController:displayViewController successHandler:snsAuthorizeSuccess];
}

- (void)qqParseAuthorizationResponseURL:(NSString *)query
{
    [self qqParseAuthorizationResponseURL:query viewController:displayViewController successHandler:snsAuthorizeSuccess];    
}

- (void)syncWeiboToAllSNS:(NSString*)text viewController:(PPViewController*)viewController
{
    if ([text length] == 0)
        return;
    
    UserService* userService = GlobalGetUserService();
    if ([userService hasUserBindQQ]){
        dispatch_async(workingQueue, ^{
            [self sendText:text snsRequest:qqRequest]; 
        });
    }

    if ([userService hasUserBindSina]){
        dispatch_async(workingQueue, ^{
            [self sendText:text snsRequest:sinaRequest]; 
        });
    }
    
}

@end
