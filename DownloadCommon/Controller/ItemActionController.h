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
#import <MessageUI/MessageUI.h>

@class DownloadItem;

@interface ItemActionController : PPViewController <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    NSNumber *alertViewNumber;
    UITextView* textViewOfAlertView;
}

@property (nonatomic, retain) DownloadItem *item;
@property (nonatomic, retain) UIViewController<CommonFileActionProtocol> *playItemController;
@property (retain, nonatomic) IBOutlet UIView *playItemSuperView;
@property (retain, nonatomic) IBOutlet UILabel *Message;
@property (retain, nonatomic) NSNumber *alertViewNumber;
@property (retain, nonatomic) UITextView* textViewOfAlertView;

- (void)showItem:(DownloadItem*)newItem;
- (IBAction)shareWithEmail:(id)sender;
- (IBAction)shareWithSMS:(id)sender;
- (IBAction)sendWithEmail:(id)sender;
- (IBAction)sendToAlbum:(id)sender;
- (IBAction)deleteFile:(id)sender;
- (IBAction)renameFile:(id)sender;

- (void)displayComposeEmailForShare;
- (void)displayComposeEmailForSend;
- (void)launchMailAppOnDevice;
- (void)displaySMSComposerSheet;

@end
