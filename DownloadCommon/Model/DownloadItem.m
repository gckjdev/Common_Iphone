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

@end
