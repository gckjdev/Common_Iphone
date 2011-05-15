//
//  AdController.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/19/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMobView.h"
#import "PPViewController.h"
#import "AdMobDelegateProtocol.h"
#import <iAD/ADBannerView.h>
#import "UIViewUtils.h"

#define kPublisherId		@"a14cbd3893a6e5c"

#define kAdMobViewHeight	(48)
#define kAdMobViewWidth		(320)
#define kAppleAdViewHeight	(50)
#define kAppleAdViewWidth	(320)

typedef enum {
	kAdPositionBottom,
	kAdPositionTop,
	kAdPositionTabBottom,
	kAdPositionToolbarBottom
} AdPositionType;

// integrate with different Ad Provider to serve Ad
@interface AdController : PPViewController <AdMobDelegate, ADBannerViewDelegate>  {

	
	AdMobView*			adMobView;
	ADBannerView*		iAdView;
	time_t				lastAdDisplayTime;
	
	UIView*				currentView;
	AdPositionType		adPositionType;
	
	// set father view controller
	UIViewController*	superViewController;
	CGRect				superViewFrame;
	
	NSString*			publisherId;
}

@property (nonatomic, retain) AdMobView*		adMobView;
@property (nonatomic, retain) ADBannerView*		iAdView;
@property (nonatomic, retain) NSString*			publisherId;

@property (nonatomic, retain) UIViewController*	superViewController;

- (void)setBottomAdWithFrame:(CGRect)superViewRect;
- (void)setTabBottomAdWithFrame:(CGRect)superViewRect;
- (void)setToolbarBottomAdWithFrame:(CGRect)superViewRect;
- (void)updateAdFrame;
- (void)setAdMobPublisherId:(NSString*)publisherId;

@end
