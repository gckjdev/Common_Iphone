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

@class DownloadItem;
@class PlayAudioVideoController;
@class DisplayReadableFileController;

@interface DownloadService : CommonService <ASIHTTPRequestDelegate>

@property (nonatomic, retain) NSOperationQueue* queue;
@property (nonatomic, retain) NSString* downloadDir;
@property (nonatomic, retain) NSString* downloadTempDir;
@property (nonatomic, assign) int concurrentDownload;

@property (nonatomic, retain) PlayAudioVideoController *videoPlayController;
@property (nonatomic, retain) DisplayReadableFileController *fileViewController;

- (BOOL)downloadFile:(NSString*)url fileType:(int)fileType webSite:(NSString*)webSite webSiteName:(NSString*)webSiteName origUrl:(NSString*)origUrl;
- (void)pauseDownloadItem:(DownloadItem*)item;
- (void)resumeDownloadItem:(DownloadItem*)item;
- (void)playItem:(DownloadItem*)item viewController:(UIViewController*)viewController;
- (void)pauseAllDownloadItem;

+ (DownloadService*)defaultService;

@end
