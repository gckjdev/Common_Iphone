//
//  PPViewController.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-1.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "PPViewController.h"
#import "UIViewUtils.h"
#import "UIBarButtonItemExt.h"
#import "StringUtil.h"
#import "UINavigationItemExt.h"
#import <MessageUI/MessageUI.h>
#import "StringUtil.h"
#import "TKAlertCenter.h"
#import "UIBlankView.h"
#import "UIImageUtil.h"

//#import "PPSegmentControl.h"
@implementation PPViewController

@synthesize loadingView;
@synthesize backgroundImageName;
@synthesize alertView;
@synthesize timer;
@synthesize locationManager, currentLocation, reverseGeocoder, currentPlacemark;
@synthesize titlePPSegControl;
@synthesize titleSegControl;
@synthesize selectedImage;
@synthesize selectedImageSaveFileName;
@synthesize currentKeyboardType;
@synthesize blankView;

#pragma mark background and navigation bar buttons

#define	kAlertViewShowTimerInterval		2

- (void)popupMessage:(NSString*)msg title:(NSString*)title
{
    
//	if (self.alertView == nil){	
//        // TODO why cannot autorelease AlertView, crash if using autorelease here
//		self.alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];			
//	}
//	else {
//		[self.alertView dismissWithClickedButtonIndex:0 animated:NO];		
//		[alertView setMessage:msg];
//		[alertView setTitle:title];		
//	}
//
//    NSLog(@"alert view retain count=%d", [alertView retainCount]);
//    
//	[alertView show];	
//	[NSTimer scheduledTimerWithTimeInterval:kAlertViewShowTimerInterval target:self selector:@selector(dismissAlertView:) userInfo:nil repeats:NO];
    
    if (title == nil){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msg];
    }
    else if (msg == nil){        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:title];        
    }
    else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:
         [NSString stringWithFormat:@"%@", msg]];                
    }
}

- (void)popupHappyMessage:(NSString*)msg title:(NSString*)title
{
	NSString* newMsg = [NSString stringWithFormat:@"%@ %@", kHappyFace, msg];
	[self popupMessage:newMsg title:title];
}

- (void)popupUnhappyMessage:(NSString*)msg title:(NSString*)title
{
	NSString* newMsg = [NSString stringWithFormat:@"%@ %@", kUnhappyFace, msg];
	[self popupMessage:newMsg title:title];

}

- (void)dismissAlertView:(id)sender
{
    NSLog(@"alert view retain count=%d", [alertView retainCount]);
	[self.alertView dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)showBackgroundImage
{
	[self.view setBackgroundImageView:self.backgroundImageName];
	
	if ([self respondsToSelector:@selector(dataTableView)]){
		UITableView* tableView = [self performSelector:@selector(dataTableView)];
		tableView.backgroundColor = [UIColor clearColor];
	}
}

- (void)setNavigationLeftButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action
{
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] 
									   initWithCustomView:[UIBarButtonItem getButtonWithTitle:title 
																					imageName:imageName 
																					   target:self 
																					   action:action]
									   ];
	
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
	
}

#define INSET_TOP 12
#define INSET_LEFT 10

- (UIButton *)createButtonWithTitle:(NSString*)title imageName:(NSString*)imageName target:(id)target action:(SEL)action
{
	UIButton* button = [[[UIButton alloc] init] autorelease];
    UIImage* image = [UIImage imageNamed:imageName];
	[button setImage:image forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];	
	button.titleLabel.font = [UIFont boldSystemFontOfSize:12];	
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];	
    CGRect rect = CGRectMake(0, 0, image.size.width + INSET_LEFT, image.size.height + INSET_TOP);
    button.frame = rect;
	return button;
}

- (void)setNavigationLeftButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action hasEdgeInSet:(BOOL)hasEdgeInSet
{
    UIButton* button = [self createButtonWithTitle:title imageName:imageName target:self action:action];
    [button setImageEdgeInsets:UIEdgeInsetsMake(INSET_TOP, INSET_LEFT, 0, 0)];
    
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];	
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
}

- (void)setNavigationRightButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action
{
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] 
											   initWithCustomView:[UIBarButtonItem getButtonWithTitle:title 
                                                            imageName:imageName 
                                                                target:self 
                                                                action:action]
											   ];
	
	self.navigationItem.rightBarButtonItem = barButtonItem;
	[barButtonItem release];
}

- (void)setNavigationRightButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action hasEdgeInSet:(BOOL)hasEdgeInSet
{
    UIButton* button = [self createButtonWithTitle:title imageName:imageName target:self action:action];
    [button setImageEdgeInsets:UIEdgeInsetsMake(INSET_TOP, 0, 0, INSET_LEFT)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(INSET_TOP, 0, 0, INSET_LEFT)];
    
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];	
	self.navigationItem.rightBarButtonItem = barButtonItem;
	[barButtonItem release];
}

- (void)setNavigationRightButton:(NSString*)title image:(UIImage*)strectableImage action:(SEL)action hasEdgeInSet:(BOOL)hasEdgeInSet
{
    UIButton* button = [self createButtonWithTitle:title imageName:nil target:self action:action];    
    [button setContentEdgeInsets:UIEdgeInsetsMake(INSET_TOP, 0, 0, INSET_LEFT)];
    [button setBackgroundImage:strectableImage forState:UIControlStateNormal];
    
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];	
	self.navigationItem.rightBarButtonItem = barButtonItem;
	[barButtonItem release];
}


- (void)setNavigationRightButton:(NSString*)title action:(SEL)action
{
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:action];
	
	self.navigationItem.rightBarButtonItem = barButtonItem;
	[barButtonItem release];
}

- (void)setNavigationLeftButton:(NSString*)title action:(SEL)action
{
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:action];
	
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
}



- (void)setNavigationRightButtonWithSystemStyle:(UIBarButtonSystemItem)systemItem action:(SEL)action
{
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:action];	
	self.navigationItem.rightBarButtonItem = barButtonItem;
	[barButtonItem release];
}

- (void)setNavigationLeftButtonWithSystemStyle:(UIBarButtonSystemItem)systemItem action:(SEL)action
{
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:action];
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
}

- (void)setNavigationTitle:(NSString*)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont
{

	[self.navigationItem setRichTextTitleView:title
									textColor:textColor
										 font:textFont];
}

#pragma Segment Control Delegate

- (void)clickSegControl:(id)sender
{
    NSLog(@"This is PPViewController default implementation");
}

- (void)createDefaultNavigationTitleToolbar:(NSArray*)titleArray defaultSelectIndex:(int)defaultSelectIndex
{
    if (titleArray == nil)
        return;
    
    self.titleSegControl = [[[UISegmentedControl alloc] initWithItems:titleArray] autorelease];
    
    titleSegControl.segmentedControlStyle = UISegmentedControlStyleBar;    
    if (defaultSelectIndex >= 0 && defaultSelectIndex < [titleArray count])        
        titleSegControl.selectedSegmentIndex = defaultSelectIndex;
    [titleSegControl addTarget:self 
                        action:@selector(clickSegControl:) 
              forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = titleSegControl;
}


//
//- (void)createNavigationTitleToolbar:(NSArray*)titleArray defaultSelectIndex:(int)defaultSelectIndex
//{    
//    if (titleArray == nil)
//        return;
//    UIImage *bgImage = [[UIImage imageNamed:@"tu_46.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:0];
//    UIImage *selectImage = [[UIImage imageNamed:@"tu_39-15.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:0];
//    self.titlePPSegControl = [[PPSegmentControl alloc] initWithItems:titleArray defaultSelectIndex:defaultSelectIndex bgImage:bgImage selectedImage:selectImage];
//    [self.titlePPSegControl  setSegmentFrame:CGRectMake(0, 0, 320, 25)];
//    [self.titlePPSegControl  setSelectedTextFont:[UIFont systemFontOfSize:12] color:[UIColor colorWithRed:134/255 green:148/255 blue:67/255 alpha:1]];
//    [self.titlePPSegControl  setUnselectedTextFont:[UIFont systemFontOfSize:12] color:[UIColor colorWithRed:111/255 green:104/255 blue:94/255 alpha:1]];
//    [self.titlePPSegControl  setSelectedSegmentFrame:CGRectMake(0, 0, titlePPSegControl.buttonWidth, 30) image:selectImage];
//    [self.titlePPSegControl  setViewController:self];
//}

#pragma mark activity loading view

- (TKLoadingView*)getActivityViewWithText:(NSString*)loadingText withCenter:(CGPoint)point
{
	if (loadingView == nil){
		self.loadingView = [[[TKLoadingView alloc] initWithTitle:@"" message:loadingText] autorelease];
        loadingView.center = point;
		[self.view addSubview:loadingView];
	}
	
	return loadingView;
}

- (TKLoadingView*)getActivityViewWithText:(NSString*)loadingText
{
	if (loadingView == nil){
		self.loadingView = [[[TKLoadingView alloc] initWithTitle:@"" message:loadingText] autorelease];
        loadingView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2+10);
		[self.view addSubview:loadingView];
	}
	
	return loadingView;
}

- (void)showActivityWithText:(NSString*)loadingText withCenter:(CGPoint)point
{
	loadingView = [self getActivityViewWithText:loadingText withCenter:point];
	[loadingView setMessage:loadingText];
	[loadingView startAnimating];
	loadingView.hidden = NO;
}

- (void)showActivityWithText:(NSString*)loadingText
{
	loadingView = [self getActivityViewWithText:loadingText];
	[loadingView setMessage:loadingText];
	[loadingView startAnimating];
	loadingView.hidden = NO;
}

- (void)showActivity
{
    [self showActivityWithText:@""];;
}

- (void)hideActivity
{
	[loadingView stopAnimating];
	loadingView.hidden = YES;
}

#pragma mark background selector execution

- (void)performSelectorStopLoading:(NSString*)selectorString
{
	[self performSelector:NSSelectorFromString(selectorString) withObject:nil];
	[self hideActivity];
}

- (void)performSelectorWithLoading:(SEL)aSelector loadingText:(NSString*)loadingText
{	
	[self performSelector:@selector(performSelectorStopLoading:) withObject:NSStringFromSelector(aSelector) afterDelay:0.0];
	CGPoint point = CGPointMake(160, 290);
    [self showActivityWithText:loadingText withCenter:point];
}

#pragma mark resource management

- (void)createWorkingQueue
{
	workingQueue = dispatch_queue_create([[NSString GetUUID] UTF8String], NULL);
}

- (void)releaseWorkingQueue
{	
	if (workingQueue){
		dispatch_release(workingQueue);
		workingQueue = NULL;
	}
}

- (void)createAddressBook
{
	if (addressBook != NULL){
		CFRelease(addressBook);
		addressBook = NULL;
	}
	addressBook = ABAddressBookCreate();	
}

- (void)releaseAddressBook
{
	if (addressBook != NULL){
		CFRelease(addressBook);
		addressBook = NULL;	
	}
}

#pragma mark super view controller methods

- (void)testLog
{
	NSLog(@"Test Log");
}

- (void)test
{
	self.backgroundImageName = @"blackbg.png";
	[self showBackgroundImage];
	[self setNavigationLeftButton:@"Left" imageName:@"barbutton.png" action:@selector(clickBack:)];
	[self setNavigationRightButton:@"Right" imageName:@"barbutton.png" action:@selector(clickBack:)];
	
//	[self showActivityWithText:@"Loading data from network"];

	[self performSelectorWithLoading:@selector(testLog) loadingText:@"Testing Log"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self createAddressBook];
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self removeBlankView];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
	[self createWorkingQueue];
	[self createAddressBook];
	[self showBackgroundImage];
	[self registerKeyboardNotification];

//	[self test];
	[super viewDidLoad];
}

- (void)viewDidUnload
{
    self.alertView = nil;   // release alert view
    
	[self deregsiterKeyboardNotification];
    [self.blankView deregsiterKeyboardNotification];
	[super viewDidUnload];
}

- (void)releaseResourceForEnterBackground
{
	[self releaseAddressBook];
	[self releaseWorkingQueue];	
	self.alertView = nil;	
}

- (void)dealloc
{
	[self releaseAddressBook];
	[self releaseWorkingQueue];
	[backgroundImageName release];
	[timer release];
    [blankView release];
	
	[locationManager release];
	[reverseGeocoder release];
	[currentLocation release];
	[currentPlacemark release];
	
    [titlePPSegControl release];
    
    [selectedImageSaveFileName release];
    [selectedImage release];
    [titleSegControl release];

#ifdef _THREE20_	
	[loadingView release];
#endif
	
	[alertView release];
	
	[super dealloc];
}

#pragma mark Email Methods

- (void)displayComposerSheetTo:(NSArray*)toRecipients 
				  ccRecipients:(NSArray*)ccRecipients 
				 bccRecipients:(NSArray*)bccRecipients 
					   subject:(NSString*)subject
						  body:(NSString*)body
						isHTML:(BOOL)isHTML
					  delegate:(id)delegate

{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	
	if (delegate != nil){
		picker.mailComposeDelegate = delegate;
	}
	else {
		picker.mailComposeDelegate = self;
	}

	
	[picker setSubject:subject];	
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];	
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email, not used
	//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
	//    NSData *myData = [NSData dataWithContentsOfFile:path];
	//	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	[picker setMessageBody:body isHTML:isHTML];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
// This method is mainly for copy & paste
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	NSString* text = nil;
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			text = @"<MFMailComposeViewController.didFinishWithResult> Result: canceled";
			break;
		case MFMailComposeResultSaved:
			text = @"<MFMailComposeViewController.didFinishWithResult> Result: saved";
			break;
		case MFMailComposeResultSent:
			text = @"<MFMailComposeViewController.didFinishWithResult> Result: sent";
			break;
		case MFMailComposeResultFailed:
			text = @"<MFMailComposeViewController.didFinishWithResult> Result: failed";
			break;
		default:
			text = @"<MFMailComposeViewController.didFinishWithResult> Result: not sent";
			break;
	}
	
	NSLog(@"%@", text);
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Keyboard Methods

// sub class can implement this method
- (void)keyboardDidShowWithRect:(CGRect)keyboardRect
{
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	// adjust current view frame
	
	// get keyboard frame
	NSDictionary* info = [notification userInfo];
	NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];	
    CGRect keyboardRect;
    [value getValue:&keyboardRect];

	[self keyboardDidShowWithRect:keyboardRect];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
}

- (void)registerKeyboardNotification
{
	// create notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)deregsiterKeyboardNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];	
}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDeviceTo:(NSString*)toRecipient 
				  ccRecipients:(NSArray*)ccRecipients 
//				 bccRecipients:(NSArray*)bccRecipients 
					   subject:(NSString*)subject
						  body:(NSString*)body
//						isHTML:(BOOL)isHTML
//					  delegate:(id)delegate
{
	
	// compose cc string
	NSMutableString* ccString = [[NSMutableString alloc] init];
	int index = 0;
	for (NSString* cc in ccRecipients){
		if (index > 0)
			[ccString appendFormat:@",%@", cc];
		else
			[ccString appendFormat:@"%@", cc];
		index ++;
	}
	
	NSString *email = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", toRecipient, ccString, subject, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
	
	[ccString release];
}

- (BOOL)sendEmailTo:(NSArray*)toRecipients 
	   ccRecipients:(NSArray*)ccRecipients 
	  bccRecipients:(NSArray*)bccRecipients 
			subject:(NSString*)subject
			   body:(NSString*)body
			 isHTML:(BOOL)isHTML
		   delegate:(id)delegate
{
	NSString* firstRecipient = @"";
	if (toRecipients && [toRecipients count] > 0)
		firstRecipient = [toRecipients objectAtIndex:0];			
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheetTo:toRecipients ccRecipients:ccRecipients bccRecipients:bccRecipients subject:subject body:body isHTML:isHTML delegate:delegate];
		}
		else
		{
			[self launchMailAppOnDeviceTo:firstRecipient ccRecipients:ccRecipients subject:subject body:body];
		}
	}
	else
	{
		[self launchMailAppOnDeviceTo:firstRecipient ccRecipients:ccRecipients subject:subject body:body];
	}
	
	return YES;
}

#pragma mark SMS Methods

-(void)sendSms:(NSString*)receiver body:(NSString*)body
{
	NSLog(@"<sendSms> receiver=%@, body=%@", receiver, body);
	MFMessageComposeViewController* vc = [[[MFMessageComposeViewController alloc] init] autorelease];
	vc.messageComposeDelegate = self;
	vc.body = body;
	vc.recipients = [NSArray arrayWithObject:receiver];
	
	if ([MFMessageComposeViewController canSendText] == NO){
		return;
	}	 
	
	[self presentModalViewController:vc animated:YES];
}

-(void)sendSmsWithReceivers:(NSArray*)receivers body:(NSString*)body
{
	NSLog(@"<sendSms> receiver=%@, body=%@", [receivers description], body);
	MFMessageComposeViewController* vc = [[[MFMessageComposeViewController alloc] init] autorelease];
	vc.messageComposeDelegate = self;
	vc.body = body;
	vc.recipients = receivers;
	
	if ([MFMessageComposeViewController canSendText] == NO){
		return;
	}	 
	
	[self presentModalViewController:vc animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{		
	NSLog(@"<sendSms> result=%d", result);	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Timer Methods

- (void)clearTimer
{
	[self.timer invalidate];
}

#pragma mark Location Methods

- (void)initLocationManager
{
	if (self.locationManager == nil){
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	}
}

- (void)startUpdatingLocation
{
	if (locationManager == nil){
		[self initLocationManager];
	}
	
	// start to update the location
	locationManager.delegate = self;		
	locationManager.desiredAccuracy = 10.0f; //kCLLocationAccuracyNearestTenMeters;	
	locationManager.distanceFilter = 10.0f;
	[locationManager startUpdatingLocation];	
	
	[self performSelector:@selector(stopUpdatingLocation:) withObject:kTimeOutObjectString afterDelay:kLocationUpdateTimeOut];    

}

- (void)stopUpdatingLocation:(NSString *)state {
	
	NSLog(@"stopUpdatingLocation,state=%@", state);
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;    
}

// the following code is for copying

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
    // save to current location
    self.currentLocation = newLocation;
	NSLog(@"Current location is %@, horizontalAccuracy=%f, timestamp=%@", [self.currentLocation description], [self.currentLocation horizontalAccuracy], [[currentLocation timestamp] description]);
	
	// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
	// [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:kTimeOutObjectString];
	
	// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:kTimeOutObjectString];
	
	// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
	[self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
	
	// translate location to address
	// [self reverseGeocodeCurrentLocation:self.currentLocation];
	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }	
}




#pragma mark reverseGeocoder


- (void)reverseGeocode:(CLLocationCoordinate2D)coordinate
{
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:coordinate] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}

- (void)reverseGeocodeCurrentLocation:(CLLocation *)location
{
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"MKReverseGeocoder has failed.");	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	self.currentPlacemark = placemark;
	NSLog(@"reverseGeocoder finish, placemark=%@", [placemark description] );
	//	NSLog(@"current country is %@, province is %@, city is %@, street is %@%@", self.currentPlacemark.country, currentPlacemark.administrativeArea, currentPlacemark.locality, placemark.thoroughfare, placemark.subThoroughfare);	
}


#pragma PPSegmentControl delegate

-(void)didSegmentValueChange:(PPSegmentControl *)seg
{
    [self clickSegControl:seg];

}




#pragma Image Picker Related

// this is just for copy
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil){
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];        
    }
     
}

- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];        
    }
    
}

- (void)addBlankView:(UIView*)searchBar
{
    int top = searchBar.frame.origin.y + searchBar.frame.size.height;
    [self addBlankView:top currentResponder:searchBar];
}

- (void)addBlankView:(CGFloat)top currentResponder:(UIView*)currentResponder
{
    CGRect frame = CGRectMake(0, top, 320, 480);
    if (self.blankView == nil){
        blankView = [[UIBlankView alloc] initWithFrame:frame];
    }
    
    [blankView removeFromSuperview];
    [blankView registerKeyboardNotification:currentResponder fatherView:self.view frame:frame];
}

- (void)removeBlankView
{
    [self.blankView deregsiterKeyboardNotification];
}

// for groupbuy
- (void)setGroupBuyNavigationBackButton
{
    [self setNavigationLeftButton:nil 
                              imageName:@"tu_63.png" 
                                 action:@selector(clickBack:)
                           hasEdgeInSet:YES];
}

- (void)setDownloadNavigationTitle:(NSString*)titleString
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = titleString;
    label.textColor = [UIColor colorWithRed:101/255.0 green:134/255.0 blue:156/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.shadowColor = [UIColor colorWithRed:241/255.0 green:246/255.0 blue:249/255.0 alpha:1.0];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
        
    self.navigationItem.titleView = label;
    
    [label release];
}

- (void)setGroupBuyNavigationTitle:(NSString*)titleString
{
    UILabel* label = [[UILabel alloc] init];
    label.text = titleString;
    label.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    UIView* view = [[UIView alloc] init];
    [view addSubview:label]; 
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, 200, 44);
    
    // adjust Y of label    
    CGRect frame = CGRectMake(0, INSET_TOP, 200, 44 - INSET_TOP);
    frame.origin.y = INSET_TOP;
    label.frame = frame;
    
    self.navigationItem.titleView = view;
    
    [view release];
    [label release];
}

- (void)setGroupBuyNavigationRightButton:(NSString*)buttonTitle action:(SEL)action
{
    int extraWidth = 20;
//    int width = 15/2;
    
    // TODO cache the image for better performance
    UIImage* buttonImage1 = [UIImage strectchableImageName:@"tu_72.png"];
    UIImage* buttonImage2 = [UIImage strectchableImageName:@"tu_82.png"];    
    
    int fontSize = 12;
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage2 forState:UIControlStateSelected];
    [button.titleLabel setFont:font];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = [buttonTitle sizeWithFont:font];
    button.frame = CGRectMake(0, INSET_TOP, size.width + extraWidth, 44 - INSET_TOP);
    
    UIView* view = [[UIView alloc] init];
    [view addSubview:button];
    view.frame = CGRectMake(0, 0, size.width + extraWidth + INSET_LEFT, 44);
            
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;

    [item release];    
    [view release];
}

@end


// the following code is just for copy & paste


//[UIView beginAnimations:nil context:nil];
//[UIView setAnimationDuration:0.5]; 
//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[optionsPane view] cache:YES];
//[[self view] addSubview:[optionsPane view]];
//[theWebView setFrame:CGRectMake(0,87,320,230)];
//[[optionsPane view] setFrame:CGRectMake(0,0,320,87)];
//[UIView commitAnimations];       


#pragma mark Action Sheet

// the following code is just for copy & paste

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	enum ButtonIndex {
//		kCallNow,
//		kSendSms,
//		kAddCalendar,
//		kDoNothing
//	};
//	
//	int index = actionSheet.tag;
//	UILocalNotification* notif = [self getObjectFromArray:index];
//	if (notif == nil)
//		return;	
//	
//	NSString* phone = [notif.userInfo objectForKey:kKeyPhone];	
//	NSString* contactName = [notif.userInfo objectForKey:kKeyContactName];
//	
//	[self removeObjectFromArray:index];
//	switch (buttonIndex) {
//		case kDoNothing:
//			// do nothing
//			break;
//		case kCallNow:
//			[DialManager dial:phone];
//			break;
//		case kSendSms:
//		{
//			NSLog(@"sendSms %@", phone);
//			[self sendSms:phone];
//		}
//			break;
//		case kAddCalendar:
//		{
//			NSLog(@"addCalendar %@", phone);
//			[self addCalendar:contactName phone:phone];
//		}
//			break;
//		default:
//			break;
//	}
//	
//}
//
//- (void)handleLocalNotification:(UILocalNotification *)notif
//{
//	
//	[DialManager handleLocalNotification:notif];
//}
//
//#pragma mark Alert View
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	enum ButtonIndex {
//		kButtonCloseIndex,
//		kButtonDialIndex
//	};
//	
//	int index = alertView.tag;
//	UILocalNotification* notif = [self getObjectFromArray:index];
//	if (notif == nil)
//		return;
//	
//	if (buttonIndex == kButtonDialIndex){
//		[self handleLocalNotification:notif];
//	}
//	else {
//		
//	}
//	
//	
//	[self removeObjectFromArray:index];
//}