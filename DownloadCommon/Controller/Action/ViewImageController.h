//
//  ViewImageController.h
//  Download
//
//  Created by gckj on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFileActionController.h"
#import "PPViewController.h"

@interface ViewImageController : PPViewController<CommonFileActionProtocol>

@property (nonatomic, retain) DownloadItem* downloadItem;

@end
