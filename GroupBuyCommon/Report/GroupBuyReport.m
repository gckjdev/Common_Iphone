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
    NSString* eventName = @"Click Tab";        
    [MobClick event:eventName label:controller.tabBarItem.title];
}

+ (void)reportSegControlClick:(UISegmentedControl*)segControl
{
    int selectedIndex = segControl.selectedSegmentIndex;
    NSString* title = [segControl titleForSegmentAtIndex:selectedIndex];
    NSString* eventName = @"Click Seg";
    [MobClick event:eventName label:title];
}

+ (void)reportDataRefreshResult:(int)result
{
    [MobClick event:@"Pull Result" label:[NSString stringWithFormat:@"%d", result]];
}

+ (void)reportClickMore:(NSString*)categoryName type:(NSString*)type
{
    NSString* label;
    if (categoryName){
        label = [categoryName stringByAppendingFormat:@"-%@", type];
    }
    else{
        label = [NSString stringWithFormat:@"%@", type];        
    }
    
    [MobClick event:@"Click More" label:label];
}

+ (void)reportPullRefresh:(NSString*)categoryName type:(NSString*)type
{
    NSString* label;
    if (categoryName){
        label = [categoryName stringByAppendingFormat:@"-%@", type];
    }
    else{
        label = [NSString stringWithFormat:@"%@", type];        
    }

    [MobClick event:@"Pull Refresh" label:label];    
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
