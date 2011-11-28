//
//  DecompressService.m
//  Download
//
//  Created by gckj on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DecompressService.h"
#import "PlayAudioVideoController.h"
#import "DisplayReadableFileController.h"
#import "CommonFileActionController.h"
#import "ViewImageController.h"

DecompressService* globalDecompressService;

@implementation DecompressService

@synthesize videoPlayController;
@synthesize fileViewController;
@synthesize viewImageController;

- (void)dealloc
{
    [videoPlayController release];
    [fileViewController release];
    [viewImageController release];
    [super dealloc];
}

- (id)init
{
    self.videoPlayController = [[[PlayAudioVideoController alloc] init] autorelease];    
    self.fileViewController = [[[DisplayReadableFileController alloc] init] autorelease];
    self.viewImageController = [[[ViewImageController alloc] init] autorelease];
    return self;
}

- (void)playItem:(DecompressItem*)item viewController:(UIViewController*)viewController
{
    UIViewController<CommonFileActionProtocol>* playController = [self getViewControllerByItem:item];
    [playController preview:viewController decompressItem:item];
}

- (void)playItem:(NSArray *)list index:(int)indexValue viewController:(UIViewController *)viewController
{
    UIViewController<CommonFileActionProtocol>* playController = [self getViewControllerByItem:[list objectAtIndex:indexValue]];
    [playController preview:viewController itemList:list index:indexValue];
}

+ (DecompressService*) defaultService
{
    if (globalDecompressService == nil) {
        globalDecompressService = [[DecompressService alloc] init];
    }
    return globalDecompressService;
}

- (UIViewController<CommonFileActionProtocol>*)getViewControllerByItem:(DecompressItem*)item
{
    if ([item isAudio] || [item isVideo]){
        return videoPlayController;
    }
    else if ([item isReadableFile]){
        return fileViewController;
    }
    else if([item isImage]) {
        return viewImageController;
    }
    else{
        return [[[DisplayReadableFileController alloc] initWithDownloadItem:nil] autorelease];
    }
    return nil;
}



@end
