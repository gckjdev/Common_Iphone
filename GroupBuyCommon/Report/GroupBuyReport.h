//
//  GroupBuyReport.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;
@class PPSegmentControl;
@interface GroupBuyReport : NSObject {
    
}

+ (void)reportTabBarControllerClick:(UITabBarController *)tabBarController;
+ (void)reportSegControlClick:(UISegmentedControl*)segControl;
+ (void)reportPPSegControlClick:(PPSegmentControl*)segControl;
+ (void)reportDataRefreshResult:(int)result;

+ (void)reportClickMore:(NSString*)categoryName type:(NSString*)type;
+ (void)reportPullRefresh:(NSString*)categoryName type:(NSString*)type;
+ (void)reportEnterProductDetail:(Product*)product;
+ (void)reportClickShowProductMore:(Product*)product;
+ (void)reportClickBuyProduct:(Product*)product;
+ (void)reportClickSaveProduct:(Product*)product;

@end
