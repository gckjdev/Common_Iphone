//
//  SINAWeiboRequest.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SINAWeiboRequest.h"


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


@end
