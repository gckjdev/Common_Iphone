//
//  PPViewController.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-1.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "UIUtils.h"
#import "LocaleUtils.h"
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define kDefaultBarButton			@"barbutton.png"

#define kLocationUpdateTimeOut		60.0
#define kTimeOutObjectString		@"Time out"


#define _THREE20_ 1

#ifdef _THREE20_
#import <Three20/Three20.h>
#endif

@interface PPViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate> {

	NSString*				backgroundImageName;
	
	dispatch_queue_t		workingQueue;
	ABAddressBookRef		addressBook;
	
#ifdef _THREE20_	
	TTActivityLabel*	label;
#endif	
	
	UIAlertView				*alertView;
	int						alertAction;	
	NSTimer					*timer;
	
	// for location handling
	CLLocationManager		*locationManager;
	CLLocation				*currentLocation;
	MKReverseGeocoder		*reverseGeocoder;
	MKPlacemark				*currentPlacemark;
	
}

#ifdef _THREE20_
@property (nonatomic, retain) TTActivityLabel*	activityLabel;
#endif

@property (nonatomic, retain) NSTimer				*timer;
@property (nonatomic, retain) NSString*				backgroundImageName;
@property (nonatomic, retain) UIAlertView			*alertView;

@property (nonatomic, retain) CLLocationManager		*locationManager;
@property (nonatomic, copy)	  CLLocation			*currentLocation;
@property (nonatomic, retain) MKReverseGeocoder		*reverseGeocoder;
@property (nonatomic, retain) MKPlacemark			*currentPlacemark;

- (void)showBackgroundImage;
- (void)setNavigationRightButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action;
- (void)setNavigationLeftButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action;
- (void)setNavigationLeftButton:(NSString*)title action:(SEL)action;
- (void)setNavigationRightButton:(NSString*)title action:(SEL)action;


// this method helps you to performa an internal method with loading view
- (void)performSelectorWithLoading:(SEL)aSelector loadingText:(NSString*)loadingText;

- (void)showActivityWithText:(NSString*)loadingText;
- (void)showActivity;
- (void)hideActivity;

// Send Email Methods
- (BOOL)sendEmailTo:(NSArray*)toRecipients 
	   ccRecipients:(NSArray*)ccRecipients 
	  bccRecipients:(NSArray*)bccRecipients 
			subject:(NSString*)subject
			   body:(NSString*)body
			 isHTML:(BOOL)isHTML
		   delegate:(id)delegate;

- (void)sendSms:(NSString*)receiver body:(NSString*)body;
- (void)sendSmsWithReceivers:(NSArray*)receivers body:(NSString*)body;

// for internal usage
- (void)registerKeyboardNotification;
- (void)deregsiterKeyboardNotification;

- (void)popupMessage:(NSString*)msg title:(NSString*)title;
- (void)popupHappyMessage:(NSString*)msg title:(NSString*)title;
- (void)popupUnhappyMessage:(NSString*)msg title:(NSString*)title;
- (void)clearTimer;

- (void)initLocationManager;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation:(NSString *)state;
- (void)reverseGeocode:(CLLocationCoordinate2D)coordinate;

@end
