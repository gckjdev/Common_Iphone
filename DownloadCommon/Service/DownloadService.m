//
//  DownloadService.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadService.h"
#import "ASIHTTPRequest.h"
#import "LogUtil.h"
#import "FileUtil.h"
#import "DownloadItem.h"
#import "DownloadItemManager.h"

#define DOWNLOAD_DIR                @"/download/incoming/"
#define DOWNLOAD_TEMP_DIR           @"/download/temp/"

DownloadService* globalDownloadService;

@implementation DownloadService

@synthesize queue;
@synthesize downloadDir;
@synthesize downloadTempDir;
@synthesize concurrentDownload;

- (void)dealloc
{
    [queue release];
    [super dealloc];
}

- (id)init
{
    self = [super init];

    self.downloadDir = [[FileUtil getAppHomeDir] stringByAppendingFormat:DOWNLOAD_DIR];
    self.downloadTempDir = [[FileUtil getAppHomeDir] stringByAppendingFormat:DOWNLOAD_TEMP_DIR];    
    self.concurrentDownload = 20;  

    // create queue
    [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    [self.queue setMaxConcurrentOperationCount:self.concurrentDownload];
    
    // create directory if not exist
    [FileUtil createDir:self.downloadTempDir];
    [FileUtil createDir:self.downloadDir];    
    return self;
}

+ (DownloadService*)defaultService
{
    if (globalDownloadService == nil){
        globalDownloadService = [[DownloadService alloc] init];
        
    }
    
    return globalDownloadService;
}

#pragma File Creation and Generation

- (NSString*)createFileName:(NSURL*)url
{
    DownloadItemManager* manager = [DownloadItemManager defaultManager];
    
    NSString* lastPath = [url lastPathComponent];
    NSString* pathExtension = [lastPath pathExtension];
    NSString* pathWithoutExtension = [lastPath stringByDeletingPathExtension];
    
    BOOL foundName = NO;    
    int i = 0;
    while (!foundName){
        if ([manager findItemByName:lastPath] != nil){            
            i ++;
            lastPath = [pathWithoutExtension stringByAppendingFormat:@"(%d).%@", i, pathExtension];
        }
        else{
            foundName = YES;
        }
    }
    
    return lastPath;
}

- (NSString*)getFilePath:(NSString*)fileName
{
    return [self.downloadDir stringByAppendingString:fileName];
}

- (NSString*)getTempFilePath:(NSString*)fileName
{
    return [self.downloadTempDir stringByAppendingString:fileName];
}

#pragma Download Internal Methods

- (BOOL)startDownload:(DownloadItem*)item
{
    NSURL* url = [NSURL URLWithString:[item url]];
    
    // start to download
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [[DownloadItemManager defaultManager] downloadStart:item request:request];
    
    [request setDownloadDestinationPath:[item localPath]];    
    [request setAllowResumeForFileDownloads:YES];
    [request setTemporaryFileDownloadPath:[item tempPath]];    
    [request setUserInfo:[item dictionaryForRequest]];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:item];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];

    PPDebug(@"download file, URL=%@, save to %@, temp path %@", [item url], [item localPath], [item tempPath]);

    [[self queue] addOperation:request];
    return YES;
}

#pragma External Methods

- (BOOL)downloadFile:(NSString*)urlString webSite:(NSString*)webSite origUrl:(NSString*)origUrl
{                
    NSURL* url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url] == NO){
        PPDebug(@"downloadFile but cannot open URL = %@", urlString);
        return NO;
    }
    
    NSString* fileName = [self createFileName:url];
    NSString* filePath = [self getFilePath:fileName];
    NSString* tempFilePath = [self getTempFilePath:fileName];
    
    // save download item
    DownloadItemManager* downloadItemManager = [DownloadItemManager defaultManager];
    DownloadItem* downloadItem = [downloadItemManager createDownloadItem:urlString 
                                                                 webSite:webSite 
                                                                 origUrl:origUrl
                                                                fileName:fileName
                                                                filePath:filePath                                   tempPath:tempFilePath];
    
    [self startDownload:downloadItem];    
    return YES;
}

- (void)pauseDownloadItem:(DownloadItem*)item
{
    [[item request] clearDelegatesAndCancel];
    [[DownloadItemManager defaultManager] downloadPause:item];
}

- (void)resumeDownloadItem:(DownloadItem*)item
{
    [self startDownload:item];
}

- (void)pauseAllDownloadItem
{
    DownloadItemManager* manager = [DownloadItemManager defaultManager];
    NSArray* array = [manager findAllItemsByStatus:DOWNLOAD_STATUS_STARTED];
    for (DownloadItem* item in array){
        [self pauseDownloadItem:item];
    }
}

#pragma ASIHTTPRequest Delegate

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];
    [[DownloadItemManager defaultManager] finishDownload:item];
    PPDebug(@"item (%@) download done, response done = %@", [item itemId], response);
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];
    [[DownloadItemManager defaultManager] downloadFailure:item];
    PPDebug(@"item (%@) download failure, response done = %@", [item itemId], [error description]);
}

@end
