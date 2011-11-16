//
//  ItemActionController.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "CommonFileActionController.h"
#import <MessageUI/MFMailComposeViewController.h>

@class DownloadItem;

@interface ItemActionController : PPViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) DownloadItem *item;
@property (nonatomic, retain) UIViewController<CommonFileActionProtocol> *playItemController;
@property (retain, nonatomic) IBOutlet UIView *playItemSuperView;

- (void)showItem:(DownloadItem*)newItem;
- (IBAction)shareWithEmail:(id)sender;

-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
@end
