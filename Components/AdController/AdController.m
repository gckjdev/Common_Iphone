    //
//  AdController.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/19/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "AdController.h"

//#define kTabBarHeight			55
//#define kNavigationBarHeight	40

@implementation AdController

@synthesize superViewController;
@synthesize iAdView;
@synthesize adMobView;
@synthesize publisherId;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)createAdBannerView 
{
    Class classAdBannerView = NSClassFromString(@"ADBannerView"); 
	if (classAdBannerView != nil) 
    {
		self.iAdView = [[classAdBannerView alloc] initWithFrame:self.view.bounds];
		NSLog(@"iAd frame = %@", NSStringFromCGRect(iAdView.frame));
		self.iAdView.delegate = self;
		self.iAdView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
		self.iAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait; 
    }
}

- (void)refreshAd
{
	[self.adMobView requestFreshAd];
}

- (void)createAdMobView
{
	self.adMobView = [AdMobView requestAdWithDelegate:self];	
	self.adMobView.frame = self.view.bounds;
	[self.adMobView requestFreshAd];
	NSLog(@"adMobView frame = %@", NSStringFromCGRect(adMobView.frame));
	
	static float kRequestAdInterval = 60.0f;
	[NSTimer scheduledTimerWithTimeInterval:kRequestAdInterval target:self selector:@selector(refreshAd) userInfo:nil repeats:YES];
}

- (void)showAdMobView
{
	[iAdView cancelBannerViewAction];
	[self.iAdView removeFromSuperview];
	if (adMobView.superview != self.view){
		currentView = adMobView;		
		[self updateAdFrame];		
		[self.view addSubview:adMobView];		
	}
}

- (void)showAdBanner		// iAd
{
	[self.adMobView removeFromSuperview];
	if (iAdView.superview != self.view){	
		currentView = iAdView;		
		[self updateAdFrame];
		[self.view addSubview:iAdView];		
	}
}

- (BOOL)needDisplayNewAd:(UIView*)newAdView
{
	if (currentView == newAdView){
		// the same Ad View, answer is YES
		return YES;
	}
	else if (newAdView == iAdView){
		// iAd has CPM, high priority
		return YES;
	}
	else {
		// different Ad View, answer depends on time
		time_t currentTime = time(NULL);
		static int kAdDisplayMinimumTime = 60; // 35 seconds to reload another Ad
		if (currentTime - lastAdDisplayTime < kAdDisplayMinimumTime){
			return NO;
		}
		else {
			return YES;
		}
		
	}
	
}

- (void)setBottomAdWithFrame:(CGRect)superViewRect
{	
	superViewFrame = superViewRect;
	adPositionType = kAdPositionBottom;
}

- (void)setTabBottomAdWithFrame:(CGRect)superViewRect
{	
	superViewFrame = superViewRect;
	adPositionType = kAdPositionTabBottom;
}

- (void)setToolbarBottomAdWithFrame:(CGRect)superViewRect
{	
	superViewFrame = superViewRect;
	adPositionType = kAdPositionToolbarBottom;
}

- (void)updateAdFrame
{
	float adHeight = 0.0f;
	float adWidth  = 0.0f;	
	if (currentView == iAdView){
		adHeight = kAppleAdViewHeight;
		adWidth  = kAppleAdViewWidth;
	}
	else{
		adHeight = kAdMobViewHeight;
		adWidth  = kAdMobViewWidth;
	}
	
	BOOL hasNavigtaionBar = YES;
	if (superViewController.navigationController == nil){
		hasNavigtaionBar = NO;
	}
	
	if (adPositionType == kAdPositionBottom){
		self.view.frame = CGRectMake(0, superViewFrame.size.height - adHeight, adWidth, adHeight);
		self.view.bounds = CGRectMake(0, 0, adWidth, adHeight);	
	}
	else if (adPositionType == kAdPositionTabBottom) {
		int extraHeight = 0;
		if (hasNavigtaionBar){
			extraHeight = kNavigationBarHeight;
		}
		self.view.frame = CGRectMake(0, superViewFrame.size.height - adHeight - extraHeight - kTabBarHeight, adWidth, adHeight);
		self.view.bounds = CGRectMake(0, 0, adWidth, adHeight);	
	}
	else if (adPositionType == kAdPositionToolbarBottom) {
		int extraHeight = 0;
		if (hasNavigtaionBar){
			extraHeight = kNavigationBarHeight;
		}
		self.view.frame = CGRectMake(0, superViewFrame.size.height - adHeight - extraHeight - kToolBarHeight, adWidth, adHeight);
		self.view.bounds = CGRectMake(0, 0, adWidth, adHeight);	
	}
	
	
	NSLog(@"Ad View Bounds = %@, Frame = %@", NSStringFromCGRect(self.view.bounds), NSStringFromCGRect(self.view.frame));
}	


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor clearColor];
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self updateAdFrame];
	[self createAdBannerView];
	[self createAdMobView];	
	
    [super viewDidLoad];	
}

- (void)viewDidAppear:(BOOL)animated
{
	[self updateAdFrame];
	[super viewDidAppear:animated];
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
	[superViewController release];
	adMobView.delegate = nil;
	[adMobView release];
	iAdView.delegate = nil;
	[iAdView release];
	[publisherId release];
    [super dealloc];
}

#pragma mark AdMob Delegate

- (NSString *)publisherIdForAd:(AdMobView *)adView
{
	if (self.publisherId != nil)
		return self.publisherId;
	else {
		return kPublisherId;
	}

}

// Return the current view controller (AdMobView should be part of its view hierarchy).
// Make sure to return the root view controller (e.g. a UINavigationController, not
// the UIViewController attached to it) .
- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView
{
	return superViewController;
}

- (void)didReceiveAd:(AdMobView *)adView
{
	NSLog(@"AdMob, didReceiveAd");
	if ([self needDisplayNewAd:adMobView]){
		[self showAdMobView];
		lastAdDisplayTime = time(0);
	}	
}

- (void)didReceiveRefreshedAd:(AdMobView *)adView
{
	NSLog(@"AdMob, didReceiveAd");
	if ([self needDisplayNewAd:adMobView]){
		[self showAdMobView];
		lastAdDisplayTime = time(0);
	}	
}

- (void)didFailToReceiveAd:(AdMobView *)adView
{
	NSLog(@"AdMob, didFailToReceiveAd");
	[self showAdBanner];
}

- (void)didFailToReceiveRefreshedAd:(AdMobView *)adView
{
	NSLog(@"AdMob, didFailToReceiveRefreshedAd");	
	[self showAdBanner];
}

- (NSArray *)testDevices
{
      return [NSArray arrayWithObjects:
              ADMOB_SIMULATOR_ID,                             // Simulator
              //@"28ab37c3902621dd572509110745071f0101b124",  // Test iPhone 3GS 3.0.1
              //@"8cf09e81ef3ec5418c3450f7954e0e95db8ab200",  // Test iPod 2.2.1
              nil];	
}

// If implemented, lets you specify the action type of the test ad. Defaults to @"url" (web page).
// Does nothing if testDevices is not implemented or does not map to the current device.
// Acceptable values are @"url", @"app", @"movie", @"call", @"canvas".  For interstitials
// use "video_int".
//
// Normally, the adservers restricts ads appropriately (e.g. no click to call ads for iPod touches).
// However, for your testing convenience, they will return any type requested for test ads.
//- (NSString *)testAdActionForAd:(AdMobView *)adView
//{
//}


#pragma mark iAd Delegate



- (void)bannerViewDidLoadAd:(ADBannerView *)banner 
{
	NSLog(@"iAd, bannerViewDidLoadAd");	
	
	if ([self needDisplayNewAd:iAdView]){
		[self showAdBanner];
		lastAdDisplayTime = time(0);
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"iAd, didFailToReceiveAdWithError:%@", [error description]);	
	[self showAdMobView];
}

- (void)setAdMobPublisherId:(NSString*)thePublisherId
{
	self.publisherId = [NSString stringWithString:thePublisherId];
}

@end


