//
//  AboutGroupSms.m
//  three20test
//
//  Created by qqn_pipi on 10-6-1.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "AboutViewController.h"
#import "UIUtils.h"
#import "UIImageExt.h"
#import "UIButtonExt.h"

@implementation AboutViewController

@synthesize button3;
@synthesize button1;
@synthesize button2;
@synthesize buttonMain;

@synthesize appName;
@synthesize appInfo;
@synthesize appAuthor;
@synthesize appSupport;

@synthesize otherApp;
@synthesize zzLabel;
@synthesize iHasyLabel;
@synthesize appboxLabel;
@synthesize appId;
@synthesize appDisplayName;
@synthesize appVersion;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
//	appName.text	= NSLocalizedString(@"悠游短信百汇", @"");
		
	appName.text	= NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
	appInfo.text	= kAppInfoAndSupport;
	appVersion.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	
	appInfo.backgroundColor = [UIColor clearColor];
	appInfo.font	= [UIFont systemFontOfSize:12];	
					   	
	otherApp.text	= kMoreApp;	
	zzLabel.text	= kAppPrivateSms;
	iHasyLabel.text	= kAppGroupSms;
	appboxLabel.text = kAppDesktopShortcut;
	
	appName.textColor = [UIColor colorWithRed:0xe1/255.0 green:0xdd/255.0 blue:0xf5/255.0 alpha:1.0];
	appInfo.textColor = appName.textColor;
	appVersion.textColor = appName.textColor;
	otherApp.textColor = appName.textColor;
	zzLabel.textColor = appName.textColor;
	iHasyLabel.textColor = appName.textColor;
	appboxLabel.textColor = appName.textColor;
	
	[button2 addTarget:self action:@selector(clickZZ:) forControlEvents:UIControlEventTouchUpInside];
	[button3 addTarget:self action:@selector(clickHasy:) forControlEvents:UIControlEventTouchUpInside];
	[button1 addTarget:self action:@selector(clickAppBox:) forControlEvents:UIControlEventTouchUpInside];
	[buttonMain addTarget:self action:@selector(clickGroupSms:) forControlEvents:UIControlEventTouchUpInside];
	
	buttonMain.backgroundColor = [UIColor clearColor];

	UIImage* image = [UIImage createRoundedRectImage:[UIImage imageNamed:@"57.png"] size:CGSizeMake(57, 57)];
	[buttonMain setBackgroundImage:image forState:UIControlStateNormal];	


	UIImage* image2 = [UIImage createRoundedRectImage:[UIImage imageNamed:kAppBoxImage] size:CGSizeMake(57, 57)];
	[button1 setBackgroundImage:image2 forState:UIControlStateNormal];	
	
	UIImage* image1 = [UIImage createRoundedRectImage:[UIImage imageNamed:kCallReminderImage] size:CGSizeMake(57, 57)];
	[button2 setBackgroundImage:image1 forState:UIControlStateNormal];	

	UIImage* image3 = [UIImage createRoundedRectImage:[UIImage imageNamed:kGroupSmsImage] size:CGSizeMake(57, 57)];
	[button3 setBackgroundImage:image3 forState:UIControlStateNormal];	
	
//	UIImage* image = [UIImage createRoundedRectImage:[UIImage imageNamed:@"短信百汇57.png"] size:CGSizeMake(57, 57)];
//	[buttonMain setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)clickZZ:(id)sender
{
	[UIUtils openApp:kCallReminderId];
}

- (IBAction)clickAppBox:(id)sender
{
	[UIUtils openApp:kAppBoxId];
}

- (IBAction)clickHasy:(id)sender
{
	[UIUtils openApp:kGroupSmsId];
}

- (IBAction)clickGroupSms:(id)sender
{
	[UIUtils openApp:appId];	// to be changed
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[appId release];
	[appDisplayName release];
    [super dealloc];
}


@end
