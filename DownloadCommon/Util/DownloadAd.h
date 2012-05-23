//
//  DownloadAd.h
//  Download
//
//  Created by haodong qiu on 12年5月23日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GADBannerView;

@interface DownloadAd : NSObject

+ (GADBannerView*)allocAdMobView:(UIViewController*)superViewController;

@end
