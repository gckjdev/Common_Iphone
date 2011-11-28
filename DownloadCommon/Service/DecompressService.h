//
//  DecompressService.h
//  Download
//
//  Created by gckj on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecompressItem.h"
#import "CommonFileActionController.h"

@class PlayAudioVideoController;
@class DisplayReadableFileController;
@class ViewImageController;

@interface DecompressService : NSObject

@property (nonatomic, retain) PlayAudioVideoController *videoPlayController;
@property (nonatomic, retain) DisplayReadableFileController *fileViewController;
@property (nonatomic, retain) ViewImageController *viewImageController;
+ (DecompressService*) defaultService;
- (UIViewController<CommonFileActionProtocol>*)getViewControllerByItem:(DecompressItem*)item;
- (void)playItem:(DecompressItem*)item viewController:(UIViewController*)viewController;
- (void)playItem:(NSArray*)list index:(int)indexValue viewController:(UIViewController*)viewController;
@end
