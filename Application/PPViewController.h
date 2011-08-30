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
#import "TKLoadingView.h"

#define kDefaultBarButton			@"barbutton.png"

#define kLocationUpdateTimeOut		60.0
#define kTimeOutObjectString		@"Time out"

@interface PPViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

	NSString*				backgroundImageName;
	
	dispatch_queue_t		workingQueue;
	ABAddressBookRef		addressBook;
	
	TKLoadingView*          loadingView;
	
	UIAlertView				*alertView;
	int						alertAction;	
	NSTimer					*timer;
	
	// for location handling
	CLLocationManager		*locationManager;
	CLLocation				*currentLocation;
	MKReverseGeocoder		*reverseGeocoder;
	MKPlacemark				*currentPlacemark;
	
    UISegmentedControl      *titleSegControl;
    
    UIImage                 *selectedImage;
    NSString                *selectedImageSaveFileName;
    
    UIKeyboardType          currentKeyboardType;
}

@property (nonatomic, retain) TKLoadingView*        loadingView;
@property (nonatomic, retain) NSTimer				*timer;
@property (nonatomic, retain) NSString*				backgroundImageName;
@property (nonatomic, retain) UIAlertView			*alertView;

@property (nonatomic, retain) CLLocationManager		*locationManager;
@property (nonatomic, copy)	  CLLocation			*currentLocation;
@property (nonatomic, retain) MKReverseGeocoder		*reverseGeocoder;
@property (nonatomic, retain) MKPlacemark			*currentPlacemark;

@property (nonatomic, retain) UISegmentedControl    *titleSegControl;

@property (nonatomic, retain) UIImage               *selectedImage;
@property (nonatomic, retain) NSString              *selectedImageSaveFileName;
@property (nonatomic, assign) UIKeyboardType        currentKeyboardType;


- (void)showBackgroundImage;
- (void)setNavigationRightButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action;
- (void)setNavigationLeftButton:(NSString*)title imageName:(NSString*)imageName action:(SEL)action;
- (void)setNavigationLeftButton:(NSString*)title action:(SEL)action;
- (void)setNavigationRightButton:(NSString*)title action:(SEL)action;
- (void)createNavigationTitleToolbar:(NSArray*)titleArray defaultSelectIndex:(int)defaultSelectIndex;

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

- (void)selectPhoto;
- (void)takePhoto;

@end
