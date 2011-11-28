//
//  DecompressItem.h
//  Download
//
//  Created by gckj on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface DecompressItem : NSObject <QLPreviewItem>

@property (nonatomic, retain) NSNumber* fileSize;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber* fileType;
@property (nonatomic, retain) NSString* localPath;

- (id)initWithLocalPath:(NSString*)localPathValue
               fileName:(NSString*) fileNameValue;
- (BOOL)isAudio;
- (BOOL)isVideo;
- (BOOL)isReadableFile;
- (BOOL)isImage;

@end
