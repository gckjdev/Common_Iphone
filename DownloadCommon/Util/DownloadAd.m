//
//  DownloadAd.m
//  Download
//
//  Created by haodong qiu on 12年5月23日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "DownloadAd.h"
#import "GADBannerView.h"

@implementation DownloadAd

#define PUBLISHER_ID @"a14fbb62035e7d5" 
+ (GADBannerView*)allocAdMobView:(UIViewController*)superViewController
{
    // Create a view of the standard size at the bottom of the screen.
    GADBannerView* bannerView_ = [[GADBannerView alloc]
                                  initWithFrame:CGRectMake(0.0,
                                                           superViewController.view.bounds.size.height -
                                                           GAD_SIZE_320x50.height,
                                                           GAD_SIZE_320x50.width,
                                                           GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = PUBLISHER_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = superViewController;
    [superViewController.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];   
    
    return bannerView_;
}

@end
