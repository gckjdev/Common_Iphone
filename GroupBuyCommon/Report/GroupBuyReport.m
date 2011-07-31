//
//  GroupBuyReport.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupBuyReport.h"
#import "MobClick.h"
#import "Product.h"

@implementation GroupBuyReport

+ (void)reportTabBarControllerClick:(UITabBarController *)tabBarController{

    int selectedIndex = [tabBarController selectedIndex];
    UIViewController* controller = [tabBarController.viewControllers objectAtIndex:selectedIndex];
    NSString* eventName = [NSString stringWithFormat:@"Click Tab %@", controller.tabBarItem.title];        
    [MobClick event:eventName];
}

+ (void)reportSegControlClick:(UISegmentedControl*)segControl
{
    int selectedIndex = segControl.selectedSegmentIndex;
    NSString* title = [segControl titleForSegmentAtIndex:selectedIndex];
    NSString* eventName = [@"Click Seg " stringByAppendingString:title];
    [MobClick event:eventName];
}

+ (void)reportDataRefreshResult:(int)result
{
    [MobClick event:@"Pull Data" label:[NSString stringWithFormat:@"Result:%d", result]];
}

+ (void)reportClickMore
{
    [MobClick event:@"Pull"];
}

+ (void)reportPullRefresh
{
    [MobClick event:@"Click More"];    
}

+ (void)reportEnterProductDetail:(Product*)product
{
    NSString* productInfo = [NSString stringWithFormat:@"%@", product.siteName];
    [MobClick event:@"View Product" label:productInfo];
}

+ (void)reportClickShowProductMore:(Product*)product
{
    NSString* productInfo = [NSString stringWithFormat:@"%@", product.siteName];
    [MobClick event:@"View Product More" label:productInfo];    
}

+ (void)reportClickBuyProduct:(Product*)product
{
    NSString* productInfo = [NSString stringWithFormat:@"%@", product.siteName];
    [MobClick event:@"Buy Product" label:productInfo];        
}


@end
