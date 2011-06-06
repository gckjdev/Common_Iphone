//
//  SINAWeiboRequest.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonSNSRequest.h"

#define SINA_REQUEST_TOKEN_URL          @"http://api.t.sina.com.cn/oauth/request_token"
#define SINA_AUTHORIZE_URL              @"http://api.t.sina.com.cn/oauth/authorize"
#define SINA_ACCESS_TOKEN_URL           @"http://api.t.sina.com.cn/oauth/access_token"
#define SINA_USER_INFO_URL              @"http://api.t.sina.com.cn/account/verify_credentials.json"

@interface SINAWeiboRequest : CommonSNSRequest <CommonSNSProtocol> {
    
}

@end
