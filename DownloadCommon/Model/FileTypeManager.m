//
//  FileTypeManager.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FileTypeManager.h"

FileTypeManager* globalFileTypeManager;

@implementation FileTypeManager

-(BOOL) isAll:(NSString*) fileType
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"综合",@"文档",
                          nil];
    return [fileTypeSet containsObject:fileType];

}

-(BOOL) isImage:(NSString*) fileType
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"图片",@"jpg",@"jpeg",@"png",
                          nil];
    return [fileTypeSet containsObject:fileType];
}

-(BOOL) isVideoAudio:(NSString*) fileType
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"视频",@"mp3",@"mp4",
                          nil];
    return [fileTypeSet containsObject:fileType];
}

+ (FileTypeManager*) defaultManager
{
    if (globalFileTypeManager == nil) {
        globalFileTypeManager = [[FileTypeManager alloc] init];
    }
    return globalFileTypeManager;
}

@end
