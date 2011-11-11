//
//  ResourceService.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@protocol ResourceServiceDelegate <NSObject>

- (void)findAllSitesFinish:(int)resultCode;

@end

@interface ResourceService : CommonService

+ (ResourceService*)defaultService;
- (void)findAllSites:(id<ResourceServiceDelegate>)delegateObject;

@end
