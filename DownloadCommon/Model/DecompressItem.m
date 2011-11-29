//
//  DecompressItem.m
//  Download
//
//  Created by gckj on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DecompressItem.h"
#import "LogUtil.h"

@implementation DecompressItem

@synthesize fileName;
@synthesize fileSize;
@synthesize fileType;
@synthesize localPath;

- (id)initWithLocalPath:(NSString *)localPathValue fileName:(NSString *)fileNameValue
{
    self = [super init];
    self.localPath = localPathValue;
    self.fileName = fileNameValue;
    return self;
}

-(void)dealloc
{
    [fileName release];
    [localPath release];
}

- (BOOL)isVideo
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mp3", @"mid", @"mp4", @"3pg", @"mov", @"avi", @"flv", @"rm", @"rmvb", @"ogg", @"wmv", @"m4v", @"wav", @"caf", @"m4v", @"aac", @"aiff", @"dvix",
                          nil];
    return [fileTypeSet containsObject:[[self.fileName pathExtension] lowercaseString]];
}

- (BOOL)isAudio
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"mp3", @"aac", nil];
    return [fileTypeSet containsObject:[[self.fileName pathExtension] lowercaseString]];
}

- (BOOL)isReadableFile
{
    NSSet* fileTypeSet = [NSSet setWithObjects:@"pdf", @"doc", @"txt", @"xls", @"ppt", @"rtf", @"epub", nil];
    return [fileTypeSet containsObject:[[self.fileName pathExtension] lowercaseString]];
}

- (BOOL)isImage
{
    NSString* extension = [[self.fileName pathExtension] lowercaseString];
    NSSet* fileTypeSet = [NSSet setWithObjects:@"jpg", @"png", @"bmp", @"jpeg", nil];
    return [fileTypeSet containsObject:extension];
}

- (NSURL*)previewItemURL
{
    NSURL* url = [NSURL fileURLWithPath:self.localPath];
    return url;
}


@end
