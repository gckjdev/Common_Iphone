//
//  VideoPlayController.h
//  Download
//
//  Created by gckj on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PPTableViewController.h"
#import "PlayAudioVideoController.h"

@class GADBannerView;

@interface VideoPlayController : PlayAudioVideoController

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, retain) UILabel *tipsLabel;
@property (nonatomic, retain) GADBannerView* bannerView;

- (void)showVideoPlayer:(BOOL)play index:(int)indexValue;
@end
