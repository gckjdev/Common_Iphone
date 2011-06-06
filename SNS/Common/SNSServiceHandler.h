//
//  SNSServiceHandler.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommonSNSRequest;

@interface SNSServiceHandler : NSObject {
    
}

- (BOOL)loginForAuthorization:(CommonSNSRequest*)snsRequest;

@end
