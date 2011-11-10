//
//  DownloadItemManager.m
//  Download
//
//  Created by  on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadItemManager.h"
#import "DownloadItem.h"
#import "CoreDataUtil.h"
#import "StringUtil.h"
#import "LogUtil.h"

DownloadItemManager* globalDownloadManager;

@implementation DownloadItemManager

+ (DownloadItemManager*)defaultManager
{
    if (globalDownloadManager == nil){
        globalDownloadManager = [[DownloadItemManager alloc] init];
    }
    
    return globalDownloadManager;
}

- (int)getFileTypeFromName:(NSString*)fileName
{
    return 0;
}

- (DownloadItem*)createDownloadItem:(NSString*)url
                            webSite:(NSString*)webSite
                            origUrl:(NSString*)origUrl
                           fileName:(NSString*)fileName
                           filePath:(NSString*)filePath
                           tempPath:(NSString*)tempPath;
{
    
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    DownloadItem* item = [dataManager insert:@"DownloadItem"];
    
    item.origUrl = origUrl;
    item.downloadSize = [NSNumber numberWithInt:0];
    item.fileName = fileName;
    item.localPath = filePath;
    item.tempPath = tempPath;
    item.starred = [NSNumber numberWithBool:NO];
    item.fileType = [NSNumber numberWithInt:[self getFileTypeFromName:fileName]];
    item.startDate = [NSDate date];
    item.url = url;
    item.webSite = webSite;
    item.itemId = [NSString GetUUID];
    item.deleteFlag = [NSNumber numberWithBool:NO];
    
    PPDebug(@"create download item = %@", [item description]);
    
    [dataManager save];    
    return item;
}

- (DownloadItem*)findItemByName:(NSString*)fileName
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return (DownloadItem*)[dataManager execute:@"findItemByName" forKey:@"FILE_NAME" value:fileName];
}

- (void)finishDownload:(DownloadItem*)item
{
    [item setEndDate:[NSDate date]];
    [item setStatus:[NSNumber numberWithInt:DOWNLOAD_STATUS_FINISH]];
    [item setDownloadProgress:[NSNumber numberWithFloat:1.0]];
    [[CoreDataManager dataManager] save];
}

- (void)downloadFailure:(DownloadItem*)item
{
    [item setStatus:[NSNumber numberWithInt:DOWNLOAD_STATUS_FAIL]];
    [item setDownloadProgress:[NSNumber numberWithFloat:1.0]];
    [[CoreDataManager dataManager] save];    
}

@end
