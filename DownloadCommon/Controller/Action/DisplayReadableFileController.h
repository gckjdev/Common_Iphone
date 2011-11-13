//
//  DisplayReadableFileController.h
//  Download
//
//  Created by  on 11-11-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFileActionController.h"
#import "PPViewController.h"

@interface DisplayReadableFileController : PPViewController<CommonFileActionProtocol, UIDocumentInteractionControllerDelegate>

@property (nonatomic, retain) DownloadItem* downloadItem;
@property (nonatomic, retain) UIDocumentInteractionController* docController;

@end
