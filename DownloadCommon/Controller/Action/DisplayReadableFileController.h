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
#import <QuickLook/QuickLook.h>

@interface DisplayReadableFileController : PPViewController<CommonFileActionProtocol, UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@property (nonatomic, retain) DownloadItem* downloadItem;
@property (nonatomic, retain) UIDocumentInteractionController* docController;
@property (nonatomic, retain) QLPreviewController* previewController;
@property (nonatomic, retain) UIViewController* superViewController;

@end
