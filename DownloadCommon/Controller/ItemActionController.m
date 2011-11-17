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

@implementation ItemActionController

@synthesize item;
@synthesize playItemController;
@synthesize playItemSuperView;
@synthesize Message;

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
    [Message release];
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
    
    self.navigationItem.title = self.item.fileName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"Next Item") action:@selector(clickNext:)];
    self.navigationItem.title = self.item.fileName;
}

- (void)viewDidUnload
{
    [self setPlayItemSuperView:nil];
    [self setMessage:nil];
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
			Message.hidden = NO;
			Message.text = @"Device not configured to send SMS.";
            
		}
	}
	else {
		Message.hidden = NO;
		Message.text = @"Device not configured to send SMS.";
	}
}

- (IBAction)sendToAlbum:(id)sender
{
    NSLog(@"%@",self.item.localPath);
    
    if (self.item.isImage)
    {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:self.item.localPath], nil, nil, nil);
        Message.hidden = NO;
		Message.text = @"Saved!";
    }
    else if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.item.localPath))
    {
        UISaveVideoAtPathToSavedPhotosAlbum(self.item.localPath, nil, nil, nil);
        Message.hidden = NO;
		Message.text = @"Saved!";
    }
    else 
    {
        Message.hidden = NO;
		Message.text = @"This file can not be saved to the Album.";
    }
}

- (void)displayComposeEmailForShare
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:NSLS(@"kShareEmailSubject")];
	
	NSString *emailBody = self.item.url;
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
    
	NSString *emailBody = @"";              //add content later
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
	Message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			Message.text = @"Result: Mail sending canceled";
			break;
		case MFMailComposeResultSaved:
			Message.text = @"Result: Mail saved";
			break;
		case MFMailComposeResultSent:
			Message.text = @"Result: Mail sent";
			break;
		case MFMailComposeResultFailed:
			Message.text = @"Result: Mail sending failed";
			break;
		default:
			Message.text = @"Result: Mail not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result 
{
	Message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			Message.text = @"Result: SMS sending canceled";
			break;
		case MessageComposeResultSent:
			Message.text = @"Result: SMS sent";
			break;
		case MessageComposeResultFailed:
			Message.text = @"Result: SMS sending failed";
			break;
		default:
			Message.text = @"Result: SMS not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
