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

@property (retain, nonatomic) IBOutlet UIButton *openButton;
@property (retain, nonatomic) IBOutlet UIButton *renameButton;
@property (retain, nonatomic) IBOutlet UIButton *DeleteButton;
@property (retain, nonatomic) IBOutlet UIButton *facebookButton;
@property (retain, nonatomic) IBOutlet UIButton *twitterButton;
@property (retain, nonatomic) IBOutlet UIButton *emailShareButton;
@property (retain, nonatomic) IBOutlet UIButton *SMSButton;
@property (retain, nonatomic) IBOutlet UIButton *moreButton;
@property (retain, nonatomic) IBOutlet UIButton *albumButton;
@property (retain, nonatomic) IBOutlet UIButton *emailSendButton;

@property (nonatomic, retain) DownloadItem *item;
@property (nonatomic, retain) UIViewController<CommonFileActionProtocol> *playItemController;
@property (retain, nonatomic) IBOutlet UIView *playItemSuperView;
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
