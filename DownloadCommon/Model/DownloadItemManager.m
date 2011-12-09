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
#import "FileUtil.h"

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
                           fileType:(int)fileType
                            webSite:(NSString*)webSite
                        webSiteName:(NSString*)webSiteName 
                            origUrl:(NSString*)origUrl
                           fileName:(NSString*)fileName
                           filePath:(NSString*)filePath
                           tempPath:(NSString*)tempPath
{
    
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    DownloadItem* item = [dataManager insert:@"DownloadItem"];
    
    item.origUrl = origUrl;
    item.downloadSize = [NSNumber numberWithInt:0];
    item.fileName = fileName;
    item.localPath = filePath;
    item.tempPath = tempPath;
    item.starred = [NSNumber numberWithInt:0];
    item.fileType = [NSNumber numberWithInt:fileType];
    item.startDate = [NSDate date];
    item.url = url;
    item.webSite = webSite;
    item.itemId = [NSString GetUUID];
    item.deleteFlag = [NSNumber numberWithInt:0];
    
    PPDebug(@"create download item = %@", [item description]);
    
    [dataManager save];    
    return item;
}

#pragma ALL FIND METHODS

- (DownloadItem*)findItemByName:(NSString*)fileName
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return (DownloadItem*)[dataManager execute:@"findItemByName" forKey:@"FILE_NAME" value:fileName];
}

- (DownloadItem*)findItemByUrl:(NSString*) url
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return (DownloadItem*) [dataManager execute:@"findItemByUrl" forKey:@"URL" value:url];
}


- (NSArray*)findAllItems
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return [dataManager execute:@"findAllItems" sortBy:@"startDate" ascending:NO];    
}

- (NSArray*)findAllItemsByStatus:(int)status
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return [dataManager execute:@"findAllItemsByStatus" forKey:@"STATUS" value:[NSNumber numberWithInt:status] sortBy:@"startDate" ascending:YES];    
}

- (NSArray*)findAllCompleteItems
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return [dataManager execute:@"findAllCompleteItems" sortBy:@"startDate" ascending:NO];        
}

- (NSArray*)findAllDownloadingItems
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return [dataManager execute:@"findAllDownloadingItems" sortBy:@"startDate" ascending:NO];        
}

- (NSArray*)findAllStarredItems
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return [dataManager execute:@"findAllStarredItems" sortBy:@"startDate" ascending:NO];        
}

#pragma STATUS CONTROL

- (void)finishDownload:(DownloadItem*)item
{        
    [item setRequest:nil];
    [item setEndDate:[NSDate date]];
    [item setStatus:[NSNumber numberWithInt:DOWNLOAD_STATUS_FINISH]];
    [item setDownloadProgress:[NSNumber numberWithFloat:1.0]];
    if ([item.fileSize doubleValue] <= 0.0f){
        // read file size from file if file size doesn't exist
        NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[item localPath] error:nil];
        item.fileSize = [NSNumber numberWithDouble:[[attributes objectForKey:NSFileSize] doubleValue]];
    }
    [item setDownloadSize:item.fileSize];   // make sure download size is the same as file size
    
    [[CoreDataManager dataManager] save];
}

- (void)downloadFailure:(DownloadItem*)item
{
    [item setRequest:nil];
    [item setStatus:[NSNumber numberWithInt:DOWNLOAD_STATUS_FAIL]];
    [item setDownloadProgress:[NSNumber numberWithFloat:1.0]];
    [[CoreDataManager dataManager] save];    
}

- (void)downloadPause:(DownloadItem*)item
{
    [item setRequest:nil];
    [item setStatus:[NSNumber numberWithInt:DOWNLOAD_STATUS_PAUSE]];
    [[CoreDataManager dataManager] save];    
}

- (void)downloadStart:(DownloadItem*)item request:(ASIHTTPRequest*)request
{
    [item setRequest:request];
    [item setStatus:[NSNumber numberWithInt:DOWNLOAD_STATUS_STARTED]];
    [[CoreDataManager dataManager] save];        
}

- (NSString*)adjustImageFileName:(DownloadItem*)item newFileName:(NSString*)newFileName
{
    NSString* retFileName = newFileName;
    
    // if file name has no extension and file type is image, set file extension as JPEG
    if ([item isImageFileType]){
        if ([[newFileName pathExtension] length] <= 0){
            if ([newFileName characterAtIndex:[newFileName length]-1] == '.'){
                retFileName = [newFileName stringByAppendingString:@"jpg"];                
            }
            else{
                retFileName = [newFileName stringByAppendingString:@".jpg"];                
            }
        }
    }
    
    return retFileName;
}

- (void)setFileInfo:(DownloadItem*)item newFileName:(NSString*)newFileName fileSize:(long)fileSize
{    
    item.fileName = newFileName;
    item.fileSize = [NSNumber numberWithLong:fileSize];
    [[CoreDataManager dataManager] save];        
}

- (void)starItem:(DownloadItem*)item
{
    int value = !([item.starred intValue]);
    item.starred = [NSNumber numberWithInt:value];
    [[CoreDataManager dataManager] save];            
}

- (BOOL)isURLReport:(NSString*)urlString
{
    return NO;
}

- (void)setURLReported:(NSString*)urlString
{
    
}

- (BOOL)deleteItem:(DownloadItem*)item
{
    if ([item isDownloadFinished] == NO){
        item.deleteFlag = [NSNumber numberWithInt:1];
        [[CoreDataManager dataManager] save];
        return YES;        
    }
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] removeItemAtPath:item.localPath error:&error])
    {
        item.deleteFlag = [NSNumber numberWithInt:1];
        [[CoreDataManager dataManager] save];
        return YES;
    }
    else
    {
        PPDebug(@"delete item fail, error = %@", [error description]);
        return NO;
    }
}

- (BOOL)renameFile:(DownloadItem*)item newFileName:(NSString*)newFileName
{
    NSRange rgn = NSMakeRange(item.localPath.length-item.fileName.length, item.fileName.length);
    
    NSMutableString *filepath = [[NSMutableString alloc] initWithFormat:@""];
    [filepath appendString:item.localPath];
    
    NSString *realNewFileName;
    
    
    if (0 == [[newFileName pathExtension] length])
    {
        realNewFileName = [NSString stringWithFormat:@"%@.%@",newFileName,[item.fileName pathExtension]];
    }
    else
    {
        realNewFileName = [NSString stringWithFormat:@"%@",newFileName];
    }
    
    
    [filepath replaceCharactersInRange:rgn withString:realNewFileName];
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] moveItemAtPath:item.localPath toPath:filepath error:&error])
    {
        item.fileName=realNewFileName;
        item.localPath=filepath;
        [[CoreDataManager dataManager] save];
        [filepath release];
        return YES;
    }
    else
    {
        PPDebug(@"delete item fail, error = %@", [error description]);
        [filepath release];
        return NO;
    }
}

- (NSArray*)findAllImageDownloadItem
{
    NSArray *allList = [[DownloadItemManager defaultManager] findAllCompleteItems];
    NSMutableArray *retList = [[[NSMutableArray alloc] init] autorelease];
    
    for (DownloadItem *item in allList) {
        if ([item isImage]) {
            [retList addObject:item];
        }
    }
    
    return retList;
}

- (NSArray*)findAllCompressItems
{
    NSArray *allList = [[DownloadItemManager defaultManager] findAllCompleteItems];
    NSMutableArray *retList = [[[NSMutableArray alloc] init] autorelease];
    
    for (DownloadItem *item in allList) {
        if ([item isCompressFile]) {
            [retList addObject:item];
        }
    }
    
    return retList;
    
}

- (NSArray*)findAllReadableItems
{
    NSArray *allList = [[DownloadItemManager defaultManager] findAllCompleteItems];
    NSMutableArray *retList = [[[NSMutableArray alloc] init] autorelease];
    
    for (DownloadItem *item in allList) {
        if ([item isReadableFile]) {
            [retList addObject:item];
        }
    }
    
    return retList;
    
}

- (NSArray*)findAllAudioVideoItems
{
    NSArray *allList = [[DownloadItemManager defaultManager] findAllCompleteItems];
    NSMutableArray *retList = [[[NSMutableArray alloc] init] autorelease];
    
    for (DownloadItem *item in allList) {
        if ([item isAudioVideo]) {
            [retList addObject:item];
        }
    }
    
    return retList;    
}

- (NSArray*)findAllAudioItems
{
    NSArray *allList = [[DownloadItemManager defaultManager] findAllCompleteItems];
    NSMutableArray *retList = [[[NSMutableArray alloc] init] autorelease];
    
    for (DownloadItem *item in allList) {
        if ([item isAudio]) {
            [retList addObject:item];
        }
    }
    
    return retList;    
}

@end
