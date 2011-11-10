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

- (BOOL)downloadFile:(NSString*)urlString webSite:(NSString*)webSite origUrl:(NSString*)origUrl
{
    if ([self queue] == nil) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
        [self.queue setMaxConcurrentOperationCount:self.concurrentDownload];
    }
            
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
    
    // start to download
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
    [request setDownloadDestinationPath:filePath];    
    [request setAllowResumeForFileDownloads:YES];
    [request setTemporaryFileDownloadPath:tempFilePath];
    PPDebug(@"download file, URL=%@, save to %@, temp path %@", urlString, filePath, tempFilePath);

    [request setUserInfo:[downloadItem dictionaryForRequest]];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:downloadItem];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [[self queue] addOperation:request]; //queue is an NSOperationQueue
    
    return YES;
}

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
