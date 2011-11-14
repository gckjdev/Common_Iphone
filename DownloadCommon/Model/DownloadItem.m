//
//  DownloadItem.m
//  Download
//
//  Created by  on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadItem.h"
#import "ASIHTTPRequest.h"
#import "LogUtil.h"
#import "LocaleUtils.h"

#define DOWNLOAD_KEY @"DOWNLOAD_KEY"

@implementation DownloadItem

@dynamic downloadSize;
@dynamic endDate;
@dynamic fileName;
@dynamic fileSize;
@dynamic fileType;
@dynamic starred;
@dynamic startDate;
@dynamic status;
@dynamic url;
@dynamic origUrl;
@dynamic webSite;
@dynamic localPath;
@dynamic itemId;
@dynamic tempPath;
@dynamic deleteFlag;
@dynamic downloadProgress;
@dynamic webSiteName;

@synthesize request;

#pragma Progress Delegate

- (void)setProgress:(float)newProgress
{
    self.downloadProgress = [NSNumber numberWithFloat:newProgress];
    PPDebug(@"item (%@) download progress = %f", [self itemId], newProgress);
}

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    self.downloadSize = [NSNumber numberWithLongLong:bytes + [self.downloadSize doubleValue]];
    PPDebug(@"item (%@) download progress didReceiveBytes = %qi", [self itemId], bytes);    
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    self.fileSize = [NSNumber numberWithLongLong:newLength];
    PPDebug(@"item (%@) download file content size = %qi", [self itemId], newLength);        
}

#pragma Download Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    PPDebug(@"item (%@) download finish", [self itemId]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    PPDebug(@"item (%@) download fail", [self itemId]);
}

- (NSDictionary*)dictionaryForRequest
{
    return [NSDictionary dictionaryWithObject:self forKey:DOWNLOAD_KEY];
}

+ (DownloadItem*)fromDictionary:(NSDictionary*)dict
{
    return [dict objectForKey:DOWNLOAD_KEY];
}

#pragma STRING

- (NSString*)statusText
{    
    NSArray* array = [NSArray arrayWithObjects:
                      NSLS(@"DOWNLOAD_STATUS_NOT_STARTED"), 
                      NSLS(@"DOWNLOAD_STATUS_STARTED"), 
                      NSLS(@"DOWNLOAD_STATUS_FINISH"), 
                      NSLS(@"DOWNLOAD_STATUS_PAUSE"), 
                      NSLS(@"DOWNLOAD_STATUS_FAIL"), 
                      nil];

    int index = [self.status intValue];
    if (index >=0 && index < [array count])
        return [array objectAtIndex:index];
    else
        return @"";
}

- (BOOL)canPause
{
    switch ([self.status intValue]) {
        case DOWNLOAD_STATUS_NOT_STARTED:            
        case DOWNLOAD_STATUS_FINISH:
        case DOWNLOAD_STATUS_PAUSE:
        case DOWNLOAD_STATUS_FAIL:
            return NO;
            
        case DOWNLOAD_STATUS_STARTED:
        default:
            return YES;
    }
}

- (BOOL)canResume
{
    switch ([self.status intValue]) {
        case DOWNLOAD_STATUS_NOT_STARTED:            
        case DOWNLOAD_STATUS_PAUSE:
        case DOWNLOAD_STATUS_FAIL:
            return YES;
            
        case DOWNLOAD_STATUS_STARTED:
        case DOWNLOAD_STATUS_FINISH:
        default:
            return NO;
    }    
}

- (BOOL)isAudioVideo
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mp3", @"mid", @"mp4", @"3pg", @"mov", @"avi", @"flv", @"rm", @"rmvb", @"ogg", @"wmv", @"m4v", @"wav", @"caf", @"m4v", @"aac", @"aiff", @"dvix",
                          nil];
    return [fileTypeSet containsObject:[self.fileName pathExtension]];
}

- (BOOL)isReadableFile
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"pdf", @"doc", @"txt", @"xls", @"ppt", @"rtf",
                          @"epub", nil];
    return [fileTypeSet containsObject:[self.fileName pathExtension]];
}

// TODO not implemented yet
- (BOOL)isImage
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mp3", @"mp4", @"zip", @"3pg", @"mov", @"jpg", @"png", 
                          @"jpeg", @"avi", @"pdf", @"doc", @"txt", @"gif", @"xls", @"ppt", @"rtf",
                          @"rar", @"tar", @"gz", @"flv", @"rm", @"rmvb", @"ogg", @"wmv", @"m4v",
                          @"bmp", @"wav", @"caf", @"m4v", @"aac", @"aiff", @"dvix", @"epub",
                          nil];
    return [fileTypeSet containsObject:[self.fileName pathExtension]];
}

@end