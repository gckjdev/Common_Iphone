//
//  DecompressManager.m
//  Download
//
//  Created by gckj on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DecompressManager.h"
#import "DecompressItem.h"
#import "DownloadItem.h"
#import "LogUtil.h"
#import "Unrar4iOS.h"
#import "SSZipArchive.h"

DecompressManager* globalDecompressManager;

@implementation DecompressManager

+ (DecompressManager*) defaultManager
{
    if (globalDecompressManager == nil) {
        globalDecompressManager = [[DecompressManager alloc] init];
    }
    return globalDecompressManager;
}

- (DecompressItem*) createDecompressItem:(NSString*)localPath
                                fileName:(NSString*)fileName
{
    DecompressItem* item = [[[DecompressItem alloc]initWithLocalPath:localPath fileName:fileName] autorelease];
    
    return item;
}

- (NSArray*) decompressDownloadItem:(DownloadItem*) downloadItem 
{
    PPDebug(@"Open DownloadItem: (%@)", downloadItem.localPath);

    NSMutableArray* decompressItemList = [NSMutableArray array];
    NSString *destinationDir = [[downloadItem localPath] stringByDeletingPathExtension];
    NSString *repeatDir =  [destinationDir stringByAppendingPathComponent:[downloadItem.fileName stringByDeletingPathExtension]];
    BOOL result = NO;
    
    if (downloadItem.isZipFile) {
       
        //check if already unzip
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:destinationDir];
        if (!exist) {
            PPDebug(@"Unzip destination Path: (%@)", destinationDir);
            result = [SSZipArchive unzipFileAtPath:[downloadItem localPath] toDestination:destinationDir];
            if (!result){
                PPDebug(@"Unzip item (%@) but fail to unzip file", [downloadItem itemId]);                    
            }
        }
    }
    else if (downloadItem.isRarFile) {
        
        //check if already unrar
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:destinationDir];
        BOOL unrarOk;
        if (!exist) {
            PPDebug(@"Unzip destination Path: (%@)", destinationDir);
            Unrar4iOS *unrar = [[Unrar4iOS alloc] init];
            unrarOk = [unrar unrarOpenFile:[downloadItem localPath]];
            if (unrarOk) {
                result = [unrar unrarFileTo:destinationDir overWrite:YES];
                if (!result){
                    PPDebug(@"Unrar item (%@) but fail to unrar file", [downloadItem itemId]);                    
                }
            }
            else{
                PPDebug(@"Unrar item (%@) but fail to open file", [downloadItem itemId]);
            }
            [unrar unrarCloseFile];               
            [unrar release];
        }
        
    }
    
    NSArray * directoryContents;
    if ([[NSFileManager defaultManager] fileExistsAtPath:repeatDir]) {
        directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:repeatDir error:nil];
    } else {
        directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:destinationDir error:nil];
    }
    
    for (NSString *content in directoryContents) {
        PPDebug(@"list decompress file: %@",content);
        NSString *localPath = [destinationDir stringByAppendingPathComponent:content];

        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:localPath isDirectory:&isDir] && isDir) {
            NSArray * subDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath error:nil];
            for (NSString *subContent in subDirectoryContents) {
                NSString *subPath = [localPath stringByAppendingPathComponent:subContent];
                PPDebug(@"DecompressItem subPath: %@", subPath);
                DecompressItem* item = [self createDecompressItem:subPath fileName:subContent];
                [decompressItemList addObject:item];
            }
        }
        
        PPDebug(@"DecompressItem localpath: %@", localPath);
        DecompressItem* item = [self createDecompressItem:localPath fileName:content];
        [decompressItemList addObject:item];
        
    }    
    return decompressItemList;
}


@end
