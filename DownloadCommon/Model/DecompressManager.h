//
//  DecompressManager.h
//  Download
//
//  Created by gckj on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecompressItem.h"

@class DownloadItem;

@interface DecompressManager : NSObject

+ (DecompressManager*) defaultManager;
- (DecompressItem*) createDecompressItem:(NSString*)localPath
                                fileName:(NSString*)fileName;
- (NSArray*) decompressDownloadItem:(DownloadItem*) downloadItem;
@end
