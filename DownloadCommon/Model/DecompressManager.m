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
    DecompressItem* item = [[DecompressItem alloc]initWithLocalPath:localPath fileName:fileName];
    return item;
}

- (NSArray*) decompressDownloadItem:(DownloadItem*) downloadItem 
{
    NSMutableArray* decompressItemList = [NSMutableArray array];
    if (downloadItem.isZipFile) {
        PPDebug(@"Unzip DownloadItem: (%@)", downloadItem.localPath);
        
        NSString *destinationDir = [[downloadItem localPath] stringByDeletingPathExtension];
        NSString *destinationPath = [[downloadItem localPath] stringByDeletingLastPathComponent];
        
        PPDebug(@"Unzip destination Path: (%@)", destinationPath);
        
        [SSZipArchive unzipFileAtPath:[downloadItem localPath] toDestination:destinationPath];
        
        NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:destinationDir error:nil];
        
        for (NSString *content in directoryContents) {
            PPDebug(@"list unzip file: %@",content);
            NSString *localPath = [destinationDir stringByAppendingPathComponent:content];
            PPDebug(@"DecompressItem localpath: %@", localPath);
            DecompressItem* item = [self createDecompressItem:localPath fileName:content];
            [decompressItemList addObject:item];
            
        }

    }
    else if (downloadItem.isRarFile) {
        PPDebug(@"Unrar DownloadItem: (%@)", downloadItem.localPath);

        NSString *destinationDir = [[downloadItem localPath] stringByDeletingPathExtension];
        NSString *destinationPath = [[downloadItem localPath] stringByDeletingLastPathComponent];

        Unrar4iOS *unrar = [[Unrar4iOS alloc] init];
        BOOL ok = [unrar unrarOpenFile:[downloadItem localPath]];
        if (ok) {
            NSArray *files = [unrar unrarListFiles];
            for (NSString *filename in files) {
                PPDebug(@"list unrar file: %@", filename);
                NSString *localPath = [destinationDir stringByAppendingPathComponent:filename];
                PPDebug(@"DecompressItem localpath: %@", localPath);
                DecompressItem* item = [self createDecompressItem:localPath fileName:filename];
                [decompressItemList addObject:item];
            }
            [unrar unrarFileTo:destinationDir overWrite:YES];
            
            [unrar unrarCloseFile];
        }
        else {
            [unrar unrarCloseFile];
        }
        [unrar release];

    }
    
    return decompressItemList;
}


@end
