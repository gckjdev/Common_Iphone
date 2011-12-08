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

#define DOWNLOAD_DIR                @"/download/incoming/"
#define DOWNLOAD_TEMP_DIR           @"/download/temp/"
#define DOWNLOAD_ICLOUD_DIR           @"/download/iCloud/"

@class DownloadItem;
@class TopDownloadItem;
@class PlayAudioVideoController;
@class DisplayReadableFileController;
@class ViewImageController;
@class ViewDecompressItemController;

@interface DownloadService : CommonService <ASIHTTPRequestDelegate>

@property (nonatomic, retain) NSOperationQueue* queue;
@property (nonatomic, retain) NSString* downloadDir;
@property (nonatomic, retain) NSString* downloadTempDir;
@property (nonatomic, retain) NSString* iCloudDir;
@property (nonatomic, retain) DownloadItem* nowPlayingItem;
@property (nonatomic, assign) int concurrentDownload;

@property (nonatomic, retain) PlayAudioVideoController *videoPlayController;
@property (nonatomic, retain) DisplayReadableFileController *fileViewController;
@property (nonatomic, retain) ViewImageController *viewImageController;
@property (nonatomic, retain) ViewDecompressItemController *viewDecompressItemController;

- (BOOL)downloadFile:(NSString*)url fileType:(int)fileType webSite:(NSString*)webSite webSiteName:(NSString*)webSiteName origUrl:(NSString*)origUrl;
- (void)pauseDownloadItem:(DownloadItem*)item;
- (void)resumeDownloadItem:(DownloadItem*)item;
- (void)playItem:(DownloadItem*)item viewController:(UIViewController*)viewController;
- (void)playItem:(NSArray*)list index:(int)indexValue viewController:(UIViewController*)viewController;
- (void)pauseAllDownloadItem;
- (void)resumeAllDownloadItem;

+ (DownloadService*)defaultService;

- (void)requestWentWrong:(ASIHTTPRequest *)request;

- (BOOL)hasDownloaded:(TopDownloadItem*)item;

@end
