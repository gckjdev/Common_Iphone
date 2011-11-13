//
//  DownloadService.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadService.h"
#import "ASIHTTPRequest.h"
#import "LogUtil.h"
#import "FileUtil.h"
#import "DownloadItem.h"
#import "DownloadItemManager.h"
#import "UIUtils.h"
#import "StringUtil.h"
#import "StatusView.h"
#import "LocaleUtils.h"

#define DOWNLOAD_DIR                @"/download/incoming/"
#define DOWNLOAD_TEMP_DIR           @"/download/temp/"

DownloadService* globalDownloadService;

@implementation DownloadService

@synthesize queue;
@synthesize downloadDir;
@synthesize downloadTempDir;
@synthesize concurrentDownload;

- (void)dealloc
{
    [queue release];
    [super dealloc];
}

- (id)init
{
    self = [super init];

    self.downloadDir = [[FileUtil getAppHomeDir] stringByAppendingFormat:DOWNLOAD_DIR];
    self.downloadTempDir = [[FileUtil getAppHomeDir] stringByAppendingFormat:DOWNLOAD_TEMP_DIR];    
    self.concurrentDownload = 20;  

    // create queue
    [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    [self.queue setMaxConcurrentOperationCount:self.concurrentDownload];
    
    // create directory if not exist
    [FileUtil createDir:self.downloadTempDir];
    [FileUtil createDir:self.downloadDir];    
    return self;
}

+ (DownloadService*)defaultService
{
    if (globalDownloadService == nil){
        globalDownloadService = [[DownloadService alloc] init];
        
    }
    
    return globalDownloadService;
}

#pragma File Creation and Generation

- (NSString*)createFileName:(NSString*)lastPathComponent
{
    DownloadItemManager* manager = [DownloadItemManager defaultManager];
    
    NSString* lastPath = lastPathComponent;
    NSString* pathExtension = [lastPath pathExtension];
    NSString* pathWithoutExtension = [lastPath stringByDeletingPathExtension];
    
    BOOL foundName = NO;    
    int i = 0;
    while (!foundName){
        if ([manager findItemByName:lastPath] != nil){            
            i ++;
            lastPath = [pathWithoutExtension stringByAppendingFormat:@"(%d).%@", i, pathExtension];
        }
        else{
            foundName = YES;
        }
    }
    
    return lastPath;
}

- (NSString*)getFilePath:(NSString*)fileName
{
    return [self.downloadDir stringByAppendingString:fileName];
}

- (NSString*)getTempFilePath:(NSString*)fileName
{
    return [self.downloadTempDir stringByAppendingString:fileName];
}

#pragma Download Internal Methods

- (BOOL)startDownload:(DownloadItem*)item
{
    NSURL* url = [NSURL URLWithString:[item url]];
    
    // start to download
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [[DownloadItemManager defaultManager] downloadStart:item request:request];
    
    [request setDownloadDestinationPath:[item localPath]];    
    [request setAllowResumeForFileDownloads:YES];
    [request setTemporaryFileDownloadPath:[item tempPath]];    
    [request setUserInfo:[item dictionaryForRequest]];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:item];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];

    PPDebug(@"download file, URL=%@, save to %@, temp path %@", [item url], [item localPath], [item tempPath]);

    [[self queue] addOperation:request];
    return YES;
}

#pragma External Methods

- (BOOL)downloadFile:(NSString*)urlString webSite:(NSString*)webSite origUrl:(NSString*)origUrl
{                
    NSURL* url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url] == NO){
        PPDebug(@"downloadFile but cannot open URL = %@", urlString);
        return NO;
    }
    
    NSString* fileName = [NSString GetUUID]; // [self createFileName:url];
    NSString* filePath = [self getFilePath:fileName];
    NSString* tempFilePath = [self getTempFilePath:fileName];
    
    // save download item
    DownloadItemManager* downloadItemManager = [DownloadItemManager defaultManager];
    DownloadItem* downloadItem = [downloadItemManager createDownloadItem:urlString 
                                                                 webSite:webSite 
                                                                 origUrl:origUrl
                                                                fileName:@""            // no file name
                                                                filePath:filePath                                  
                                                                tempPath:tempFilePath];
    
    [self startDownload:downloadItem];    
    return YES;
}

- (void)pauseDownloadItem:(DownloadItem*)item
{
    [[item request] clearDelegatesAndCancel];
    [[DownloadItemManager defaultManager] downloadPause:item];
}

- (void)resumeDownloadItem:(DownloadItem*)item
{
    [self startDownload:item];
}

- (void)pauseAllDownloadItem
{
    DownloadItemManager* manager = [DownloadItemManager defaultManager];
    NSArray* array = [manager findAllItemsByStatus:DOWNLOAD_STATUS_STARTED];
    for (DownloadItem* item in array){
        [self pauseDownloadItem:item];
    }
}

#pragma ASIHTTPRequest Delegate

- (NSString*)unicodeStringToUTF8:(NSString*)unicodeString
{
    NSData* data = [unicodeString dataUsingEncoding:NSUnicodeStringEncoding];
    NSData* data1 = [unicodeString dataUsingEncoding:NSISOLatin1StringEncoding];
    
    NSString* str = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    NSString* str1 = [[NSString alloc] initWithBytes:[data1 bytes] length:[data1 length] encoding:NSUTF8StringEncoding];
        
    NSLog(@"unicodeString=%@, str=%@, str1=%@", unicodeString, str, str1);
    
//    return finalString;
    return nil;
}

- (NSString *)replaceUnicode:(NSString *)yourString {  
    
    int i = 0;
    int len = [yourString length];    
    char* charArray = malloc(sizeof(char)*(len+1));
    for (i=0; i<len; i++){
        unichar ch = [yourString characterAtIndex:i];
        charArray[i] = ch;
//        NSLog(@"char = %02x, %d, %c", ch, ch, ch);
    }
    charArray[i] = '\0';
    
    NSString* str = [[[NSString alloc] initWithUTF8String:charArray] autorelease];    
    if (str == nil){
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        str = [NSString stringWithCString:charArray encoding:enc];
    }    
    return str;
}

- (NSString*)getFileNameFromContentDisposition:(NSString*)data
{
    if (data == nil)
        return nil;
                
    NSString* retStr = [self replaceUnicode:data];    
    retStr = [retStr stringByReplacingOccurrencesOfString:@"attachment;" withString:@""];    
    retStr = [retStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    retStr = [retStr stringByReplacingOccurrencesOfString:@"filename=" withString:@""];
    retStr = [retStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];

    PPDebug(@"Content Disposition = %@, %@", data, retStr);        
    return retStr;
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];
    PPDebug(@"item (%@) requestStarted, url = %@", [item itemId], [item.url description]);        
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];        
    
    // rename item here
    NSString* fileName1 = [self getFileNameFromContentDisposition:[responseHeaders valueForKey:@"Content-Disposition"]];
    NSString* fileName2 = [responseHeaders objectForKey:@"Content-Location"];
    
    PPDebug(@"item (%@) didReceiveResponseHeaders Content-Disposition = %@, Content-Location = %@", [item itemId], fileName1, fileName2);    
    
    NSString* fileName = nil;
    if (fileName1 != nil){
        fileName = [self createFileName:[fileName1 lastPathComponent]];    
    }
    else if (fileName2 != nil){
        fileName = [self createFileName:[fileName2 lastPathComponent]];
    }
    else{
        fileName = [self createFileName:[[request url] lastPathComponent]];
    }
    
    [[DownloadItemManager defaultManager] setFileName:item newFileName:fileName];
    
    NSString* statusText = [NSString stringWithFormat:NSLS(@"kDownloadStart"), item.fileName];
    [StatusView showtStatusText:statusText vibrate:NO duration:10.0];
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];
    PPDebug(@"item (%@) willRedirectToURL = %@", [item itemId], [newURL description]);    
}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];
    PPDebug(@"item (%@) requestRedirected", [item itemId]);        
}

- (void)moveFile:(DownloadItem*)item
{
    NSString* finalFilePath = [self getFilePath:item.fileName];
    NSError* error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:item.localPath toPath:finalFilePath error:&error];
    if (error != nil){
        NSLog(@"fail to rename file from %@ to %@", item.localPath, finalFilePath);
    }
    else{
        [item setLocalPath:finalFilePath];
    }
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];
    [self moveFile:item];
    [[DownloadItemManager defaultManager] finishDownload:item];
    PPDebug(@"item (%@) download done, response done = %@", [item itemId], response);
    
    NSString* statusText = [NSString stringWithFormat:NSLS(@"kDownloadFinish"), item.fileName];
    [StatusView showtStatusText:statusText vibrate:NO duration:10.0];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    DownloadItem *item = [DownloadItem fromDictionary:request.userInfo];
    [[DownloadItemManager defaultManager] downloadFailure:item];
    PPDebug(@"item (%@) download failure, response done = %@", [item itemId], [error description]);

    NSString* statusText = [NSString stringWithFormat:NSLS(@"kDownloadFailure"), item.fileName];
    [StatusView showtStatusText:statusText vibrate:NO duration:10.0];

}

@end
