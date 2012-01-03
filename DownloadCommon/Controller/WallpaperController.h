//
//  WallpaperController.h
//  Download
//
//  Created by gckj on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewImageController.h"

@interface WallpaperController : ViewImageController

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, retain) UILabel *tipsLabel;

- (void)showWallpaper:(int)indexValue;

@end
