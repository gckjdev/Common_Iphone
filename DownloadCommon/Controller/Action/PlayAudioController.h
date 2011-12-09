//
//  PlayAudioController.h
//  Download
//
//  Created by  on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonFileActionController.h"

@class MDAudioPlayerController;

@interface PlayAudioController : UIViewController<CommonFileActionProtocol>

@property (nonatomic, retain) NSArray* itemList;
@property (nonatomic, retain) MDAudioPlayerController *audioPlayer;
@property (nonatomic, retain) DownloadItem* currentItem;

@end
