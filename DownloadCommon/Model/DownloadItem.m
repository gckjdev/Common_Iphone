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
#import "FileUtil.h"

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
    if (self.fileSize != nil){
        self.downloadSize = [NSNumber numberWithLongLong:[self.fileSize longLongValue]*newProgress];
    }
    
    PPDebug(@"item (%@) download progress = %f", [self itemId], newProgress);
}

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
//    self.downloadSize = [NSNumber numberWithLongLong:bytes + [self.downloadSize doubleValue]];
//    PPDebug(@"item (%@) download progress didReceiveBytes = %qi", [self itemId], bytes);    
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
                      NSLS(@"DOWNLOAD_STATUS_PAUSE"), 
                      NSLS(@"DOWNLOAD_STATUS_FAIL"), 
                      nil];

    int index = [self.status intValue];
    if (index >=0 && index < [array count])
        return [array objectAtIndex:index];
    else if (index == DOWNLOAD_STATUS_FINISH){
        return NSLS(@"DOWNLOAD_STATUS_FINISH");
    }
    else{
        return @"";
    }
}

- (BOOL)isStarred
{
    return ([self.starred intValue] == 1);
}

- (BOOL)isDownloading
{
    switch ([self.status intValue]) {
        case DOWNLOAD_STATUS_STARTED:
            return YES;
        default:
            return NO;
    }        
}

- (BOOL)isDownloadFinished
{
    switch ([self.status intValue]) {
        case DOWNLOAD_STATUS_FINISH:
            return YES;
        default:
            return NO;
    }    
}

- (BOOL)canPlay
{
    return [self isAudioVideo];
}

- (BOOL)canView
{
    return [QLPreviewController canPreviewItem:self];
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

- (BOOL)isImage
{
    NSString* extension = [[self.fileName pathExtension] lowercaseString];
    NSSet* fileTypeSet = [NSSet setWithObjects:@"jpg", @"png", @"bmp", @"jpeg", nil];
    return [fileTypeSet containsObject:extension];
}

- (BOOL)isCompressFile
{
    return [self isZipFile] || [self isRarFile];
}

- (BOOL)isAudioVideo
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mp3", @"mid", @"mp4", @"3pg", @"mov", @"avi", @"flv", @"rm", @"rmvb", @"ogg", @"wmv", @"m4v", @"wav", @"caf", @"m4v", @"aac", @"aiff", @"dvix",
                          nil];
    return [fileTypeSet containsObject:[[self.fileName pathExtension] lowercaseString]];
}

- (BOOL)isVideo
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mid", @"mp4", @"3pg", @"mov", @"avi", @"flv", @"rm", @"rmvb", @"ogg", @"wmv", @"m4v", @"m4v", @"aiff", @"dvix",
                          nil];
    return [fileTypeSet containsObject:[[self.fileName pathExtension] lowercaseString]];
}

- (BOOL)isAudio
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mp3", @"mid", @"wav", @"caf", @"m4v", @"aac", nil];
    return [fileTypeSet containsObject:[[self.fileName pathExtension] lowercaseString]];
}

- (BOOL)isZipFile
{
    return [[[self.fileName pathExtension] lowercaseString] isEqualToString:(@"zip")];
}

- (BOOL)isRarFile
{
    return [[[self.fileName pathExtension] lowercaseString] isEqualToString:(@"rar")];
}

- (BOOL)isReadableFile
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"pdf", @"doc", @"txt", @"xls", @"ppt", @"rtf",
                          @"epub", @"htm", @"html", nil];
    return [fileTypeSet containsObject:[[self.fileName pathExtension] lowercaseString]];
}

- (BOOL)isImageFileType
{
    return ([self.fileType intValue] == FILE_TYPE_IMAGE);
}

- (NSURL*)previewItemURL
{
    NSURL* url = [NSURL fileURLWithPath:self.localPath];
    return url;
}

@end
