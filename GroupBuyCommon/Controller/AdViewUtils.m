//
//  AdViewUtils.m
//  groupbuy
//
//  Created by  on 11-11-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AdViewUtils.h"

@implementation AdViewUtils

+ (GADBannerView*)allocAdMobView:(UIViewController*)superViewController
{
    if (!GlobalGetEnableAd()){
        return nil;
    }
    
    // Create a view of the standard size at the bottom of the screen.
    GADBannerView* bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            superViewController.view.bounds.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = GlobalGetEnableAdPubliserId();
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = superViewController;
    [superViewController.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];   
    
    return bannerView_;
}

@end
