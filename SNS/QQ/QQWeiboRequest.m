//
//  QQWeiboRequest.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "QQWeiboRequest.h"


@implementation QQWeiboRequest

- (NSString*)getAuthorizeURLMain
{
    return QQ_AUTHORIZE_URL;
}

- (NSString*)getRequestTokenURLMain
{
    return QQ_REQUEST_TOKEN_URL;        
}

@end
