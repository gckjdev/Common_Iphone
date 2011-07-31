//
//  GroupBuyReport.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;

@interface GroupBuyReport : NSObject {
    
}

+ (void)reportTabBarControllerClick:(UITabBarController *)tabBarController;
+ (void)reportSegControlClick:(UISegmentedControl*)segControl;
+ (void)reportDataRefreshResult:(int)result;

+ (void)reportClickMore;
+ (void)reportPullRefresh;
+ (void)reportEnterProductDetail:(Product*)product;
+ (void)reportClickShowProductMore:(Product*)product;
+ (void)reportClickBuyProduct:(Product*)product;

@end
