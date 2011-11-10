//
//  DownloadService.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "ASIHTTPRequestDelegate.h"

@interface DownloadService : CommonService <ASIHTTPRequestDelegate>

@property (nonatomic, retain) NSOperationQueue* queue;
@property (nonatomic, retain) NSString* downloadDir;
@property (nonatomic, retain) NSString* downloadTempDir;
@property (nonatomic, assign) int concurrentDownload;

- (BOOL)downloadFile:(NSString*)url webSite:(NSString*)webSite origUrl:(NSString*)origUrl;

+ (DownloadService*)defaultService;

@end
