//
//  FileTypeManager.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTypeManager : NSObject

+ (FileTypeManager*) defaultManager;

- (BOOL)isVideoAudio:(NSString*) fileType;
- (BOOL)isImage:(NSString*) fileType;
- (BOOL)isAll:(NSString*) fileType;


@end
