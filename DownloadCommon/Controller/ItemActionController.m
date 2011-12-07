//
//  ItemActionController.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ItemActionController.h"
#import "PlayAudioVideoController.h"
#import "DisplayReadableFileController.h"
#import "DownloadItem.h"
#import "DownloadItemManager.h"
#import "LogUtil.h"
#import "DownloadResource.h"

@implementation ItemActionController

@synthesize openButton;
@synthesize renameButton;
@synthesize DeleteButton;
@synthesize facebookButton;
@synthesize twitterButton;
@synthesize emailShareButton;
@synthesize SMSButton;
@synthesize moreButton;
@synthesize albumButton;
@synthesize emailSendButton;
@synthesize item;
@synthesize playItemController;
@synthesize playItemSuperView;
@synthesize alertViewNumber;
@synthesize textViewOfAlertView;
@synthesize itemActionInnerView;
@synthesize lastSelectedButton;
@synthesize previewLabel;
@synthesize shareLabel;
@synthesize SendToLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [playItemController release];
    [item release];
    [playItemSuperView release];
    [alertViewNumber release];
    [textViewOfAlertView release];
    [openButton release];
    [renameButton release];
    [DeleteButton release];
    [facebookButton release];
    [twitterButton release];
    [emailShareButton release];
    [SMSButton release];
    [moreButton release];
    [albumButton release];
    [emailSendButton release];
    [itemActionInnerView release];
    [previewLabel release];
    [shareLabel release];
    [SendToLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle


- (void)createPlayItemView
{
//    self.playItemController = [self getViewControllerByItem:self.item];
//    [self.playItemController show:self.playItemSuperView];    
}

- (void)showItem:(DownloadItem*)newItem
{
    if (self.item != newItem){
        self.item = newItem;
        [self createPlayItemView];
    }
    
//    self.navigationItem.title = self.item.fileName;
    [self setDownloadNavigationTitle:self.item.fileName];
    [self updateSaveAlbumButton];
}

- (void)updateSaveAlbumButton
{
    if (self.item.isImage || UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.item.localPath))
    {
        self.albumButton.enabled = YES;	
    }
    else
    {
        self.albumButton.enabled = NO;
    }    
}

- (void)setLeftBarButton
{
    float buttonHigh = 27.5;
    float backButtonLen = 60;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, backButtonLen, buttonHigh)];
    [backButton setBackgroundImage:ITEM_BACK_ICON_IMAGE forState:UIControlStateNormal];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [backButton.titleLabel setFont:font];
    [backButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backButton setTitle:NSLS(@"kBack") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
}

- (void)setRightBarButton
{
    float buttonHigh = 27.5;
    float nextButtonLen = 60;
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(218, 0, nextButtonLen, buttonHigh)];
    [nextButton setBackgroundImage:ITEM_NEXT_ICON_IMAGE forState:UIControlStateNormal];
    
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [nextButton.titleLabel setFont:font];
    [nextButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [nextButton setTitle:NSLS(@"kNextItem") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
    
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.itemActionInnerView setImage:ITEM_ACTION_INNER_BG_IMAGE];
    [self.previewLabel setText:NSLS(@"kPreview")];
    [self.shareLabel setText:NSLS(@"kShare")];
    [self.SendToLabel setText:NSLS(@"kSendto")];
    
    [self.openButton setTitle:NSLS(@"kOpen") forState:UIControlStateNormal];
    [self.openButton setImage:ITEM_OPEN_IMAGE forState:UIControlStateNormal];
    [self.openButton setImage:ITEM_OPEN_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.DeleteButton setTitle:NSLS(@"kDelete") forState:UIControlStateNormal];
    [self.DeleteButton setImage:ITEM_DELETE_IMAGE forState:UIControlStateNormal];
    [self.DeleteButton setImage:ITEM_DELETE_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.renameButton setTitle:NSLS(@"kRename") forState:UIControlStateNormal];
    [self.renameButton setImage:ITEM_RENAME_IMAGE forState:UIControlStateNormal];
    [self.renameButton  setImage:ITEM_RENAME_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.facebookButton setTitle:NSLS(@"kFacebook") forState:UIControlStateNormal];
    [self.facebookButton setImage:ITEM_FACEBOOK_IMAGE forState:UIControlStateNormal];
    [self.facebookButton setImage:ITEM_FACEBOOK_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.twitterButton setTitle:NSLS(@"kTwitter") forState:UIControlStateNormal];
    [self.twitterButton setImage:ITEM_TWITTER_IMAGE forState:UIControlStateNormal];
    [self.twitterButton setImage:ITEM_TWITTER_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.emailShareButton setTitle:NSLS(@"kEmail") forState:UIControlStateNormal];
    [self.emailShareButton setImage:ITEM_EMAIL_IMAGE forState:UIControlStateNormal];
    [self.emailShareButton  setImage:ITEM_EMAIL_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.SMSButton setTitle:NSLS(@"kSMS") forState:UIControlStateNormal];
    [self.SMSButton setImage:ITEM_SMS_IMAGE forState:UIControlStateNormal];
    [self.SMSButton setImage:ITEM_SMS_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.moreButton setTitle:NSLS(@"kMore") forState:UIControlStateNormal];
    [self.moreButton setImage:ITEM_MORE_IMAGE forState:UIControlStateNormal];
    [self.moreButton setImage:ITEM_MORE_IMAGE forState:UIControlStateSelected];
    
    [self.albumButton setTitle:NSLS(@"kAlbum") forState:UIControlStateNormal];
    [self.albumButton setImage:ITEM_ALBUM_IMAGE forState:UIControlStateNormal];
    [self.albumButton setImage:ITEM_ALBUM_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.emailSendButton setTitle:NSLS(@"kEmail") forState:UIControlStateNormal];
    [self.emailSendButton setImage:ITEM_EMAIL_IMAGE forState:UIControlStateNormal];
    [self.emailSendButton setImage:ITEM_EMAIL_PRESS_IMAGE forState:UIControlStateSelected];

    self.view.backgroundColor = [UIColor whiteColor];
//    [self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
//    [self setNavigationRightButton:NSLS(@"Next Item") action:@selector(clickNext:)];
    
    [self setLeftBarButton];
    [self setRightBarButton];

    
//    self.navigationItem.title = self.item.fileName;
    [self setDownloadNavigationTitle:self.item.fileName];
    
}	

//- (void)viewDidAppear:(BOOL)animated
//{
//    NSLog(@"%@",self.item.fileName);
//    [self updateSaveAlbumButton];    
//    [super viewDidAppear:animated];
//}

- (void)viewDidUnload
{
    [self setPlayItemSuperView:nil];
    [self setOpenButton:nil];
    [self setRenameButton:nil];
    [self setDeleteButton:nil];
    [self setFacebookButton:nil];
    [self setTwitterButton:nil];
    [self setEmailShareButton:nil];
    [self setSMSButton:nil];
    [self setMoreButton:nil];
    [self setAlbumButton:nil];
    [self setEmailSendButton:nil];
    [self setItemActionInnerView:nil];
    [self setPreviewLabel:nil];
    [self setShareLabel:nil];
    [self setSendToLabel:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// save
// http://stackoverflow.com/questions/6916305/how-to-save-video-file-into-document-directory
// http://stackoverflow.com/questions/5706911/save-mp4-into-iphone-photo-album

- (IBAction)renameFile:(id)sender
{
    self.alertViewNumber = [NSNumber numberWithInt:1]; 
    
    UIAlertView *alert = [UIUtils showTextView:NSLS(@"kRenameFileAlertTitle") 
                                 okButtonTitle:NSLS(@"kRenameFileAlertOkButtonTitle" )
                             cancelButtonTitle:NSLS(@"kRenameFileAlertCancelButtonTitle") 
                                      delegate:self];
    
    self.textViewOfAlertView = (UITextView*)[alert viewWithTag:kAlertTextViewTag];
    
    [alert show];
    
    [self.lastSelectedButton setSelected:NO];
    [self.renameButton setSelected:YES];
    self.lastSelectedButton = renameButton;
    
}

- (IBAction)deleteFile:(id)sender
{
    self.alertViewNumber = [NSNumber numberWithInt:2]; 
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:NSLS(@"kDeleteFileAlertTitle")
                          message:[NSString stringWithFormat:NSLS(@"kDeleteFileAlertMessage"),item.fileName]
                          delegate:self
                          cancelButtonTitle:NSLS(@"kDeleteFileAlertCancelButtonTitle") 
                          otherButtonTitles:NSLS(@"kDeleteFileAlertOtherButtonTitle"),nil];
    
    [alert show];
    [alert release];
    
    [self.lastSelectedButton setSelected:NO];
    [self.DeleteButton setSelected:YES];
    self.lastSelectedButton = DeleteButton;
}

- (IBAction)shareWithEmail:(id)sender
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposeEmailForShare];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    [self.lastSelectedButton setSelected:NO];
    [self.emailShareButton setSelected:YES];
    self.lastSelectedButton = emailShareButton;
}

- (IBAction)sendWithEmail:(id)sender
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposeEmailForSend];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    
    [self.lastSelectedButton setSelected:NO];
    [self.emailSendButton setSelected:YES];
    self.lastSelectedButton = emailSendButton;
}

- (IBAction)shareWithSMS:(id)sender
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil) { 			
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet];
		}
		else {	
            [self popupUnhappyMessage:NSLS(@"kCanNotSendSMS") title:nil];
		}
	}
	else {
        [self popupUnhappyMessage:NSLS(@"kCanNotSendSMS") title:nil];
	}
    
    [self.lastSelectedButton setSelected:NO];
    [self.SMSButton setSelected:YES];
    self.lastSelectedButton = SMSButton;
}

- (void)            image: (UIImage *) image 
 didFinishSavingWithError: (NSError *) error 
              contextInfo: (void *) contextInfo
{
    [self hideActivity];
    if ([error code] == 0){
        [self popupHappyMessage:NSLS(@"kSaveToAlbumSuccess") title:nil];
    }
    else{
        PPDebug(@"save item to album fail, error = %@", [error description]);
        [self popupUnhappyMessage:NSLS(@"kSaveToAlbumFail") title:nil];
    }
}

- (void)               video: (NSString *) videoPath
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo
{
    [self hideActivity];
    if ([error code] == 0){
        [self popupHappyMessage:NSLS(@"kSaveToAlbumSuccess") title:nil];   //要改描述
    }
    else{
        PPDebug(@"save item to album fail, error = %@", [error description]);
        [self popupUnhappyMessage:NSLS(@"kSaveToAlbumFail") title:nil];
    }
}

    
- (IBAction)sendToAlbum:(id)sender
{
    if (self.item.isImage)
    {        
        [self showActivityWithText:NSLS(@"kSavingToAlbum")];
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:self.item.localPath], 
                                       self, 
                                       @selector(image:didFinishSavingWithError:contextInfo:), 
                                       nil);
    }
    else if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.item.localPath))
    {
        [self showActivityWithText:NSLS(@"kSavingToAlbum")];
        UISaveVideoAtPathToSavedPhotosAlbum(self.item.localPath, 
                                            self, 
                                            @selector(video:didFinishSavingWithError:contextInfo:), 
                                            nil);
    }
    else 
    {
        [self popupUnhappyMessage:NSLS(@"kSaveAlbumFail") title:nil];
    }
    
    [self.lastSelectedButton setSelected:NO];
    [self.albumButton setSelected:YES];
    self.lastSelectedButton = albumButton;
}

- (void)displayComposeEmailForShare
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:NSLS(@"kShareEmailSubject")];
	
	NSString *emailBody = [NSString stringWithFormat:NSLS(@"kShareEmailBody"),self.item.fileName,self.item.url];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)displayComposeEmailForSend
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:NSLS(@"kSendEmailSubject")];
    NSData *myData = [NSData dataWithContentsOfFile:self.item.localPath];
	[picker addAttachmentData:myData mimeType:[self.item.fileName pathExtension] fileName:self.item.fileName]; 
    
	NSString *emailBody = [NSString stringWithFormat:NSLS(@"kSendEmailBody"),self.item.fileName];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)displaySMSComposerSheet 
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

// Launches the Mail application on the device.
- (void)launchMailAppOnDevice
{
	NSString *email = @"mailto:user@example.com";
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
            [self popupHappyMessage:NSLS(@"kEmailCanceled") title:nil];
			break;
		case MFMailComposeResultSaved:
            [self popupHappyMessage:NSLS(@"kEmailSaved") title:nil];
			break;
		case MFMailComposeResultSent:
            [self popupHappyMessage:NSLS(@"kEmailSent") title:nil];
			break;
		case MFMailComposeResultFailed:
            [self popupUnhappyMessage:NSLS(@"kEmailFailed") title:nil];
			break;
		default:
            [self popupHappyMessage:NSLS(@"kEmailNotSent") title:nil];
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result 
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
            [self popupHappyMessage:NSLS(@"kMessageCanceled") title:nil];
			break;
		case MessageComposeResultSent:
            [self popupHappyMessage:NSLS(@"kMessageSent") title:nil];
			break;
		case MessageComposeResultFailed:
            [self popupUnhappyMessage:NSLS(@"kMessageFailed") title:nil];
			break;
		default:
            [self popupHappyMessage:NSLS(@"kMessageNotSent") title:nil];
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([NSNumber numberWithInt:1] ==self.alertViewNumber)
    {
        switch (buttonIndex) 
        {
            case 0:
                break;
            case 1:
                if ([[DownloadItemManager defaultManager] renameFile:self.item newFileName:self.textViewOfAlertView.text])
                {
                    self.navigationItem.title = self.item.fileName;
                }
                else
                {
                    [self popupUnhappyMessage:NSLS(@"kRenameFileFailed") title:nil];
                }
                break;
            default:
                break;
        }
    }
    else if ([NSNumber numberWithInt:2] ==self.alertViewNumber)
    {
        switch (buttonIndex) 
        {
            case 0:
                break;
            case 1:
                if ([[DownloadItemManager defaultManager] deleteItem:self.item])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self popupUnhappyMessage:NSLS(@"kDeleteFileFailed") title:nil];
                }
                break;
            default:
                break;
        }
    }
}

@end
