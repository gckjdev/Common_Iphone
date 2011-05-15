//
//  AboutGroupSms.h
//  three20test
//
//  Created by qqn_pipi on 10-6-1.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PPViewController.h"

#define kAboutInfoPlist				@"AboutView"

#define kAppInfoAndSupport			NSLocalizedStringFromTable(@"kAppInfoAndSupport", kAboutInfoPlist, nil)
#define kMoreApp					NSLocalizedStringFromTable(@"kMoreApp", kAboutInfoPlist, nil)
#define kAppZZ						NSLocalizedStringFromTable(@"kAppZZ", kAboutInfoPlist, nil)
#define kAppContactAppBox			NSLocalizedStringFromTable(@"kAppContactAppBox", kAboutInfoPlist, nil)
#define kAppGroupSms				NSLocalizedStringFromTable(@"kAppGroupSms", kAboutInfoPlist, nil)
#define kAppRedialHelper			NSLocalizedStringFromTable(@"kAppRedialHelper", kAboutInfoPlist, nil)
#define kAppCallReminder			NSLocalizedStringFromTable(@"kAppCallReminder", kAboutInfoPlist, nil)
#define kAppDesktopShortcut			NSLocalizedStringFromTable(@"kAppDesktopShortcut", kAboutInfoPlist, nil)
#define kAppPrivateSms				NSLocalizedStringFromTable(@"kAppPrivateSms", kAboutInfoPlist, nil)

#define kViewSupportTitle			NSLocalizedStringFromTable(@"kViewSupportTitle", kAboutInfoPlist, nil)
#define kViewSupportImage			@"support.png"

#define kAppBoxId					@"421701004"
#define kGroupSmsId					@"377378452"
#define kCallReminderId				@"427737140"

#define kAppBoxImage				@"deskcontact.png"
#define kGroupSmsImage				@"gsms.png"
#define kCallReminderImage			@"privatesms.png"
#define kRedialHelperImage			@"redialhelper.png"

@interface AboutViewController : PPViewController {

	IBOutlet UIButton*	buttonMain;
	IBOutlet UIButton*	button3;
	IBOutlet UIButton*	button1;
	IBOutlet UIButton*	button2;
		
	IBOutlet UILabel*	appName;
	IBOutlet UILabel*	appAuthor;
	IBOutlet UILabel*	appSupport;
	IBOutlet UILabel*	appVersion;
	

	IBOutlet UILabel*	zzLabel;
	IBOutlet UILabel*	iHasyLabel;
	IBOutlet UILabel*	appboxLabel;
	
	IBOutlet UILabel*	otherApp;
	
	IBOutlet UITextView* appInfo;
	
	NSString*			appId;
	NSString*			appDisplayName;
	
}

@property (nonatomic, retain) IBOutlet UIButton*	button3;
@property (nonatomic, retain) IBOutlet UIButton*	button1;
@property (nonatomic, retain) IBOutlet UIButton*	button2;
@property (nonatomic, retain) IBOutlet UIButton*	buttonMain;

@property (nonatomic, retain) IBOutlet UILabel*	appName;
@property (nonatomic, retain) IBOutlet UILabel*	appAuthor;
@property (nonatomic, retain) IBOutlet UILabel*	appSupport;
@property (nonatomic, retain) IBOutlet UILabel*	appVersion;

@property (nonatomic, retain) IBOutlet UILabel*	otherApp;
@property (nonatomic, retain) IBOutlet UITextView* appInfo;

@property (nonatomic, retain) IBOutlet UILabel*	zzLabel;
@property (nonatomic, retain) IBOutlet UILabel*	iHasyLabel;
@property (nonatomic, retain) IBOutlet UILabel*	appboxLabel;

@property (nonatomic, retain) NSString*			appId;
@property (nonatomic, retain) NSString*			appDisplayName;

- (IBAction)clickZZ:(id)sender;
- (IBAction)clickAppBox:(id)sender;
- (IBAction)clickHasy:(id)sender;

@end
