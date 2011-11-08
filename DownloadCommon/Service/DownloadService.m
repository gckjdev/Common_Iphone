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

DownloadService* globalDownloadService;

@implementation DownloadService

@synthesize queue;

- (void)dealloc
{
    [queue release];
    [super dealloc];
}

+ (DownloadService*)defaultService
{
    if (globalDownloadService == nil){
        globalDownloadService = [[DownloadService alloc] init];
    }
    
    return globalDownloadService;
}

- (void)downloadFile:(NSString*)urlString
{
    if (![self queue]) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    
    NSURL* url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSString* destPath = [FileUtil getFileFullPath:@"my_file.mp3"];
    [request setDownloadDestinationPath:destPath];
    PPDebug(@"download file, URL=%@, save to %@", urlString, destPath);
    
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [[self queue] addOperation:request]; //queue is an NSOperationQueue
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    PPDebug(@"response done = %@", response);
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    PPDebug(@"response error = %@", [error description]);
}

#pragma Progress Delegate

- (void)setProgress:(float)newProgress
{
    PPDebug(@"download progress = %f", newProgress);
}

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    PPDebug(@"download progress didReceiveBytes = %qi", bytes);    
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    PPDebug(@"download file content size = %qi", newLength);        
}

@end
