//
//  DownloadItem.h
//  Download
//
//  Created by  on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ASIProgressDelegate.h"
#import "ASIHTTPRequestDelegate.h"
#import <QuickLook/QuickLook.h>

enum DOWNLOAD_STATUS {
    DOWNLOAD_STATUS_NOT_STARTED = 0,
    DOWNLOAD_STATUS_STARTED,
    DOWNLOAD_STATUS_PAUSE,
    DOWNLOAD_STATUS_FAIL,
    DOWNLOAD_STATUS_FINISH = 18,
};

enum FILE_TYPE {
    FILE_TYPE_UNKNOWN = 0,
    FILE_TYPE_IMAGE    
};
 
@interface DownloadItem : NSManagedObject <ASIProgressDelegate, ASIHTTPRequestDelegate, QLPreviewItem>

@property (nonatomic, retain) NSNumber * downloadSize;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSNumber * fileType;
@property (nonatomic, retain) NSNumber * starred;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * webSite;
@property (nonatomic, retain) NSString * origUrl;
@property (nonatomic, retain) NSString * localPath;
@property (nonatomic, retain) NSString * tempPath;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * webSiteName;
@property (nonatomic, retain) NSNumber * deleteFlag;
@property (nonatomic, retain) NSNumber * downloadProgress;
@property (nonatomic, assign) ASIHTTPRequest * request;
@property(readonly) NSURL * previewItemURL;

- (NSDictionary*)dictionaryForRequest;
+ (DownloadItem*)fromDictionary:(NSDictionary*)dict;
- (NSString*)statusText;
- (BOOL)canPause;
- (BOOL)canResume;
- (BOOL)canPlay;
- (BOOL)isDownloadFinished;
- (BOOL)canView;
- (BOOL)isStarred;
- (BOOL)isImage;

- (BOOL)isAudioVideo;
- (BOOL)isReadableFile;
- (BOOL)isImageFileType;

@end
