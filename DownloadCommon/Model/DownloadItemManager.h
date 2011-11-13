//
//  DownloadItemManager.h
//  Download
//
//  Created by  on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadItem;
@class ASIHTTPRequest;

@interface DownloadItemManager : NSObject

+ (DownloadItemManager*)defaultManager;

- (DownloadItem*)createDownloadItem:(NSString*)url
                            webSite:(NSString*)webSite
                            origUrl:(NSString*)origUrl
                           fileName:(NSString*)fileName
                           filePath:(NSString*)filePath
                           tempPath:(NSString*)tempPath;

- (DownloadItem*)findItemByName:(NSString*)fileName;
- (void)finishDownload:(DownloadItem*)item;
- (void)downloadFailure:(DownloadItem*)item;
- (void)downloadPause:(DownloadItem*)item;
- (void)downloadStart:(DownloadItem*)item request:(ASIHTTPRequest*)request;

- (NSArray*)findAllItems;
- (NSArray*)findAllItemsByStatus:(int)status;

- (void)setFileName:(DownloadItem*)item newFileName:(NSString*)newFileName;

@end
