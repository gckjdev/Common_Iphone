//
//  AdViewUtils.h
//  groupbuy
//
//  Created by  on 11-11-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"

@class GADBannerView;

@interface AdViewUtils : NSObject

+ (GADBannerView*)allocAdMobView:(UIViewController*)superViewController;

@end

extern BOOL GlobalGetEnableAd();
extern NSString* GlobalGetEnableAdPubliserId();