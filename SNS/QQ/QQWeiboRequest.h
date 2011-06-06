//
//  QQWeiboRequest.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonSNSRequest.h"

#define QQ_REQUEST_TOKEN_URL                @"https://open.t.qq.com/cgi-bin/request_token"
#define QQ_AUTHORIZE_URL                    @"https://open.t.qq.com/cgi-bin/authorize"
#define qqAccessTokenUrl                    @"https://open.t.qq.com/cgi-bin/access_token"
#define qqUserInfoUrl                       @"http://open.t.qq.com/api/user/info"


@interface QQWeiboRequest : CommonSNSRequest <CommonSNSProtocol> {
    
}

@end
