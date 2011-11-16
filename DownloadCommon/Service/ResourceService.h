//
//  ResourceService.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

enum SITE_REQUEST {
    SITE_REQUEST_TYPE_NONE = -1,
    SITE_REQUEST_TYPE_TOP,
    SITE_REQUEST_TYPE_HOT,
    SITE_REQUEST_TYPE_NEW
    };



@protocol ResourceServiceDelegate <NSObject>

- (void)findAllSitesFinish:(int)resultCode requestType:(int)requestTypeValue newDataList:(NSArray*)newDataList;

@end

@interface ResourceService : CommonService

+ (ResourceService*)defaultService;

- (void)findAllSites:(id<ResourceServiceDelegate>)delegateObject requestType:(int)requestType;

- (void)findAllTopDownloadItems:(id<ResourceServiceDelegate>)delegateObject requestType:(int)requestType;
@end
